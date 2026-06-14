# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias pip=pip3
alias pip-login='cd $HOME/Projects/monorepo && task pip-login && source pip.env && cd -'
alias npm-login='cd $HOME/Projects/monorepo && task npm-login && source npm.env && cd -'
alias ecr-login='cd $HOME/Projects/monorepo && task docker-login-ecr-cache && cd -'
alias project_root="git rev-parse --show-toplevel"
alias lzd='lazydocker'
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza --icons=auto --group-directories-first --long --git'
alias la='eza --icons=auto --group-directories-first --all'
alias tree='eza --icons=auto --tree'
export BAT_THEME="Catppuccin Mocha"
if command -v bat &>/dev/null; then
    alias cat="bat"
elif command -v batcat &>/dev/null; then
    alias cat="batcat"
fi
alias vim='nvim'

# Enable VI Mode
setopt VI

# Init Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# TODO: figure out if needed for darwin builds 
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Source out of autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

fastfetch
