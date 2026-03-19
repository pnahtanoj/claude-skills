---
name: ticket-creator
description: >
  Transform rough feature ideas, product briefs, or incomplete descriptions into
  well-structured engineering tickets. Use this skill whenever a user wants to
  create, write, flesh out, or improve a ticket, issue, story, or task — even if
  they just describe an idea casually. Triggers on phrases like "write a ticket
  for...", "turn this into a ticket", "help me spec out...", "create a GitHub
  issue for...", or any time a user describes a feature and needs it structured
  for engineering work. Do not trigger for general feature brainstorming,
  user story mapping, or design critiques — use the appropriate skill for those.
---

# Ticket Creator Skill

Transform vague feature ideas, product briefs, or rough notes into complete,
actionable engineering tickets.

## Core Behavior

**The goal is a ticket a developer can pick up without chasing down the author
for context.** Ask clarifying questions when input is ambiguous — but skip them
if the user has already provided a complete user story, acceptance criteria, and
scope. Don't ask for information you already have.

**Before drafting, check `references/ticket-template.md` for any project-specific
conventions in the Notes for Customization section — sizing guidelines, required
labels, team formats. Apply them throughout.**

---

## Step 1: Intake & Clarification

When the user provides a feature idea (in any form — conversational, a doc
snippet, a stub issue):

1. **Acknowledge** what you understood from the input in 1-2 sentences.
2. **Ask clarifying questions only if needed** — identify the 2-4 gaps that
   would most block ticket completion. Typical areas to probe:
   - Who is the user / actor?
   - What triggers this feature?
   - What does the happy path look like?
   - What are the failure cases?
   - Any dependencies on other work?
   - Any design spec, Figma, or doc to reference?
   - Any known constraints (performance, accessibility, platform)?

3. **Don't ask everything at once.** If input is very thin, start with who /
   what / why before getting into edge cases.
4. **If input is already complete** — user story, acceptance criteria, and scope
   are all present — skip clarification and draft immediately.
5. **If this ticket follows from a user story or design critique in this
   session**, carry that context forward. Reference the originating story or
   critique finding in Background / Context rather than re-asking for it.

---

## Step 2: Draft the Ticket

Once clarifications are resolved (or the user says "just draft it"):

1. Load `references/ticket-template.md` for the ticket structure and quality bar.
2. Produce a complete ticket following that template. **Test Scenarios is always required** — never omit it, even if the feature seems simple.
3. Apply the quality bar checklist before presenting — don't surface a draft
   that fails it.

---

## Step 2b: Determine Output Path

Before writing, resolve where the ticket file should live:

1. **Infer a task/feature grouping** from available context, in priority order:
   - Current git branch name (strip prefixes like `feature/`, `fix/`, `chore/`)
   - A PRD or requirements doc open or referenced in the session
   - **Existing subdirectories under `tickets/`** — if one or more subdirectories already contain tickets, and the current work clearly belongs to one of them, use that subdirectory. This prevents tickets from landing at the top level when a grouping already exists.
   - The session topic if it clearly maps to a single feature
   - If none of the above apply, use no subdirectory (flat in `tickets/`)

2. **Determine the next sequential number** by scanning existing files in the target directory. If the directory doesn't exist yet, start at `0001`.

3. **Construct the file path:**
   - With grouping: `tickets/<feature-name>/<NNNN>-<ticket-slug>.md`
   - Without grouping: `tickets/<NNNN>-<ticket-slug>.md`
   - Ticket slug: lowercase, hyphen-separated, derived from the ticket title (max ~5 words)

4. **Write the file** using the Write tool. Create parent directories as needed.

5. **Tell the user the path** where the ticket was written.

---

## Step 3: Self-Review Loop

After writing all ticket files, run a gap review before surfacing anything to the user:

1. Re-read each ticket against the quality bar in `references/ticket-template.md` and the original user input.
2. Check for: missing acceptance criteria, untested edge cases, vague scope, empty Out of Scope, over-prescribed implementation, or any gap between what the user described and what the ticket captures.
3. If gaps are found — fix them silently, re-write the affected files, and run the review again.
4. Repeat up to **5 passes** until no gaps remain.
5. When the review passes cleanly (or the iteration limit is reached), tell the user:
   - How many review passes were needed
   - A one-line summary of what was fixed (if anything), e.g. *"Fixed: added error states to tickets 2 and 4, tightened scope on ticket 3."*
   - If the limit was hit without a clean pass, flag the remaining gaps explicitly.

