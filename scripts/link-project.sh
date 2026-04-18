#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Sync Cline and Trae to the current Claude profile.

Usage:
  scripts/link-project.sh

Source of truth:
  ~/.claude/CLAUDE.md
  ~/.claude/skills

Links created:
  ~/.cline/skills                       -> ~/.claude/skills
  ~/Documents/Cline/Rules/AGENTS.md     -> ~/.claude/CLAUDE.md
  ~/.trae/skills                        -> ~/.claude/skills
  ~/.marscode/user_rules.md             -> ~/.claude/CLAUDE.md
  ~/.trae/user_rules.md                 -> ~/.claude/CLAUDE.md

Conflicting targets are moved to:
  ~/.waza/backups/<timestamp>/
EOF
}

log() {
  printf '%s\n' "$*"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -ne 0 ]]; then
  usage >&2
  exit 64
fi

HOME_DIR="${HOME}"
CLAUDE_RULES="${HOME_DIR}/.claude/CLAUDE.md"
CLAUDE_SKILLS="${HOME_DIR}/.claude/skills"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_ROOT="${HOME_DIR}/.waza/backups/${TIMESTAMP}"
BACKUP_CREATED=0

if [[ ! -f "${CLAUDE_RULES}" ]]; then
  printf 'Missing Claude rules file: %s\n' "${CLAUDE_RULES}" >&2
  exit 1
fi

if [[ ! -d "${CLAUDE_SKILLS}" ]]; then
  printf 'Missing Claude skills directory: %s\n' "${CLAUDE_SKILLS}" >&2
  exit 1
fi

backup_target() {
  local target="$1"
  local rel_path="${target#${HOME_DIR}/}"
  local backup_path

  if [[ "${rel_path}" == "${target}" ]]; then
    rel_path="$(basename "${target}")"
  fi

  backup_path="${BACKUP_ROOT}/${rel_path}"

  mkdir -p "$(dirname "${backup_path}")"
  mv "${target}" "${backup_path}"
  BACKUP_CREATED=1
  log "backup: ${target} -> ${backup_path}"
}

link_target() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "${dest}")"

  if [[ -L "${dest}" ]]; then
    local current
    current="$(readlink "${dest}")"

    if [[ "${current}" == "${src}" ]]; then
      log "ok: ${dest} -> ${src}"
      return 0
    fi

    backup_target "${dest}"
  elif [[ -e "${dest}" ]]; then
    backup_target "${dest}"
  fi

  ln -s "${src}" "${dest}"
  log "link: ${dest} -> ${src}"
}

log "claude rules: ${CLAUDE_RULES}"
log "claude skills: ${CLAUDE_SKILLS}"

link_target "${CLAUDE_SKILLS}" "${HOME_DIR}/.cline/skills"
link_target "${CLAUDE_RULES}" "${HOME_DIR}/Documents/Cline/Rules/AGENTS.md"
link_target "${CLAUDE_SKILLS}" "${HOME_DIR}/.trae/skills"
link_target "${CLAUDE_RULES}" "${HOME_DIR}/.marscode/user_rules.md"
link_target "${CLAUDE_RULES}" "${HOME_DIR}/.trae/user_rules.md"

if [[ "${BACKUP_CREATED}" -eq 1 ]]; then
  log "backup root: ${BACKUP_ROOT}"
else
  log "backup root: none"
fi

log "done: Cline and Trae now follow ~/.claude"
