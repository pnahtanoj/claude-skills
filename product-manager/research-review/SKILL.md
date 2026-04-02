---
name: research-review
description: >
  Audit a research document — vendor evaluation, competitive analysis, research
  brief, spike finding, or any structured investigation — for factual accuracy,
  internal consistency, and completeness. Verifies claims against public sources,
  cross-references against other project documents, identifies gaps, and produces
  a structured findings report with recommended edits. Use this skill whenever
  the user asks you to review, fact-check, verify, audit, or validate a research
  document or vendor assessment. Trigger on phrases like "review this research",
  "fact-check this brief", "verify the claims", "audit this vendor evaluation",
  "does this assessment hold up", "check the validity of this", "cross-reference
  this against our discovery docs", or any time a user has an existing research
  artifact and wants to know if it's accurate and complete before acting on it.
  Also trigger when the user shares a research doc and asks how it compares to
  other project work. Pairs naturally with the researcher skill (which creates
  briefs — this one audits them). Do NOT trigger for creating new research from
  scratch (use researcher), reviewing code (use code-review), or critiquing
  product designs (use design-critique).
---

# Research Review

Audit an existing research document for factual accuracy, source reliability,
internal consistency, and completeness. The goal is to tell the user what they
can trust, what they should correct, and what's missing — before they make
decisions based on it.

This skill works on any structured research artifact: vendor evaluations,
competitive analyses, research briefs, technical spike findings, market
assessments, or similar documents.

---

## Step 1: Read and Understand

Read the target document fully. Then look for related project context:

- **Discovery docs** — DISCOVERY.md, docs/ directory, or similar living documents
  that describe the project's current state, systems, and stakeholders
- **Other research** — prior briefs in research/, ADRs in docs/decisions/, or
  related evaluations that overlap with or inform this document
- **Project config** — README, CLAUDE.md, or any file that establishes what the
  project is and what the team cares about

The point is to understand what the document claims, and what the project
context expects. A vendor evaluation that says "integrates with Blue Yonder"
means something different if the project's discovery doc says "we have
read-only database access to BY" vs. "we own the BY admin console."

Don't ask the user what to cross-reference — find the relevant docs yourself.
Only ask if the project has no discoverable context at all.

---

## Step 2: Extract Claims

Go through the document and pull out every verifiable claim. These typically
fall into categories:

| Category | Examples |
|----------|----------|
| **Funding & financials** | Funding amounts, round details, investors, valuations |
| **Partnerships & integrations** | "Integrates with X", "listed partner of Y", "works with Z" |
| **Customer references** | Named customers, case study details, quoted metrics |
| **Product capabilities** | Feature lists, workflow descriptions, technical architecture claims |
| **Market data** | Market size, competitor funding, industry statistics |
| **People & roles** | Named individuals, their titles, their involvement |
| **Awards & recognition** | Industry awards, press mentions, analyst coverage |

For each claim, note:
- The specific assertion being made
- How confident the document says it is (if it flags confidence levels)
- Whether it's attributed to a source or stated as fact

Some claims aren't worth verifying — a company's self-description on their own
website, or widely-known industry context. Focus verification effort on claims
that (a) the user might act on, (b) are specific enough to check, and
(c) would change the document's conclusions if wrong.

---

## Step 3: Verify Against Public Sources

For each claim worth checking, do targeted web research. Use subagents for
parallel research when there are many independent claims to verify — this is
the most time-consuming step and parallelism helps significantly.

Classify each claim:

| Verdict | Meaning |
|---------|---------|
| **Confirmed** | Found independent corroboration from a credible source |
| **Partially confirmed** | Core claim holds but details differ, or source is weaker than implied |
| **Unconfirmed** | Couldn't find evidence either way — not necessarily wrong, just unverifiable |
| **Denied** | Found evidence that contradicts the claim |
| **Overstated** | Factually true but presented more strongly than the evidence supports |

The **Overstated** category matters a lot. "Confirmed integration" vs. "claims
integration capability" is the difference between a risk you've retired and one
you still carry. Watch for:

- Vendor marketing pages presented as validated partnerships
- Self-reported case study metrics presented as independently verified results
- "Listed on a website" conflated with "production-tested and endorsed"
- Trial terms, pricing, or availability claims that are inconsistent across a
  vendor's own pages

