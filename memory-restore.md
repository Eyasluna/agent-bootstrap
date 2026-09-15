# Restoring project memory on a new machine

Memory is **not** in this repository, and must not be added to it: this repo is
public, and memory files carry internal hostnames, private IPs, tailnet
addresses, storage bucket names, and ticket content.

## How memory is scoped

Claude Code partitions memory **per working directory**, with no inheritance:

```
~/.claude/projects/<slugified-cwd>/memory/
    MEMORY.md          # the index, loaded into context every session
    <name>.md          # one fact per file
```

The slug is the absolute path with `/` replaced by `-`, e.g.
`/Users/me/Dropbox/petatron` → `-Users-me-Dropbox-petatron`.

**A session only ever sees the bucket for its own primary working directory.**
There is no global memory and no fallback, so a rule that must hold everywhere
belongs in `~/.claude/CLAUDE.md` (which *is* in this repo), not in memory.

## Carrying it to a new machine

Use an encrypted or private channel — not this repo:

```bash
# on the old machine
tar czf claude-memory.tgz -C ~/.claude/projects \
  $(cd ~/.claude/projects && ls -d */memory 2>/dev/null)

# on the new machine, after checking out the same project paths
tar xzf claude-memory.tgz -C ~/.claude/projects
```

If the new machine checks projects out at **different paths**, rename the slug
directories to match, or memory will not load.

## What to do instead of committing memory here

- Cross-cutting rules → `claude/CLAUDE.md` in this repo (loads everywhere).
- Repo-specific conventions → that repo's own `AGENTS.md` (version-controlled
  with the code, which is where a reviewer expects it).
- Situated operational knowledge (addresses, credentials' locations, cluster
  state) → memory only, moved out of band.
