---
name: meeting-prep
description: >
  Draft the user's sections of a recurring meeting's shared agenda doc —
  anchored in evidence from the user's actual week (git commits, new docs,
  meeting transcripts, Jira activity), with last-week's commitments
  status-checked verbatim against reality. Output is a markdown draft for
  the user to review and paste; the skill never writes to the shared doc
  itself. Use this skill whenever the user is preparing for a recurring
  meeting (L10, weekly leadership, weekly 1:1s with a standing agenda,
  recurring staff meeting, recurring stand-up review) and says things
  like "draft my shareout", "prep me for tomorrow's L10", "what should I
  show for [recurring meeting]", "help me prep for [recurring meeting]",
  "write up my section of the agenda", or asks for any pre-meeting status
  on commitments and rocks. Also trigger when the user mentions a
  recurring meeting on the calendar within the next 48 hours and is in a
  context that suggests prep — working in a repo, reviewing the week,
  scanning Granola. The forcing function is anchoring: every status
  claim must cite a commit, doc path, or meeting date, and last-week's
  to-dos must be quoted verbatim from the prior agenda or transcript so
  the user catches drift before the meeting instead of during it. Do NOT
  trigger for one-off meeting prep (no recurring agenda doc to anchor
  against), pre-call prep for an external vendor or candidate (different
  inputs), or calendar/scheduling/availability questions.
---

# Meeting Prep

Draft the user's sections of a recurring team meeting's shared agenda doc, anchored in concrete artifacts from the user's actual week. Output is a markdown draft delivered to chat (and optionally to a local prep file) for the user to review and paste into the shared doc themselves. **Never** write to the shared agenda doc directly.

## Why this skill exists

Pre-meeting agenda population is the single most reliable place AI-assisted prep produces slop. Four failure modes recur:

1. **Fabricated specificity.** Vague accomplishments dressed up with invented dates, durations, and meeting attendance: *"Day 30 presentation finalized — V1 draft reviewed with Steve 4/23 (77-minute structure alignment session)…"* No artifact, no reality.
2. **Drift on last-week's to-dos.** Items the user committed to last week get re-staged as "in progress" without checking whether anything actually moved. A commitment becomes a perpetual rolling status.
3. **Cross-ownership mistakes.** Architectural / shared items appear on the user's rocks list when they belong to someone else's, and the conflict only surfaces in the live meeting — wasting everyone's time and creating exactly the kind of friction the meeting is meant to resolve.
4. **Aspirational-to-committed drift.** *"I'd like to look into X"* from last week becomes *"I will deliver X"* this week, which then produces a slipped-status next week against a commitment the user never actually made.

The skill is a forcing function against all four. Every status claim must anchor to an artifact (commit, doc, transcript, ticket). Last-week's to-dos are quoted verbatim. Cross-ownership is checked before drafting, not during the meeting. Aspirational language stays aspirational.

## Scope

Recurring meetings only. Skip:

- One-off meeting prep — no prior agenda to reconcile against.
- External vendor / candidate / sales pre-call prep — different inputs, different output shape.
- Calendar, scheduling, availability, or invite questions.

If you're unsure whether the meeting qualifies as recurring, ask the user. The forcing function only works when there's a previous instance to anchor against.

## Workflow

The skill runs seven phases. Don't skip phases — each phase exists to catch a specific failure mode named above. Phases 1 and 2 must complete before Phase 3 begins, because reconciliation requires both inputs.

### Phase 0: Resolve config

Look for `.claude/meeting-prep.json` in the project root. Schema and example: `references/config-schema.md`.

If it exists, read it and proceed. If it doesn't exist or is missing fields needed for the request, ask the user the four questions inline:

1. Your name / role as it appears in the agenda doc (used to filter "your" sections, your git commits, and your Granola attendance).
2. The recurring meeting's identifier — title pattern, organizer, day of week.
3. Where the shared agenda doc lives (SharePoint URL or path pattern).
4. Local artifacts to inventory (which directories/files to scan for evidence — typically `docs/`, the project root, and any artifact subdirs).

