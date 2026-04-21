---
name: autoresearch-cleanup
description: Clean up finished autoresearch worktrees and branches. Finds all autoresearch/* branches, checks which are merged into the base branch, and removes their worktrees and branches. Use when asked to "cleanup autoresearch", "remove merged worktrees", or "clean up research branches".
---

# Autoresearch Cleanup

Remove merged autoresearch worktrees and branches. Leave unmerged ones untouched.

## Step 1 — Discover

From the **main repo root** (not a worktree), run:

```bash
git worktree list --porcelain
```

Parse the output to build a list of worktrees. Each entry looks like:

```
worktree /path/to/worktree
HEAD abc1234def5678...
branch refs/heads/autoresearch/optimize-tests-20250421-120000
```

Filter to worktrees whose branch starts with `refs/heads/autoresearch/`.

Also find autoresearch branches that have no linked worktree (orphaned branches):

```bash
git branch --list 'autoresearch/*'
```

Cross-reference with the worktree list. Any `autoresearch/*` branch not in a worktree is orphaned.

## Step 2 — Check merged status

Detect the base branch:

```bash
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|refs/remotes/origin/||'
# fallback: git branch --list main master | head -1 | tr -d ' *'
```

Get all merged branches:

```bash
git branch --merged <base-branch> --list 'autoresearch/*'
```

## Step 3 — Summarize and confirm

Present a table to the user before doing anything:

```
Autoresearch branches found: 4

  MERGED (will remove worktree + delete branch):
    autoresearch/optimize-tests-20250421-120000
      Worktree: /path/to/repo-research-optimize-tests-20250421-120000
      Experiments: 23 kept, 41 total  (read from worktree's autoresearch.jsonl if present)

    autoresearch/optimize-bundle-20250421-130000
      Worktree: /path/to/repo-research-optimize-bundle-20250421-130000
      Experiments: 8 kept, 15 total

  UNMERGED (skipping — finalize and merge first):
    autoresearch/optimize-ml-20250421-140000
      Worktree: /path/to/repo-research-optimize-ml-20250421-140000

  ORPHANED branches (no worktree — will delete branch only):
    autoresearch/old-experiment-20250410-090000
```

**Wait for user confirmation before proceeding.**

If the user says yes to all, proceed. If they want to skip specific ones, adjust accordingly.

## Step 4 — Remove

For each merged worktree to remove, in order:

```bash
# Remove the worktree (--force if it has uncommitted changes from autoresearch files)
git worktree remove /path/to/worktree --force

# Delete the branch
git branch -d autoresearch/branch-name
# If -d fails (not fully merged per git's check), use -D only if user confirmed
```

For orphaned merged branches:

```bash
git branch -d autoresearch/branch-name
```

If `git worktree remove` fails because the directory has untracked files (autoresearch session files), try:

```bash
git worktree remove /path/to/worktree --force
```

If that still fails, remove manually:

```bash
rm -rf /path/to/worktree
git worktree prune
```

## Step 5 — Report

After cleanup, report:

```
Cleaned up 2 worktrees and branches:
  ✓ autoresearch/optimize-tests-20250421-120000
  ✓ autoresearch/optimize-bundle-20250421-130000

Skipped (unmerged):
  — autoresearch/optimize-ml-20250421-140000

Run 'git worktree list' to verify.
```

## Edge Cases

- **No autoresearch branches found**: Report "Nothing to clean up" and stop.
- **Worktree directory missing but branch exists**: Skip worktree removal, just delete the branch after `git worktree prune`.
- **Branch not fully merged per git**: Warn the user — use `-D` only with explicit confirmation.
- **Currently inside the worktree being removed**: Tell the user to `cd` to the main repo first, then retry.
- **Unmerged worktrees with uncommitted autoresearch files**: These are safe to skip — the session files (autoresearch.jsonl, autoresearch.md) are the only uncommitted content and are not lost since the kept experiments are already in git commits.
