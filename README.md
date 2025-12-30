# promodoro-tui.sh

A bash script to have a simple promodoro timer TUI that can be paused and skipped.

## Pre-requirements

- `gum`
  - install with `sudo dnf install gum` (fedora)

## Usage

1. Clone the repo and move into it

```bash
git clone https://github.com/trgr-boi/promodoro-tui.sh && cd promodoro-tui
```

2. Copy script to `~/.local/bin/`

```bash
cp promodoro-tui.sh ~/.local/bin/promodoro-tui
```

3. Use with `promodoro-tui`

## Roadmap

- [ ] add a way to change timer length without needing to change the script (so maybe with a config file (`~/.config/promodoro-tui`?)that can be modified from within the TUI)
- [ ] save analytics in a file to get a history
- [ ] add a main menu to load different profiles, or different types of timers.
- [ ] themes (these are always fun!) (also in the config file?)
