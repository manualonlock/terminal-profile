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

for arg in "$@"; do
  case "$arg" in
    --desktop)
      INSTALL_DESKTOP=true
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: $0 [--desktop]"
      exit 1
      ;;
  esac
done

PM="$(detect_pm)"

brew_install_packages() {
  brew install \
    font-hack-nerd-font \
    starship \
    eza \
    tree-sitter-cli \
    go \
    fzf \
    fastfetch \
    bat \
    virtualenv \
    nvim \
    glow

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

install_fastfetch_deb() {
  case "$(uname -m)" in
    x86_64)
      FASTFETCH_ARCH="amd64"
      ;;
    aarch64|arm64)
      FASTFETCH_ARCH="aarch64"
      ;;
    armv7l)
      FASTFETCH_ARCH="armv7l"
      ;;
    *)
      echo "Unsupported Fastfetch architecture: $(uname -m)"
      return 1
      ;;
  esac

  FASTFETCH_DEB="/tmp/fastfetch-linux-${FASTFETCH_ARCH}.deb"
  curl -fL \
    "https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-${FASTFETCH_ARCH}.deb" \
    -o "$FASTFETCH_DEB"
  sudo apt-get install -y "$FASTFETCH_DEB"
  rm "$FASTFETCH_DEB"
}

install_starship() {
  if command -v starship >/dev/null 2>&1 || [ -x "$HOME/.local/bin/starship" ]; then
    echo "Starship is already installed"
    return
  fi

  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
}

install_eza() {
  if command -v eza >/dev/null 2>&1 || [ -x "$HOME/.local/bin/eza" ]; then
    echo "eza is already installed"
    return
  fi

  case "$(uname -m)" in
    x86_64)
      EZA_ARCH="x86_64"
      ;;
    aarch64|arm64)
      EZA_ARCH="aarch64"
      ;;
    *)
      echo "Unsupported eza architecture: $(uname -m)"
      return 1
      ;;
  esac

  EZA_ARCHIVE="/tmp/eza.tar.gz"
  curl -fL \
    "https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}-unknown-linux-gnu.tar.gz" \
    -o "$EZA_ARCHIVE"
  tar -xzf "$EZA_ARCHIVE" -C "$HOME/.local/bin"
  rm "$EZA_ARCHIVE"
}

install_tree_sitter() {
  if command -v tree-sitter >/dev/null 2>&1 || [ -x "$HOME/.local/bin/tree-sitter" ]; then
    echo "tree-sitter CLI is already installed"
    return
  fi

  case "$(uname -m)" in
    x86_64)
      TREE_SITTER_ARCH="x64"
      ;;
    aarch64|arm64)
      TREE_SITTER_ARCH="arm64"
      ;;
    *)
      echo "Unsupported tree-sitter architecture: $(uname -m)"
      return 1
      ;;
  esac

  mkdir -p "$HOME/.local/bin"
  TREE_SITTER_ARCHIVE="/tmp/tree-sitter.gz"
  curl -fL \
    "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${TREE_SITTER_ARCH}.gz" \
    -o "$TREE_SITTER_ARCHIVE"
  gzip -dc "$TREE_SITTER_ARCHIVE" > "$HOME/.local/bin/tree-sitter"
  chmod +x "$HOME/.local/bin/tree-sitter"
  rm "$TREE_SITTER_ARCHIVE"
}

apt_install_packages() {
  sudo apt-get update
  sudo apt-get install -y \
    fonts-hack \
    golang-go \
    fzf \
    bat \
    virtualenv \
    glow
  install_starship
  install_eza
  install_tree_sitter
  install_fastfetch_deb
  install_nvim_tarball
}

install_hermes_agent() {
  if command -v hermes >/dev/null 2>&1 || [ -x "$HOME/.local/bin/hermes" ]; then
    echo "Hermes Agent is already installed"
    return
  fi

  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
}

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

install_hermes_agent

# Copy to .config
for config_dir in starship nvim fastfetch ghostty zshrc; do
  cp -rf "$config_dir" ~/.config/
done

# Install ZSH autocompletion
mkdir -p ~/.zsh
if [ ! -e ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
      ~/.zsh/zsh-autosuggestions
fi

# Source from configured .zshrc (only if exists)
LINE='source ~/.config/zshrc/.zshrc'
FILE="$HOME/.zshrc"
touch "$FILE"
# append only if missing
grep -qxF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

# Git aliases
if command -v git >/dev/null 2>&1; then
  git config --global alias.co checkout
  git config --global alias.ci commit
fi
