#!/usr/bin/env bash
set -euo pipefail

# install.sh — full setup for pi-research
# Safe to run multiple times (idempotent).
#
# What it does:
#   1. pi install davebcn87/pi-autoresearch  (core extension)
#   2. pi install Bunchhieng/pi-research     (this package)
#   3. Adds pi-research alias to your shell rc file
#   4. Adds Ghostty launch-queue hook to your shell rc file

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
ORANGE='\033[38;5;214m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

step()  { echo -e "\n${ORANGE}${BOLD}▶ $1${NC}"; }
ok()    { echo -e "  ${GREEN}✓ $1${NC}"; }
skip()  { echo -e "  ${YELLOW}↷ $1${NC}"; }
fail()  { echo -e "  ${RED}✗ $1${NC}" >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="${SCRIPT_DIR}/pi-research"
ALIAS_LINE="alias pi-research='${SCRIPT_PATH}'"

# ---------------------------------------------------------------------------
# Detect shell rc file
# ---------------------------------------------------------------------------

detect_rc() {
  local shell_name
  shell_name="$(basename "${SHELL:-}")"
  if [[ "$shell_name" == "zsh" ]] || [[ -f "$HOME/.zshrc" ]]; then
    echo "$HOME/.zshrc"
  elif [[ "$shell_name" == "bash" ]]; then
    [[ "$(uname)" == "Darwin" ]] && echo "$HOME/.bash_profile" || echo "$HOME/.bashrc"
  else
    echo "$HOME/.profile"
  fi
}

# ---------------------------------------------------------------------------
# Step 1 — pi install core extension
# ---------------------------------------------------------------------------

step "Installing pi-autoresearch (core extension)"

if ! command -v pi &>/dev/null; then
  fail "pi not found — install pi first: https://pi.dev/"
fi

pi install https://github.com/davebcn87/pi-autoresearch
ok "pi-autoresearch installed"

# ---------------------------------------------------------------------------
# Step 2 — pi install this package
# ---------------------------------------------------------------------------

step "Installing pi-research (this package)"
pi install https://github.com/Bunchhieng/pi-research
ok "pi-research installed"

# ---------------------------------------------------------------------------
# Step 3 — add alias to shell rc
# ---------------------------------------------------------------------------

step "Adding pi-research alias to shell"

RC_FILE="$(detect_rc)"

if grep -q "alias pi-research=" "$RC_FILE" 2>/dev/null; then
  skip "alias already in ${RC_FILE} — skipping"
else
  {
    echo ""
    echo "# pi-research"
    echo "$ALIAS_LINE"
  } >> "$RC_FILE"
  ok "added to ${RC_FILE}"
  echo -e "  ${DIM}${ALIAS_LINE}${NC}"
fi

# ---------------------------------------------------------------------------
# Step 4 — add Ghostty launch-queue hook to shell rc
# ---------------------------------------------------------------------------

step "Adding Ghostty launch-queue hook to shell"

QUEUE_HOOK='
# pi-research — Ghostty split launch queue
_pi_research_dequeue() {
  local _q="$HOME/.pi-research-queue"
  [[ -s "$_q" ]] || return
  local _cmd
  _cmd=$(head -1 "$_q") && { tail -n +2 "$_q" > "$_q.tmp" && mv "$_q.tmp" "$_q"; } 2>/dev/null
  [[ -n "$_cmd" ]] && eval "$_cmd"
}
_pi_research_dequeue'

if grep -q "_pi_research_dequeue" "$RC_FILE" 2>/dev/null; then
  skip "queue hook already in ${RC_FILE} — skipping"
else
  printf '%s\n' "$QUEUE_HOOK" >> "$RC_FILE"
  ok "queue hook added to ${RC_FILE}"
fi

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------

echo ""
echo -e "${GREEN}${BOLD}All done!${NC} Reload your shell to activate:"
echo -e "  ${DIM}source ${RC_FILE}${NC}"
echo ""
