# promodoro-tui.sh

A bash script to have a simple promodoro timer TUI that can be paused and skipped.

## Pre-requirements

- `gum`
  - install with `sudo dnf install gum` (fedora)
- `dunstify`
  - I use this te get notifications in i3. Disable if you don't want to use

## Usage

1. Clone the repo move into it and copy the script to `~/.local/bin/`

```bash
git clone https://github.com/trgr-boi/promodoro-tui.sh && \
cd promodoro-tui && \
cp promodoro-tui.sh ~/.local/bin/promodoro-tui
```

2. Use with:

```bash
promodoro-tui
```

## Roadmap

- [ ] add a way to change timer length without needing to change the script (so maybe with a config file (`~/.config/promodoro-tui`?)that can be modified from within the TUI)
- [ ] save analytics in a file to get a history
- [ ] add a main menu to load different profiles, or different types of timers.
- [ ] themes (these are always fun!) (also in the config file?)
- [ ] add audio feedback with `paplay /path/to/file`
- [ ] add a boolean for `dunstify` and `paplay` (should be configurable in config file)
  - could also be used with `zenity` but is GUI so idk...