---

## Step 4: Surface Assumptions and Iterate

After the self-review loop:

1. **Explicitly list any assumptions you made** — especially where you drew on project context rather than explicit user input. This lets the user catch anything you got wrong without having to read the whole ticket. Format as a brief bulleted list.
2. Invite feedback: *"Want me to tweak the scope, add edge cases, or split this into smaller tickets?"*
3. **Keep iterating until:**
   - The user says they're happy, or
   - The user gives no further feedback
   Each round of feedback triggers a new self-review loop (Step 3) on the affected tickets, with files updated in place. Surface a brief summary of what changed after each round.

---

## Handling Thin Input

If the user gives very little (e.g., "write a ticket for a login page"):

1. **Before asking anything**, check available project context: CLAUDE.md, PRDs, session history, prior tickets in this session. If that context answers your key questions, draft immediately — don't ask questions the project files already answer.
2. If genuine gaps remain after checking context, state the 2-3 things you'd still need and ask those directly.
3. Once you have enough, proceed with the full structure.

The goal is never to make the user answer questions you could answer yourself by reading.

---

## Context Accumulation (Multi-Ticket Sessions)

If the user is writing multiple tickets in a session:
- Maintain awareness of previously written tickets.
- Reference them in the Dependencies section where relevant.
- Flag if a new ticket overlaps with or contradicts an existing one.

---

## Rules

Failure patterns to avoid. Update this section when new ones are observed.

- **Never ask clarifying questions when the input is already complete.** If user story, acceptance criteria, and scope are all present, draft immediately.
- **Never ask a question you could answer by reading project context.** CLAUDE.md, PRDs, session history, and prior tickets in this session are fair game — mine them before asking the user anything.
- **Never re-ask for context established earlier in the session.** If a story or critique was produced upstream, carry it forward into Background / Context.
- **Never leave the Out of Scope section empty.** Think about what a developer might reasonably assume is included — then rule it out explicitly.
- **Never over-prescribe implementation.** Describe what needs to happen, not how to build it, unless there's a specific technical constraint that must be respected.
- **Never present a ticket without populated acceptance criteria.** A ticket without testable criteria isn't actionable.
- **Never present output that fails the quality bar** — fix it first, then present.
- **When the user approves an output as good, save it as an example.** Append it to `references/examples.md` (create the file if it does not exist) under a dated heading. Future runs should check this file for approved output patterns and match their style and depth.
- **Use subagents for ticket splitting.** If a feature is complex enough to warrant 3+ tickets, spawn parallel subagents to draft each ticket simultaneously, then review for dependency ordering and conflicts before presenting.
- **Add a 🧪 Testing Checkpoint section only at genuine product milestones.** The bar is high: this ticket unlocks something a human would meaningfully want to step back and experience — a new persona can use the product for the first time, a major workflow phase becomes testable end-to-end, or the product crosses a threshold where real quality judgment is possible. A ticket that merely converges multiple dependencies is NOT automatically a checkpoint — convergence is necessary but not sufficient. When in doubt, omit it.
- **Always write the ticket to a local file.** Do not only output to the conversation. The file is the artifact; the conversation output is a summary.
- **Always include YAML frontmatter on new tickets** with `id` (the ticket number, e.g. `0001`), `status: todo`, and `depends_on: []` (list any blocking ticket IDs). When work begins, update `status` to `in-progress`; when complete, to `done`. This frontmatter is machine-readable — the `ticket-status` skill uses it to derive the board view without relying on memory.
- **Never hardcode a subdirectory.** Infer the grouping from branch/PRD/context — don't ask the user for a folder name unless there is truly no signal.
- **Always check `tickets/` for existing subdirectories before falling back to flat.** If a subdirectory already contains tickets and the new work belongs there, use it. Don't drop tickets at the top level when a grouping already exists.
- **MCP posting is not the primary path.** Do not offer to post to GitHub/Linear/Jira unless explicitly asked.
