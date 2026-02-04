ensure_brew() {
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is already installed."
    else
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Linuxbrew to PATH if on Linux
        if [ "$(uname)" = "Linux" ]; then
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi

        echo "Homebrew installation complete."
    fi
}

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

# will not be unused for as long as defaulting to homebrew 
apt_install_packages() {
  sudo apt-get update
  sudo apt-get install -y \
    fonts-hack \
    vivid \
    lsd \
    fzf \
    neofetch \
    bat \
    virtualenv
}

# case "$PM" in
#   brew)
#     brew_install_packages
#     ;;
#   apt)
#     apt_install_packages
#     ;;
#   *)
#     echo "No supported package manager found"
#     ;;
# esac
ensure_brew
brew_install_packages

# Copy to .config
for config_dir in posh nvim neofetch ghostty zshrc; do
  cp -rf "$config_dir" ~/.config/
done

# Install ZSH autocompletion
mkdir -p ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ~/.zsh/zsh-autosuggestions

# Source from configured .zshrc (only if exists)
LINE='source ~/.config/zshrc/.zshrc'
FILE="$HOME/.zshrc"
touch "$FILE"
# append only if missing
grep -qxF "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
