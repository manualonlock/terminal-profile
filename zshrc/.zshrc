# Aliases 
alias pip=pip3
alias pip-login='cd $HOME/Projects/monorepo && task pip-login && source pip.env && cd -'
alias npm-login='cd $HOME/Projects/monorepo && task npm-login && source npm.env && cd -'
alias ecr-login='cd $HOME/Projects/monorepo && task docker-login-ecr-cache && cd -'
alias project_root="git rev-parse --show-toplevel"
alias lzd='lazydocker'
alias ls="lsd"
alias cat="bat"
alias vim='nvim'

# Enable VI Mode
setopt VI

# Set ls color scheme
VIVID_COLOR_SCHEME = "molokai"
export LS_COLORS=$(vivid generate "$VIVID_COLOR_SCHEME")

# Init the posh config, ignore in Iterm
export POSH_CONFIG_FILE_PATH="$HOME/.config/posh/posh.json"
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
eval "$(oh-my-posh init zsh --config $POSH_CONFIG_FILE_PATH)"
fi

# TODO: figure out if needed for darwin builds 
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Source out of autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
