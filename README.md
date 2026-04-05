# tswitch

A fuzzy project picker for tmux. Replaces the manual `Ctrl-b c` + `cd ~/work/git/project` workflow.

## What it does

- **From bare terminal:** Run `tswitch` — fuzzy pick a project — lands you in a new tmux session
- **From inside tmux:** Hit `Ctrl-b f` — fuzzy pick — opens a new window in your current session
- Recently used projects float to the top of the list

## Requirements

- LuaJIT
- fzf
- tmux

## Install

```bash
git clone git@github.com:Sebstrdigital/tswitch.git ~/work/git/tswitch
cd ~/work/git/tswitch
chmod +x bin/tswitch install.sh
./install.sh
tmux source-file ~/.config/tmux/tmux.conf
```

## Usage

```bash
tswitch          # from terminal
Ctrl-b f         # from inside tmux (floating popup)
```

## Project structure

```
bin/tswitch        Entry point
lib/tmux.lua       tmux session/window commands
lib/history.lua    Recent project tracking (~/.tswitch_history)
lib/projects.lua   Directory scanning + sorting
lib/picker.lua     fzf integration
install.sh         Symlink + tmux keybind setup
```
