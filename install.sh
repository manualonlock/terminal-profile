#!/usr/bin/env bash
detect_pm() {
  if command -v brew >/dev/null 2>&1; then
    echo "brew"
  elif command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v yum >/dev/null 2>&1; then
    echo "yum"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  else
    echo "none"
  fi
}

INSTALL_DESKTOP=false
CONFIGS_ONLY=false

for arg in "$@"; do
  case "$arg" in
    --desktop)
      INSTALL_DESKTOP=true
      ;;
    --configs-only)
      CONFIGS_ONLY=true
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--desktop] [--configs-only]"
      exit 1
      ;;
  esac
done

cd "$(dirname "$0")"

PM="$(detect_pm)"

brew_install_packages() {
  brew install \
    font-hack-nerd-font \
    vivid \
    lsd \
    fzf \
    bat \
    virtualenv \
    nvim \
    opencode \
    go \
    glow \
    fastfetch \
    zoxide \
    ripgrep \
    fd \
    shellcheck \
    tree-sitter-cli \
    tmux \
    lazygit \
    git-delta

  if [ "$INSTALL_DESKTOP" = true ]; then
    brew install --cask \
      handy \
      homerow \
      1password \
      chatgpt \
      deepl \
      caffeine \
      thaw \
      obsidian \
      warp \
      thebrowsercompany-dia \
      betterdisplay \
      tailscale-app \
      rectangle-pro
  fi
}

install_nvim_tarball() {
  mkdir -p ~/.local/bin
  ARCH=$(uname -m)
  if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    NVIM_ARCH="nvim-linux-arm64"
  else
    NVIM_ARCH="nvim-linux-x86_64"
  fi
  curl -LO "https://github.com/neovim/neovim/releases/latest/download/${NVIM_ARCH}.tar.gz"
  tar xzf "${NVIM_ARCH}.tar.gz"
  rm -rf ~/.local/"${NVIM_ARCH}"
  mv "${NVIM_ARCH}" ~/.local/
  ln -sf ~/.local/"${NVIM_ARCH}"/bin/nvim ~/.local/bin/nvim
  rm "${NVIM_ARCH}.tar.gz"
}

apt_install_packages() {
  sudo apt-get update
  sudo apt-get install -y \
    fonts-hack \
    vivid \
    lsd \
    fzf \
    fastfetch \
    zoxide \
    ripgrep \
    fd-find \
    tmux \
    git-delta \
    shellcheck \
    bat \
    virtualenv \
    glow
  install_nvim_tarball
}

install_oh_my_posh() {
  if command -v oh-my-posh >/dev/null 2>&1 || [ -x "$HOME/.local/bin/oh-my-posh" ]; then
    echo "Oh My Posh is already installed"
    return
  fi

  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
}

install_hermes_agent() {
  if command -v hermes >/dev/null 2>&1 || [ -x "$HOME/.local/bin/hermes" ]; then
    echo "Hermes Agent is already installed"
    return
  fi

  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
}

install_packages() {
  case "$PM" in
    brew)
      brew_install_packages
      ;;
    apt)
      apt_install_packages
      ;;
    *)
      echo "No supported package manager found"
      ;;
  esac

  install_oh_my_posh
  install_hermes_agent
}

clone_or_update() {
  if [ -d "$2/.git" ]; then
    git -C "$2" pull --quiet --ff-only || true
  else
    git clone --depth 1 "$1" "$2"
  fi
}

install_configs() {
  mkdir -p ~/.config

  # A leftover kickstart.nvim checkout breaks the merge-copy below; move it aside once
  if [ -d ~/.config/nvim/lua/kickstart ]; then
    backup=~/.config/nvim.bak.$(date +%Y%m%d%H%M%S)
    echo "Backing up old Neovim config to $backup"
    mv ~/.config/nvim "$backup"
  fi

  for config_dir in posh nvim fastfetch ghostty zshrc tmux lazygit git; do
    cp -rf "$config_dir" ~/.config/
  done

  # ZSH plugins
  mkdir -p ~/.zsh
  clone_or_update https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
  curl -fsSL \
    https://raw.githubusercontent.com/catppuccin/zsh-syntax-highlighting/main/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh \
    -o ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh || true

  # Source from configured .zshrc (append only if missing)
  LINE='source ~/.config/zshrc/.zshrc'
  FILE="$HOME/.zshrc"
  touch "$FILE"
  grep -qxF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
}

if [ "$CONFIGS_ONLY" = false ]; then
  install_packages
fi
install_configs

# Git aliases
if command -v git >/dev/null 2>&1; then
  git config --global alias.co checkout
  git config --global alias.ci commit
  # delta pager settings live in ~/.config/git/delta.gitconfig
  INCLUDE="$HOME/.config/git/delta.gitconfig"
  git config --global --get-all include.path | grep -qxF "$INCLUDE" || \
    git config --global --add include.path "$INCLUDE"
fi

echo "Done. Open a new Ghostty window (or run: exec zsh) to see the changes."
