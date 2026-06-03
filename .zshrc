# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="minimal"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Aliases
alias ll="ls -lah"
alias vim="nvim"
alias humble="python3 $HOME/tools/humble/humble.py"
alias testssl="bash $HOME/tools/testssl.sh/testssl.sh"
alias webroot="cd /var/www/html"
alias jadx="flatpak run com.github.skylot.jadx"

# PATH
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH="/usr/local/go/bin:$HOME/go/bin:$HOME/.pdtm/go/bin:$PATH"
export PATH="$HOME/.gems/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# Environment
export GEM_HOME="$HOME/.gems"
export NVM_DIR="$HOME/nvm"
export TERM=xterm-256color
export PYTHONWARNINGS="ignore"

# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
