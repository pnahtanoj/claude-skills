---
name: ticket-status
description: >
  Scan a tickets/ directory and output a board view showing which tickets are
  done, in-progress, available (unblocked), or blocked — derived from YAML
  frontmatter (id, status, depends_on) in each ticket file. Use this skill
  whenever the user asks what's next, what to work on, what's available,
  what's blocked, or wants a status overview of the ticket backlog. Triggers
  on phrases like "what's the next ticket", "what should I work on", "show me
  the board", "what tickets are available", "what's blocked", "ticket status",
  or "what's in progress". Also trigger at the start of a session when the user
  asks about project state. Do NOT trigger for creating tickets (use
  ticket-creator) or reviewing ticket quality (use ticket-review).
---

# Ticket Status Skill

Derive the current project board from ticket files — no memory, no stale
pointers. The ticket files are the source of truth.

---

## How it works

Each ticket file has YAML frontmatter:

```yaml
---
id: 0003
status: todo        # todo | in-progress | done
depends_on: [0001, 0002]
---
```

This skill reads that frontmatter across all tickets and outputs a live board
view. Because it reads the files directly, it is always accurate.

---

## Step 1: Find tickets

1. Look for a `tickets/` directory in the project root. If it doesn't exist,
   tell the user and stop.
2. Glob for all `**/*.md` files under `tickets/` recursively.
3. Read each file and parse the YAML frontmatter block (the content between
   the first pair of `---` delimiters).
4. Extract: `id`, `status`, `depends_on` (default to `[]` if absent).
   If a file has no frontmatter, skip it with a note.

---

## Step 2: Build the board

Using the parsed data:

1. Collect all IDs with `status: done` into a **done set**.
2. For each ticket with `status: todo`:
   - If `depends_on` is empty OR all listed IDs are in the done set → **available**
   - Otherwise → **blocked** (note which dep IDs are not yet done)
3. Tickets with `status: in-progress` get their own group.

---

## Step 3: Output the board

Present the board grouped in this order:

```
### In Progress
- [0004] Ticket title (ticket-slug.md)

### Available
- [0005] Ticket title
- [0006] Ticket title

### Blocked
- [0007] Ticket title — blocked by: 0005, 0006
- [0008] Ticket title — blocked by: 0006

### Done
- [0001] Ticket title
- [0002] Ticket title
- [0003] Ticket title
```

- If a group is empty, omit it.
- Use the ticket's markdown heading as the title (the first `### ` heading
  in the file body, after the frontmatter).
- Include the relative file path in parentheses for easy navigation.

---

## Step 4: Offer to claim a ticket (multi-agent support)

After outputting the board, if there are available tickets, ask:

> "Want me to claim one of the available tickets and start work? I'll update
> its status to `in-progress` before beginning."

If the user says yes (or names a ticket), update the `status` field in the
ticket's frontmatter from `todo` to `in-progress` before proceeding. This
prevents other agents from picking up the same ticket.

When work on a ticket is complete, update its frontmatter `status` to `done`.

---

## Rules

- **Never read project memory to answer "what's next."** Always derive the
  answer from ticket files. Memory goes stale; files don't lie.
- **If depends_on references an ID not found in any ticket file**, flag it as
  a broken reference rather than silently treating it as unblocked.
- **Update frontmatter in place** when claiming or completing a ticket — edit
  only the `status` line in the frontmatter block, leave everything else
  unchanged.
- **In a multi-agent context**, always claim (set `in-progress`) before
  starting work, and always mark `done` when finished. This is the
  coordination mechanism.
