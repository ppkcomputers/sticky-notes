#!/bin/bash
# ~/.config/quickshell/StickyNotes/notes.sh

QML_PATH="$HOME/.config/quickshell/StickyNotes/shell.qml"

# If running → kill it
if pgrep -f "quickshell.*StickyNotes/shell.qml" >/dev/null; then
    pkill -f "quickshell.*StickyNotes/shell.qml"
    echo "Sticky note closed."
    exit 0
fi

echo "Launching sticky note..."
nohup quickshell -p "$QML_PATH" > /dev/null 2>&1 &
