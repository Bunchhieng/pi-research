#!/usr/bin/env bash
set -euo pipefail

# install.sh — adds the pi-research alias to your shell rc file
# Safe to run multiple times (idempotent).

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
DIM='\033[2m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="${SCRIPT_DIR}/pi-research"
ALIAS_LINE="alias pi-research='${SCRIPT_PATH}'"

# ---------------------------------------------------------------------------
# Detect rc file
# ---------------------------------------------------------------------------

detect_rc() {
  local shell_name
  shell_name="$(basename "${SHELL:-}")"

  if [[ "$shell_name" == "zsh" ]] || [[ -f "$HOME/.zshrc" ]]; then
    echo "$HOME/.zshrc"
  elif [[ "$shell_name" == "bash" ]]; then
    if [[ "$(uname)" == "Darwin" ]]; then
      echo "$HOME/.bash_profile"
    else
      echo "$HOME/.bashrc"
    fi
  else
    echo "$HOME/.profile"
  fi
}

RC_FILE="$(detect_rc)"

# ---------------------------------------------------------------------------
# Check already installed
# ---------------------------------------------------------------------------

if grep -q "alias pi-research=" "$RC_FILE" 2>/dev/null; then
  echo -e "${YELLOW}Already installed${NC} — pi-research alias found in ${RC_FILE}"
  echo -e "${DIM}To update the path, remove the existing alias and re-run.${NC}"
  exit 0
fi

# ---------------------------------------------------------------------------
# Append alias
# ---------------------------------------------------------------------------

{
  echo ""
  echo "# pi-research"
  echo "$ALIAS_LINE"
} >> "$RC_FILE"

echo -e "${GREEN}✓ Installed${NC}"
echo -e "  Added to: ${DIM}${RC_FILE}${NC}"
echo -e "  Alias:    ${DIM}${ALIAS_LINE}${NC}"
echo ""
echo -e "  Reload your shell to activate:"
echo -e "  ${DIM}source ${RC_FILE}${NC}"
