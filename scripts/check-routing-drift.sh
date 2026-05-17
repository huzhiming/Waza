#!/usr/bin/env bash
# check-routing-drift.sh: verify that the dispatcher routing table in
# scripts/package-skill.sh stays in sync with skills/RESOLVER.md.
#
# Strategy: both files must reference the same set of skill names.
# The packaged SKILL.md routing table lists one row per skill; RESOLVER.md's
# "按工作流阶段分路" tables reference skills/<name>/SKILL.md tokens.
set -euo pipefail
cd "$(dirname "$0")/.."

python3 - <<'PYEOF'
import re
import sys
from pathlib import Path

root = Path(".")

# Skills that must appear in both the dispatcher routing table and RESOLVER.md.
expected_skills = set()
for p in (root / "skills").glob("*/SKILL.md"):
    expected_skills.add(p.parent.name)

if not expected_skills:
    print("ERROR: no skills found under skills/*/SKILL.md", file=sys.stderr)
    raise SystemExit(1)

# Parse dispatcher routing table from package-skill.sh.
# The heredoc section contains rows like:
#   | intent text | skill | `skills/<name>/SKILL.md` |
dispatcher_text = (root / "scripts" / "package-skill.sh").read_text()
dispatcher_skills = set(re.findall(r'skills/([a-z][a-z0-9_-]*)/SKILL\.md', dispatcher_text))

# Parse RESOLVER.md for all skill references.
resolver_text = (root / "skills" / "RESOLVER.md").read_text()
resolver_skills = set(re.findall(r'skills/([a-z][a-z0-9_-]*)/SKILL\.md', resolver_text))

fail = False

missing_from_dispatcher = expected_skills - dispatcher_skills
if missing_from_dispatcher:
    print(f"ROUTING DRIFT: skills missing from package-skill.sh dispatcher: {sorted(missing_from_dispatcher)}", file=sys.stderr)
    fail = True

missing_from_resolver = expected_skills - resolver_skills
if missing_from_resolver:
    print(f"ROUTING DRIFT: skills missing from RESOLVER.md: {sorted(missing_from_resolver)}", file=sys.stderr)
    fail = True

stale_in_dispatcher = dispatcher_skills - expected_skills
if stale_in_dispatcher:
    print(f"ROUTING DRIFT: stale skill refs in package-skill.sh: {sorted(stale_in_dispatcher)}", file=sys.stderr)
    fail = True

if fail:
    raise SystemExit(1)

print(f"ok: routing consistent across {len(expected_skills)} skills (dispatcher + RESOLVER.md)")
PYEOF
