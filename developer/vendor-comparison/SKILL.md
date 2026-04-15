---
name: vendor-comparison
description: >
  Produce a structured, weighted comparison of 3 or more vendors, tools,
  or platforms for a specific use case. Builds a scored comparison matrix
  with explicit weighted criteria, a side-by-side feature parity table,
  per-vendor strengths and weaknesses, and a recommendation tied to the
  scoring. Saves the output as a dated markdown doc in research/ or
  docs/research/. Use this skill whenever the user wants to compare
  multiple vendors, evaluate competing tools, build a shortlist, pick
  between platforms, or says things like "compare Vendor A, B, and C",
  "evaluate these tools for X", "which of these vendors should we pick",
  "build me a comparison matrix for...", "score these options", "head
  to head on [vendors]", "vendor shortlist for...", or "which is the
  best fit for our needs". Also trigger when the user has already done
  research on individual vendors and wants to synthesize them into a
  side-by-side. Especially useful when there are 3+ real options on the
  table and the user needs a structured scorecard rather than a narrative.
  Do NOT trigger for picking between 2-3 tech libraries or frameworks
  (use stack-decision), general research on a single vendor or market
  (use researcher), or for auditing an existing vendor evaluation (use
  research-review).
---

# Vendor Comparison

Produce a structured, weighted comparison of multiple vendors, tools, or
platforms for a specific use case. The output is a scored comparison that
makes implicit trade-offs explicit — so the user can defend the choice
to a skeptical stakeholder, not just say "it felt right."

This is a research-shaped workflow, not a decision document. The output
may end without a final pick (e.g., when pricing conversations or
reference calls are still pending) — that's fine. The goal is to produce
a scorecard that survives scrutiny.

---

## Step 1: Scope the comparison

Before diving in, pin down the basics. Ask the user (or infer from context):

1. **What are the vendors/tools in scope?** You need a concrete list of 3+.
   If they give you only 2, flag it and either suggest 1-2 adjacent options
   to round out the field, or ask if they'd rather use `stack-decision`
   (which is better for A-vs-B choices).

2. **What is the use case?** Not "pick a BI tool" — "pick a BI tool for
   a multi-tenant 3PL portal where 50+ clients need dashboards, budget
   is modest, team has no BI experience." Specifics drive the criteria.

3. **What are the hard constraints?** Things that are non-negotiable:
   - Budget ceiling
   - Must integrate with X
   - Must support Y compliance regime
   - Must be deployable by Z date
   
   These become gates before scoring — a vendor that fails a hard
   constraint is disqualified, not just docked points.

4. **What's the timeline for the decision?** Affects how much research
   depth makes sense. A "pick in the next 2 weeks" is different from
   "we're 6 months out."

If any of these are unclear, ask 2-3 sharp questions before proceeding.
A weak scope produces a weak scorecard.

---

## Step 2: Define weighted criteria

This is the core intellectual work of the skill. The criteria and their
weights are the thing that makes the comparison defensible.

### Choosing criteria

Aim for 5-9 criteria. Fewer than 5 and you're not really comparing;
more than 9 and the weights get diluted to the point of meaninglessness.

Criteria should be:
- **Specific to the use case.** "Good UX" is too generic. "Self-service
  dashboard authoring by non-technical client admins" is a criterion.
- **Observable from research.** If you can't find evidence one way or the
  other across vendor docs, analyst reports, and case studies, the
  criterion won't discriminate.
- **Independent.** Two criteria that are really measuring the same thing
  will double-weight that dimension. Merge them.

Common criteria to consider:

| Category | Examples |
|---|---|
| **Fit** | Core feature coverage, workflow match, domain expertise |
| **Integration** | APIs, existing system compatibility, data flow |
| **Cost** | List price, TCO, scaling cost, hidden costs (add-ons, implementation) |
| **Risk** | Vendor maturity, lock-in, escape hatch, regulatory fit |
| **Team** | Skill match, learning curve, ecosystem support |
| **Scale** | Performance under load, multi-tenancy, growth headroom |
| **Time** | Time-to-value, implementation effort, proof-of-concept availability |

### Weighting

Assign weights that sum to 100 (or use a 1-5 scale per criterion and
note which are "high weight"). Show the weights explicitly with rationale:

> **Multi-tenant RLS (weight: 20)** — Highest weighted because 50+ client
> accounts must not see each other's data. Any vendor failing this is
> disqualified regardless of other scores.

**Be honest about why weights are what they are.** A weight is a political
statement — it says "this matters more to us than that." Surface the
reasoning so the user can argue with it. Hidden weights fuel the "this
felt off but I can't say why" reaction.

---

## Step 3: Gather evidence

For each vendor × each criterion, gather concrete evidence before scoring.
Don't score from gut.

Sources in order of trust:
1. **Independent third parties** — analyst reports (Gartner, Forrester),
   peer review sites (G2, Capterra), customer case studies from
   non-vendor-controlled channels
