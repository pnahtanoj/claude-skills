---
name: user-story-flow
description: >
  Transform vague product ideas, goals, or feature requests into structured user
  stories and user flows. Use this skill whenever a user wants to define, map,
  or flesh out how a user will interact with a specific feature — including the
  step-by-step journey, alternate paths, and error states. Triggers on phrases
  like "map out the user flow for...", "write user stories for...", "how would a
  user...", "define the flow for...", or any time someone describes a product
  idea that needs to be broken down into user-centered steps and stories. Do not
  trigger for general feature brainstorming, architecture discussions, or design
  critiques — use the appropriate skill for those instead.
---

# User Story & Flow Definition Skill

Turn vague product ideas into structured user stories, step-by-step flows, and
clear acceptance criteria — from the user's perspective.

## Core Behavior

**Start by understanding the user and their goal, not the feature.** Vague ideas
become good stories when you anchor them in who is doing what and why. Always
clarify before drafting.

**Before producing output, check `references/story-flow-template.md` for any
project-specific personas, platform conventions, or customization notes. Apply
them throughout — don't treat them as optional.**

---

## Step 1: Clarify the Idea

When the user shares a product idea or goal:

1. **Reflect back** what you heard in one sentence — confirm you understood the
   core intent.
2. **Ask targeted clarifying questions**, prioritized in this order — stop once
   you have enough to proceed:
   - **Who is the user?** *(Always ask this first if not stated — everything
     else depends on it.)*
   - **What's their goal?** What are they trying to accomplish — not what the
     feature does, but what the user *needs*?
   - **What's the entry point?** Where does the user start this flow — what
     triggers it?
   - **Are there different user types?** Would different users experience this
     differently (e.g. admin vs. end user, new vs. returning)?
   - **Any known constraints?** Platform, permissions, existing systems to
     integrate with?

3. If the idea is very thin, focus only on: who, what they need, and why.
   Don't ask about edge cases until the happy path is clear.

---

## Step 2: Calibrate Scope

Before drafting, determine the appropriate depth:

- **Simple feature, single user type:** One story, one flow, brief acceptance
  criteria. Don't over-engineer it.
- **Multi-persona or multi-path feature:** One story per user type, flows for
  each meaningful path, fuller acceptance criteria.
- **Large or ambiguous scope:** Flag if this should be broken into multiple
  flows. Offer to tackle one at a time.

**Story granularity:** Write one story per user *goal*, not per sub-action. If
a user has one goal (e.g. "start the meeting clock"), write one story that
covers it — not separate stories for each input they configure along the way.
Sub-actions belong in the numbered flow steps, not as separate stories. The
right question is: what is the user ultimately trying to accomplish?

---

## Step 3: Define User Stories

Once you have enough context, load `references/story-flow-template.md` and
produce the full output following that structure:

- One or more user stories in "As a / I want / So that" format
- A numbered user flow for the primary path
- Happy path + key alternate and error paths
- Acceptance criteria per story
- Open questions and assumptions flagged at the end

**Apply the quality bar before presenting. If the output fails any check, fix
it first — don't surface a draft that doesn't meet the bar.**

---

## Step 4: Offer to Refine

After presenting the output:

1. Call out any assumptions you made so the user can correct them.
2. Offer next steps: *"Want me to add more user types, go deeper on an alternate
   path, or adjust the scope?"*
3. If this flow is ready for ticketing, offer to hand off to the ticket-creator
   skill: *"Ready to break this into tickets?"*

---

## Handling Thin Input

If the idea is very vague (e.g. "do a flow for onboarding"):

1. Name the 2-3 things you need to write something useful.
2. Ask those questions directly — don't produce a generic placeholder.

---

## Multi-Story Sessions

If the user defines multiple flows in a session:
- Note where flows connect or hand off to each other.
- Flag if a new flow assumes something a previous one doesn't cover.
- Keep a running list of open questions that span flows — surface them at
  natural breakpoints, not mid-flow.

---

## Rules

Failure patterns to avoid. Update this section when new ones are observed.

- **Never write stories from the system's perspective.** "The system sends an email" is not a user story step — find the user action that triggers it.
- **Never ask for information already present in the conversation.** If the user type, platform, or goal was established earlier in the session, carry it forward.
- **Never produce acceptance criteria that can't be tested.** If you can't write a test for it, rewrite it before presenting.
- **Never produce a happy path with gaps.** Every step must have a clear actor and a clear next state — no "and then the user proceeds" without specifying to what.
- **Never skip alternate and error paths for a simple-seeming feature.** Simple features often have the most consequential edge cases.
- **Never present output that fails the quality bar** — fix it first, then present.
- **Never state specific values not sourced from the input.** File size limits, count limits, timeouts, retention periods, SLAs — if the input didn't mention it, don't invent it. Either flag it as [TBD] or list it explicitly in the assumptions section with a note that it needs confirmation. Invented specifics look like decisions but aren't — they mislead the team.
- **When the user approves an output as good, save it as an example.** Append it to `references/examples.md` (create the file if it does not exist) under a dated heading. Future runs should check this file for approved output patterns and match their style and depth.
- **Use subagents for multi-persona work.** If a feature has 3+ distinct user types, spawn parallel subagents to draft each persona's story and flow simultaneously, then synthesize. Do not serialize work that can be parallelized.
