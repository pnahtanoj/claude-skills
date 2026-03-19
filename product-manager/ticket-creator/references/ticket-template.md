# Ticket Template & Quality Standards

## Template

---

```yaml
---
id: NNNN
status: todo
depends_on: []
---
```

### [Ticket Title]
*Short, imperative, specific. E.g. "Add email verification step to signup flow"*

---

**User Story**
> As a [type of user], I want to [do something] so that [I get some benefit].

---

**Background / Context**
*(Optional — include if there's meaningful context a developer would benefit
from knowing. Keep it brief.)*

---

**Acceptance Criteria**
A checklist of specific, testable conditions that must be true for this ticket
to be considered complete. Write these as "Given / When / Then" or plain
declarative statements. Be concrete — avoid vague criteria like "works correctly."

- [ ] ...
- [ ] ...
- [ ] ...

---

**Test Scenarios**
Key scenarios a developer or QA should verify, including edge cases and error
states. These should map directly to acceptance criteria where possible.

| Scenario | Input / State | Expected Result |
|----------|---------------|-----------------|
| Happy path | ... | ... |
| Edge case | ... | ... |
| Error state | ... | ... |

---

**Dependencies**
List any tickets, services, teams, or external factors this work depends on, or
that depend on this work.

- Depends on: *[ticket / system / team]*
- Blocks: *[ticket / feature]*

*(Remove this section if there are no known dependencies.)*

---

**Technical Notes**
*(Optional — include only if there are known implementation considerations,
architectural constraints, or suggested approaches worth flagging. Don't
over-prescribe — leave room for the developer to make decisions.)*

---

**🧪 Testing Checkpoint**
*(Optional — include only when this ticket completes a meaningful vertical
slice worth a human end-to-end test. The signal: completing this ticket means
two or more prior tickets can be validated together for the first time.
Describe what to test and what a passing run looks like.)*

---

**Out of Scope**
Explicitly list things this ticket does NOT cover. Think about what a developer
might reasonably assume is included — then rule out anything that isn't.
Common candidates: related edge cases being handled in a separate ticket,
future enhancements deferred to v2, adjacent features that touch the same code.

- ...

---

## Quality Bar

**Fix failures before presenting — don't surface a draft that doesn't pass.**

- [ ] A developer unfamiliar with the feature could start work immediately
- [ ] Every acceptance criterion is testable — someone could write a test for it
- [ ] Edge cases and failure modes are explicitly addressed
- [ ] Scope is bounded — it's clear what's in and what's out
- [ ] Out of Scope covers things a developer might reasonably assume are included
- [ ] No implementation is over-prescribed unless there's a strong reason
- [ ] Project-specific conventions from Notes for Customization are applied

---

## Notes for Customization

**Claude: read this section before drafting and apply anything defined here
throughout the ticket — sizing, labels, formats, and standards are
project conventions, not suggestions.**

This file is the right place to add project-specific conventions, e.g.:
- Ticket sizing / story point guidelines
- Required labels or tags
- Team-specific acceptance criteria formats
- Coding or architectural standards to reference in Technical Notes
