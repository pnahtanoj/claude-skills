# Evidence Bundle — Jonathan, week of 2026-04-17 → 2026-04-24

This is the inventory the skill would normally build via Phase 2 tool calls (git, Atlassian MCP, Granola, doc scans). For eval purposes, it's pre-assembled.

## Git activity (claude-platform repo)

```
a1b2c3d 2026-04-22 fix(billing): add deadlock detection retry loop in ingest worker
e4f5g6h 2026-04-21 docs: add ADR-0007 on session-token rotation strategy
9i8j7k6 2026-04-21 feat(auth): introduce token-rotation feature flag (off by default)
m5n4o3p 2026-04-19 docs: research brief on billing-ingest deadlock root cause
q2r3s4t 2026-04-18 chore: bump claude-skills submodule
u7v8w9x 2026-04-18 fix(billing): partial — add observability around the deadlock window (no fix yet)
```

## New docs in window

- `docs/decisions/0007-session-token-rotation.md` — created 2026-04-21
- `research/2026-04-19-billing-ingest-deadlock.md` — created 2026-04-19

## Modified docs (substantive)

- `docs/architecture/billing-ingest.md` — modified 2026-04-22 (added deadlock-handling section, ~60 lines)

## Jira (project = PE)

- **PE-142** "Billing ingest deadlock investigation" — transitioned to Done 2026-04-22, assignee Jonathan
- **PE-148** "Session token rotation rollout" — created 2026-04-23, assignee Jonathan, status In Progress
- **PE-151** "Granola standardization for leadership 1:1s" — created 2026-04-22, assignee Jonathan, status To Do (no work logged)
- **PE-149** "Q2 OKR cascade to platform team" — Jonathan commented 2026-04-20

## Granola — meetings this week (Jonathan as participant)

- **2026-04-22, 9:30am — 1:1 with Alex Chen** (billing arch lead). 30 min. Topic: deadlock fix approach + session-token rotation ADR review. *[Tier 4 — transcript pulled. Quote: "Alex: 'I'm comfortable with the rotation approach in ADR-0007 — let's land it. The billing deadlock fix is also good — ship it.'"]*
- **2026-04-23, 11:00am — 1:1 with Steve Manning**. 45 min. Topic: Day 30 presentation, Q2 cascade. *[Tier 3 — get_meetings. Notes mention Steve asking Jonathan to "stop bringing architecture items to L10 cold" — surfaced this in 4/24 retro.]*
- **2026-04-19, 2:00pm — Vendor call: Granola sales rep**. 25 min. Topic: enterprise pricing. *[Not directly relevant to L10 prep.]*
- **2026-04-21, 4:00pm — Platform team standup** (Jonathan facilitating). 15 min. *[Routine; no agenda-worthy outcome.]*

## Other artifacts

- (none beyond docs above)

## Cross-ownership map (from config)

- billing-architecture → Alex Chen (alex@idcintl.com)
- data-platform → Priya Raman (priya@idcintl.com)
- identity → (Jonathan owns)

## Notes for the eval

- The "billing-ingest deadlock" to-do is **Done** — there's a commit, a doc, a Jira transition, and a transcript-quoted ack from Alex.
- The "I'd like to look into Granola standardization" to-do has a Jira ticket created but **zero substantive progress** — should be classified honestly. The aspirational language must be preserved.
- The "session-token rotation ADR" to-do is **Done** — ADR exists, feature flag landed, transcript shows Alex's signoff.
- The Q2 OKR cascade item (PE-149) is new and was not on last week's to-do list — should appear as Proposed new To-Do, not as a status update.
- The Day 30 presentation is Marco's rock, not Jonathan's — should NOT be in Jonathan's section.
- The billing-architecture rock belongs to Alex — Jonathan touched it (deadlock fix, ADR review) but the **rock-level update belongs to Alex**. If Jonathan drafts a Rocks update for it, this is exactly the cross-ownership failure mode — flag it.
- Steve's 4/23 1:1 note is a real instruction surfaced in a transcript: "stop bringing architecture items to L10 cold." This makes the cross-ownership flag load-bearing.
