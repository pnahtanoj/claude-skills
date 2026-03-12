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

## Step 3: Surface Assumptions and Offer to Refine

After presenting the draft:

1. **Explicitly list any assumptions you made** — especially where you drew on project context rather than explicit user input. This lets the user catch anything you got wrong without having to read the whole ticket. Format as a brief bulleted list.
2. Offer to adjust: *"Want me to tweak the scope, add edge cases, or split this
   into smaller tickets?"*

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
