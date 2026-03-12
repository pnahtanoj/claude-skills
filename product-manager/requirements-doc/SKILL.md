---
name: requirements-doc
description: >
  Produce a Product Requirements Document (PRD) from user stories, design
  critique findings, and session decisions. Use this skill whenever a user
  wants to consolidate product work into a single reference document — after
  stories and flows are defined, after a design critique, or before handing
  off to engineering. Triggers on phrases like "write a PRD", "produce a
  requirements doc", "create a spec", "make a product doc", "write this up
  for engineering", or any time the user wants to capture what's been decided
  into a durable artifact. Do not trigger for live brainstorming, user story
  mapping, or design critique — use the appropriate skills for those first.
---

# Requirements Doc Skill

Consolidate user stories, design critique findings, and session decisions into
a lean, durable PRD that an engineer or stakeholder can read without
reconstructing the conversation.

## Core Behavior

**Reconstruct from session context first.** If user stories, critique findings,
and decisions are already present in the conversation, extract them directly —
don't ask the user to re-explain what you already have. Only ask for genuine
gaps.

**Stay lean.** A 2-page PRD that gets read beats a 10-page one that doesn't.
Use must/should/won't language to distinguish requirements from nice-to-haves.
Defer anything not essential to v1 explicitly.

**Before producing output, check `references/prd-template.md`** for document
structure and any project-specific conventions in the Notes for Customization
section. Apply them throughout.

---

## Step 1: Assess Available Context

First, check for existing project files that may contain established context:
- Look for a `CLAUDE.md` in the project root — it often contains settled product
  decisions, constraints, and out-of-scope items
- Look for any existing PRD files (e.g. `docs/*.md`) — don't duplicate or
  contradict what's already decided; build on it

Then, from the conversation, identify what's already established:

- [ ] Problem statement and user need
- [ ] User type(s) and goals
- [ ] User stories and flows
- [ ] Design critique findings and resolutions
- [ ] Key decisions made (and their rationale)
- [ ] Open questions and assumptions
- [ ] Platform / technical constraints

If any of these are missing and can't be reasonably inferred, ask — but keep
questions targeted. One focused question beats five vague ones.

If all of the above are present, proceed directly to Step 2.

---

## Step 2: Draft the PRD

Load `references/prd-template.md` and produce the full document.

Apply the quality bar before presenting — don't surface a draft that doesn't
pass:

- [ ] Problem statement is user-centered, not feature-centered
- [ ] Goals and non-goals are explicit — non-goals are as important as goals
- [ ] Every functional requirement traces back to a user story or decision
- [ ] Must / should / won't language is used consistently
- [ ] Decisions log captures rationale, not just outcomes
- [ ] Open questions are specific and flagged as blocking or non-blocking
- [ ] Document is readable by a non-technical stakeholder AND actionable for an engineer
- [ ] Nothing in v1 scope that wasn't established in stories or critique
- [ ] Project-specific conventions from Notes for Customization are applied

---

## Step 3: Offer Next Steps

After presenting the PRD:

1. Note any sections that were thinly sourced or assumed — flag them explicitly
2. Offer to refine: *"Want me to expand any section, tighten the scope, or
   add more detail to the requirements?"*
3. If the PRD is ready for engineering: *"Ready to break this into tickets?"*
4. If a Claude Code handoff is next: *"Want a CLAUDE.md block from this for
   Claude Code?"*

---

## Handling Thin Input

If the user asks for a PRD with minimal prior context (no stories, no critique):

1. Flag what's missing and what you'll need to produce a useful doc
2. Ask for the 2-3 most critical inputs (problem statement, user, core flow)
3. Produce a draft with explicit placeholders for anything unresolved — don't
   fill gaps with invented requirements

The most common things that get invented when input is thin — don't do this:
- Specific values: duration options, numeric thresholds, percentages ("20% adoption")
- Success metrics: these belong to the user's goals, not the PRD author
- UI specifics: exact copy, component names, interaction details
- Timelines or release dates

If you don't have it, write `[TBD]` and flag it as blocking or non-blocking.

---

## Rules

Failure patterns to avoid. Update this section when new ones are observed.

- **Never write a feature-centered problem statement.** The problem belongs to the user, not the product. If it reads like a feature description, rewrite it.
- **Never invent requirements.** If something wasn't established in stories, critique, or explicit decisions, it doesn't belong in the PRD. Use [TBD] placeholders instead.
- **Never leave the Non-Goals section empty.** Non-goals are as important as goals — an empty section signals the scope hasn't been thought through.
- **Never mix must/should/won't language inconsistently.** Pick the right level for each requirement and apply it throughout.
- **Never omit rationale from the Decisions Log.** The outcome without reasoning will be relitigated. Capture why, not just what.
- **Never let the PRD grow beyond ~3 pages for a v1 product.** If it's longer, trim or defer — a PRD that doesn't get read doesn't help anyone.
- **Never add document sections not sourced from the input.** A PRD's sections come from what was established, not from what a complete PRD might theoretically contain. If the user didn't provide risk data, don't add a risk register. If they didn't define success metrics, don't invent them. Stick to what's known.
- **When the user approves an output as good, save it as an example.** Append it to `references/examples.md` (create the file if it does not exist) under a dated heading. Future runs should check this file for approved output patterns and match their style and depth.
- **Use subagents for large PRDs.** If the PRD has 4+ major sections (problem, flows, requirements, non-goals, etc.), spawn parallel subagents to draft each section from the available inputs, then synthesize and check for internal consistency.
