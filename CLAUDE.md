# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Terminal profile configuration repository that sets up a complete development environment with ZSH, Neovim, Oh My Posh, Ghostty terminal, and Fastfetch. Supports macOS (Homebrew) and Linux (apt, dnf, yum, pacman).

## Installation

```bash
./install.sh                 # full install
./install.sh --configs-only  # only re-copy configs (re-apply theme)
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
- `ghostty/config` - Ghostty terminal settings (Catppuccin Mocha, JetBrains Mono, blur)
- `fastfetch/config.jsonc` - Fastfetch greeting shown on shell start

## Key Configuration Details

**ZSH**: VI mode enabled, Catppuccin Mocha colors (vivid, bat, fzf, syntax highlighting), fzf + zoxide, aliases `ls`→`lsd`, `cat`→`bat`, `vim`→`nvim`

**Neovim**: Leader key is Space. Key plugins: Catppuccin (theme), Telescope, Treesitter (main branch, needs Neovim 0.12 + tree-sitter CLI), Neo-tree, Mason + mason-lspconfig v2 + blink.cmp (LSP/completion), lualine, which-key

**Neovim Keybindings**:
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>b` - Open file explorer

**Oh My Posh**: Config loaded from `~/.config/posh/posh.json`, skipped in Apple Terminal
