# PRD Template

A lean product requirements document. Fill every section from session context.
Use explicit placeholders ([TBD]) for genuine gaps — don't invent requirements.

---

```markdown
# [Product Name] — Product Requirements Document
Version: [v0.1 / draft]
Date: [date]
Status: [Draft / In Review / Approved]

---

## Problem Statement

[2-3 sentences. What pain exists, for whom, and why it matters. Written from
the user's perspective — not the product's. Avoid feature language here.]

---

## Goals

What success looks like for v1. Keep to 3-5 items maximum.

- **[Goal]** — [one sentence on why this matters]

## Non-Goals

What this product explicitly does NOT do in v1. As important as goals —
non-goals prevent scope creep and set stakeholder expectations.

- [Non-goal] — [brief rationale or "deferred to v2"]

---

## Users

**Primary user:** [Who they are, what they're trying to accomplish, what
context they're in when they use this]

**Secondary users (if any):** [Same format]

---

## Functional Requirements

What the product must do. Derived from user stories and decisions.

Use this language consistently:
- **Must** — required for v1, non-negotiable
- **Should** — strongly desired, include if feasible
- **Won't** — explicitly out of scope for v1

Group by feature area where helpful.

### [Feature Area]

- **Must:** [Requirement]
- **Must:** [Requirement]
- **Should:** [Requirement]
- **Won't:** [Deferred requirement — note why]

### [Feature Area]

- **Must:** [Requirement]
- ...

---

## Decisions Log

Key product decisions made during scoping. Captures rationale so future
sessions don't relitigate settled questions.

| Decision | What was decided | Rationale |
|---|---|---|
| [Topic] | [What was chosen] | [Why] |
| [Topic] | [What was chosen] | [Why] |

---

## Open Questions

Unresolved questions that could affect design or implementation.

| Question | Blocking? | Owner |
|---|---|---|
| [Question] | Yes / No | [Person or role] |

---

## Out of Scope (v2+)

Features or behaviours explicitly deferred. Capturing these prevents them
from creeping into v1 and gives a clear starting point for v2.

- [Feature] — [brief note on why deferred]

---

## Assumptions

Things treated as true that haven't been explicitly validated. Flag these —
they're the most likely source of problems downstream.

- [Assumption] — [what would need to be true for this to hold]
```

---

## Quality Bar

**Fix failures before presenting — don't surface a PRD that doesn't pass.**

- [ ] Problem statement is user-centered, not feature-centered
- [ ] Every functional requirement traces back to a user story or explicit decision
- [ ] Must / should / won't language is used consistently throughout
- [ ] Non-goals section is populated — not left empty
- [ ] Decisions log captures rationale, not just outcomes
- [ ] Open questions are specific and flagged as blocking or non-blocking
- [ ] Nothing appears in requirements that wasn't established in prior session work
- [ ] Document is under ~3 pages — if longer, trim or defer

---

## Notes for Customization

**Claude: read this section before drafting and apply anything defined here
throughout the document — these are project conventions, not suggestions.**

Add project-specific conventions here as the product matures:
- Document versioning or approval workflow
- Required sections for your team's PRD format
- Stakeholder names or roles to reference
- Engineering team or platform constraints to note
- Link to design system, repo, or related docs
