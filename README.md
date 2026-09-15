# agent-bootstrap

Shared rules for coding agents — Claude Code, Codex, and Cursor — so a fresh
machine or a fresh session starts with the same conventions instead of
rediscovering them.

```bash
git clone https://github.com/Eyasluna/agent-bootstarp.git
cd agent-bootstarp && ./install.sh
```

`install.sh` installs `~/.claude/CLAUDE.md` and merges
`includeCoAuthoredBy: false` into `~/.claude/settings.json` (backing up
anything it replaces; re-run with `--force` to overwrite). Pass a project path
as the second argument to also drop in the Cursor rule.

## What's here

| Path | Goes to | Purpose |
| --- | --- | --- |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Global rules, loaded in **every** project on the machine |
| `claude/settings.template.json` | `~/.claude/settings.json` | Chiefly `includeCoAuthoredBy: false` |
| `cursor/rules/git-attribution.mdc` | `<project>/.cursor/rules/` | Same attribution rule, enforced for Cursor |
| `templates/AGENTS.md` | a repo root | Starting point for a per-repo agent guide |
| `memory-restore.md` | — | How project memory is scoped, and how to move it |

## The rule this exists for

No AI attribution in **git history** — no `Co-Authored-By: Claude …` trailers,
no "Generated with …" footers, no model names in commit messages or PR bodies.

Agent attribution goes in **PR comments only**, as `**Claude (Opus 5)** — …`,
so a thread reviewed by several agents and a human says who is speaking.

Both halves are stated in `claude/CLAUDE.md`, which also records that this rule
**outranks** the attribution instruction Claude Code injects by default. Setting
`includeCoAuthoredBy: false` stops that instruction at the source; the written
rule is the backstop for machines and tools where the setting does not apply.

## Memory is deliberately not here

This repository is **public**. Project memory holds internal hostnames, private
IP and tailnet addresses, storage bucket names, and ticket content, so it is
excluded by `.gitignore` and must stay excluded. See
[`memory-restore.md`](memory-restore.md) for how memory is scoped and how to
carry it between machines.
