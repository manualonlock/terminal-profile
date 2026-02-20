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

PM="$(detect_pm)"

brew_install_packages() {
  brew install \
    font-hack-nerd-font \
    jandedobbeleer/oh-my-posh/oh-my-posh \
    vivid \
    lsd \
    fzf \
    neofetch \
    bat \
    virtualenv \
    nvim
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
  # The freshest posh version will not be found in the apt repository
  curl -s https://ohmyposh.dev/install.sh | bash -s
  sudo apt-get update
  sudo apt-get install -y \
    fonts-hack \
    vivid \
    lsd \
    fzf \
    neofetch \
    bat \
    virtualenv
  install_nvim_tarball
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

# Copy to .config
for config_dir in posh nvim neofetch ghostty zshrc; do
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
