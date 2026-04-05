---
name: candidate-comparison
description: >
  Compare multiple interview candidates side-by-side using a structured
  scorecard methodology. Reads candidate interview notes, applies a weighted
  rubric, produces a normalized comparison with head-to-head analysis, flags
  scoring inconsistencies, and surfaces hiring signals that might be missed in
  individual reviews. Use this skill whenever the user wants to compare
  candidates, rank interviewees, decide between finalists, check for scoring
  drift, or asks things like "compare the candidates", "who should we hire",
  "how do they stack up", "rank the candidates", "which candidate is stronger",
  or "put together a comparative assessment". Also trigger when the user has
  finished multiple interviews and wants to synthesize findings. Do NOT trigger
  for preparing for a single interview (that's just prep work), writing up notes
  from a single interview (use interview-debrief), or general hiring strategy
  questions.
---

# Candidate Comparison

Produce a structured, fair comparison of interview candidates that helps the
hiring team make a confident decision. The output is always a draft for human
review — never a final verdict.

---

## Step 1: Find the materials

Locate the interview framework and candidate data:

1. **Scorecard / rubric** — Look for an interview scorecard, rubric, or
   evaluation criteria file. Common locations: `interview-scorecard.md`,
   `scorecard.md`, `rubric.md`, or similar in the project root or a docs
   directory. This defines the sections, weights, and scoring scale.

2. **Candidate directories** — Look for a `candidates/` directory or similar
   containing per-candidate subdirectories. Each candidate should have
   interview notes, a debrief, or scored assessment.

3. **Existing assessments** — Check if there are prior comparative assessments
   to understand the format the user expects and any corrections they've made
   to previous drafts. Previous corrections are gold — they reveal where your
   default judgment diverges from the interviewer's and you should calibrate
   accordingly.

If you can't find a scorecard, ask the user what criteria matter and what
weights to use. Don't invent a rubric — the whole point is consistency with
the team's actual evaluation framework.

---

## Step 2: Extract scores and signals per candidate

For each candidate, read their interview notes and/or debrief. Extract:

### Scores by section

Map each section from the scorecard to the candidate's performance. Use the
scorecard's scale (typically 1-5) and weight each section as specified.

If the candidate's notes contain explicit scores, use those. If they contain
narrative only, derive scores from the evidence — but flag them as
"inferred from notes" so the reviewer knows they weren't directly observed
scores.

**Resist score inflation.** A 5 means "exceptional — beyond senior
expectations" and should be rare. Most strong candidates land in the
3.5-4.5 range. Before assigning a 5, ask: did the candidate do something
that genuinely surprised the interviewer, or were they just solid? Use
half-point scores (3.5, 4.5) when the evidence falls between levels —
a 4.5 with clear reasoning is more useful than a rounded 5 that
compresses the scale and makes candidates harder to differentiate.

### Key signals

For each candidate, pull out the 3-5 most important signals — things that
differentiate them from a generic "qualified candidate." These should be
specific and evidenced, not generic praise:

- **Good:** "Volunteered ROW_NUMBER alternative with tradeoff analysis
  unprompted" or "Hit edge case in production migration, rolled back cleanly,
  escalated appropriately"
- **Bad:** "Strong SQL skills" or "Good communicator"

### Concerns

Note specific risks or red flags with context. A concern without context is
unfair to the candidate:

- **Good:** "Three sub-2-year tenures — could indicate pattern, but each move
  had a clear rationale (acquisition, layoff, role mismatch)"
- **Bad:** "Job hopper"

---

## Step 3: Normalize and compare

### Weighted score table

Present a table with each section score, weight, and weighted total per
candidate:

```
| Section          | Weight | Candidate A | Candidate B |
|------------------|--------|-------------|-------------|
| Problem Solving  | 25%    | 3.0         | 3.0         |
| Domain Problem   | 30%    | 4.0         | 4.5         |
| System Design    | 25%    | 4.0         | 4.0         |
| Soft Skills      | 20%    | 3.5         | 4.0         |
| **Weighted Total** |      | **3.65**    | **3.90**    |
```

### Head-to-head dimensions

Go beyond the scorecard sections. Compare candidates on dimensions that
matter for the specific role but aren't captured in a single rubric score:

- Hands-on coding ability vs. architectural thinking
- Relevant platform experience (e.g., Azure vs. AWS)
- Scale of prior work
- Communication style and clarity
- Greenfield vs. brownfield fit
- Biggest concern for each

Present this as a compact table with one row per dimension and a brief
(5-10 word) characterization per candidate. Don't pad with dimensions where
both candidates are equivalent — focus on where they differ.

### Threshold check

Apply the scorecard's hiring thresholds (if defined) to each candidate:

- Does each candidate meet the bar for the target level?
- Are there any section scores below the minimum threshold?
- If borderline, say so explicitly rather than rounding up.

---

## Step 4: Check for scoring drift

This is the step that justifies having a skill rather than doing this
freehand. Look for inconsistencies in how the same behaviors were scored
across candidates:

- **Same answer, different score?** If two candidates gave similar-quality
  responses to the same question but one scored higher, flag it with the
  specific evidence from each.

- **Halo/horn effects?** If a candidate who impressed in one area received
  uniformly high scores across all areas (even where the notes don't support
  it), note the pattern.

- **Shared weaknesses treated differently?** If both candidates showed the
  same limitation (e.g., "vibe coding" tendency) but it was penalized for
  one and not the other, call it out.

- **Recency bias?** If the second candidate interviewed consistently scored
  higher or lower than the first with similar evidence, flag the pattern.

Present drift observations neutrally — they're calibration checks, not
accusations. Frame them as: "These scores may warrant a second look because..."

---

## Step 5: Present the assessment

Structure the output as:

### 1. Individual summaries (one paragraph each)

For each candidate: weighted score, 2-3 standout strengths, 1-2 concerns,
and where they sit relative to the hiring bar. Keep it tight — the detail
is in the tables.

### 2. Weighted score table

As described in Step 3.

### 3. Head-to-head comparison table

As described in Step 3.

### 4. Scoring consistency notes

Any drift observations from Step 4. If no issues found, say so — that's
useful information too.

### 5. Recommendation

State your recommendation clearly, then immediately qualify it:

> "Based on the scores and signals, Candidate B is the stronger match for
> this role. However, this assessment is based on my reading of your notes —
> you were in the room and may have observed signals that aren't captured
> here. Review the scoring consistency notes above and adjust if needed."

Always frame the recommendation as a draft. The interviewer's in-room
observations override any analysis of their notes.

### 6. Decision-relevant questions

End with 2-3 questions that would help sharpen the decision. These should
be things the data can't answer:

- "How much does Azure experience matter for the first 6 months vs.
  the longer term?"
- "Is the tenure pattern a real risk given the team's timeline?"
- "Would either candidate's communication style be a friction point with
  the existing team?"

---

## Principles

**The interviewer was in the room. You weren't.** Notes are lossy. A
candidate who "struggled" in the notes might have recovered brilliantly in
a way that wasn't written down. Always present your analysis as a reading
of the notes, not as ground truth about the candidate.

**Fair comparison requires consistent criteria.** The single most valuable
thing this skill does is check whether the same rubric was applied
consistently across candidates. Lean into this — it's the thing humans
are worst at and care most about getting right.

**Specific over general.** "Strong architectural thinker" is useless.
"Volunteered medallion architecture with clear Bronze/Silver/Gold
separation and addressed cross-source timing at the Gold layer" is useful.
Every claim about a candidate should be traceable to something in their
notes.

**Name the tradeoff, don't hide it.** If one candidate is stronger on
architecture but weaker on coding, say that plainly. Don't average away
the signal. The hiring team needs to decide which dimension matters more
for this role at this time.

**Previous corrections are calibration data.** If the user has corrected
a prior comparative assessment, those corrections tell you where your
default judgment is miscalibrated. Read them carefully and adjust.
