# pi-research

Worktree launcher and cleanup tools for [pi-autoresearch](https://github.com/davebcn87/pi-autoresearch).

## Install

```bash
git clone https://github.com/Bunchhieng/pi-research.git ~/pi-research
cd ~/pi-research && ./install.sh
source ~/.zshrc
```

The install script handles everything: installs `pi-autoresearch`, installs this pi package, and adds the `pi-research` alias to your shell. Safe to re-run.

## Usage

```bash
# Start a new research session in a fresh worktree
pi-research
pi-research optimize-tests
pi-research -s 3 optimize-bundle     # 3 worktrees in tmux splits

# Clean up merged worktrees
pi-research cleanup                  # interactive
pi-research cleanup --all            # remove all merged without prompt
pi-research cleanup optimize-tests   # remove specific worktree by name
```

## What's included

| | |
|---|---|
| **`pi-research`** | Bash script — creates a git worktree and launches pi. Supports tmux splits via `-s N`. |
| **`autoresearch-cleanup`** | Pi skill — finds merged autoresearch worktrees and removes them with their branches. |

## Requirements

- [pi](https://pi.dev/) coding agent
- [pi-autoresearch](https://github.com/davebcn87/pi-autoresearch) installed
- `tmux` (only for `-s N` multi-split mode)
