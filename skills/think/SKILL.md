---
name: think
description: Use before building anything new, when requirements are unclear, or when a plan needs pressure-testing before writing code.
version: 2.0.0
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - WebSearch
  - AskUserQuestion
---

# Think: Design and Validate Before You Build

Turn a rough idea into a clear, approved plan, then pressure-test the architecture before a line of code is written.

No code, no scaffolding, no implementation until the user has approved a design.

Give opinions directly. Avoid: "That's an interesting approach," "There are many ways to think about this," "You might want to consider." Take a position and state what evidence would change it.

## Phase 1: Understand the Problem

Read the relevant files and recent commits first. Then work through the idea one question at a time: purpose first, constraints second, success criteria third.

Challenge whether it is the right problem:
- What does the user actually want to happen? Not the feature described, the outcome they care about.
- What changes if nothing is built? Is there a cheaper path to the same result?
- What already exists in the codebase that covers part of this? Map sub-problems to existing code before proposing new code.
- Does this decision hold up in 12 months, or does it create drag?

## Scope Mode

Name the mode at the start:

| Mode | When | Posture |
|------|------|---------|
| **expand** | New feature, blank slate | Push scope up. Ask what would make this 10x better. |
| **shape** | Adding to existing | Hold the baseline, surface expansion options one at a time. |
| **hold** | Bug fix, tight constraints | Scope is locked. Make it correct. |
| **cut** | Plan that grew too large | Strip to the minimum that solves the real problem. |

## Phase 2: Propose Approaches

Offer 2 or 3 options with tradeoffs and a recommendation. For each: one-sentence summary, effort, risk, two strongest reasons for and against, what existing code it builds on. Always include one minimal option and one architecturally complete option.

When comparing, ask:
- Which decisions are hard to undo? Slow down on those.
- What would cause this to fail? Design away from that first.
- What are we explicitly not building?
- Would the same result hold with less: fewer fields, fewer states, fewer APIs?

Before presenting the recommendation: attack it. Ask yourself what would make this approach fail. If the attack holds, the approach deforms, and you should present the deformed version instead. If the attack shatters the approach entirely, discard it and tell the user why.

Get approval before proceeding.

## Phase 3: Validate the Architecture

Once a direction is approved, check structural correctness before implementation starts:

**Scope.** Grep for existing implementations of each sub-problem. Flag anything deferrable. More than 8 files or 2 new services? Acknowledge it explicitly.

**Dependencies and data flow.** Draw an ASCII diagram for any non-trivial flow. Look for cycles and hidden coupling. Trace the main path, then break it: nil input, empty collection, upstream timeout, partial failure.

**Single points of failure.** Name every component whose loss degrades the system. Are those risks acceptable?

**Test coverage.** List every meaningful path: happy path, error branches, edge cases. For each: does a test exist, how thorough is it? List gaps with file, assertion, test type. Any bug fix without a reproducing test is not done.

**Quality signals.** Duplication that should be shared. Names that don't match the domain. Errors that are swallowed. Functions with more than 5 branches.

**Performance exposure.** What grows with input size? Repeated calls in loops? Worst-case latency on the top 2-3 paths?

Also ask:
- If this goes wrong at 3am, what breaks and who notices?
- Is the technology choice boring enough? Non-standard choices accumulate maintenance cost.
- Can this be rolled back without touching data?
- Where does untrusted input enter, and is it validated at that boundary?

## Output

For each issue found in Phase 3:
- What it is (1 sentence)
- Specific recommendation ("move X to Y because Z", not "consider refactoring")
- Fix size: small, medium, large
- Risk if ignored: low, medium, high

**Approved design summary:**
- **Building**: what this is (1 paragraph)
- **Not building**: explicit out-of-scope list
- **Approach**: chosen option with rationale
- **Key decisions**: 3-5 with reasoning
- **Unknowns**: anything needing resolution during implementation

Close with one-line status per architecture section: clear, flagged, or skipped with reason.
