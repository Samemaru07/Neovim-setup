# 🌊 Neovim Setup

<div align="center">
    <h3>A Neovim config for Arch Linux / WSL / macOS, watched over by anime characters.</h3>
</div>

<div align="center">
    <h5>The ultimate editor setup that makes coding at the speed of thought genuinely fun.</h5>
</div>

<div align="center">

[![Editor](https://img.shields.io/badge/Editor-Neovim-57A143?style=flat-square&logo=neovim&logoColor=white)](https://neovim.io)
[![Language](https://img.shields.io/badge/Language-Lua-2C2D72?style=flat-square&logo=lua&logoColor=white)](https://www.lua.org)
[![Plugin Manager](https://img.shields.io/badge/Plugin%20Manager-lazy.nvim-4A90D9?style=flat-square)](https://github.com/folke/lazy.nvim)
[![License](https://img.shields.io/badge/License-MIT-888780?style=flat-square)](./LICENSE)

</div>

> [!NOTE]
> Managed as a submodule of [dotfiles](https://github.com/Samemaru07/dotfiles).

![dashboard](assets/nvim-dashboard.png)

![demo-lsp](assets/nvim-lsp.gif)

![lualine-and-notify](assets/nvim_lualine-notify.JPEG)

## ⭐ Features

- 🎨 Color scheme: [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
- 📦 Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim) (auto-installs on startup)
- 🔧 LSP: Auto-configured via [Mason](https://github.com/willamboman/mason.nvim)
- 🌸 Dashboard: Greeted by ASCII art and quotes from **Mion Sonozaki** (_Higurashi When They Cry_)
- 💬 Notifications: Anime characters send you messages on copy, paste, cut, and delete (_Code Geass, Fafner in the Azure, Rascal Does not Dream, Kantai Collection, Chainsaw Man_)
- ⚔️ Status line: _"If it's saved, it's no big deal!"_ and _"I'll save that file!!"_ (_Mobile Suit Gundam & Zeta Gundam_)

## 📋 Prerequisites

- **Windows native (`nvim.exe`) is currently not recommended.** Please use WSL instead.
- Neovim >= 0.10 is required. Some tools are version-sensitive - packages from `apt` may be outdated. Follow the [Installation section](#🚀-installation) for details.

## 🚀 Installation

### Use with dotfiles (Recommended)

Clone [dotfiles](https://github.com/Samemaru07/dotfiles) with `--recurse-submodules`.
See the dotfiles [README](https://github.com/Samemaru07/dotfiles) for details.

<details>
<summary>macOS</summary>

##### 1. Install Homebrew

If not already installed:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew.install/HEAD/install.sh)"
```

##### 2. Install required tools

```bash
brew install neovim git curl ripgrep fd node go rust shellcheck shfmt llvm
```

> **📍Note:** Installing `llvm` makes `clang-format` available.

##### 3. Python (usually pre-installed on macOS)

```bash
python3 --version
pip3 --version
```

If Python is not available:

```bash
brew install python3
```

##### 4. Optional: Install Deno

```bash
brew install deno
```

##### 5. Nerd Font (Recommended)

A Nerd Font is recommended for proper icon display.

```bash
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
# or
brew install --cask font-jetbrains-mono-nerd-font
```

After installation, change the font in your terminal's settings.

##### 6. Set up SSH key authentication (GitHub)

```bash
ssh-keygen -t ed25519 -C "<your@mail>"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

> **🔴 Important:** This config has the following entry in `.gitconfig` , which forces lazy.nvim to clone plugins over SSH.

```
    [url "git@github.com:"]
        insteadOf = https://github.com/
```

> **⚠️ Warning:** Therefore, SSH Agent must be running before you launch Neovim for the first time.
> On macOS, SSH Agent usually starts automatically, but you can start it manually with `eval "$(ssh-agent -s)"`.

- Register the printed public key on [GitHub](https://github.com/settings/keys).
- Verify:

```bash
    ssh -T git@github.com
```

##### 7. Clone

```bash
git clone https://github.com/Samemaru07/Neovim-setup.git ~/.config/nvim
```

##### 8. Launch Neovim

```bash
nvim
```

> **💡 Tip:** On first launch, lazy.nvim will automatically install all plugins.
> Mason will also set up LSP servers automatically.

</details>

<details>
<summary>WSL (Ubuntu)</summary>

##### 0. Pre-setup (Windows)

###### Place win32yank.exe

1. Download [win32yank](https://github.com/equalsraf/win32yank/releases).
2. Extract and place it in `C:\tools\`.

##### 1. Install basic tools

```bash
sudo apt update
sudo apt install -y git curl build-essential zsh ripgrep fd-find pulseaudio-utils xclip python3 python3-pip shellcheck shfmt clang-format
sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
```

##### 2. Install version-sensitive tools

###### Neovim

The `apt` version is outdated. Install the LTS version via NodeSource instead.

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/vim-linux-x86_64/bin/nvim /usr/local/bin/nvim
```

###### Node.js

The `apt` version is outdated. Install the LTS version via NodeSource instead.

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs -y
```

###### Go

The `apt` version is outdated. Install from the official tarball instead.

```bash
GO_VERSION=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -1 | sed 's/^go//')
curl -LO "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
export PATH="$PATH:/usr/local/go/bin"
```

###### Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

###### Deno

```bash
curl -fsSL https://deno.land/install.sh | sh
```

##### 3. Set up SSH key authentication (GitHub)

```bash
ssh-keygen -t ed25519 -C "<your@mail>"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

> **🔴 Important:** This config has the following entry in `.gitconfig`, which forces lazy.nvim to clone plugins over SSH.

```
    [url "git@github.com:"]
        insteadOf = https://github.com/
```

> **⚠️ Warning:** Terefore, SSH Agent must be running before you launch Neovim for the first time.
> Add SSH Agent auto-start to you `.zshrc`, or run `eval "$(ssh-agent -s)"` manuall before adding your key.

- Register the printed public key on [GitHub](https://github.com/settings/keys).
- Verify:

```bash
    ssh -T git@github.com
```

##### 4. Clone

```bash
git clone https://github.com/Samemaru07/Neovim-setup.git ~/.config/nvim
```

##### 5. Launch Neovim

```bash
nvim
```

> **💡 Tip:** On first launch, lazy.nvim will automatically install all plugins.
> Mason will also set up LSP servers automatically.

</details>
