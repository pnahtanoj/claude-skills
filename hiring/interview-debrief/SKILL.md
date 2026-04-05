---
name: interview-debrief
description: >
  Transform raw interview notes or a transcript into a structured, scored
  debrief using the project's scorecard and debrief template. Reads the
  candidate's interview notes or transcript, maps observations to rubric
  sections, assigns scores with evidence, identifies cross-section signals,
  and produces a hiring recommendation. Use this skill whenever the user
  wants to write up an interview, debrief a candidate, score an interview,
  structure their notes, or asks things like "write up the debrief for
  [name]", "score this interview", "structure my notes from the interview",
  "fill out the scorecard for [name]", "how did [name] do", or "put together
  the assessment". Also trigger when the user finishes an interview and says
  something like "okay, that's done" or "let's do the writeup". Do NOT
  trigger for comparing multiple candidates (use candidate-comparison),
  preparing questions before an interview, or creating interview frameworks
  from scratch.
---

# Interview Debrief

Turn raw interview observations into a structured, scored assessment that's
useful for hiring decisions. The output should feel like the interviewer
wrote it themselves — their observations organized and scored, not
reinterpreted.

---

## Step 1: Find the framework

Locate the scoring framework and candidate materials:

1. **Scorecard** — Find the interview scorecard or rubric that defines
   sections, weights, scoring scale, and hiring thresholds. This is the
   source of truth for what to evaluate and how.

2. **Debrief template** — Check for a debrief template that defines the
   expected output format. If one exists, use its exact structure. The
   interviewer chose that structure for a reason.

3. **Candidate materials** — Find the candidate's directory. Look for:
   - `interview-notes.md` — raw observations from the interview
   - `transcript.md` — full conversation log
   - `prep.md` — pre-interview questions and focus areas
   - `resume.md` — candidate background

Read the notes/transcript first, then the scorecard. Understanding what
happened before learning how to score it prevents anchoring on the rubric
rather than the evidence.

---

## Step 2: Map observations to sections

Go through the notes or transcript and tag each meaningful observation to
the relevant scorecard section. An observation can map to multiple sections
if it reveals signal across categories.

For each section, collect:

**What they did well** — Specific things the candidate said or did that
demonstrate competence. Quote or closely paraphrase from the notes, don't
abstract.

- **Good:** "Used ROW_NUMBER with PARTITION BY and explained why it's more
  flexible than GROUP BY + MAX for top-N queries"
- **Bad:** "Demonstrated strong SQL knowledge"

