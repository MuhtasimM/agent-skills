#!/usr/bin/env bash
# Install the skills in this repo for Claude Code and Codex.
#
#   ./install.sh                 symlink every skill into ~/.claude/skills and ~/.codex/skills
#   ./install.sh unslop teach    install only the named skills
#   ./install.sh --copy          copy instead of symlink
#   ./install.sh --uninstall     remove links/copies this script created
#
# Can also be piped from curl, in which case the repo is cloned to
# $AGENT_SKILLS_HOME (default ~/.agent-skills) first:
#
#   curl -fsSL https://raw.githubusercontent.com/MuhtasimM/agent-skills/main/install.sh | bash
set -euo pipefail

REPO_URL="https://github.com/MuhtasimM/agent-skills.git"
CLONE_DIR="${AGENT_SKILLS_HOME:-$HOME/.agent-skills}"
TARGETS="${AGENT_SKILLS_TARGETS:-$HOME/.claude/skills $HOME/.codex/skills}"

mode=link
uninstall=0
selected=""
for arg in "$@"; do
  case "$arg" in
    --copy) mode=copy ;;
    --uninstall) uninstall=1 ;;
    -h|--help) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) echo "unknown option: $arg" >&2; exit 2 ;;
    *) selected="$selected $arg" ;;
  esac
done

# Locate the repo: next to this script, or clone/update it when piped from curl.
script_dir=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi
if [ -n "$script_dir" ] && [ -d "$script_dir/skills" ]; then
  repo="$script_dir"
else
  command -v git >/dev/null || { echo "git is required" >&2; exit 1; }
  if [ -d "$CLONE_DIR/.git" ]; then
    git -C "$CLONE_DIR" pull --ff-only --quiet
  else
    git clone --quiet "$REPO_URL" "$CLONE_DIR"
  fi
  repo="$CLONE_DIR"
fi

if [ -z "$selected" ]; then
  for dir in "$repo"/skills/*/; do
    selected="$selected $(basename "$dir")"
  done
fi

for name in $selected; do
  src="$repo/skills/$name"
  [ -f "$src/SKILL.md" ] || { echo "no such skill: $name" >&2; exit 1; }

  for target in $TARGETS; do
    dest="$target/$name"

    if [ "$uninstall" = 1 ]; then
      if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        rm "$dest"
        echo "removed  $dest"
      elif [ -f "$dest/.agent-skills-copy" ]; then
        rm -rf "$dest"
        echo "removed  $dest"
      fi
      continue
    fi

    mkdir -p "$target"
    if [ -L "$dest" ]; then
      rm "$dest"
    elif [ -e "$dest" ]; then
      if [ -f "$dest/.agent-skills-copy" ]; then
        rm -rf "$dest"
      else
        # Keep backups outside the skills dir so they aren't loaded as skills.
        backup="$(dirname "$target")/skills-backup/$name-$(date +%Y%m%d%H%M%S)"
        mkdir -p "$(dirname "$backup")"
        mv "$dest" "$backup"
        echo "backed up existing $dest -> $backup"
      fi
    fi

    if [ "$mode" = copy ]; then
      cp -R "$src" "$dest"
      touch "$dest/.agent-skills-copy"
      echo "copied   $dest"
    else
      ln -s "$src" "$dest"
      echo "linked   $dest"
    fi
  done
done

if [ "$uninstall" = 0 ]; then
  echo "Done. Restart Claude Code / Codex to pick up the skills."
fi
