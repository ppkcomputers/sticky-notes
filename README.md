# Sticky Note OSD for Hyprland (Quickshell)

A lightweight, visually polished **Sticky Note OSD** (On-Screen Display) built with **Quickshell** and **QML** for Hyprland. This tool provides a slide-out interface for quick note-taking that persists across sessions.

---

## ✦ Features

* [cite_start]**Slide-Out Animation:** Smooth `OutCubic` transitions on both X and Y axes[cite: 12, 13].
* [cite_start]**Persistent Storage:** Automatically saves notes to `~/.local/share/quickshell-stickynote.txt`[cite: 2].
* [cite_start]**Auto-Save:** Includes a debounced timer (800ms) that saves content as you type[cite: 30, 32].
* **Interactive UI:**
    * [cite_start]**Draggable:** A custom handle allows you to reposition the OSD on your screen using mouse input[cite: 15, 21].
    * [cite_start]**Styled:** A classic "sticky note" yellow aesthetic with rounded corners and high-contrast typography[cite: 14, 16, 17].
* [cite_start]**Wayland Native:** Built specifically for **WlrLayershell** with focus management[cite: 5, 6].

---

## 🛠 Installation & Requirements

Ensure you are running **Arch Linux** (or similar) with the following installed:
* **Hyprland**
* **Quickshell**

### Setup
1. Clone this repository.
2. Place `shell.qml` in your Quickshell configuration directory.
3. The note data will be automatically created at: 
   [cite_start]`~/.local/share/quickshell-stickynote.txt`[cite: 2].

---

## 🚀 Usage

### To Run:
```bash
quickshell --path /path/to/your/shell.qml

Hyprland bind key entry
Calls the script that toggles it in and out on screen
bind = SUPER, N, exec, ~/.config/quickshell/StickyNotes/notes.sh

