#!/bin/bash

set -e

# ============================================================
# 作業ディレクトリ
# ============================================================
WORK_DIR="$HOME/Downloads"
mkdir -p "$WORK_DIR"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ============================================================
# パッケージマネージャの判定
# ============================================================
if command -v brew &>/dev/null; then
    PKG_MANAGER="brew"
elif command -v apt-get &>/dev/null; then
    PKG_MANAGER="apt"
elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
else
    echo "Error: No supported package manager found (brew / apt / pacman)."
    exit 1
fi

echo "Detected package manager: $PKG_MANAGER"

# WSL判定
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
else
    IS_WSL=false
fi

# ============================================================
# シンボリックリンクの作成
# ============================================================
setup_symlinks() {
    echo "Creating symlinks..."
    ln -sf "$SCRIPT_DIR/tools/.clang-format" "$HOME/.clang-format"
    echo "  ✅ ~/.clang-format"
    ln -sf "$SCRIPT_DIR/tools/.latexmkrc" "$HOME/.latexmkrc"
    echo "  ✅ ~/.latexmkrc"
}

# ============================================================
# Neovim 本体（公式バイナリ）
# ============================================================
install_neovim() {
    if command -v nvim &>/dev/null; then
        echo "Neovim already installed ($(nvim --version | head -1)), skipping."
        return
    fi

    if [ "$PKG_MANAGER" = "brew" ]; then
        echo "Installing Neovim via Homebrew..."
        brew install neovim
    else
        echo "Installing Neovim (official binary)..."
        local archive="nvim-linux-x86_64.tar.gz"
        curl -LO --output-dir "$WORK_DIR" "https://github.com/neovim/neovim/releases/latest/download/$archive"
        sudo tar -C /opt -xzf "$WORK_DIR/$archive"
        sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
        rm -f "$WORK_DIR/$archive"
    fi

    echo "Neovim installed."
}

# ============================================================
# apt 用インストール
# ============================================================
install_apt() {
    echo "Updating apt repositories..."
    sudo apt-get update

    echo "Installing core tools..."
    sudo apt-get install -y git curl wget unzip tar gzip build-essential zsh

    if [ "$IS_WSL" = true ]; then
        echo "Installing WSL-specific packages..."
        sudo apt-get install -y pulseaudio-utils sound-theme-freedesktop xclip wslu
    else
        sudo apt-get install -y xclip wl-clipboard
    fi

    echo "Installing search tools..."
    sudo apt-get install -y ripgrep fd-find
    if ! command -v fd &>/dev/null && command -v fdfind &>/dev/null; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi

    echo "Installing language runtimes..."
    sudo apt-get install -y python3 python3-pip python3-venv perl
    sudo apt-get install -y php php-xml composer

    echo "Installing formatter/linter tools..."
    sudo apt-get install -y shellcheck shfmt
    sudo apt-get install -y clang-format chktex
    sudo apt-get install -y pgformatter || echo "Warning: pgformatter not found in apt repos"
    sudo apt-get install -y ghdl || echo "Warning: ghdl not found in apt repos"

    # LaTeX (任意)
    read -rp "Do you want to install LaTeX (TeX Live)? This is large. (y/N) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt-get install -y texlive-full latexmk \
            libfile-homedir-perl libyaml-tiny-perl
        install_zathura_apt
    fi
}

# ============================================================
# pacman 用インストール
# ============================================================
install_pacman() {
    echo "Updating pacman repositories..."
    sudo pacman -Syu --noconfirm

    echo "Installing dependencies..."
    sudo pacman -S --noconfirm --needed \
        git curl wget unzip tar gzip base-devel zsh \
        ripgrep fd \
        xclip wl-clipboard \
        python python-pip \
        go rustup perl php composer \
        shellcheck shfmt ghdl clang pgformatter chktex

    # LaTeX (任意)
    read -rp "Do you want to install LaTeX (TeX Live)? This is large. (y/N) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo pacman -S --noconfirm --needed \
            texlive-basic texlive-latex texlive-latexrecommended \
            texlive-latexextra texlive-fontsrecommended texlive-fontsextra \
            latexmk perl-file-homedir perl-yaml-tiny
        install_zathura_pacman
    fi
}

# ============================================================
# brew 用インストール
# ============================================================
install_brew() {
    echo "Installing core tools..."
    brew install git curl wget unzip zsh \
        ripgrep fd \
        python3 perl php composer \
        shellcheck shfmt \
        llvm chktex \
        node go

    # LaTeX (任意)
    read -rp "Do you want to install LaTeX (TeX Live)? This is large. (y/N) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        brew install --cask mactex-no-gui
        eval "$(/usr/libexec/path_helper)"
        echo "  ⚠️  On macOS, zathura has no official package."
        echo "     Please refer to https://pwmt.org/projects/zathura/ to install manually."
    fi
}

# ============================================================
# zathura
# ============================================================
install_zathura_apt() {
    echo "Installing zathura..."
    sudo apt-get install -y zathura zathura-pdf-mupdf
    echo "zathura installed."
}

install_zathura_pacman() {
    echo "Installing zathura..."
    sudo pacman -S --noconfirm --needed zathura zathura-pdf-mupdf
    echo "zathura installed."
}

