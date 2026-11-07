# ---------------------------------------------------------------------------
# PATH
# ---------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt AUTO_CD INTERACTIVE_COMMENTS NO_BEEP

# ---------------------------------------------------------------------------
# Completion (menu with colors, case-insensitive)
# ---------------------------------------------------------------------------
if command -v brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi
autoload -Uz compinit
# Rebuild the completion dump at most once a day
() {
    setopt local_options extended_glob
    if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) || ! -f ${ZDOTDIR:-$HOME}/.zcompdump ]]; then
        compinit
    else
        compinit -C
    fi
}
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*:descriptions' format '%F{magenta}-- %d --%f'

# ---------------------------------------------------------------------------
# Colors — Catppuccin Mocha everywhere
# ---------------------------------------------------------------------------
export VIVID_COLOR_SCHEME="catppuccin-mocha"
command -v vivid &>/dev/null && export LS_COLORS="$(vivid generate "$VIVID_COLOR_SCHEME")"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

export BAT_THEME="Catppuccin Mocha"
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"   # keep lazygit config in ~/.config on macOS too
export FZF_DEFAULT_OPTS=" \
  --height=40% --layout=reverse --border=rounded --info=inline-right \
  --color=bg+:#313244,bg:-1,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a,border:#6c7086,label:#cdd6f4"
command -v fd &>/dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
alias pip=pip3
alias pip-login='cd $HOME/Projects/monorepo && task pip-login && source pip.env && cd -'
alias npm-login='cd $HOME/Projects/monorepo && task npm-login && source npm.env && cd -'
alias ecr-login='cd $HOME/Projects/monorepo && task docker-login-ecr-cache && cd -'
alias project_root="git rev-parse --show-toplevel"
alias lzd='lazydocker'
alias lgit='lazygit'
alias vim='nvim'

if command -v lsd &>/dev/null; then
    alias ls="lsd"
    alias ll="lsd -l --group-directories-first"
    alias la="lsd -la --group-directories-first"
    alias lt="lsd --tree --depth 2"
fi
if command -v bat &>/dev/null; then
    alias cat="bat --paging=never"
elif command -v batcat &>/dev/null; then
    alias cat="batcat --paging=never"
fi

# ---------------------------------------------------------------------------
# VI mode
# ---------------------------------------------------------------------------
bindkey -v
export KEYTIMEOUT=1
bindkey '^R' history-incremental-search-backward   # replaced by fzf below if present
bindkey '^?' backward-delete-char                   # backspace past insert point

# ---------------------------------------------------------------------------
# Tools
# ---------------------------------------------------------------------------
command -v fzf &>/dev/null && source <(fzf --zsh)          # ^R history, ^T files, Alt-C cd
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"  # `z <dir>`

# Prompt (skipped in Apple Terminal — no true color there)
export POSH_CONFIG_FILE_PATH="$HOME/.config/posh/posh.json"
if [ "$TERM_PROGRAM" != "Apple_Terminal" ] && command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh init zsh --config "$POSH_CONFIG_FILE_PATH")"
fi

# ---------------------------------------------------------------------------
# Plugins (cloned by install.sh into ~/.zsh)
# ---------------------------------------------------------------------------
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
# Syntax highlighting must be sourced last
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    [ -f ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh ] && \
        source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ---------------------------------------------------------------------------
# Greeting
# ---------------------------------------------------------------------------
if [[ -o interactive ]] && command -v fastfetch &>/dev/null; then
    fastfetch
fi
