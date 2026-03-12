# User Story & Flow Template

## User Stories

Write one story per distinct user goal. If multiple user types are involved,
write a story for each.

---

**Story: [Short label, e.g. "First-time user signs up"]**

> As a **[type of user]**,
> I want to **[accomplish something]**,
> so that **[I get this benefit / outcome]**.

*(Repeat for each user type or distinct goal)*

---

## User Flow

A numbered, step-by-step sequence of what the user does and what the system
does in response. Written from the user's perspective.

**Trigger:** *What causes the user to start this flow?*

### Happy Path
1. User does X
2. System responds with Y
3. User does Z
4. ...
5. **End state:** *What does success look like?*

### Alternate Path(s)
*For meaningful variations — different choices the user could make that still
lead to a valid outcome.*

- **If [condition]:** User does X instead → System responds with Y → continues
  from step N

### Error / Edge Cases
*What happens when things go wrong or edge conditions are hit.*

- **If [error condition]:** System shows [message/state] → User can [recovery
  action]

---

## Acceptance Criteria

Specific, testable conditions that must be true for these stories to be
considered complete. One set per story if they differ significantly.

Use "Given / When / Then" format. Every criterion must be testable by a
developer or QA — if you can't write a test for it, rewrite it.

**Good:** `Given a logged-out user, when they submit the login form with valid
credentials, then they are redirected to the dashboard.`

**Bad:** `Login works correctly.` *(untestable — rewrite)*
**Bad:** `The system handles errors.` *(too vague — name the specific error)*

- [ ] Given [context], when [action], then [outcome]
- [ ] Given [context], when [action], then [outcome]
- [ ] ...

---

## Open Questions & Assumptions

Flag anything uncertain that could affect the design or implementation.

**Assumptions made:**
- ...

**Open questions:**
- ...

---

## Quality Bar

**Fix failures before presenting — don't surface a draft that doesn't pass.**

- [ ] Stories are written from the user's perspective, not the system's
- [ ] Every step in the flow has a clear actor (user or system)
- [ ] The happy path is complete end-to-end — no gaps
- [ ] Alternate and error paths cover the most likely real-world variations
- [ ] Every acceptance criterion is testable — someone could write a test for it
- [ ] Open questions surface real ambiguities, not just filler
- [ ] Project-specific personas and platform conventions (from Notes) are applied

---

## Notes for Customization

**Claude: read this section before producing output and apply anything defined
here. Do not treat these as suggestions — they are project conventions.**

Add project-specific context here as you learn the product:
- User types / personas used by the team
- Platform conventions (web, mobile, internal tool)
- Design system or pattern library to reference
- Specific accessibility or localization requirements
