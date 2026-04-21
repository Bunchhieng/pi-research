# pi-research

Worktree launcher and cleanup tools for [pi-autoresearch](https://github.com/davebcn87/pi-autoresearch).

## Install

```bash
# 1. Install the core autoresearch extension
pi install https://github.com/davebcn87/pi-autoresearch

# 2. Install this package (worktree launcher + cleanup skill)
pi install https://github.com/Bunchhieng/pi-research

# 3. Add pi-research to your shell (run once)
bash ~/.pi/agent/git/github.com/Bunchhieng/pi-research/install.sh

# 4. Reload your shell
source ~/.zshrc
```

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
