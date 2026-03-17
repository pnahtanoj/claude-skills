---
name: researcher
description: >
  Investigate a product space and produce a structured research brief saved as a
  dated markdown doc in a research/ directory. Use this skill whenever the user
  wants to research a market, investigate competitors, understand user pain points,
  explore a product space, or gather context before writing a PRD or brainstorming
  features. Trigger on phrases like "research X", "look into the market for...",
  "who are the competitors for...", "what do users say about...", "investigate the
  space for...", "do a competitive analysis of...", "I want context on...", "what's
  the landscape for...", or any time the user needs grounded market/product
  intelligence before making product decisions. Also trigger when a user is about
  to start a PRD or feature-ideation session and hasn't done any market research
  yet — proactively suggest it. Feeds naturally into feature-ideation and
  requirements-doc. Do NOT trigger for writing features, creating tickets, or
  critiquing an existing design — use the appropriate skill for those.
---

# Researcher Skill

Investigate a product space through targeted web research and produce a
structured, synthesis-first research brief — not a raw dump of search results,
but a document a product team can actually use to make decisions.

The output lives in `research/` as a dated markdown file. It's designed to
feed directly into `feature-ideation` or `requirements-doc` sessions.

---

## Step 1: Clarify the Scope

Before searching, make sure you know what you're researching and why.

**First, check available context:**
- Is there a PRD, CLAUDE.md, or product doc in the project that describes the product?
- Has the user described the product or goal earlier in the session?
- Is there a `research/` directory with prior briefs that establish context?

If the scope is clear from context, proceed immediately. Don't ask questions
you can answer by reading.

**If the scope is genuinely ambiguous** — e.g., "research productivity tools" with
no other context — ask one focused question: *what specific angle or decision
is this research meant to inform?* (e.g., "I'm trying to understand whether
to build async video vs. text-based standup" is very different from "I want to
know who else is in this space.")

One question, then proceed. Don't stall.

---

## Step 2: Execute Research

Run targeted web searches across the dimensions below. For each dimension, do
1–3 focused searches. Prefer recent sources (within 2 years). Pull from
review sites (G2, Capterra, Reddit, App Store), industry analysis, company
websites, and job postings where relevant.

**Research dimensions:**

1. **Problem Space** — What core problem does this category solve? Who has it?
   How acute is it? Any taxonomy of sub-problems?

2. **Market Landscape** — How mature is this market? Growing, shrinking, or
   shifting? Any recent consolidation, new entrants, or regulatory pressures?

3. **Key Players & Positioning** — Who are the main competitors? How do they
   position themselves? What's each one's core bet?

4. **Pricing Patterns** — What pricing models exist (per-seat, usage, freemium,
   enterprise)? Rough price points? Any notable free tiers or trials?

5. **User Pain Points** — What do real users complain about? Where do they feel
   underserved? Mine reviews, forums, Reddit, and support communities.

6. **Market Trends** — What's changing? New behaviors, technology shifts,
   regulatory changes, or category convergence worth noting?

7. **Gaps & Opportunities** — What's missing? Where are users consistently
   underserved? What does no one seem to be doing well?

8. **Open Questions** — What couldn't you answer confidently? What would require
   deeper research (user interviews, analyst reports, etc.)?

You don't need equal depth on every dimension — let the evidence lead. If
pricing data is sparse, say so. If user pain points are rich, go deep there.

---

## Step 3: Synthesize

Don't transcribe search results. Synthesize:

- Pull out patterns across multiple sources, not single datapoints
- Note when sources contradict each other — that tension is often the most
  interesting signal
- Connect findings across dimensions (e.g., a pricing gap + a user pain point
  often points to an unmet opportunity)
- Flag confidence: mark findings as **High / Medium / Low** confidence based on
  source quality and corroboration

---

## Step 4: Write the Brief

Write the brief to `research/<YYYY-MM-DD>-<topic-slug>.md`. The topic slug
should be lowercase, hyphen-separated, and descriptive (e.g.,
`async-video-standup-tools`, `b2b-expense-management`).

Use this structure:

```markdown
# Research Brief: [Topic]
*Date: YYYY-MM-DD | Confidence: [overall High/Medium/Low] | Research question: [one sentence]*

## Executive Summary
3–5 bullets. The most important findings only — what does a product team need
to know to make decisions? Don't restate everything; surface the signal.

## Problem Space
What problem is being solved, for whom, and how acutely.

## Market Landscape
Maturity, size signals, growth direction, recent shifts.

## Key Players
| Player | Positioning | Core bet | Notable |
|--------|-------------|----------|---------|
| ...    | ...         | ...      | ...     |

## Pricing Patterns
Models, price points, free tiers. Flag if data was sparse.

## User Pain Points
What real users say. Cite source types (e.g., "across G2 reviews", "Reddit
threads in r/productivity"). Group by theme rather than listing one-by-one.

## Market Trends
What's changing and why it matters.

## Gaps & Opportunities
The most actionable section. Specific, concrete gaps — not generic
"there's an opportunity to be better."

## Open Questions
What this research couldn't answer. What would unlock the next level of insight
(e.g., "need user interviews to validate X", "couldn't find reliable pricing
for enterprise tier").

## Sources & Confidence Notes
Brief list of source types used. Flag any low-confidence sections with a
one-liner on why.
```

After writing, tell the user the file path and give a 2–3 sentence summary
of the most important finding.

---

## Step 5: Offer Next Steps

After presenting the summary, offer:

> "Want me to feed this into a feature-ideation session, or use it as
> background for a requirements doc?"

If there are significant open questions, name them specifically and offer to
dig deeper on any of them.

---

## Principles

**Synthesis over completeness.** A research brief with 5 sharp insights beats
one with 20 bullets of loosely organized facts. Prune aggressively.

**Flag what you don't know.** Overconfident research is worse than honest gaps.
Mark low-confidence findings clearly so the reader knows where to push harder.

**Stay close to evidence.** Every claim should be traceable to a source type.
Avoid generic statements like "users want simplicity" — instead: "G2 reviews
for [Competitor] repeatedly cite X as frustrating."

**Recency matters.** A 3-year-old competitive landscape may be misleading.
Prefer recent sources; flag when you couldn't find them.

**Don't manufacture depth.** If a dimension has thin coverage (e.g., pricing
is opaque, or the market is too new for good data), say so clearly and move on.
Don't pad with speculation.
