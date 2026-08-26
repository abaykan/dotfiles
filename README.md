# dotfiles

Personal configuration files for zsh, kitty, nvim, and git.

## What's included

- **.zshrc** - Shell config (Oh My Zsh, aliases, functions, PATH)
- **kitty/** - Kitty terminal config + VSCode Dark theme
- **nvim/** - Neovim config + custom VSCode Dark colorscheme
- **git/.gitconfig** - Git config
- **bin/** - Custom scripts (openapi-checker.sh, googleapicheck, basic-recon.sh)
- **gtk/gtk.css** - Dark theme for Nemo file manager (VSCode Dark)

## Custom commands

| Command | Function |
|---------|----------|
| `mkdir namafolder` | Create directory and enter it |
| `cekip` | Check public IP via ipconfig.io |
| `extract file.zip` | Universal extract (tar, zip, 7z, gz, xz) |
| `path` | Show all PATH entries |
| `reload` | Restart shell without closing terminal |

### Aliases

| Alias | Command |
|-------|---------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `ll` | `ls -lah` |
| `vim` | `nvim` |

## Install

```bash
git clone git@github.com:abaykan/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

Existing configs will be backed up to `~/.dotfiles-backup/`.

## Prerequisites

- zsh + [Oh My Zsh](https://ohmyz.sh/)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [Neovim](https://neovim.io/) + [vim-plug](https://github.com/junegunn/vim-plug)
- [Nemo](https://github.com/linuxmint/nemo) file manager
- git
