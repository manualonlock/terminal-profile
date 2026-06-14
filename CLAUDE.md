# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Terminal profile configuration repository that sets up a complete development environment with ZSH, Neovim, Starship, eza, Ghostty terminal, and Fastfetch. Supports macOS (Homebrew) and Linux (apt, dnf, yum, pacman).

## Installation

```bash
./install.sh
```

This script:
- Detects the package manager automatically
- Installs dependencies (fonts, ZSH tools, Neovim, Starship, eza, etc.)
- Copies config directories to `~/.config/`
- Sets up ZSH autosuggestions plugin
- Appends source line to `~/.zshrc`

## Repository Structure

- `install.sh` - Main installer with package manager detection
- `zshrc/.zshrc` - ZSH configuration (aliases, VI mode, Starship init)
- `nvim/init.lua` - Neovim config using lazy.nvim plugin manager
- `starship/starship.toml` - Starship prompt theme
- `ghostty/config` - Ghostty terminal settings (Catppuccin Latte, JetBrains Mono)
- `fastfetch/` - Fastfetch system information display configuration

## Key Configuration Details

**ZSH**: VI mode enabled, aliases `ls`→`eza`, `cat`→`bat`, `vim`→`nvim`

**Neovim**: Leader key is Space. Key plugins: Catppuccin (theme), Telescope (fuzzy finder), Treesitter (syntax), Neo-tree (file explorer)

**Neovim Keybindings**:
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>b` - Open file explorer

**Starship**: Config loaded from `~/.config/starship/starship.toml`
