#!/bin/sh
set -eu

if [ "$#" -gt 1 ]; then
  printf '%s\n' "usage: ./install.sh [target-codex-home]" >&2
  exit 2
fi

package_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ "$#" -eq 1 ]; then
  target_codex_dir=$1
else
  target_codex_dir=$(printenv CODEX_HOME 2>/dev/null || printf '%s' "$HOME/.codex")
fi

if [ -z "$target_codex_dir" ]; then
  printf '%s\n' "target Codex home must not be empty" >&2
  exit 2
fi

skill_source="$package_dir/agent-squad"
agent_source="$package_dir/codex-agents/luna-worker.toml"
skill_target="$target_codex_dir/skills/agent-squad"
agent_target="$target_codex_dir/agents/luna-worker.toml"
backup_dir=

if [ ! -s "$skill_source/SKILL.md" ] ||
   [ ! -s "$skill_source/agents/openai.yaml" ] ||
   [ ! -s "$agent_source" ] ||
   ! grep -q '^name: agent-squad$' "$skill_source/SKILL.md" ||
   ! grep -q '^interface:$' "$skill_source/agents/openai.yaml" ||
   ! grep -q '^name = "luna_worker"$' "$agent_source" ||
   ! grep -q '^model = "gpt-5.6-luna"$' "$agent_source" ||
   ! grep -q '^model_reasoning_effort = "max"$' "$agent_source"; then
  printf '%s\n' "package validation failed; no existing files were moved" >&2
  exit 1
fi

if [ -e "$skill_target" ] || [ -L "$skill_target" ] || [ -e "$agent_target" ] || [ -L "$agent_target" ]; then
  timestamp=$(date '+%Y%m%d-%H%M%S')
  backup_dir="$target_codex_dir/backups/agent-squad-openai-$timestamp"
  suffix=0
  while [ -e "$backup_dir" ] || [ -L "$backup_dir" ]; do
    suffix=$((suffix + 1))
    backup_dir="$target_codex_dir/backups/agent-squad-openai-$timestamp-$suffix"
  done

  mkdir -p "$backup_dir"

  if [ -e "$skill_target" ] || [ -L "$skill_target" ]; then
    mv "$skill_target" "$backup_dir/agent-squad"
  fi
  if [ -e "$agent_target" ] || [ -L "$agent_target" ]; then
    mv "$agent_target" "$backup_dir/luna-worker.toml"
  fi
fi

mkdir -p "$target_codex_dir/skills" "$target_codex_dir/agents"
cp -R "$skill_source" "$skill_target"
cp "$agent_source" "$agent_target"

printf '%s\n' "Installed skill: $skill_target"
printf '%s\n' "Installed agent: $agent_target"
if [ -n "$backup_dir" ]; then
  printf '%s\n' "Previous managed files, when present, were moved to: $backup_dir"
else
  printf '%s\n' "No existing managed skill or agent required a backup."
fi
printf '%s\n' "No config.toml, main model, reasoning, or concurrency settings were changed."
printf '%s\n' "Follow the target runtime's current Codex documentation, then restart or start a fresh task if discovery is cached."
