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

- Neovim >= 0.10が必要です。また、いくつかのツールはバージョンが重要な為、`apt`のものは古い場合があります。詳しくは[インストールセクション](#🚀-インストール)に従ってください。

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

##### 2. バージョンが重要なツールのインストール

###### Neovim

aptのものは古い為、公式バイナリを導入します。

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
```

###### Node.js

aptのものは古い為、NodeSource経由でLTSを導入します。

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install nodejs -y
```

###### Go

aptのものは古い為、公式tarballを導入します。

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

## プラグイン一覧

### UI

| プラグイン名                                                        | 説明                     |
| ------------------------------------------------------------------- | ------------------------ |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | アイコン表示             |
| [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)         | ファイルエクスプローラ   |
| [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)       | バッファライン表示       |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)        | ステータスライン         |
| [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)       | ターミナルトグル         |
| [trouble.nvim](https://github.com/folke/trouble.nvim)               | 診断・参照の一覧表示     |
| [catppuccin](https://github.com/catppuccin/nvim)                    | カラースキーム           |
| [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)           | カラースキーム           |
| [alpha-nvim](https://github.com/goolord/alpha-nvim)                 | ダッシュボード           |
| [hlchunk.nvim](https://github.com/shellRaining/hlchunk.nvim)        | インデントハイライト     |
| [noice.nvim](https://github.com/folke/noice.nvim)                   | UI拡張                   |
| [nui.nvim](https://github.com/MunifTanjim/nui.nvim)                 | UI部品ライブラリ         |
| [nvim-notify](https://github.com/rcarriga/nvim-notify)              | 通知システム             |
| [which-key.nvim](https://github.com/folke/which-key.nvim)           | キーバインド表示         |
| [SmoothCursor.nvim](https://github.com/gen740/SmoothCursor.nvim)    | カーソルアニメーション   |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim)   | TODOコメント強調         |
| [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim)          | スムーススクロール       |
| [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)             | ウィンバーナビゲーション |

### LSP

| プラグイン名                                                                              | 説明                        |
| ----------------------------------------------------------------------------------------- | --------------------------- |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                                | LSP設定                     |
| [mason.nvim](https://github.com/williamboman/mason.nvim)                                  | LSP/DAP/Linterマネージャ    |
| [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Masonツール自動インストール |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)              | Mason-LSP連携               |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim)                                     | Lua LSP拡張                 |
| [luvit-meta](https://github.com/Bilal2453/luvit-meta)                                     | Lua型定義                   |
| [fidget.nvim](https://github.com/j-hui/fidget.nvim)                                       | LSP進捗表示                 |

### 補完

| プラグイン名                                                                        | 説明                     |
| ----------------------------------------------------------------------------------- | ------------------------ |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                                     | 補完エンジン             |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)                             | LSP補完ソース            |
| [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)                                 | バッファ補完ソース       |
| [cmp-path](https://github.com/hrsh7th/cmp-path)                                     | パス補完ソース           |
| [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)                               | コマンドライン補完ソース |
| [cmp-skkeleton](https://github.com/uga-rosa/cmp-skkeleton)                          | SKK補完ソース            |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip)                                      | スニペットエンジン       |
| [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)                | スニペット集             |
| [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip)                          | LuaSnip補完ソース        |
| [skkeleton](https://github.com/vim-skk/skkeleton)                                   | SKK日本語入力            |
| [denops.vim](https://github.com/vim-denops/denops.vim)                              | Denoランタイム           |
| [skkeleton_indicator.nvim](https://github.com/delphinus/skkeleton_indicator.nvim)   | SKKモード表示            |
| [skkeleton-henkan-highlight](https://github.com/NI57721/skkeleton-henkan-highlight) | SKK変換ハイライト        |

### エディタ

| プラグイン名                                                                                    | 説明                   |
| ----------------------------------------------------------------------------------------------- | ---------------------- |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)                           | シンタックス解析       |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)           | コンテキスト表示       |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs)                                      | 括弧自動補完           |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag)                                    | HTMLタグ自動閉じ       |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim)                                        | コメントトグル         |
| [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) | コメント文字列自動設定 |
| [nvim-surround](https://github.com/kylechui/nvim-surround)                                      | 囲み文字操作           |
| [flash.nvim](https://github.com/folke/flash.nvim)                                               | 高速移動               |
| [emmet-vim](https://github.com/mattn/emmet-vim)                                                 | HTML/CSS展開           |
| [beacon.nvim](https://github.com/rainbowhxch/beacon.nvim)                                       | カーソル位置強調       |

### 言語

| プラグイン名                                                                     | 説明                  |
| -------------------------------------------------------------------------------- | --------------------- |
| [vimtex](https://github.com/lervag/vimtex)                                       | LaTeX統合環境         |
| [flutter-tools.nvim](https://github.com/nvim-flutter/flutter-tools.nvim)         | Flutter開発支援       |
| [verilog_systemverilog.vim](https://github.com/vhda/verilog_systemverilog.vim)   | Verilog/SystemVerilog |
| [vim-dadbod](https://github.com/tpope/vim-dadbod)                                | データベース接続      |
| [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui)                 | データベースUI        |
| [vim-dadbod-completion](https://github.com/kristijanhusak/vim-dadbod-completion) | DB補完                |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)         | Markdownプレビュー    |
| [bibcite.nvim](https://github.com/aidavdw/bibcite.nvim)                          | BibTeX管理            |
| [vim-processing](https://github.com/sophacles/vim-processing)                    | Processing対応        |

### ツール

| プラグイン名                                                                             | 説明               |
| ---------------------------------------------------------------------------------------- | ------------------ |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                       | ファジーファインダ |
| [nvim-spectre](https://github.com/nvim-pack/nvim-spectre)                                | 検索置換UI         |
| [conform.nvim](https://github.com/stevearc/conform.nvim)                                 | フォーマッタ管理   |
| [nvim-lint](https://github.com/mfussenegger/nvim-lint)                                   | Linter管理         |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                              | Git差分表示        |
| [nvim-dap](https://github.com/mfussenegger/nvim-dap)                                     | デバッガ           |
| [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)                                   | デバッガUI         |
| [nvim-nio](https://github.com/nvim-neotest/nvim-nio)                                     | 非同期I/O          |
| [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text)              | デバッグ変数表示   |
| [mason-nvim-dap.nvim](https://github.com/jay-babu/mason-nvim-dap.nvim)                   | Mason-DAP連携      |
| [neotest](https://github.com/nvim-neotest/neotest)                                       | テストランナー     |
| [FixCursorHold.nvim](https://github.com/antoinemadec/FixCursorHold.nvim)                 | CursorHold修正     |
| [telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) | Telescope高速化    |
| [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)                                 | Lua関数ライブラリ  |
| [dressing.nvim](https://github.com/stevearc/dressing.nvim)                               | UI選択拡張         |

## ツール一覧

### フォーマッター

| ツール名               | 対象言語                                     |
| ---------------------- | -------------------------------------------- |
| prettier               | HTML、JavaScript、TypeScript、JSON、Markdown |
| black                  | Python                                       |
| clang_format           | C、C++、Processing                           |
| pint                   | PHP                                          |
| stylua                 | Lua                                          |
| shfmt                  | Shell                                        |
| pg_format              | SQL                                          |
| latexindent            | LaTeX、BibTeX                                |
| verible-verilog-format | Verilog                                      |
| goimports              | Go                                           |
| qmlformat              | QML                                          |
| markdownlint           | Markdown                                     |

### Linter

| ツール名   | 対象言語 |
| ---------- | -------- |
| ruff       | Python   |
| ghdl       | VHDL     |
| shellcheck | Shell    |

### LaTeX

| ツール名      | 説明                  |
| ------------- | --------------------- |
| latexmk       | LaTeX自動ビルドツール |
| lualatex      | LaTeXエンジン         |
| neovim-remote | vimtex用リモート操作  |

### SKK辞書

| 辞書名       | 説明                    |
| ------------ | ----------------------- |
| SKK-JISYO.L  | SKK辞書（システム辞書） |
| ~/.skkeleton | SKKユーザー辞書         |

### オーディオ

| ツール名 | 説明       |
| -------- | ---------- |
| paplay   | 通知音再生 |

<!-- > **環境別の読み替えについて:**\ -->
<!-- > 以下のインストール方法は**WSL (Ubuntu) ** を基準に記載しています。**Arch Linux**をお使いの場合は、`apt`→`pacman -S` / `yay -S`に読み替えてください。 -->
<!---->
 <!-- > macOSをお使いの場合は、`apt`→`brew install`に読み替えてください -->
<!---->
<!-- | ツール                                  | 備考                                                      | -->
<!-- | --------------------------------------- | --------------------------------------------------------- | -->
<!-- | Neovim >= 0.10                          | aptのものは古い                                           | -->
<!-- | Git                                     | lazy.nvimのプラグイン取得に必要                           | -->
<!-- | SSHキー                                 | GitHubへのSSH登録とSSH Agentの起動が必要                  | -->
<!-- | build-essential (gcc / make)            | Mason経由のLSPサーバのビルドに必要                        | -->
<!-- | ripgrep                                 | Telescopeのファイル検索に必要                             | -->
<!-- | fd                                      | 同上。WSLでは`fdfind`として入る為シンボリックリンクが必要 | -->
<!-- | Node.js (LTS)                           | aptのものは古い                                           | -->
<!-- | Python3 + pip                           | `pynvim`のインストールに必要                              | -->
<!-- | Go                                      | aptのものは古い                                           | -->
<!-- | Rust (cargo)                            | `stylua`のインストールに必要                              | -->
<!-- | Deno                                    | Neovim内SKKプラグインで使用                               | -->
<!-- | lazygit                                 | Git操作UI                                                 | -->
<!-- | [Nerd Font](https://www.nerdfonts.com/) | アイコン表示に必要                                        | -->
<!---->
<!-- > **WSL (Ubuntu) ユーザへ:**\ -->
<!-- > Neovim・Node.js・Go・Denoは、aptのものが古いか未収録の為、インストールセクションの手順に従ってください。 -->
<!---->
<!-- ### オプション (言語別ツール) -->
<!---->
<!-- プラグインの全機能を使うには、以下のフォーマッター・Linterを必要に応じてインストールしてください: -->
<!---->
<!-- | カテゴリ     | ツール                    | 対象言語   | インストール方法                                                      | -->
<!-- | ------------ | ------------------------- | ---------- | --------------------------------------------------------------------- | -->
<!-- | フォーマット | stylua                    | Lua        | `cargo install stylua`                                                | -->
<!-- | フォーマット | prettier                  | JS/TS/JSON | `npm install -g prettier`                                             | -->
<!-- | フォーマット | black                     | Python     | `pip install black`                                                   | -->
<!-- | フォーマット | clang-format              | C/C++      | `apt install clang-format`                                            | -->
<!-- | フォーマット | shfmt                     | Shell      | `go install mvdan.cc/sh/v3/cmd/shfmt@latest`                          | -->
<!-- | フォーマット | latexindent               | LaTeX      | `apt install latexindent`                                             | -->
<!-- | Linter       | ruff                      | Python     | `pip install ruff`                                                    | -->
<!-- | Linter       | shellcheck                | Shell      | `apt install shellcheck`                                              | -->
<!-- | Linter       | ghdl                      | VHDL       | `apt install ghdl`                                                    | -->
<!-- | LaTeX        | latexmk + lualatex        | LaTeX      | `apt install latexmk texlive-luatex`                                  | -->
<!-- | LaTeX        | neovim-remote             | vimtex     | `pip install neovim-remote`                                           | -->
<!-- | SKK辞書      | SKK-JISYO.L               | 日本語入力 | `~/.skk/` に配置 ([辞書DL](http://openlab.jp/skk/dic/SKK-JISYO.L.gz)) | -->
<!-- | オーディオ   | paplay (pulseaudio-utils) | 通知音     | `apt install pulseaudio-utils`                                        | -->
<!---->
<!-- > **Note:** LSPサーバやデバッガは[Mason](https://github.com/williamboman/mason.nvim)が自動インストールします。 -->
<!---->
<!-- > **WSL (Ubuntu) ユーザへ:** -->
<!-- > aptのパッケージはNeovim・Node.js・Goが古い為、上記リンクから最新版を導入してください。 -->
<!-- > また、クリップボード連携に`win32yank.exe`が必要です。 -->
<!-- > [こちら](https://github.com/equalsraf/win32yank/releases)から`win32yank`を`C:\tools\`に配置してください。 -->
<!---->
<!-- > **一括セットアップ:** -->
<!-- > [dotfiles](https://github.com/Samemaru07/dotfiles)のインストールスクリプト`bootstrap.sh`を使うとNeovim本体含む上記ツールを自動で導入できます。 -->
