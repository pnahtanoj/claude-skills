# Evidence Inventory — Phase 2 Deep Dive

Phase 2 of the workflow. The point of the inventory is that every status claim in the draft must trace back to something in the inventory. Skipping or thinning Phase 2 is the most common cause of slop output, because the model has nothing to anchor against and falls back to plausible-sounding paraphrase.

## Window

The inventory window is **last meeting date → now**. Get the last meeting date from Phase 1's Outlook search. If you don't have it, ask the user — don't guess "last week".

## Sources, in order of authority

### 1. Git activity

Primary command:

```bash
git log --author="<git_author>" --since="<last-meeting-date>" --pretty=format:"%h %ad %s" --date=short
```

Capture: commit hashes, dates, and short messages. Don't include diffs in the inventory — the messages are enough to reason from. If a status claim depends on what specifically a commit changed, look up that commit's diff at draft time, not during inventory.

For new docs:

```bash
git log --author="<git_author>" --since="<last-meeting-date>" --diff-filter=A --name-only --pretty=format:"%h %s" -- docs/ research/ docs/decisions/
```

For substantially modified docs (> ~20 lines added):

```bash
git log --author="<git_author>" --since="<last-meeting-date>" --numstat --pretty=format:"%h %s" -- docs/ research/ | awk 'NF==3 && $1+$2 > 20 { print }'
```

Repos to scan come from `evidence.repos` in config. If empty, default to `.`.

### 2. New documentation files

Beyond commit-level git activity, scan for new files in artifact directories. These are often the most visible deliverables — ADRs, audit reports, vendor comparisons, technical assessments.

For each new doc, capture:
- Path
- One-line subject (first heading)
- Date created (from git history)

Don't read the full doc into the inventory — just the path is enough. The draft can quote the path; readers click through.

### 3. Jira / Atlassian

Use the Atlassian MCP to find the user's ticket activity. JQL pattern:

```
assignee = currentUser() AND updated >= "<last-meeting-date>"
```

Plus any extra constraint from `evidence.jira_jql_extra` (typically a project filter like `AND project = PE`).

Capture for each ticket:
- Key (PE-142)
- Status transition (if any) within the window
- One-line summary

Tickets transitioned to Done within the window are anchors for "Done" to-do statuses. Tickets created or commented on are weaker anchors — useful as evidence but not as completion proof.

### 4. Granola — meetings this week

Apply granola-tool-routing tier rules.

Step 1: `mcp__claude_ai_Granola__list_meetings` filtered to the window. Filter to meetings where the user is a participant (use `granola_email` from config).

Step 2: For each meeting, decide if it's relevant to the prep:
- 1:1s with named stakeholders, especially shared-ownership counterparts (cross-reference `cross_ownership.shared_owners`).
- Decision conversations on architectural items.
- Vendor calls, candidate interviews, customer calls (relevant if their outcomes feed any to-do or rock).
- Recurring meeting itself (don't include — it's the input, not evidence of progress).

For relevant meetings, choose the right Granola tool by what you'll do with it:
- **Just need to know it happened?** `list_meetings` is enough. Title + date suffices as anchor.
- **Need a thematic recall ("what came up about billing")?** Tier 2 — `query_granola_meetings` is fine.
- **Will quote a commitment, decision, or specific phrase?** Tier 3+ — `get_meetings` or `get_meeting_transcript`. Especially for cross-ownership claims ("synced with Alex on billing-arch on 2026-04-22") — these are commitment-bearing and need transcript-level fidelity.

### 5. Other deliverables

Things that don't fit the above but matter:
- ADRs in `docs/decisions/` (already covered by new-doc scan, but worth flagging separately)
- Vendor-comparison docs in `research/`
- Discovery docs created or revised
- Spike findings
- External writeups (memos, briefs, board updates)

These usually appear in the new-files scan; surface them separately because they tend to be the most agenda-worthy items.

## What to exclude

- **Branches without commits.** The user may have branches in flight that have no commits in the window — those aren't evidence of progress.
- **Drafts that haven't been shared.** A doc that exists locally but hasn't been committed isn't evidence either.
- **Meetings the user attended but didn't drive.** A 30-person all-hands isn't evidence of the user's progress on anything specific.
- **Calendar holds, focus blocks, blocked time.** Not evidence of anything done.
- **Reviews / approvals on others' work** — these are weak evidence; only include if directly relevant to a to-do or rock.

## How to handle ambiguous activity

When something might be evidence and might not:

- **Commit message is generic ("wip", "updates", "more changes")**: don't use it as an anchor unless you've also looked at the diff and know what it changed. A "wip" commit on the right file can be a real anchor; a "wip" commit on tooling probably isn't.
- **Doc was edited but you can't tell what changed substantively**: get the diff. If it's a typo fix or formatting, exclude. If it's content, include.
- **Meeting happened but you're not sure of the outcome**: pull the transcript. Don't assume.

## Output of Phase 2

A structured inventory the model can scan during Phase 3. Format:

```
## Evidence inventory (window: 2026-04-17 → 2026-04-24)

### Git
- a1b2c3d 2026-04-22 feat: billing-ingest deadlock detection logic
- e4f5g6h 2026-04-21 docs: ADR-007 on session-token rotation
- ...

### New docs
- docs/decisions/0007-session-token-rotation.md (created 2026-04-21)
- research/2026-04-19-billing-ingest-deadlock.md (created 2026-04-19)

### Jira
- PE-142 — transitioned to Done 2026-04-22 — Billing ingest deadlock investigation
- PE-148 — created 2026-04-23 — Session token rotation rollout

### Granola
- 1:1 with Steve, 2026-04-23 — discussed Day 30 presentation structure (Tier 3, get_meetings)
- 1:1 with Alex (billing arch), 2026-04-22 — confirmed approach on deadlock fix (Tier 4, transcript)

### Other
- (none)
```

Output this inventory to the user before drafting. It gives them a chance to flag missing evidence before the draft is built on top of it.
