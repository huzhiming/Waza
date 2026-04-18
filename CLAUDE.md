# Waza

Personal skill collection for Claude Code. Eight skills covering the complete engineering workflow: think, design, check, hunt, write, learn, read, health.

## Shared Agent Adapters

This file is the source of truth for repository-level agent instructions.

- Edit `skills/` and `rules/` directly. Do not edit adapter paths such as `.cline/skills` or `.trae/rules/project_rules.md`.
- Keep skill metadata stable unless you are intentionally renaming or re-scoping a skill: `name`, `description`, and folder name should continue to match.
- Use `AGENTS.md` as the cross-tool entrypoint for agents that support the standard file name.
- Use `.trae/rules/project_rules.md` for Trae project rules. It should stay a thin adapter that points back to this file.
- Use `.cline/skills` for Cline project skill discovery. It should stay a thin adapter that points back to `skills/`.

## Structure

```
skills/
├── check/        -- code review before merging
│   ├── agents/   -- reviewer-security.md, reviewer-architecture.md
│   └── references/  -- persona-catalog.md
├── design/       -- production-grade frontend UI
├── health/       -- Claude Code config audit
│   └── agents/   -- inspector-context.md, inspector-control.md
├── hunt/         -- systematic debugging
├── learn/        -- research to published output
├── read/         -- fetch URL or PDF as Markdown
├── think/        -- design and validate before building
└── write/        -- natural prose in Chinese and English
    └── references/  -- write-zh.md, write-en.md
marketplace.json      -- plugin registry for npx/plugin distribution
```

Each skill has a `SKILL.md` (loaded on demand by Claude). Supporting content lives in subdirectories.

## Verification

Run `./scripts/verify-skills.sh` before any commit. If the diff is non-trivial, also run `/check`.

## Commit Convention

`{type}: {description}` -- types: feat, fix, refactor, docs, chore

## Release Convention (tw93/Mole style)

- Title: `V{version} {Codename} {emoji}` -- e.g., V3.8.0 Forge 🔨
- Tag: `v{version}` (lowercase v)
- Body: Markdown format, structure as follows:

```
<div align="center">
  <img src="..." width="120" />
  <h1>Waza V{version}</h1>
  <p><em>tagline</em></p>
</div>

### Changelog

1. **SkillName**: One sentence on what changed and its user effect.
2. ...

### 更新日志

1. **技能名**: 一句话说清楚改了什么以及对用户的影响。
2. ...

Update: `npx skills add tw93/Waza@latest` · ⭐ [tw93/Waza](https://github.com/tw93/Waza)
```

- Each item: `**Label**: one sentence` -- bold label is the skill or module name, description leads with what changed
- Style: engineer-facing, no marketing language; one-to-one bilingual mapping
- Footer: update command + star + repo link