2. **Vendor's own docs** — product pages, API references, pricing pages,
   release notes. Useful for capabilities but treat marketing claims
   skeptically.
3. **Community signal** — GitHub activity, Stack Overflow volume, Reddit
   threads. Good for "is this alive and healthy."
4. **Vendor sales/marketing materials** — least reliable; use only to
   understand positioning, not to verify capability.

**Flag what you couldn't verify.** If Vendor X claims "enterprise-grade
multi-tenancy" but you can't find architectural documentation or customer
evidence, say so and lower confidence in that score. Never make up a
score to fill a cell.

**Use subagents for parallel research** if the vendors are independent —
this is slow work and parallelism helps a lot.

---

## Step 4: Score the matrix

Score each vendor against each criterion. Use a consistent scale — 1-5
is usually right:

- **5** — Clear winner; best-in-class for this criterion
- **4** — Strong; above average with caveats
- **3** — Adequate; meets the requirement without standing out
- **2** — Weak; meets some of the need but has real gaps
- **1** — Inadequate; fails this criterion materially

Every score needs **one line of evidence** next to it. Not "5 — great API" —
but "5 — REST + GraphQL APIs documented; published webhook patterns;
customer case study at Company X describes 200+ integrations in production."

### Handling hard constraints

Hard constraints (from Step 1) are applied before scoring. A vendor that
fails a hard constraint is marked as disqualified — don't score it. You
can still include it in the matrix with an explanation of why it was
dropped, because that reasoning may be useful later.

### Calculating totals

Weighted total = sum of (score × weight) for each criterion.

If weights are 1-5, normalize so the max possible is comparable across
setups. If weights sum to 100, just multiply and sum.

Show the math explicitly in the output. Nobody should have to reverse-engineer
why Vendor B beat Vendor A.

### Show unweighted alongside weighted

Include an unweighted average (or sum) next to the weighted total for
each vendor. This makes the impact of the weighting visible at a glance:

| Vendor | Unweighted avg | Weighted total |
|---|---|---|
| Vendor A | 3.8 | 4.2 |
| Vendor B | 3.9 | 3.5 |
| Vendor C | 3.4 | 2.9 |

When the unweighted and weighted rankings disagree (as above — B beats A
unweighted but A wins weighted), that's the most important signal the
comparison produces. It tells the reader the weighting is doing real work
and forces them to confront whether they agree with the weights. If the
two columns always produce the same order, the weighting isn't actually
discriminating — reconsider whether the weights matter.

---

## Step 5.5: Verify the math before writing the narrative

This is a separate step because it's the thing that most often breaks
trust in a comparison doc. Before you write any narrative that cites
totals or margins, verify:

1. **Recalculate every weighted total.** For each vendor: for each
   criterion, multiply score × weight, sum. Do it twice (or use a
   script) if the matrix is large.
2. **Cross-check any number you plan to cite elsewhere.** The executive
   summary, the recommendation, the margin analysis — every cited
   number must match the scorecard table exactly.
3. **Check the weights sum.** If you said weights sum to 100, they
   actually must.
4. **Check the vendor order.** If you're claiming "Vendor A leads",
   the arithmetic must actually put A first.

Arithmetic errors in a vendor comparison are worse than any other kind
of mistake. A reader who spots one will not trust the scoring or the
recommendation — they'll assume the whole analysis is sloppy. Spending
60 seconds on this check is the highest-ROI work in the entire skill.

If the math doesn't come out clean (weights don't sum, weighted total
produces a surprising ranking), stop and figure out why before writing
the recommendation. It usually means a score needs revisiting or a
weight was off.

---

## Step 5: Write per-vendor strengths and weaknesses

The matrix alone isn't enough. For each vendor, write a short section:

- **2-3 strengths** — where the vendor scored highest or has unique value
- **2-3 weaknesses** — where it scored lowest or has real risk
- **Best fit for** — the kind of situation where this vendor wins
- **Unconfirmed / needs validation** — open questions, reference checks
  to do, PoC items to run

This section catches things the numeric scoring flattens. A vendor can
score 4.2 overall and still be wrong for you because of one specific
weakness that the weights didn't capture fully.

### Consistency check: strengths and weaknesses vs. the scorecard

Before moving on, sanity-check that the strengths and weaknesses match
the numeric scoring. A vendor scored 5/5 on cost shouldn't have
"expensive" listed as a weakness. A vendor scored 2/5 on multi-tenant
RLS shouldn't have "great RLS" listed as a strength.

When they disagree, one of three things is true:
- The score is wrong (revisit it with the evidence)
- The narrative is wrong (rewrite the strength/weakness)
- The criterion is too broad — the score averages across sub-aspects
  that pull in different directions (consider splitting the criterion)

Don't paper over disagreement. If cost is "low on list price but
expensive at scale", either reflect that in the score (a 3, not a 5)
or split "cost" into "list price" and "scaling cost" as separate
criteria.

---

