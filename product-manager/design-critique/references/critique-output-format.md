# Critique Output Format

## Structure

Present findings as a prioritized list of issues, grouped by severity.
Each issue should be specific, actionable, and tied to a dimension.

---

## Output Template

### Design Critique: [Design Name]
*Stage: [Concept / Mid-fidelity / Near-final]*
*Reviewed against: [list of dimensions covered]*

---

### 🔴 Critical — Address Before Moving Forward
Issues that represent fundamental problems with the design. If left unresolved,
they will likely cause the design to fail or require significant rework.

**[Issue title]** *(Dimension)*
What the problem is, why it matters, and what to consider doing about it.

---

### 🟡 Significant — Should Be Resolved
Real gaps or risks that aren't showstoppers but will cause friction, confusion,
or technical pain if not addressed.

**[Issue title]** *(Dimension)*
What the problem is, why it matters, and what to consider doing about it.

---

### 🔵 Minor — Worth Noting
Small issues, polish items, or things to keep in mind. Low urgency but worth
tracking.

**[Issue title]** *(Dimension)*
What the problem is and a suggested direction.

---

### ✅ What's Working
2-4 specific things the design does well. Be precise — name the exact element,
decision, or pattern that works and *why* it works. Generic praise ("good
visual hierarchy") is not useful. The goal is to anchor what must be preserved
as the design evolves, not to soften the critique.

---

## Quality Bar

**Fix failures before presenting — don't surface a critique that doesn't pass.**

- [ ] Every issue is tied to a named dimension
- [ ] Every issue is specific — names the exact element, step, or section
- [ ] Every issue points toward a resolution, even loosely
- [ ] No issues are manufactured to fill the template — if there are 2 real
      critical issues, list 2, not 5
- [ ] Critical issues are not softened — if something is fundamental, say so
- [ ] "What's Working" items are specific and explain why, not generic praise
- [ ] Project-specific standards from Notes for Customization are applied

---

## Notes for Customization

**Claude: read this section before critiquing and apply anything defined here
as hard criteria — not suggestions.**

Add project-specific critique criteria here as the product matures:
- Design system or pattern library standards to check against
- Accessibility requirements (WCAG level, specific needs)
- Performance budgets or technical constraints
- Brand or tone guidelines
- Known technical limitations of the stack
