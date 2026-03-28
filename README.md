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

| ツール                                 | 備考                                                                                                  |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| Neovim >= 0.10                         | aptのものは古い為[公式](https://github.com/neovim/neovim/releases)から最新版を導入                    |
| Git                                    | lazy.nvimのプラグイン取得に必要                                                                       |
| SSHキー                                | GitHubへのSSHキー登録と`ssh-agent`の起動が必要(`eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519`) |
| build-essential (gcc / make)           | Mason経由のLSPサーバのビルドに必要                                                                    |
| ripgrep                                | Telescopeのファイル検索に必要                                                                         |
| fd                                     | 同上                                                                                                  |
| Node.js (LTS)                          | aptのものは古い為[NodeSource](https://github.com/nodesource/distributions)経由で導入                  |
| Python3 + pip                          | `pynvim`のインストールに必要                                                                          |
| Go                                     | aptのものは古い為[公式](https://go.dev/dl)                                                            |
| Rust (cargo)                           | `stylua`のインストールに必要                                                                          |
| Deno                                   | SKKプラグインで使用                                                                                   |
| lazygit                                | Git操作UI                                                                                             |
| [Nerd Font](https://www.nerdfonts.com/) | アイコン表示に必要。FiraCode/JetBrains Mono等をターミナルに設定                                      |

### オプション (言語別ツール)

プラグインの全機能を使うには、以下のフォーマッター・Linterを必要に応じてインストールしてください:

| カテゴリ     | ツール                          | 対象言語    | インストール方法                       |
| ------------ | ------------------------------- | ----------- | -------------------------------------- |
| フォーマット | stylua                          | Lua         | `cargo install stylua`                 |
| フォーマット | prettier                        | JS/TS/JSON  | `npm install -g prettier`              |
| フォーマット | black                           | Python      | `pip install black`                    |
| フォーマット | clang-format                    | C/C++       | `apt install clang-format`             |
| フォーマット | shfmt                           | Shell       | `go install mvdan.cc/sh/v3/cmd/shfmt@latest` |
| フォーマット | latexindent                     | LaTeX       | `apt install latexindent`              |
| Linter       | ruff                            | Python      | `pip install ruff`                     |
| Linter       | shellcheck                      | Shell       | `apt install shellcheck`               |
| Linter       | ghdl                            | VHDL        | `apt install ghdl`                     |
| LaTeX        | latexmk + lualatex              | LaTeX       | `apt install latexmk texlive-luatex`   |
| LaTeX        | neovim-remote                   | vimtex      | `pip install neovim-remote`            |
| SKK辞書      | SKK-JISYO.L                     | 日本語入力  | `~/.skk/` に配置 ([辞書DL](http://openlab.jp/skk/dic/SKK-JISYO.L.gz)) |
| オーディオ   | paplay (pulseaudio-utils)       | 通知音      | `apt install pulseaudio-utils`         |

> **Note:** LSPサーバやデバッガは[Mason](https://github.com/williamboman/mason.nvim)が自動インストールします。

> **WSL (Ubuntu) ユーザへ:**
> aptのパッケージはNeovim・Node.js・Goが古い為、上記リンクから最新版を導入してください。
> また、クリップボード連携に`win32yank.exe`が必要です。
> [こちら](https://github.com/equalsraf/win32yank/releases)から`win32yank`を`C:\tools\`に配置してください。

> **一括セットアップ:**
> [dotfiles](https://github.com/Samemaru07/dotfiles)のインストールスクリプト`bootstrap.sh`を使うとNeovim本体含む上記ツールを自動で導入できます。
