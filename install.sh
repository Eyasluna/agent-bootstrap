#!/usr/bin/env bash
# Bootstrap a fresh machine with shared agent rules.
# Usage: ./install.sh [--force]
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FORCE="${1:-}"

backup() {
  [ -e "$1" ] || return 0
  if [ "$FORCE" != "--force" ]; then
    echo "exists, skipping (use --force to overwrite): $1"; return 1
  fi
  cp "$1" "$1.bak.$(date +%Y%m%d%H%M%S)"; echo "backed up: $1"
}

mkdir -p "$HOME/.claude"

# 1. Global rules — applies to every project on this machine.
if backup "$HOME/.claude/CLAUDE.md"; then
  cp "$REPO/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  echo "installed: ~/.claude/CLAUDE.md"
fi

# 2. Settings. Merge rather than clobber if one already exists.
if [ -f "$HOME/.claude/settings.json" ]; then
  python3 - "$REPO/claude/settings.template.json" "$HOME/.claude/settings.json" <<'PY'
import json, sys, pathlib
tpl, dst = (pathlib.Path(p) for p in sys.argv[1:3])
cur = json.loads(dst.read_text())
add = json.loads(tpl.read_text())
changed = [k for k, v in add.items() if k not in cur]
cur.update({k: v for k, v in add.items() if k not in cur})
# includeCoAuthoredBy must be false regardless of what was there
if cur.get("includeCoAuthoredBy") is not False:
    cur["includeCoAuthoredBy"] = False; changed.append("includeCoAuthoredBy")
dst.write_text(json.dumps(cur, indent=2) + "\n")
print("settings merged:", ", ".join(changed) if changed else "no changes needed")
PY
else
  cp "$REPO/claude/settings.template.json" "$HOME/.claude/settings.json"
  echo "installed: ~/.claude/settings.json"
fi

# 3. Cursor rules, if a target project is given.
if [ -n "${2:-}" ] && [ -d "$2" ]; then
  mkdir -p "$2/.cursor/rules"
  cp "$REPO/cursor/rules/git-attribution.mdc" "$2/.cursor/rules/"
  echo "installed: $2/.cursor/rules/git-attribution.mdc"
fi

cat <<'MSG'

Done. Not installed by this script:
  - Project memory (~/.claude/projects/<slug>/memory/). It is machine-local and
    holds internal infrastructure detail, so it is NOT in this public repo.
    See memory-restore.md for how to carry it to a new machine.
MSG
