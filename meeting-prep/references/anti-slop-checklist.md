# Anti-Slop Checklist

Apply this in Phase 6, after the draft is complete and before output to chat. Each rule has a why — the rule itself is downstream of a specific failure mode. Skip rules that don't apply, but don't skip the pass.

## Why a checklist

LLM-generated meeting prep has a recognizable signature: confident specificity layered over generic structure, paraphrased commitments, and triple-pattern paragraphs that imply more thought than was actually applied. The user's teammates can feel this signature and it erodes trust in the prep — even when the underlying status is accurate. The checklist exists to strip the signature.

## The rules

### 1. Every status claim has an anchor

Any line that asserts something happened must point to one of:
- Commit hash (`a1b2c3d`)
- Doc path (`docs/architecture/billing-ingest-design.md`)
- Meeting date and counterpart (`1:1 with Steve, 2026-04-23`)
- Jira ticket key (`PE-142`)
- Decision artifact (`ADR-007`)

If a line cannot point to one of these, either anchor it or replace with `[needs user confirmation]`. Do not write status claims with no anchor.

### 2. No fabricated specificity

Specificity is a marker of authenticity — but only when it's true. Fabricated specificity (made-up durations, attendee counts, session lengths, percentages) is the highest-trust-erosion failure mode this skill prevents.

Strip these unless an artifact backs them up:
- Meeting durations (*"77-minute alignment session"*)
- Attendee counts (*"reviewed with the four engineering leads"*)
- Round numbers that read as estimates (*"approximately 80% complete"*)
- Compound qualifiers (*"thoroughly aligned and validated"*)

If you don't have the artifact, say less.

### 3. Em-dash budget

Limit to 1–2 em-dashes per section. Em-dashes are a recognizable LLM tell — especially in contexts where the user normally writes plainly. Most em-dashes can be replaced with a comma, a period, or a restructure.

Test: read the section aloud. If it sounds like a LinkedIn post, the dashes are part of the problem.

### 4. No three-point parallel structure unless genuinely three-fold

LLM prose is biased toward triples ("aligned, validated, and committed"; "scope, sequencing, and dependencies"; "the strategy, the execution, and the metrics"). Real status updates are rarely actually three-fold.

If you find yourself writing a triple, ask: was the underlying thing actually three things, or did I land on three because three sounds complete? If it was two, write two. If it was four, write four. If it was a list, use bullets.

### 5. Banned phrases — strip on sight

These are the LinkedIn-isms and AI-hallucinated qualifiers that signal slop:

- "I meticulously…" / "meticulously crafted"
- "I successfully…" / "successfully delivered"
- "comprehensive" / "comprehensively"
- "robust" (especially "robust solution")
- "leveraged" (just say "used")
- "facilitated discussions around…"
- "spearheaded"
- "proactively" (especially "proactively addressed")
- "thoughtfully" / "carefully considered"
- "deep dive" (as a noun)
- "alignment session" (unless it was specifically called that)
- "structured approach"
- "in collaboration with…" (as a way of vague-attributing)
- "across the organization"
- "drove forward" / "drove alignment"
- "key stakeholders" (name them)
- "high-impact" / "high-value"
- "strategic" (as a generic adjective)
- "synergies"
- "best practices" (cite the practice instead)

This list is not exhaustive. The pattern: any word whose presence implies effort or quality without describing what specifically happened. Replace with the specific thing.

### 6. Pronoun discipline

- **"I" for things only the user did.** Don't write *"we delivered the audit"* if only the user touched it.
- **"We" for team commitments and shared work.** Don't write *"I aligned the team on the migration"* if it was a group decision.
- **Name the person** when something hinged on a specific other person. *"Resolved with Steve, 2026-04-22"* beats *"resolved through stakeholder alignment"*.

If the user's name is in the agenda template (e.g., "Jonathan's update"), the bullets within that section default to "I" — readers know whose section it is.

### 7. No upgrading aspirational language

If last week's to-do said *"I'd like to look into X"*, this week's status is against *"I'd like to look into X"*, not against *"I will deliver X"* or *"investigate X by [date]"*. The user committed to specific words; statusing against different words is statusing against a different commitment.

If the user wants to upgrade an aspirational item to a real commitment, that belongs under "Proposed new To-Dos" with an explicit date — not silently in the status update.

### 8. No padding to fill the template

If a sub-section has nothing real to report — no Breakthroughs, no Fires, no IDS this week — **omit the heading entirely**. Don't emit "Breakthroughs: Nothing this week" or "No new IDS this week" as bullet content. Empty placeholders are padding with extra steps.

The opposite — inventing a Headline, manufacturing an IDS, padding a Rocks update — wastes meeting time and erodes trust. Better to look thin one week than to bloat every week.

The exception: if the team's template requires the section even when empty (you can tell from prior weeks always including it), match the template — but use a single em-dash or "—" rather than narrating the absence.

### 9. The cut list goes in the chat block

If you cut items to keep the meeting to 5–7 priorities, the cut items appear in the **chat block** with a one-line reason each — not in the paste-ready markdown. The user can decide to override; if they do, they ask you to add an item back. The cut list isn't agenda-doc content.

### 10. Cross-ownership flags go in the chat block, not the paste-ready markdown

If Phase 5 produced cross-ownership flags, they appear in the chat block as warnings to the user, with a one-line suggested action. The paste-ready markdown should *omit* the cross-owned item entirely, not include a flagged version of it.

Pasting "⚠ this is Alex's rock" into the shared doc looks like calling out a teammate publicly. The flag is a warning *to the user* about what to fix before the meeting (sync with Alex, or just leave the update to him), not a line for the agenda.

## Quick self-test before output

Read the draft once more. For each section, ask:

1. Could a teammate verify every status claim by clicking a link or opening a file?
2. Did I use any banned phrase from rule 5?
3. Are there more than 2 em-dashes in any section?
4. Did I quote last week's to-dos verbatim, or did I "improve" the wording?
5. Are there any cross-ownership items without a flag?
6. Did I invent specificity I can't anchor?

If yes to any, fix and re-read.
