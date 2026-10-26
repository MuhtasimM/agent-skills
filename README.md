# agent-skills

Shared agent skills for Claude Code and Codex.

| Skill | What it does |
| --- | --- |
| `multi-code-review` | Pre-merge review by five specialist agents: correctness, readability, architecture, security, performance. In T3 Code it runs them on Claude Opus 5.5 (Claude subscription), GPT-6.1 Sol (Codex subscription), or both, at high effort. |
| `unslop` | Cuts AI tells from writing. |
| `teach` | Teaches you a skill or concept inside the current workspace. |

## Install

One line, on any machine with git:

```sh
curl -fsSL https://raw.githubusercontent.com/MuhtasimM/agent-skills/main/install.sh | bash
```

This clones the repo to `~/.agent-skills` and symlinks each skill into `~/.claude/skills` and `~/.codex/skills`. Restart your agent afterwards.

Or clone it wherever you like and run the script from there:

```sh
git clone https://github.com/MuhtasimM/agent-skills.git
cd agent-skills
./install.sh
```

## Options

```sh
./install.sh unslop teach    # only the named skills
./install.sh --copy          # copy files instead of symlinking
./install.sh --uninstall     # remove what the script installed
```

Through curl, pass options after `bash -s --`:

```sh
curl -fsSL https://raw.githubusercontent.com/MuhtasimM/agent-skills/main/install.sh | bash -s -- unslop
```

Environment variables:

- `AGENT_SKILLS_HOME`: where the curl install clones the repo (default `~/.agent-skills`).
- `AGENT_SKILLS_TARGETS`: space-separated skill directories to install into (default `~/.claude/skills ~/.codex/skills`).

An existing skill with the same name is moved to `~/.claude/skills-backup/` (or `~/.codex/skills-backup/`) before being replaced.

## Update

Skills are symlinked, so pulling is enough:

```sh
git -C ~/.agent-skills pull
```

Re-run `install.sh` after a pull if new skills were added, or if you installed with `--copy`.

## Add a skill

Create `skills/<name>/SKILL.md` with `name` and `description` frontmatter, commit, and push. `install.sh` picks up every directory under `skills/`.
