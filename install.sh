#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

mkdir -p "$BACKUP_DIR"

backup() {
    local src="$1"
    if [ -e "$src" ] && [ ! -L "$src" ]; then
        mv "$src" "$BACKUP_DIR/"
        echo "  backed up: $src"
    fi
}

link() {
    local src="$1"
    local dst="$2"
    mkdir -p "$(dirname "$dst")"
    backup "$dst"
    ln -sf "$src" "$dst"
    echo "  linked: $dst -> $src"
}

echo "Backing up existing configs to $BACKUP_DIR..."
echo ""

# Shell
echo "[shell]"
link "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Kitty
echo "[kitty]"
link "$DOTFILES_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
link "$DOTFILES_DIR/kitty/current-theme.conf" "$HOME/.config/kitty/current-theme.conf"

# Neovim
echo "[nvim]"
link "$DOTFILES_DIR/nvim/init.vim" "$HOME/.config/nvim/init.vim"
link "$DOTFILES_DIR/nvim/colors/onedark-custom.vim" "$HOME/.config/nvim/colors/onedark-custom.vim"

# Git
echo "[git]"
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# Bin scripts
echo "[bin]"
mkdir -p "$HOME/bin"
link "$DOTFILES_DIR/bin/openapi-checker.sh" "$HOME/bin/openapi-checker.sh"
link "$DOTFILES_DIR/bin/googleapicheck" "$HOME/bin/googleapicheck"

# GTK (Nemo file manager)
echo "[gtk]"
mkdir -p "$HOME/.config/gtk-3.0"
link "$DOTFILES_DIR/gtk/gtk.css" "$HOME/.config/gtk-3.0/gtk.css"

echo ""
echo "Done. Restart your shell to apply changes."
echo ""
echo "Make sure ~/bin is in your PATH:"
echo "  export PATH=\"\$HOME/bin:\$PATH\""
