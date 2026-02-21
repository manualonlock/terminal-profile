# CODEX.md

This file provides guidance to Codex when working with code in this repository.

## Project Overview

Terminal profile configuration repository that sets up a complete development environment with ZSH, Neovim, Oh My Posh, Ghostty terminal, and Neofetch. Supports macOS (Homebrew) and Linux (apt, dnf, yum, pacman).

## Installation

```bash
./install.sh
```

This script:
- Detects the package manager automatically
- Installs dependencies (fonts, ZSH tools, Neovim, Oh My Posh, etc.)
- Copies config directories to `~/.config/`
- Sets up ZSH autosuggestions plugin
- Appends source line to `~/.zshrc`

## Repository Structure

- `install.sh` - Main installer with package manager detection
- `zshrc/.zshrc` - ZSH configuration (aliases, VI mode, Oh My Posh init, vivid colors)
- `nvim/init.lua` - Neovim config using lazy.nvim plugin manager
- `posh/posh.json` - Oh My Posh prompt theme
- `ghostty/config` - Ghostty terminal settings (Catppuccin Latte, JetBrains Mono)
- `neofetch/` - Neofetch display configuration and custom logo

## Key Configuration Details

**ZSH**: VI mode enabled, uses vivid with molokai color scheme, aliases `ls`→`lsd`, `cat`→`bat`, `vim`→`nvim`

**Neovim**: Leader key is Space. Key plugins: Catppuccin (theme), Telescope (fuzzy finder), Treesitter (syntax), Neo-tree (file explorer)

**Neovim Keybindings**:
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>b` - Open file explorer

**Oh My Posh**: Config loaded from `~/.config/posh/posh.json`, skipped in Apple Terminal
