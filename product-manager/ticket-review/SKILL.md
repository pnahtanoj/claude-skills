---
name: ticket-review
description: >
  Audit existing tickets in a tickets/ directory for gaps, missing criteria,
  vague scope, and quality issues — then fix them in place. Use this skill
  whenever a user wants to review pre-existing tickets, check ticket quality,
  or audit a backlog. Triggers on phrases like "review my tickets", "check
  tickets for gaps", "audit the backlog", "are my tickets good enough", or
  "/ticket-review". Also trigger when a user starts a session in a repo with
  a tickets/ directory and asks for a quality check. Do NOT trigger for writing
  new tickets — use ticket-creator for that.
---

# Ticket Review Skill

Audit existing tickets in the project's `tickets/` directory, find gaps, fix
them in place, and report what changed.

---

## Step 1: Discover Tickets

1. Scan the `tickets/` directory recursively for all `.md` files.
2. If no `tickets/` directory exists, tell the user and stop.
3. List what was found: total count, subdirectories (features/tasks), file paths.

---

## Step 2: Load Quality Standards

Load `~/.claude/skills/ticket-creator/references/ticket-template.md` for the
quality bar and required ticket structure. This is the canonical standard all
tickets are measured against.

If that file is not available, fall back to these quality criteria:
- User story is present and follows "As a / I want / so that" format
- Acceptance criteria are specific and testable (not vague like "works correctly")
- Test scenarios cover happy path, edge cases, and error states
- Out of Scope section is populated with at least one item
- No acceptance criterion is un-testable
- Scope is bounded — a developer could start work without chasing down the author

---

## Step 3: Review and Fix Loop

Run up to **5 passes** over all tickets:

### Each pass:
1. Read every ticket file.
2. Check each against the quality bar.
3. For each gap found, fix it directly in the file using the Write tool.
   - Common fixes: add missing acceptance criteria, populate empty Out of Scope,
     rewrite vague criteria to be testable, add missing test scenarios, tighten
     or bound scope.
4. Track what was changed: which file, what was fixed.
5. After fixing, re-read the updated files and check again.
6. If no gaps remain, exit the loop early.

### What counts as a gap:
- Missing or incomplete user story
- Acceptance criteria that can't be verified by a test
- Empty or missing Test Scenarios table
- Empty Out of Scope section
- Scope that bleeds into adjacent features without explicit bounds
- Background/Context that contradicts the acceptance criteria
- Dependencies section missing when there are obvious dependencies

### What does NOT count as a gap:
- Style preferences
- Implementation details (don't add them unless a constraint was clearly stated)
- Hypothetical future requirements

---

## Step 4: Report

After the loop completes, report to the user:

1. **Summary table** — one row per ticket:
   | Ticket | Gaps Found | Fixed | Status |
   |--------|-----------|-------|--------|
   | `0001-...` | 2 | 2 | ✓ Clean |

2. **Pass count** — how many review passes were needed.

3. **What was fixed** — a brief bulleted list of the most significant changes
   (skip trivial ones like whitespace).

4. **Remaining issues** — if the iteration limit was hit before a clean pass,
   explicitly list what still needs attention and why it wasn't auto-fixable
   (e.g. requires product decision, missing information only the author has).

5. **Invite another round** — after presenting the report, ask: *"Want me to review again, or are these ready to hand off?"* Keep iterating until:
   - The user says they're satisfied, or
   - A full pass finds zero gaps
   Each new round runs the full review loop (Step 3) again. This catches anything introduced by prior fixes and lets the user direct focus (e.g. "focus on ticket 3" or "check the edge cases more carefully").

---

## Rules

- **Never add implementation details** unless a hard constraint was already
  stated in the ticket.
- **Never remove scope** — only add clarity or bounds. If something seems out
  of place, flag it rather than deleting it.
- **Never invent acceptance criteria** that contradict or go beyond the user
  story. Infer only from what is already in the ticket.
- **Always re-write the file after fixing** — do not just flag issues.
- **If a gap requires a product decision to resolve**, document it as an open
  question at the bottom of the ticket under an `## Open Questions` heading
  rather than guessing.