# ============================================================
# Rust (rustup)
# ============================================================
install_rust() {
    if command -v rustup &>/dev/null; then
        echo "rustup already installed, skipping."
        return
    fi
    if [ "$PKG_MANAGER" = "brew" ]; then
        echo "Installing Rust via Homebrew..."
        brew install rustup
        rustup-init -y --no-modify-path
    else
        echo "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    fi
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env"
    echo "Rust installed."
}

# ============================================================
# Go（公式tarball）- Linux only
# ============================================================
install_go() {
    if command -v go &>/dev/null; then
        echo "Go already installed ($(go version)), skipping."
        return
    fi

    if [ "$PKG_MANAGER" = "brew" ]; then
        return # brew install_brew内で対応済み
    fi

    echo "Fetching latest Go version..."
    local GO_VERSION
    GO_VERSION=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1 | sed 's/^go//')
    local archive="go${GO_VERSION}.linux-amd64.tar.gz"

    echo "Installing Go ${GO_VERSION}..."
    curl -LO --output-dir "$WORK_DIR" "https://go.dev/dl/$archive"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$WORK_DIR/$archive"
    rm -f "$WORK_DIR/$archive"
    export PATH="$PATH:/usr/local/go/bin"
    echo "Go installed."
}

# ============================================================
# Node.js（NodeSource LTS）- apt only
# ============================================================
install_node() {
    if command -v node &>/dev/null; then
        echo "Node.js already installed ($(node --version)), skipping."
        return
    fi
    echo "Installing Node.js (LTS via NodeSource)..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "Node.js installed."
}

# ============================================================
# Deno
# ============================================================
install_deno() {
    if command -v deno &>/dev/null; then
        echo "Deno already installed, skipping."
        return
    fi
    if [ "$PKG_MANAGER" = "brew" ]; then
        brew install deno
    else
        echo "Installing Deno..."
        curl -fsSL https://deno.land/install.sh | sh
    fi
    echo "Deno installed."
}

# ============================================================
# 言語別ツール（nvim設定から要求されるもの）
# ============================================================
install_tool_deps() {
    echo "Installing language-specific tools for Neovim..."

    # Python
    echo "  Python: pynvim, ruff, black, debugpy, neovim-remote"
    pip3 install --user --upgrade pynvim ruff black debugpy neovim-remote \
        --break-system-packages 2>/dev/null ||
        pip3 install --user --upgrade pynvim ruff black debugpy neovim-remote

    # Node
    echo "  Node: neovim, tree-sitter-cli, prettier"
    sudo npm install -g neovim tree-sitter-cli prettier ||
        npm install -g neovim tree-sitter-cli prettier

    # Go
    echo "  Go: goimports, delve"
    if command -v go &>/dev/null; then
        export GOPATH="$HOME/go"
        export PATH="$PATH:$GOPATH/bin"
        go install golang.org/x/tools/cmd/goimports@latest
        go install github.com/go-delve/delve/cmd/dlv@latest
    else
        echo "  Go not found, skipping."
    fi

    # Rust
    echo "  Rust: stylua"
    if command -v cargo &>/dev/null; then
        cargo install stylua
    else
        echo "  cargo not found, skipping."
    fi

    # PHP
    echo "  PHP: pint"
    if command -v composer &>/dev/null; then
        composer global require laravel/pint
    else
        echo "  composer not found, skipping."
    fi
}

# ============================================================
# SKK辞書
# ============================================================
setup_skk() {
    local SKK_DIR="$HOME/.skk"
    if [ -d "$SKK_DIR" ]; then
        echo "SKK directory already exists, skipping."
        return
    fi

    echo "Downloading SKK dictionaries..."
    mkdir -p "$SKK_DIR"

    curl -LO --output-dir "$SKK_DIR" \
        "https://skk-dev.github.io/dict/SKK-JISYO.L.gz"
    gunzip "$SKK_DIR/SKK-JISYO.L.gz"

    curl -o "$SKK_DIR/SKK-JISYO.emoji.utf8" \
        "https://raw.githubusercontent.com/uasi/skk-emoji-jisyo/master/SKK-JISYO.emoji.utf8" ||
        echo "Warning: Emoji dict download failed, skipping."

    echo "SKK dictionaries installed."
}

# ============================================================
# 実行
# ============================================================
# 1. シンボリックリンク
setup_symlinks

# 2. システムパッケージ
if [ "$PKG_MANAGER" = "apt" ]; then
    install_apt
    install_node
elif [ "$PKG_MANAGER" = "pacman" ]; then
    install_pacman
elif [ "$PKG_MANAGER" = "brew" ]; then
    install_brew
fi

# 3. 最新バイナリが必要なもの
install_neovim
install_rust
install_go
install_deno

# 4. 言語別nvimツール
install_tool_deps

# 5. SKK辞書
setup_skk

# ============================================================
# 完了メッセージ
# ============================================================
echo ""
echo "=========================================="
echo " Setup complete!"
echo "=========================================="
echo ""
echo "[手動対応が必要なもの]"
if [ "$IS_WSL" = true ]; then
    echo "  win32yank (WSL クリップボード):"
    echo "  https://github.com/equalsraf/win32yank/releases から"
    echo "  win32yank.exe を C:\\tools\\ に配置してください。"
fi
echo ""
echo "  ~/.local/bin が PATH に含まれていることを確認してください。"
echo "  (nvr コマンドが使えるようになります)"
echo ""
echo "  nvim を起動してください。lazy.nvim・Masonが自動でセットアップします。"
