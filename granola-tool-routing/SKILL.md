---
name: granola-tool-routing
description: >
  Route Granola MCP tool calls to the right fidelity tier based on what's
  being produced — ephemeral Q&A, meeting prep, persistent artifact, or
  contested/quotable material. Use this skill whenever about to call any
  Granola MCP tool (`list_meetings`, `query_granola_meetings`, `get_meetings`,
  `get_meeting_transcript`), whenever the user asks for meeting notes, a
  debrief, a transcript, a stakeholder writeup, or a post-meeting summary,
  and whenever writing to paths matching `*/meeting-notes/*` or similar
  persistent-artifact locations. The common failure is defaulting to
  `query_granola_meetings` because its output pastes cleanly — fine for
  conversational Q&A, wrong for anything persisted, quoted, or load-bearing
  for attribution. Encodes the tier rules, a source-reconciliation rule
  (transcript > raw notes > AI summary), attribution conventions, and a
  pre-call checklist. Do NOT trigger for generic conversation that merely
  mentions a meeting in passing, for calendar scheduling, or for availability
  and invite questions.
---

# Granola Tool Routing

Claude Code exposes four Granola MCP tools at very different fidelity. Picking the wrong one quietly corrupts persistent artifacts and propagates errors downstream.

## The four tools

| Tool | Returns |
|---|---|
| `mcp__claude_ai_Granola__list_meetings` | Metadata + IDs only (meeting finder / index) |
| `mcp__claude_ai_Granola__query_granola_meetings` | AI-summarised natural-language answer with citations |
| `mcp__claude_ai_Granola__get_meetings` | Raw user notes + AI summary + metadata for specific IDs |
| `mcp__claude_ai_Granola__get_meeting_transcript` | Verbatim transcript |

## Why this matters

`query_granola_meetings` returns a paraphrase. Paraphrases lose direction on commitments (the user's own to-do becomes a vendor commitment, or vice versa), resurface a past ask as a fresh agreement, and assign actions to the wrong participant with high confidence. Its output pastes cleanly, which makes it the path of least resistance and the single most common source of bad persistent notes.

**Concrete failure pattern (2026-04-22).** A 30-minute vendor meeting written up with `query_granola_meetings` into a persistent notes file. The AI summary framed two of the user's own action items as vendor commitments — a file lookup that was the user's, and a past request reframed as a fresh vendor agreement. The errors propagated into an ADR, a research brief, and a project-state doc before being caught by re-running with `get_meetings` + `get_meeting_transcript`. Every derived artifact had to be corrected.

Treat this pattern as the reason for every rule below.

## Tier rules

Pick the tier by what's being produced, not by how clean the output looks.

| Tier | Example | Tools |
|---|---|---|
| 1 — Ephemeral Q&A | "What did Steve say about X last week?" | `query_granola_meetings` |
| 2 — Pre-meeting prep | "Help me prep for tomorrow's Brian meeting" | `query_granola_meetings` + selective `get_meetings` if attribution matters |
| 3 — Persistent artifact | Writing to `meeting-notes/`, an ADR, a research brief, project-state docs, audit trails | `get_meetings` + `get_meeting_transcript` (query optional as index) |
| 4 — Contested / commitment-bearing / quotable | Who committed to what, disputed claims, verbatim quotes, anything that could be argued over later | `get_meeting_transcript` mandatory |

Use `list_meetings` as a pre-step in any tier when the meeting ID isn't already known.

If a prompt spans tiers (e.g., "prep me for tomorrow and append the outcome of last week's meeting to PROJECT.md"), split it: Tier 2 for the prep portion, Tier 3/4 for the artifact write.

## Reconciliation rule

When sources disagree, trust in this order:

1. **Transcript** — authoritative for quotes, attribution, commitments, and anything contested
2. **Raw user notes** (from `get_meetings`) — authoritative for the user's editorial framing: what they chose to emphasise, how they phrased a takeaway
3. **AI summary** — lowest-confidence. Useful as an index and a starting draft; not evidence

Never treat an AI-summary claim as authoritative when a transcript is available. If the transcript contradicts the summary, correct the artifact and flag the discrepancy to the user.

## Attribution conventions

- **Direct quotes** — transcript only. Never quote from the AI summary; its paraphrasing is lossy.
- **Participant-level commitments** ("X agreed to do Y by Z") — verify against transcript. This is the highest-impact failure mode.
- **Meeting-level themes** ("this was mostly about the migration strategy") — can come from the AI summary, but cross-check against the raw notes before writing them into a persistent artifact.
- **Numbers, dates, names, system identifiers, file paths** — verify against transcript or raw notes. AI summaries routinely round, paraphrase, or infer these.

## Pre-call checklist

Before calling any Granola tool, answer three questions:

1. **What is being produced?** Conversational reply, prep notes, a persisted file, or a contested/quotable artifact?
2. **Does attribution matter?** Will anyone care later who said or committed to what?
3. **Will the output be persisted?** Does it land in a file, a ticket, an ADR, or any other Claude-readable document that later work will build on?

Map the answers to the tier table. When uncertain, move up one tier — a transcript call is far cheaper than propagating a paraphrase error across downstream artifacts.

## Rules

- Never use `query_granola_meetings` as the sole source for a persistent artifact.
- Never quote from the AI summary. Quotes come from transcript only.
- When attribution is load-bearing, call `get_meeting_transcript` even if `get_meetings` looks sufficient — raw user notes can be terse enough to obscure who said what.
- If writing to any path matching `*/meeting-notes/*`, treat as Tier 3 minimum regardless of how the prompt was phrased.
- When the user pushes back on an attribution or commitment claim sourced from `query` or `get_meetings`, do not argue — re-run with transcript and reconcile.
- State the tier and tool choice briefly before calling, so the user can redirect if the fidelity is wrong for the task.