**Where they struggled** — Specific moments where the candidate was stuck,
gave a wrong answer, needed heavy prompting, or missed something important.
Include how they recovered (or didn't).

- **Good:** "Initial Python solution printed results instead of appending
  to a list. Caught the bug when prompted with 'what does this return?'
  and fixed it, but the first instinct suggests they test by eyeballing
  output rather than asserting on return values."
- **Bad:** "Had some issues with the coding exercise"

**Notable follow-up responses** — When the interviewer probed deeper, how
did the candidate respond? Did they go deeper, get stuck, or pivot? These
responses often reveal more than the initial answers.

---

## Step 3: Score each section

Assign a score using the scorecard's scale. For each section:

1. **State the score** (e.g., 3.5/5)
2. **Cite 2-3 pieces of evidence** that justify the score
3. **Explain where it sits on the scale** — why this score and not one
   higher or lower

The evidence should be specific enough that another reader could look at
the notes and agree (or disagree) with your scoring. Vague justifications
like "overall strong performance" make it impossible for the hiring team
to calibrate.

**Half-point scores are fine.** If the evidence clearly falls between two
levels on the rubric, say so. A 3.5 with clear reasoning is better than
a forced 3 or 4.

**When the notes are thin on a section**, say so explicitly rather than
guessing. "The notes don't capture enough detail on follow-up responses
to confidently distinguish between a 3 and a 4. Scored 3.5 pending
interviewer confirmation" is honest and useful.

---

## Step 4: Identify cross-section signals

Look for patterns that cut across individual sections. These are often
the most important inputs to a hiring decision because they reveal how
someone thinks, not just what they know.

Common signals to look for:

- **Asks why before jumping in** — Did the candidate clarify requirements
  or constraints before designing a solution?
- **Defaults to boring tools** — Did they reach for proven, simple
  solutions or immediately propose complex architectures?
- **Thinks about failure modes** — Did they proactively discuss what
  happens when things go wrong?
- **Talks about data quality** — Did they mention validation, testing,
  or trust in the data without being prompted?
- **Shows ownership mentality** — Did they talk about problems as things
  they'd fix vs. things that happened to them?
- **Learns from mistakes** — In failure stories, did they extract a
  principle or just describe the resolution?

Present these as a checklist with brief evidence. Don't force signals
that aren't there — a short list of real signals is more useful than a
padded one.

---

## Step 5: Calculate weighted total and check thresholds

Compute the weighted score using the scorecard's weights. Present it as
a clear table:

```
| Section          | Weight | Score | Weighted |
|------------------|--------|-------|----------|
| Problem Solving  | 25%    | 3.0   | 0.75     |
| Domain Problem   | 30%    | 4.0   | 1.20     |
| System Design    | 25%    | 4.0   | 1.00     |
| Soft Skills      | 20%    | 3.5   | 0.70     |
| **Total**        |        |       | **3.65** |
```

Then check against the scorecard's hiring thresholds:

- Does the candidate meet the bar for the target level (mid/senior)?
- Are any section scores below the minimum?
- Is the overall weighted score above the hiring threshold?

State the result plainly: "Meets the mid-level bar (3.0+). Does not meet
the senior bar (requires 4.0+ with no section below 3.0)."

---

## Step 6: Write the recommendation

State a clear recommendation using the scorecard's categories (e.g.,
Strong hire / Hire / Lean no / No hire) with a 2-3 sentence rationale.

Then add a "key considerations" section with:

- **Strongest signal for hiring:** The single most compelling thing about
  this candidate, with evidence.
- **Biggest concern:** The most important risk or gap, with context on
  how addressable it is.
- **What would change the recommendation:** What additional information
  or signal would push the recommendation up or down.

---

## Step 7: Format and present

Use the debrief template if one exists. If not, structure the output as:

1. **Header** — Candidate name, interview date, interviewer, role
2. **Section-by-section assessment** — For each section: score, what they
   did well, where they struggled, notable follow-ups
3. **Weighted score table**
4. **Cross-section signals** — Checklist with evidence
5. **Recommendation** — Category, rationale, key considerations
6. **Notes for hiring team** — 3-5 bullet points of the most important
   takeaways for whoever reads this but wasn't in the room

After presenting, remind the interviewer to review and correct the scores.
Their in-room observations take precedence. Something like:

> "This is based on my reading of your notes. Review the scores and flag
> anything that doesn't match what you observed — the notes may not capture
> everything."

---

## Principles

**Preserve the interviewer's voice.** The debrief should read like the
interviewer's own assessment, organized and scored — not like a third-party
analysis. Use the same language and framing from the notes where possible.

**Evidence over interpretation.** For every score and signal, there should
be a traceable observation from the notes. If you find yourself writing
"the candidate likely..." or "this suggests...", you're interpreting beyond
the evidence. Flag it as inference.

**Thin notes deserve honest scores.** If a section's notes are sparse,
score conservatively and flag it. A confident score from thin evidence is
worse than an honest "insufficient data" — it gives the hiring team false
precision.

**Separate what happened from what it means.** "The candidate used
isinstance() for type checking" is what happened. "This shows defensive
programming habits" is what it means. Present both, but keep them distinct
so the reader can draw their own conclusions.

**Time matters.** The best debrief is written while the interview is fresh.
Encourage the interviewer to review and correct your draft promptly. Scores
calibrated two days later against notes are less reliable than scores
assigned in the hour after the interview.