When checking, look at both sides. If the document says "Company X integrates
with Platform Y," check both Company X's site AND Platform Y's partner
directory. One-sided claims are weaker than mutual confirmation.

---

## Step 4: Cross-Reference with Project Context

Compare the document's framing against what the project's own documents say.
Look for:

**Consistency gaps** — Does the research doc describe the project's systems,
scale, or capabilities accurately? If it says "we process tens of thousands
of shipments per day" but the discovery doc doesn't mention volume at all,
that's an unverified internal claim that should be flagged.

**Alignment assessment** — Does the document correctly position its subject
relative to the project's architecture, priorities, and constraints? A vendor
evaluation should reflect the project's actual integration points, not generic
ones.

**Missing context** — Does the document fail to address something the project
docs make obviously relevant? If the discovery doc lists a major system
migration in progress, and the vendor eval doesn't discuss how the vendor
relates to that migration, that's a gap.

**Contradictions** — Does the document say something that conflicts with what
other project docs say? Flag these explicitly.

---

## Step 5: Identify Gaps

Beyond verifying what's there, assess what's missing. Common gaps:

- **Unmapped internal workflows** — The document describes what a vendor offers
  but doesn't map it to what the team actually does or needs today
- **Missing major players** — Competitors or customers that should be mentioned
  based on the research but aren't
- **No negative evidence** — All sources are vendor-controlled; no independent
  reviews, negative press, or failure cases were sought or found
- **Unverified internal figures** — The document states internal metrics
  (volume, headcount, costs) without attribution
- **Product distinctions** — The vendor has multiple products or tiers and the
  document doesn't differentiate between them
- **Pricing gap** — No pricing data, or inconsistent pricing claims, without
  a clear recommendation on how to resolve

---

## Step 6: Present Findings

Structure the output in two parts:

### Part 1: Verification Summary

Present a summary table of the major claims and their verdicts. This gives
the user a quick scan of what held up and what didn't.

| Claim | Verdict | Notes |
|-------|---------|-------|
| Series B $27M led by General Catalyst | Confirmed | BusinessWire, Yahoo Finance |
| Blue Yonder integration confirmed | Overstated | Pallet claims capability; BY doesn't list Pallet as partner |
| ... | ... | ... |

### Part 2: Detailed Assessment

Walk through the findings organized by theme:

1. **Factual accuracy** — What's confirmed, what's overstated, what's wrong
2. **Alignment with project context** — How well it fits with discovery docs
   and other project work
3. **Strengths** — What the document does well (honest confidence labeling,
   good competitive mapping, practical next steps, etc.)
4. **Weaknesses & gaps** — What's missing or needs correction, ordered by
   impact on the document's usefulness
5. **Recommendations** — Specific, actionable edits to make. Be concrete:
   "Change 'confirmed integration' to 'claimed integration capability'" is
   useful. "Consider being more careful about integration claims" is not.

---

## Step 7: Offer to Edit

After presenting findings, offer to apply the recommended corrections directly
to the document. If the user accepts, make targeted edits — correct factual
errors, add missing information, strengthen weak sections, flag unverified
claims. Preserve the document's voice and structure; don't rewrite sections
that are fine.

---

## Principles

**Verify what matters, skip what doesn't.** Not every sentence needs a source
check. Focus on claims that inform decisions — funding, integrations,
customer references, and competitive positioning. Skip self-evident context
and widely-known facts.

**Distinguish strength of evidence.** "Confirmed by the vendor's own blog" and
"confirmed by an independent third party" are different levels of confidence.
Make this visible.

**Be specific in corrections.** "The BY integration claim is overstated" is
useful. "Some claims may need further verification" is not. Name the claim,
state what the evidence actually shows, and suggest the precise language change.

**Respect the document's purpose.** A vendor evaluation is supposed to help
the team decide whether to engage further — not to be a definitive academic
assessment. Frame findings in terms of decision impact: "This changes the risk
profile" vs. "This is technically inaccurate."

**Don't manufacture doubt.** If a claim checks out, say so and move on. The
goal is calibrated confidence, not skepticism for its own sake.
