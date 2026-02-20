#!/bin/sh
# Compiles treesitter parsers from ~/.cache/nvim sources into the directory
# Neovim expects. Run this if parsers fail to install via nvim-treesitter.

CACHE_DIR="$HOME/.cache/nvim"
PARSER_DIR="$HOME/.local/share/nvim/site/parser"
mkdir -p "$PARSER_DIR"

for lang_dir in "$CACHE_DIR"/tree-sitter-*; do
  [ -d "$lang_dir/src" ] || continue
  lang="$(basename "$lang_dir" | sed 's/^tree-sitter-//')"
  src_files="$lang_dir/src/parser.c"
  [ -f "$lang_dir/src/scanner.c" ] && src_files="$src_files $lang_dir/src/scanner.c"
  [ -f "$lang_dir/src/scanner.cc" ] && src_files="$src_files $lang_dir/src/scanner.cc"

  echo "Compiling $lang..."
  if echo "$src_files" | grep -q '\.cc'; then
    c++ -shared -o "$PARSER_DIR/$lang.so" -I "$lang_dir/src" $src_files -O2 2>&1
  else
    cc -shared -o "$PARSER_DIR/$lang.so" -I "$lang_dir/src" $src_files -O2 2>&1
  fi

  if [ $? -eq 0 ]; then
    echo "  OK: $PARSER_DIR/$lang.so"
  else
    echo "  FAILED: $lang"
  fi
done
