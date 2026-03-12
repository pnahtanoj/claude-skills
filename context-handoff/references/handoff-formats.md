# Handoff Formats

Two output formats for context-handoff. Use the one(s) appropriate to where
the work is going next.

---

## Format 1: Session Summary

For continuing in a new claude.ai session, sharing with a colleague, or
parking work to return to later. Written in natural prose — readable by a
human or a fresh Claude instance.

```
# Session Handoff: [Brief topic label]
Date: [date]
Produced by: context-handoff skill

## What We Were Working On
[1-3 sentences: the problem, the goal, the context]

## Decisions Made
[Each decision as a bullet. Format: **What was decided** — why (the reasoning
that led here, not just the outcome). If the reasoning wasn't stated, note that.]

- **[Decision]** — [reasoning]
- **[Decision]** — [reasoning]

## Artifacts Produced
[List anything created this session: stories, tickets, critiques, docs.
Note the skill that produced it if relevant.]

- [Artifact name/description] — [skill or method used, if relevant]

## Assumptions (⚠ Not Yet Validated)
[Things treated as true but never explicitly confirmed. These are the most
likely source of problems downstream. Flag clearly.]

- [Assumption] — [what would need to be true for this to hold]

## Open Questions
[Unresolved questions that came up. Make them specific enough to be actionable.]

- [Question] — [what's needed to resolve it]

## Constraints & Non-Negotiables
[Limitations, dependencies, or fixed parameters that emerged]

- [Constraint]

## Next Actions
[Concrete next steps. Not "figure out X" — "decide X by doing Y".]

1. [Action] — [owner or tool if known]
2. [Action] — [owner or tool if known]

## To Resume This Session
Paste this handoff at the start of your next conversation and say:
"Continue from this handoff."
```

---

## Format 2: CLAUDE.md Block

For handing off to Claude Code. Terse, directive, structured for an AI agent
to act on — not for human reading. Omit prose, keep entries to one line where
possible.

```markdown
## Context: [Feature/Project Name]

### Goal
[One sentence: what are we building and why]

### Decisions
- [Decision]: [one-line rationale]
- [Decision]: [one-line rationale]

### Assumptions ⚠
- [Assumption — needs validation before proceeding]

### Constraints
- [Hard constraint]
- [Hard constraint]

### Artifacts
- [Artifact]: [location or description]

### Open Questions
- [Question]: [blocking? yes/no]

### Next Actions
- [ ] [Concrete action]
- [ ] [Concrete action]
```

---

## Notes for Customization

**Claude: read this section before producing output and apply anything defined
here throughout the handoff — these are project conventions, not suggestions.**

Add project-specific conventions here, e.g.:
- Default output format preference (session summary / CLAUDE.md / both)
- Where CLAUDE.md blocks should be inserted (top of file, specific section)
- Team or project name to include in headers
- Any standing assumptions or constraints that apply to all handoffs
- Preferred date format
