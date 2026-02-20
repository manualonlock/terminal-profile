# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias pip=pip3
alias pip-login='cd $HOME/Projects/monorepo && task pip-login && source pip.env && cd -'
alias npm-login='cd $HOME/Projects/monorepo && task npm-login && source npm.env && cd -'
alias ecr-login='cd $HOME/Projects/monorepo && task docker-login-ecr-cache && cd -'
alias project_root="git rev-parse --show-toplevel"
alias lzd='lazydocker'
alias ls="lsd"
export BAT_THEME="Catppuccin Mocha"
if command -v bat &>/dev/null; then
    alias cat="bat"
elif command -v batcat &>/dev/null; then
    alias cat="batcat"
fi
alias vim='nvim'

# Enable VI Mode
setopt VI

# Set ls color scheme
export VIVID_COLOR_SCHEME="molokai"
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

# CPU/GPU cache for fast neofetch startup
CHIPS_CACHE="$HOME/.config/neofetch/.chips"
if [ ! -f "$CHIPS_CACHE" ]; then
    mkdir -p "$(dirname "$CHIPS_CACHE")"
    if [ "$(uname -s)" = "Darwin" ]; then
        cpu="$(sysctl -n machdep.cpu.brand_string) ($(sysctl -n hw.ncpu))"
        gpu="$(system_profiler SPDisplaysDataType 2>/dev/null | grep -E 'Chipset Model|Chip Model' | head -1 | sed 's/.*: //' | xargs)"
    else
        cpu="$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^ *//') ($(nproc))"
        gpu="$(lspci 2>/dev/null | grep -iE 'vga|3d|display' | head -1 | sed 's/.*: //')"
    fi
    printf 'export CACHED_CPU="%s"\nexport CACHED_GPU="%s"\n' "$cpu" "$gpu" > "$CHIPS_CACHE"
fi
source "$CHIPS_CACHE"

neofetch
