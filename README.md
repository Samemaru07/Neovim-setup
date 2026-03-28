# 🌊 Neovim Setup

### アニメキャラが見守る、Arch Linux / WSL 向けのNeovim設定。

#### **思考の速度でコード**を書くことが楽しくなる最高のエディタがここに。

<!-- TODO: 中央寄せにしたほうがいいかも？-->

> [dotfiles](https://github.com/Samemaru07/dotfiles)のサブモジュールとして管理されています。

<!-- TODO: dashboard -->
<!-- TODO: 実際にファイルを作成編集している様子。-->
<!-- TODO: 通知とステータスラインのコラージュ画像-->

## 特徴

- 🎨 カラースキーム: [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)
- 📦 プラグイン管理: [lazy.nvim](https://github.com/folke/lazy.nvim) (起動時に自動インストール)
- 🔧 LSP: [Mason](https://github.com/williamboman/mason.nvim)で自動セットアップ。
- 🌸 ダッシュボード: 園崎 魅音ちゃんのアスキーアートとセリフで出迎え (**ひぐらしのなく頃に**)
- 💬 通知: ヤンク・ペースト・削除のたびにキャラからメッセージが届く (**コードギアス・青ブタ・艦これ・チェンソーマン**)
- ⚔️ ステータスライン: 「保存しておけばどうということはない！」、「そんなファイル、保存してやる！！」 (**機動戦士ガンダム & Zガンダム**)

## 前提条件

| ツール                                  | 備考                                                                                                  |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Neovim >= 0.10                          | aptのものは古い為[公式](https://github.com/neovim/neovim/releases)から最新版を導入                    |
| Git                                     | lazy.nvimのプラグイン取得に必要                                                                       |
| SSHキー                                 | GitHubへのSSHキー登録と`ssh-agent`の起動が必要(`eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519`) |
| build-essential (gcc / make)            | Mason経由のLSPサーバのビルドに必要                                                                    |
| ripgrep                                 | Telescopeのファイル検索に必要                                                                         |
| fd                                      | 同上                                                                                                  |
| Node.js (LTS)                           | aptのものは古い為[NodeSource](https://github.com/nodesource/distributions)経由で導入                  |
| Python3 + pip                           | `pynvim`のインストールに必要                                                                          |
| Go                                      | aptのものは古い為[公式](https://go.dev/dl)                                                            |
| Rust (cargo)                            | `stylua`のインストールに必要                                                                          |
| Deno                                    | SKKプラグインで使用                                                                                   |
| lazygit                                 | Git操作UI                                                                                             |
| [Nerd Font](https://www.nerdfonts.com/) | アイコン表示に必要。FiraCode/JetBrains Mono等をターミナルに設定                                       |

### オプション (言語別ツール)

プラグインの全機能を使うには、以下のフォーマッター・Linterを必要に応じてインストールしてください:

| カテゴリ     | ツール                    | 対象言語   | インストール方法                                                      |
| ------------ | ------------------------- | ---------- | --------------------------------------------------------------------- |
| フォーマット | stylua                    | Lua        | `cargo install stylua`                                                |
| フォーマット | prettier                  | JS/TS/JSON | `npm install -g prettier`                                             |
| フォーマット | black                     | Python     | `pip install black`                                                   |
| フォーマット | clang-format              | C/C++      | `apt install clang-format`                                            |
| フォーマット | shfmt                     | Shell      | `go install mvdan.cc/sh/v3/cmd/shfmt@latest`                          |
| フォーマット | latexindent               | LaTeX      | `apt install latexindent`                                             |
| Linter       | ruff                      | Python     | `pip install ruff`                                                    |
| Linter       | shellcheck                | Shell      | `apt install shellcheck`                                              |
| Linter       | ghdl                      | VHDL       | `apt install ghdl`                                                    |
| LaTeX        | latexmk + lualatex        | LaTeX      | `apt install latexmk texlive-luatex`                                  |
| LaTeX        | neovim-remote             | vimtex     | `pip install neovim-remote`                                           |
| SKK辞書      | SKK-JISYO.L               | 日本語入力 | `~/.skk/` に配置 ([辞書DL](http://openlab.jp/skk/dic/SKK-JISYO.L.gz)) |
| オーディオ   | paplay (pulseaudio-utils) | 通知音     | `apt install pulseaudio-utils`                                        |

> **Note:** LSPサーバやデバッガは[Mason](https://github.com/williamboman/mason.nvim)が自動インストールします。

> **WSL (Ubuntu) ユーザへ:**
> aptのパッケージはNeovim・Node.js・Goが古い為、上記リンクから最新版を導入してください。
> また、クリップボード連携に`win32yank.exe`が必要です。
> [こちら](https://github.com/equalsraf/win32yank/releases)から`win32yank`を`C:\tools\`に配置してください。

> **一括セットアップ:**
> [dotfiles](https://github.com/Samemaru07/dotfiles)のインストールスクリプト`bootstrap.sh`を使うとNeovim本体含む上記ツールを自動で導入できます。

## 🚀 インストール

### dotfilesごと使う場合（推奨）

[dotfiles](https://github.com/Samemaru07/dotfiles)を`--recurse-submodules`でcloneしてください。
詳細はdotfilesの[README](https://github.com/Samemaru07/dotfiles)を参照してください。

### このリポジトリ単体で使う場合

#### WSL (Ubuntu)

##### 0. 事前準備 (Windows)

###### win32yank.exeの配置

1. [win32yank.exe](https://github.com/equalsraf/win32yank/releases)を取得。
2. `C:\tools\`に解凍・配置。

##### 1. 基本ツールのインストール

```bash
sudo apt update
sudo apt install -y git curl build-essential zsh ripgrep fd-find pulseaudio-utils xclip python3 python3-pip shellcheck shfmt clang-format
sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
```

##### 2. Neovimのインストール

aptのものは古い為、公式バイナリを導入します。

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
```

##### 3. 公開鍵認証 (GitHub) の設定

```bash
ssh-keygen -t ed25519 -C "<your@mail>"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

> **Note:** この設定では、`.gitconfig`に以下の記述がある為、lazy.nvimのプラグインcloneがSSH経由になります。

```
    [url "git@github.com:"]
        insteadOf = https://github.com/
```

> その為、Neovim初回起動前にSSH Agentが起動している必要があります。
> `.zshrc`にSSH Agentの自動起動を追記するか、エージェントに秘密鍵を登録する前に、手動で`eval "$(ssh-agent -s)"`を実行してください。

- 出力された公開鍵を[GitHub](https://github.com/settings/keys)に登録。
- 確認

```bash
    ssh -T git@github.com
```

##### 4. クローン

```bash
git clone https://github.com/Samemaru07/Neovim-setup.git ~/.config/nvim
```

##### 5. Neovimを起動

```bash
nvim
```

> 起動するとlazy.nvimが自動でプラグインをインストールします。
> Masonも自動でLSPサーバをセットアップします。

#### Arch Linux

##### 1. 基本ツールのインストール

```bash
sudo pacman -Syu
sudo pacman -S --needed git curl zsh base-devel ripgrep fd xclip wl-clipboard python python-pip nodejs npm go rustup shellcheck shfmt clang
```

##### 2. Neovimのインストール

```bash
sudo pacman -S neovim
```

##### 3. 以降

WSLの手順[3. 公開鍵認証 (GitHub) の設定](<#3.-公開鍵認証-(github)-の設定>) ~ と同様に。

> 起動するとlazy.nvimが自動でプラグインをインストールします。
> Masonも自動でLSPサーバをセットアップします。
