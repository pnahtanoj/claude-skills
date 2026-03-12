# Critique Dimensions

Evaluate the design across all five dimensions below. Not every dimension will
yield issues — that's fine. Only surface real problems, not filler.

---

## 1. User Experience & Flows

- Is the entry point clear? Does the user know what to do first?
- Is the happy path complete end-to-end with no gaps?
- Are alternate paths and error states defined?
- Are there moments where the user could get lost, confused, or stuck?
- Is feedback given to the user at the right moments (loading, success, failure)?
- Are interactions discoverable — or do they require prior knowledge?
- Is the cognitive load appropriate for the intended user?
- Are there unnecessary steps, or missing steps?

## 2. Visual Design & Aesthetics

- Is the visual direction consistent with the product's goals and tone?
- Is there a coherent visual language (forms, motion, color, density)?
- Does the visual layer communicate state clearly (active, frozen, transitioning)?
- Is there appropriate visual hierarchy — does the eye know where to go?
- Are there moments where aesthetics might conflict with usability?
- For generative/procedural visuals: is there enough variety to stay interesting
  over time? Is there a risk of visual monotony or chaos?

## 3. Technical Feasibility

- Are there components that are likely to be significantly harder than they appear?
- Are external dependencies (APIs, data sources) reliable enough for the use case?
- Are there latency or performance risks that could affect the experience?
- Are real-time or generative elements scoped realistically?
- Are there data normalization or edge case risks that aren't addressed?
- Is the proposed architecture (even if implicit) coherent?

## 4. Scope & Completeness

- Are there obvious features missing that users would expect?
- Are there sections of the design that are underspecified?
- Are open questions flagged — or are there unresolved assumptions being
  treated as settled?
- Is v1 scope realistic, or is it trying to do too much?
- Are future considerations (v2, extensibility) noted without bloating v1?

## 5. Consistency with Stated Goals

- Does the design actually deliver on the stated user stories?
- Are all acceptance criteria achievable with the current design?
- Are there places where the design drifts from the original intent?
- Does the interaction model match the stated tone/aesthetic goals?
- Are there tensions between different stated goals that haven't been resolved?
