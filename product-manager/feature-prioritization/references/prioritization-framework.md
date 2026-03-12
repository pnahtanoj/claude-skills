# Prioritization Framework

Criteria definitions, stage-appropriate weights, and output format for
feature prioritization.

---

## Scoring Scale

Use a **1-3 scale** for all criteria. Avoid 1-10 — it creates false precision
and makes scores harder to explain.

| Score | Meaning |
|---|---|
| 3 | High — strong signal, clear case |
| 2 | Medium — real but qualified |
| 1 | Low — weak, uncertain, or costly |

For **Effort**, score is inverted: 3 = low effort (fast/simple), 1 = high
effort (slow/complex). This keeps higher total scores meaning "do this first."

---

## Criteria Definitions

**User Impact (1-3)**
How meaningfully does this improve the experience for the target user?
- 3: Directly unblocks or significantly improves the core use case
- 2: Noticeably improves experience but not critical to the core loop
- 1: Nice to have; users would barely notice its absence

**Strategic Fit (1-3)**
How directly does this advance the stated product goal right now?
- 3: Core to the stated goal — without this, the goal is at risk
- 2: Supports the goal but not on the critical path
- 1: Tangential or speculative connection to current goals

**Effort (1-3, inverted)**
How much time and complexity to build well?
- 3: Low effort — days, well-understood, few dependencies
- 2: Medium effort — weeks, some unknowns
- 1: High effort — months, significant unknowns or dependencies

**Confidence (1-3)**
How well understood is the problem, the user need, and the solution?
- 3: Well validated — user research, clear precedent, or already spec'd
- 2: Reasonable hypothesis — some signal but not fully validated
- 1: Assumption — limited evidence, significant unknowns

**Risk (1-3, inverted)**
What's the downside if this is wrong, delayed, or cuts scope?
- 3: Low risk — reversible, contained, limited blast radius
- 2: Medium risk — some dependencies or hard-to-undo decisions
- 1: High risk — irreversible decisions, blocks other work, or high
     uncertainty about need

---

## Stage-Appropriate Weights

Different product stages call for different emphasis. These are starting
points — adjust based on stated goals.

| Criteria | Early (v1, validate) | Growth (scale, optimize) | Mature (retain, expand) |
|---|---|---|---|
| User Impact | High | High | High |
| Strategic Fit | High | High | Medium |
| Effort | High | Medium | Low |
| Confidence | Medium | High | High |
| Risk | Medium | Medium | High |

**Early stage:** Ship fast, validate the core loop. Effort and strategic fit
matter most — avoid building things that don't directly prove the hypothesis.

**Growth stage:** Confidence matters more — you're optimizing, not
experimenting. Don't build on unvalidated assumptions at scale.

**Mature stage:** Risk tolerance drops — users depend on the product.
Reversibility and blast radius become primary concerns.

---

## Output Format

```
## Feature Prioritization: [Product / Context]
*Goal: [stated goal]*
*Stage: [Early / Growth / Mature]*
*Criteria: [list of criteria used, with any weights noted]*

---

### Ranked List

| Rank | Feature | Impact | Fit | Effort | Confidence | Risk | Notes |
|---|---|---|---|---|---|---|---|
| 1 | [Feature] | 3 | 3 | 3 | 2 | 3 | [Key tension or driver] |
| 2 | [Feature] | ... | | | | | |
...

---

### Recommendation

**Build first:** [Top 2-3 items] — [one sentence on why this cluster]

**Defer:** [Items to cut or push] — [direct reason]

**Swing items:** [Items whose ranking is genuinely uncertain]
- [Item] — would move up if [condition]; would move down if [condition]

**What would change this ranking:**
- [Condition] → [effect on ranking]
```

---

## Common Tensions to Surface

Flag these explicitly when they appear — don't average them away:

- **High impact, high effort:** Worth it if strategic fit is also high and
  confidence is good. Otherwise, look for a smaller version.
- **High fit, low confidence:** Dangerous to build at scale. Validate first —
  a spike or prototype may be the right next action, not a full build.
- **Low effort, low impact:** "Quick wins" that don't move the needle. Be
  honest about whether these belong in the ranking at all.
- **High risk, high impact:** Flag as a swing item. The ranking depends on
  how much uncertainty the team can absorb right now.

---

## Notes for Customization

**Claude: read this section before scoring and apply anything defined here
as hard criteria — not suggestions.**

Add project-specific conventions here:
- Custom criteria relevant to this product (e.g. accessibility compliance,
  platform constraint, regulatory requirement)
- Fixed weights for this team's prioritization process
- Items that are non-negotiable (always in / always out regardless of score)
- Scoring context (e.g. "effort scores assume a 2-person team")
