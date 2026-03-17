---
name: feature-ideation
description: >
  Generate structured feature ideas for a product — grouped by theme, each with
  a one-liner rationale and a quick-win vs. big-bet tag. Use this skill whenever
  the user wants new feature ideas, asks what else they could build, wants to
  expand a backlog, or says things like "give me feature ideas", "what else could
  we add", "brainstorm features for X", "what should we build next", "more ideas",
  "what features are we missing", or "help me think of features". Also trigger
  when the user has just finished a user story, PRD, or design critique session
  and wants to explore what comes next. Works from any starting point — rich
  product context or just a one-line description. Do NOT trigger for ranking or
  prioritizing existing ideas (use feature-prioritization), or for turning ideas
  into structured tickets (use ticket-creator).
---

# Feature Ideation Skill

Generate a structured set of feature ideas — grouped by theme, each with a
one-liner rationale and a quick-win / big-bet tag — so the user walks away
with actionable, well-organized inspiration rather than a flat list.

---

## Step 1: Gather Context

Before generating anything, understand what you're ideating for.

**First, check what's already available in the session or project:**
- A PRD, requirements doc, or spec
- Existing tickets or user stories
- Prior session work (design critique, user flows, etc.)
- A CLAUDE.md with product context

If sufficient context exists, proceed directly to Step 2. Don't ask questions
you can answer by reading.

**If context is thin or absent**, ask 2–3 focused questions — enough to generate
relevant ideas, not an exhaustive interview:

1. What is the product and who is the primary user?
2. What does it do today (or what's the core value proposition)?
3. Is there a theme, goal, or area you want ideas focused on — or should it be
   open-ended?

Keep it conversational. One round of questions is usually enough.

---

## Step 2: Generate Ideas

Produce a rich set of ideas (aim for 10–20) organized into 3–5 thematic groups.
The themes should emerge naturally from the product — don't force them into a
predetermined framework.

**For each idea:**
- A clear, descriptive name (not vague like "improve onboarding")
- A rationale (1-3 sentences): why this matters to the user or the product, and what problem it solves or opportunity it opens up
- A tag: **Quick Win** or **Big Bet**

**Quick Win**: Relatively contained scope, delivers value fast, low risk.
**Big Bet**: Significant investment, potentially high impact, more uncertainty.

These tags are directional signals, not precise estimates. When in doubt,
lean toward labeling — it helps the user scan and triage.

---

## Step 3: Output Format

Use this structure:

```
## [Theme Name]

**[Idea Name]** · Quick Win / Big Bet
> [1-3 sentence rationale: what problem it solves or opportunity it opens, and why it matters to the user]

**[Idea Name]** · Quick Win / Big Bet
> [1-3 sentence rationale]
```

Close with a brief offer:
- "Want me to go deeper on any of these, generate more in a specific theme,
  or turn any of these into tickets?"

---

## Principles

**Relevance over volume.** A tighter list of ideas that clearly connect to the
product's goals is more useful than an exhaustive dump. Prune as you go.

**Don't play it too safe.** Include a few genuinely ambitious ideas — Big Bets
exist because sometimes the most valuable thing is the thing that seems hard.

**Ground ideas in user value.** The rationale for each idea should explain what
the user gets, not just what the feature does. "So the user can..." beats
"This adds the ability to..."

**Don't reinvent what's already planned.** If there are existing tickets or a
PRD in scope, avoid duplicating work that's already captured. Reference it
where relevant ("this would complement the X feature in the PRD").
