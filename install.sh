#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_SOURCE="$SCRIPT_DIR/bin/tswitch"
BIN_TARGET="$HOME/.local/bin/tswitch"
TMUX_CONF="$HOME/.config/tmux/tmux.conf"

# Ensure ~/.local/bin exists
mkdir -p "$HOME/.local/bin/"

# Symlik the binary
if [ -L "$BIN_TARGET" ]; then
	echo "Removed old symlik..."
	rm "$BIN_TARGET"
fi

ln -s "$BIN_SOURCE" "$BIN_TARGET"
echo "Linked: $BIN_TARGET -> $BIN_SOURCE"

# Add tmux keybind if not already precent
KEYBIND='bind f run-shell "popup -E ~/.local/bin/tswitch"'
if grep -q "bind f" "$TMUX_CONF" 2>/dev/null; then
	echo "tmux keybind already exists, skipping."
else
	echo "" >> "$TMUX_CONF"
	echo "# tswitch - fuzzy project picker" >> "$TMUX_CONF"
	echo "bind f display-popup -E \"$BIN_TARGET\"" >> "$TMUX_CONF"
	echo "Added Ctrl-b f keybind to $TMUX_CONF"
fi

echo ""
echo "Done! Run 'tswitch' from anywhere or hit Ctrl-b f inside tmux."
echo "You may need to: tmux source-file $TMUX_CONF"
