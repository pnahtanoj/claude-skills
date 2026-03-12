---
name: feature-prioritization
description: >
  Evaluate and stack-rank features, ideas, or backlog items against goals,
  effort, and risk. Use this skill whenever a user needs to decide what to
  build next, cut scope, shape a roadmap, or choose between competing ideas.
  Triggers on phrases like "help me prioritize", "what should we build first",
  "rank these features", "what should we cut", "help me with the roadmap",
  "which of these is most important", or any time there's a list of ideas and
  a need to order or filter them. Also trigger when a user is overwhelmed by
  backlog size or trying to define v1 scope from a larger list.
  Do not trigger for general feature brainstorming, writing user stories, or
  design critique — use the appropriate skills for those instead.
---

# Feature Prioritization Skill

Stack-rank features or backlog items against explicit criteria, making the
reasoning visible and defensible — not just a gut call dressed as a framework.

## Core Behavior

**Ask about goals and constraints before scoring.** A ranked list without
context is just an opinion. The criteria weights depend entirely on what the
product is trying to achieve and where it is in its lifecycle.

**Be framework-aware but not framework-rigid.** Know the standard frameworks
(RICE, ICE, MoSCoW, Kano) but apply them as lenses, not formulas. A v1 product
weights differently than a mature product optimising for retention.

**Surface tensions, don't hide them.** When an item scores high on impact but
low on effort, or is strategically important but risky — say so explicitly.
Averaging criteria into a single score buries the insight.

**Be opinionated.** A ranked list that qualifies everything equally isn't
useful. Make a recommendation, flag your confidence, and explain what would
change the ranking.

**Before producing output, check `references/prioritization-framework.md`**
for scoring criteria, weighting guidance by product stage, and output format.
Check Notes for Customization for any project-specific criteria or weights.

---

## Step 1: Establish Context

Before scoring anything, understand:

1. **What are the items?** If not provided as a list, ask the user to enumerate
   them — even roughly. Don't score a vague description.
2. **What's the goal?** What is the product trying to achieve right now?
   (Acquire users? Reduce churn? Hit a launch date? Prove a hypothesis?)
3. **What's the time horizon?** Are we prioritizing for the next sprint, v1
   scope, or a 6-month roadmap?
4. **Are there hard constraints?** Dependencies, team size, deadlines, or
   non-negotiables that should override scoring.
5. **What stage is the product at?** Early (validate, ship fast) vs. growth
   (optimize, scale) vs. mature (retain, expand) — this determines weights.

If these are already clear from session context, skip asking and proceed.
If only some are missing, ask for the gaps specifically — don't run through
all five questions if three are already answered.

---

## Step 2: Select and Explain Criteria

Load `references/prioritization-framework.md` for criteria definitions and
stage-appropriate weights.

Based on the product stage and goals, select 3-5 criteria to score against.
**Tell the user which criteria you're using and why** — don't apply them
silently. If you're weighting some criteria more heavily than others, say so.

Common criteria:
- **User impact** — how meaningfully does this improve the experience for the
  target user?
- **Strategic fit** — how directly does this advance the stated product goal?
- **Effort** — how much time/complexity to build? (inverse — lower effort = higher score)
- **Confidence** — how well understood is the problem and solution?
- **Risk** — what's the downside if this is wrong or delayed?

---

## Step 3: Score and Rank

Score each item against the selected criteria. Use a simple 1-3 scale
(1 = low, 2 = medium, 3 = high) — avoid false precision with 1-10 scales.

For each item:
- Give a score per criterion
- Note the key reason for the score (one sentence)
- Flag any tensions (high impact but high effort; strategic but risky)
- Flag confidence level if genuinely uncertain

Then produce the ranked output following the format in
`references/prioritization-framework.md`.

**Apply the quality bar before presenting — don't surface output that
doesn't pass.**

---

## Step 4: Make a Recommendation

After the ranked list:

1. **Call the top 3** — what should be built first and why
2. **Name what to cut or defer** — be direct, not diplomatic
3. **Flag the swing items** — things that could move significantly up or down
   the ranking with more information
4. **Note what would change the ranking** — e.g. "if the team is smaller than
   expected, X drops significantly"

---

## Step 5: Offer to Refine

After presenting:
- Offer to adjust weights or criteria: *"Want to reweight any of these, or
  add a criterion I haven't considered?"*
- If items are ready for tickets: *"Want me to turn the top items into
  tickets?"*
- If scope needs a PRD update: *"Want me to update the non-goals section of
  the PRD to reflect what we're deferring?"*

---

## Handling Thin Input

If the user provides only a vague list (e.g. "prioritize our backlog"):
1. Ask for the list explicitly — you can't score what isn't enumerated
2. Ask the single most important context question (usually: what's the goal?)
3. Proceed once you have a list and a goal — don't wait for perfect inputs

---

## Rules

Failure patterns to avoid. Update this section when new ones are observed.

- **Never score without establishing goals first.** A ranked list without a stated goal is just an opinion. Always confirm what the product is trying to achieve before applying criteria.
- **Never apply criteria silently.** Tell the user which criteria you're using and why before presenting scores — the reasoning is as important as the output.
- **Never average tensions away.** An item that scores 3 on impact and 1 on effort is a fundamentally different conversation than one that scores 2/2. Name the tension explicitly.
- **Never score items you can't distinguish.** If two items score identically across all criteria, flag it — don't fake a ranking.
- **Never be diplomatic about what to cut.** If something should be deferred, say so directly with a reason. Softening the recommendation defeats the purpose.
- **Never present output that fails the quality bar** — fix it first, then present.
- **When the user approves an output as good, save it as an example.** Append it to `references/examples.md` (create the file if it does not exist) under a dated heading. Future runs should check this file for approved output patterns and match their style and depth.
- **Use subagents for large backlogs.** If scoring 8+ items, spawn parallel subagents to score items in batches of 4, then merge results and normalize scores across batches before ranking.
