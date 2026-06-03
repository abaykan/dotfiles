# dotfiles

My personal configuration files.

## What's included

- **shell/** - zsh + Oh My Zsh (minimal theme, autosuggestions, syntax-highlighting)
- **kitty/** - Kitty terminal config + VSCode Dark theme
- **nvim/** - Neovim config + custom VSCode Dark colorscheme
- **git/** - Git config

## Install

```bash
git clone https://github.com/abaykustirama/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

Existing configs will be backed up to `~/.dotfiles-backup/`.

## Prerequisites

- zsh + [Oh My Zsh](https://ohmyz.sh/)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [Neovim](https://neovim.io/) + [vim-plug](https://github.com/junegunn/vim-plug)
- git
