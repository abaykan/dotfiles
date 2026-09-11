# dotfiles

Personal configuration files for zsh, kitty, nvim, git, btop, and omakub.

## What's included

- **.zshrc** - Shell config (Oh My Zsh, Powerlevel10k, aliases, functions, PATH)
- **zsh/.p10k.zsh** - Powerlevel10k prompt config (rainbow, Nerd Font icons)
- **kitty/** - Kitty terminal config + VSCode Dark theme, plus `serialchiller.conf` (selectable via `kitty +kitten themes`)
- **nvim/** - Neovim config (LazyVim + lazy.nvim)
- **git/.gitconfig** - Git config
- **bin/** - Custom scripts (openapi-checker.sh, googleapicheck, basic-recon.sh)
- **gtk/gtk.css** - Dark theme for Nemo file manager (VSCode Dark)
- **btop/** - btop theme "serialchiller" (VSCode Dark palette)
- **omakub/** - Omakub user theme "serialchiller" (VSCode Dark palette)
- **macchina/** - Macchina system info theme "serialchiller" + default config

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

### Omakub theme (optional)

After install, apply the serialchiller theme with:

```bash
omakub theme set serialchiller
```

Switch back anytime with `omakub theme set nord` (or any other theme).

## Prerequisites

- zsh + [Oh My Zsh](https://ohmyz.sh/)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [Neovim](https://neovim.io/) + [LazyVim](https://www.lazyvim.org/)
- [Nemo](https://github.com/linuxmint/nemo) file manager
- [btop](https://github.com/aristocratos/btop) (optional, for serialchiller theme)
- [Omakub](https://omakub.org/) (optional, for serialchiller theme)
- git