## Step 6: Make a recommendation (or explicitly defer)

Close with a clear recommendation tied to the scoring:

### If the scorecard is decisive

> **Recommendation: Pallet.**
> Scored 4.1 weighted average vs. HappyRobot (3.4) and Raft (2.9).
> Wins on breadth of workflow coverage (5/5) and pricing model fit for
> mid-market 3PLs (4/5). Loses on integration maturity — flag for
> reference check before signing.

### If the scorecard is tight

> **Recommendation: tie between Sigma and Metabase, pending cost
> conversation.** Sigma scored 4.0, Metabase scored 3.9. Sigma wins on
> UX and multi-tenant maturity; Metabase wins on cost and open-source
> escape hatch. Decision depends on whether the Power BI EA covers
> Sigma-equivalent needs.

### If the scorecard is inconclusive

> **Recommendation: deferred, pending two questions.**
> - Does the team have 2 weeks for a Metabase PoC? If yes, the scorecard
>   becomes decisive — Metabase wins on team fit.
> - Can Snowflake cost be modeled at our actual portal usage envelope?
>   Current estimate has 3× variance; affects whether Snowflake wins
>   on cost or loses.

Be honest about what the scorecard can and can't decide. Over-claiming
precision ("Vendor A wins by 0.3 points!") is worse than saying "the
scorecard points toward A but the margin is within the uncertainty of
the scoring."

---

## Step 7: Produce the output

Save to `research/YYYY-MM-DD-[topic]-vendor-comparison.md` (or
`docs/research/` if the project uses that convention).

### Standard output structure

```markdown
# [Topic] Vendor Comparison — YYYY-MM-DD

**Use case:** [one sentence — what this is for]
**Vendors evaluated:** [comma-separated list]
**Status:** [In progress | Recommendation pending | Final]

## Executive summary
[3-5 sentences — what's being compared, what won, any caveats]

## Scope and constraints
### Use case
[specifics from Step 1]
### Hard constraints
- [non-negotiables]
### Timeline
[when a decision is needed and why]

## Criteria and weights
| # | Criterion | Weight | Rationale |
|---|---|---|---|
| 1 | [name] | [weight] | [why it matters this much] |

## Scorecard
| Criterion (weight) | Vendor A | Vendor B | Vendor C |
|---|---|---|---|
| [criterion] (15) | **4** — [evidence] | 3 — [evidence] | 2 — [evidence] |
| ... | ... | ... | ... |
| **Unweighted average** | 3.8 | 3.9 | 3.4 |
| **Weighted total** | **4.1** | 3.4 | 2.9 |

_Math verified: weights sum to 100; weighted totals recomputed from
the matrix above._

## Per-vendor assessment
### Vendor A — [one-line positioning]
**Strengths**
- [specific to this comparison]
**Weaknesses**
- [specific to this comparison]
**Best fit for:** [describe the kind of buyer who wins with A]
**Needs validation:** [open items]

[repeat for each vendor]

## Recommendation
[from Step 6]

## Sources
[numbered list with confidence flags per source]

## Open questions
- [items that would tighten the recommendation if answered]
```

### When the scorecard should come first, not the prose

If the user asks for a vendor comparison, the scorecard is the artifact
they came for. Don't bury it 3 sections deep. Lead with the executive
summary, then the scorecard, then dig into criteria and per-vendor
assessments.

---

## Principles

**The weights are the argument.** Anyone can produce a feature matrix.
What makes a vendor comparison defensible is that the weighting reflects
an explicit, arguable prioritization of what matters. Surface the weights
and their rationale — that's where the intellectual content lives.

**Scores without evidence are guesses.** Every cell in the scorecard
should have a one-line justification with a source you could show to a
skeptical colleague. "3 — adequate" is not evidence. "3 — API documented
but no webhook support; customer case study mentions workaround via
polling" is evidence.

**Flag what you couldn't verify, loudly.** A vendor comparison that
presents 5 vendors with equal confidence when you only found evidence for
3 of them is misleading. Call out where data is thin. Recommend reference
checks and PoCs to resolve.

**It's OK to not have a winner.** If the scorecard is close and depends
on unverified information, say so and recommend the specific work that
would resolve it. Don't force a pick just to feel complete.

**Compare the realistic field, not the hypothetical one.** Including 8
vendors when only 3 are plausible for the user's constraints wastes
everyone's time. A tight field of 3-5 realistic options scored thoroughly
beats a broad field of 8 scored shallowly.

**Don't confuse market leadership with fit.** The Gartner MQ leader is
often wrong for a specific situation. Score for the use case, not for
the vendor's general reputation.

**Arithmetic is non-negotiable.** The scorecard is the evidence that
the recommendation is defensible. If the math doesn't check out — if
the exec summary cites a different total than the scorecard, or the
weighted sum doesn't actually produce the claimed ranking — the whole
doc loses credibility. Verify before writing. Every single number you
cite in narrative should match a number in the table.