After answering, offer to save to `.claude/meeting-prep.json` so future runs don't re-prompt. Don't write the config silently — confirm first.

### Phase 1: Source last week's commitments verbatim

Find the previous instance of this meeting and pull the user's to-dos from it. Use **all three** sources where available — they catch each other's gaps:

1. **Outlook** — `mcp__claude_ai_Microsoft_365__outlook_calendar_search` for the prior occurrence by title pattern. Confirms the meeting happened and gives you the date.
2. **SharePoint** — `mcp__claude_ai_Microsoft_365__sharepoint_search` then `read_resource` on the agenda doc. Many teams archive the prior 1-2 weeks inline in the same doc; if so, that's the most authoritative source for what was committed.
3. **Granola** — the previous meeting's transcript via `mcp__claude_ai_Granola__get_meeting_transcript`. Apply the `granola-tool-routing` skill's tier rules: this is **Tier 4 (contested / commitment-bearing)** because to-dos are commitments. Use `get_meeting_transcript`, not `query_granola_meetings`. The query tool's paraphrasing routinely flips commitment direction (the user's to-do becomes someone else's, or vice versa) and is not safe here.

Reconcile across the three. When sources disagree, follow the granola-tool-routing reconciliation rule: transcript > raw user notes > AI summary. The shared agenda doc is also authoritative if the team treats it that way (often the to-dos are typed in live during the meeting, making the doc and transcript equally good).

**Quote the user's to-dos verbatim.** Do not paraphrase, tighten, or "improve" the wording. The user committed to specific words; statusing against paraphrased words is statusing against a different commitment.

If a to-do says *"I'd like to look into the billing-ingest deadlock"*, the status this week is against *"I'd like to look into…"*, not against *"investigate billing deadlock"* or *"resolve billing deadlock"*. Aspirational stays aspirational.

### Phase 2: Inventory this week's evidence

Before drafting any status, build a complete evidence inventory. This is the raw material every status claim must trace back to. List your sources to the user before drafting — it gives them a chance to redirect if you're missing something.

Sources, in order:

