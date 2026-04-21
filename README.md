# pi-research

Worktree launcher and cleanup tools for [pi-autoresearch](https://github.com/davebcn87/pi-autoresearch).

## Install

```bash
# Install the core autoresearch extension first
pi install https://github.com/davebcn87/pi-autoresearch

# Then install this package for the worktree tools + cleanup skill
pi install https://github.com/bunchhieng/pi-research
```

Add `pi-research` to your shell:

```bash
# In ~/.zshrc or ~/.bashrc
alias pi-research='/path/to/pi-research/pi-research'
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