1. **Git activity in this repo** — `git log --author="<user>" --since="<last-meeting-date>" --pretty=format:"%h %ad %s" --date=short`. Capture commit hashes and short messages.
2. **New documentation** — `git diff --name-only --diff-filter=A <last-meeting-sha>..HEAD -- docs/` (and any other directories listed in the config's artifact targets). New files often correspond to deliverables.
3. **Modified docs** — `git diff --name-only --diff-filter=M <last-meeting-sha>..HEAD -- docs/` for material edits to existing docs.
4. **Jira / Atlassian** — use the Atlassian MCP to find tickets the user created, transitioned, commented on, or logged time against in the window. JQL like `assignee = currentUser() AND updated >= "<last-meeting-date>"`.
5. **Granola — meetings this week** — `mcp__claude_ai_Granola__list_meetings` filtered to this week. For each meeting where the user was a participant and the meeting is relevant (1:1s with stakeholders, decision conversations, vendor calls, architectural discussions), pull the appropriate-tier Granola data. Apply granola-tool-routing: for prep purposes (Tier 2) `query_granola_meetings` is fine for thematic recall; for anything that will end up as evidence in the draft (a quoted commitment, a decision, a date), upgrade to `get_meetings` or `get_meeting_transcript`.
6. **Other deliverables** — ADRs, audit docs, technical assessments, vendor-comparison docs, research briefs created or substantially revised this week. Find them via the new-files diff and the artifact-target paths in config.

For deeper guidance on the evidence-inventory step (scope of what counts as evidence, how to handle ambiguous changes, what to include vs. exclude), see `references/evidence-inventory.md`.

### Phase 3: Per-to-do reconciliation

For each to-do quoted from Phase 1, classify against the inventory from Phase 2. Use exactly four classifications:

| Status | Required anchor |
|---|---|
| **Done** | Specific commit hash, doc path, ticket transition, or meeting date that completes the to-do |
| **In Progress** | Specific *substantive* advance — a commit, draft, partial deliverable, conversation held. Not "continued work on…" |
| **Slipped** | Explicitly named as slipped. Must offer a one-line cause |
| **Dropped** | Explicitly named as dropped. Must offer a one-line reason |

These are the **only** four. Do not invent intermediate statuses ("partially done", "scoped down", "pivoted"). If a to-do has split or its scope has shifted, classify the original verbatim to-do as Slipped or Dropped and surface the new version under "Proposed new To-Dos" in Phase 4. That preserves the integrity of the prior commitment.

**Placeholder activity is not advance.** A Jira ticket created with no work logged, a calendar hold for a future conversation, an empty branch — these are *intent to work*, not work. Classify the to-do as **Slipped** with a one-line cause ("bandwidth went elsewhere", "ticket created but not picked up"), not as In Progress. The "specific substantive advance" bar exists precisely to keep In Progress from drifting into "I thought about it" — once that drift starts, last-week's commitments become perpetual rolling statuses, which is exactly the failure mode this phase prevents.

A useful test: would a teammate, looking only at the artifact you cited, agree the to-do has measurably moved forward this week? If not, it's Slipped.

**Banned phrases for status updates** — do not use these:
- "substantial progress"
- "various updates"
- "several items"
- "continued work on…"
- "made good progress"
- "ongoing"
- Any claim with no date, doc path, commit ref, or named conversation

If you cannot anchor a status to a specific artifact, **mark the line "needs user confirmation"** rather than fabricating one. Missing evidence is a signal, not a problem to paper over.

### Phase 4: Draft the rest of the user's sections

Match the team's existing template — do not impose your own. Phase 1 already pulled the agenda doc; reuse its structure. Common section names (vary by team):

- **Last Week's To-Dos** — output of Phase 3
- **Roadmap Rocks** — per rock, list due date, status, and a one-line update with anchor
- **Team Headlines** — Breakthroughs / Good news / Fires (or whatever subheads the team uses)
- **IDS candidates** — Issues to discuss; see structure below
- **Proposed new To-Dos** — with concrete dates

For template detection guidance and how to handle teams that don't use EOS-style sections, see `references/output-template.md`.

#### IDS framing structure

Don't surface an issue as IDS unless it's structured for resolution. The discipline is:

- **Decision needed**: a one-sentence question that names what has to be decided.
- **Options**: A / B / C with one-line characterizations and the tradeoff each entails.
- **Open Qs**: 2–4 specific questions that gate the decision. Vague questions ("what should we do?") don't gate anything.

If the user has a blocker but it isn't structured this way, it's a **Fire** in Team Headlines, not an IDS. The point of IDS is that the meeting can resolve it; loose blockers waste the slot.

#### Roadmap Rocks updates

Each Rock entry needs:
- Due date (from the agenda doc; carry through unchanged unless the user has moved it)
- Status (On track / At risk / Off track)
- One-line update with at least one anchor (commit, doc, meeting date)

Status downgrades (On track → At risk, At risk → Off track) need a one-line cause. Status upgrades just need the anchor.

#### Volume discipline

The meeting is finite — typically 60 minutes. If the user has 12 candidate items across IDS and Headlines, force prioritization to 5–7. Surface the cut items at the bottom under "**Cut for time** (carry to next week or async)" so the user sees what was set aside and can override.

#### Empty sections

If a sub-section has nothing to report — no Breakthroughs, no Fires, no IDS this week, no items to cut — **omit the heading entirely**. Don't emit "Breakthroughs: Nothing this week" or "Cut for time: None this week". Empty placeholders read as padding and waste the reader's eye, which the team meeting can't afford. The exception: if the team's template *requires* the section (their archived prior weeks always include it even when empty), match the template — but use a single em-dash or "—" rather than narrating the absence.

### Phase 5: Cross-ownership check

Before output, walk through every Roadmap Rock, IDS candidate, and Proposed new To-Do you've drafted. For each:

1. **Is this item architectural or shared-ownership?** (e.g., billing architecture, data platform, identity, payments, cross-team infra, anything that touches another team's domain.)
2. **If yes, has the user synced with the actual owner this week?** Check Granola list_meetings for 1:1s with the owner. Check git for shared-doc edits where both have committed. Check Jira for shared tickets.
3. **If a sync is missing or the rock-level update belongs to someone else**, surface that — but in the **chat block only**, not in the paste-ready markdown.

The flag goes in the chat block (see Phase 7) because:
- It's a warning *to the user* about what to fix before the meeting, not a line for the agenda doc.
- Pasting "⚠ Cross-ownership flag — this is Alex's rock" into the SharePoint doc makes the user look like they're publicly calling out their teammate. Not the goal.
- The paste-ready markdown should simply *omit* the rock or item that belongs to someone else, not include a flagged version of it.

**Flag format — strict two-line cap.** A flag is a warning, not a memo:

- **Line 1:** what's flagged and why (one short sentence — the rock/owner and the sync gap).
- **Line 2:** suggested action (one short sentence — sync with X, or leave to X).

Example:
> ⚠ **billing-architecture rock** is Alex's; no sync visible this week. Suggest a 5-min ping to Alex before the meeting, or leave the rock-level update to him.

Don't expand to multi-paragraph context, don't quote prior incidents at length, don't itemize all the reasons the flag matters. The user already knows the team dynamics; the flag's job is to surface the gap and propose an action, not to teach.

This is the single highest-value check the skill performs. Cross-ownership surprises in the live meeting are exactly the failure mode the skill exists to prevent.

### Phase 6: Anti-slop pass

Before output, run the draft through the anti-slop checklist. Full checklist: `references/anti-slop-checklist.md`. The headline rules:

- **Every status claim has a date, doc path, commit ref, or meeting reference.** Strip claims that don't.
- **No three-point parallel-structure paragraphs** unless the underlying thing is genuinely three-fold. AI-generated prep is biased toward triples; team-meeting prep is rarely actually three-fold.
- **Em-dash budget**: 1–2 per section maximum. Em-dashes are a tell. Use commas, periods, or restructure.
- **Banned phrases**: strip "I meticulously…", "I successfully…", "comprehensive", "robust", "leveraged", "facilitated discussions around…", "spearheaded", "proactively", "thoughtfully".
- **Pronoun discipline**: don't use "we" for things only the user did. Don't use "I" for team commitments. If you find yourself writing "we delivered X" and only the user touched it, switch to "I delivered X" — and vice versa.
- **No upgrading aspirational language**. *"I'd like to"* from last week stays *"I'd like to"* this week.

If a sentence reads like a LinkedIn post, rewrite it as a status line.

### Phase 7: Output

The output has **two clearly separated parts**: a chat block (context, flags, things the user should know) and the paste-ready markdown (what they copy into the SharePoint doc).

This separation matters. The user is going to copy something into a shared doc that their team will read. If the chat preamble, cross-ownership flags, or evidence-inventory summary land in that copy, the user has to manually trim before pasting — or worse, paste it as-is and look unpolished in front of teammates. The skill does this trimming work upfront.

**Format:**

```
## Chat block (for the user, not for the agenda doc)

Draft for [meeting name] on [date], anchored in [N commits / M docs / K Granola transcripts].

[Only what's actionable. Include only the sub-sections that have content — drop the heading entirely if there's nothing to say:
 - Cross-ownership flags (two-line format from Phase 5; only if any fired)
 - Items marked "needs user confirmation" (only if any exist)
 - Items cut for volume discipline (only if any cut)
 - Notes on classification edge cases (only if a status decision was non-obvious)]

---

## Paste-ready markdown (copy below this line into the agenda doc)

[The user's sections, matching the team's template, no preamble, no flags, no metadata.]
```

The horizontal rule and the explicit "copy below this line" make the boundary unambiguous. The user shouldn't have to think about what to include and what to leave behind.

**The chat block follows the same anti-padding rule as the paste-ready markdown.** If nothing was cut for volume, omit the "Items cut" sub-heading — don't write "Items cut: None this week." If everything is anchored, omit the "needs user confirmation" sub-heading. Empty sub-headings in the chat block are the same anti-pattern as empty sub-headings in the paste-ready: they signal padding, slow the user down, and add nothing.

**Don't enumerate absent items.** If Priya's data-platform rock and Marco's Day-30 rock aren't in the paste-ready because they aren't the user's, *don't* list them in the chat block as "rocks not in the paste-ready (and why)". The user knows what's theirs. Only surface a non-Jonathan rock in the chat block if there's a real cross-ownership concern (Phase 5 flagged it). Otherwise, silence is the right answer — the absence is self-explanatory.

Offer to save just the paste-ready portion to a local file (typical: `meeting-prep/<YYYY-MM-DD>-<meeting-slug>.md` in the project root, or wherever the config specifies). Wait for confirmation before saving. The chat block stays in chat — it's session-ephemeral.

**Never write to the SharePoint agenda doc.** Never edit upstream artifacts. Never send messages to teammates. Never create Jira tickets. Those are separate workflows the user runs after reviewing the draft.

## Anti-patterns

These are the failure modes to actively reject, not just avoid:

- **Don't fabricate specificity.** No invented durations, attendee counts, or session lengths. If the meeting was 30 minutes, don't write "77-minute alignment session". If you don't know, don't claim.
- **Don't paraphrase last week's to-dos.** Quote verbatim. The user committed to specific words.
- **Don't upgrade aspirational language.** "I'd like to" / "we should consider" / "I want to explore" never become commitments without the user's explicit acknowledgement.
- **Don't pad to fill the template.** If a sub-section has nothing real to report, omit the heading. Don't write "Breakthroughs: Nothing this week" — that's just padding with extra steps.
- **Don't claim work happened that you can't anchor.** If evidence is missing, flag "needs user confirmation" — don't paper over with "various updates".
- **Don't surface architectural items cold.** Apply the cross-ownership check (Phase 5) before output, not after the user pastes into the doc.
- **Don't impose a template.** Match the team's. If they don't use IDS, don't add an IDS section.
- **Don't over-include.** 5–7 items, not 12. The meeting is 60 minutes.

## Defers to other skills

This skill explicitly does **not** redefine logic owned by other skills:

- **`granola-tool-routing`** — for any Granola MCP call, follow that skill's tier rules. This skill's Phase 1 transcript pull is Tier 4 (commitment-bearing); Phase 2's meeting inventory is Tier 2 unless content will be quoted in the draft, in which case upgrade to Tier 3. Don't redefine the rules; consult the other skill.
- **`context-handoff`** — if the user wants to capture the prep session itself for handoff, that's a different skill.
- Skills for *acting on* the draft (writing to SharePoint, creating Jira tickets, sending messages) — out of scope. The user invokes those after reviewing the draft.

## References

- `references/anti-slop-checklist.md` — full checklist applied in Phase 6, including the banned-phrase list and the em-dash / parallel-structure rules.
- `references/config-schema.md` — `.claude/meeting-prep.json` schema, example, and migration notes.
- `references/evidence-inventory.md` — deeper guidance on Phase 2: what counts as evidence, how to handle ambiguous activity, what to exclude.
- `references/output-template.md` — template detection, common variants (EOS L10, weekly leadership, custom), how to handle teams without standardized agendas.
