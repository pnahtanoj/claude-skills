---
name: design-critique
description: >
  Review and critique a product design, user flow, or design document and return
  a prioritized list of issues, gaps, and risks. Use this skill whenever a user
  shares a design artifact and wants critical evaluation — wireframes, flows,
  specs, or mockups. Triggers on phrases like "critique this design", "review
  this flow", "does this hold up", "give me feedback on this design", or "what
  are the problems with this". Do not trigger for general questions like "does
  this make sense?", "what am I missing?" in non-design contexts, architecture
  discussions, or code reviews — use the appropriate skill for those instead.
---

# Design Critique Skill

Review product designs, user flows, and design documents across five dimensions
and return a prioritized list of issues, gaps, and risks.

## Core Behavior

**Be a thoughtful critic, not a validator.** The goal is to surface real
problems before they become expensive — not to reassure. Be direct, specific,
and constructive. Every issue should be actionable.

**Before critiquing, check `references/critique-output-format.md` for any
project-specific standards, accessibility requirements, or design system
conventions in the Notes for Customization section. Apply them as hard
criteria — not suggestions.**

---

## Step 1: Understand the Design

Before critiquing, establish context:

1. **Confirm what you're reviewing** — summarize the design in 2-3 sentences
   so the user can correct any misreading.
2. **Clarify the stage** if not obvious — is this early concept, mid-fidelity,
   or near-final? Stakes and depth of critique should match the stage.
3. **Ask one question if critical context is missing** — e.g. who the primary
   user is, or what the stated goal is. Don't ask if you can reasonably infer it.

If the design is well-documented (e.g. a full design doc is provided), skip
straight to the critique.

---

## Step 2: Critique the Design

Load `references/critique-dimensions.md` for the full evaluation criteria
across all five dimensions.

Evaluate across:
- User Experience & Flows
- Visual Design & Aesthetics
- Technical Feasibility
- Scope & Completeness
- Consistency with Stated Goals

Then produce output following the structure in
`references/critique-output-format.md`.

**Apply the quality bar before presenting. If the output fails any check, fix
it first — don't surface a critique that doesn't meet the bar.**

---

## Step 3: Invite Discussion

After presenting the critique:

1. Flag any issues where your confidence is limited due to missing information
   — name specifically what you'd need to evaluate them fully.
2. Offer to go deeper: *"Want me to expand on any of these, suggest solutions,
   or look at a specific section more closely?"*
3. If the critique surfaced undefined flows or scope gaps, offer to hand off:
   *"Some of these gaps could become user stories — want me to draft them?"*
   If technical feasibility concerns were raised: *"Want to turn any of the
   technical risks into tickets?"*

---

## Calibrating Depth

- **Early concept:** Focus on goals, user needs, and major flow gaps. Skip
  pixel-level feedback.
- **Mid-fidelity:** Cover all five dimensions. Flag both strategic and
  tactical issues.
- **Near-final:** Be thorough. Small issues matter now.

---

## Handling Thin Input

If the user shares only a rough sketch or brief description:
1. Work with what you have — don't refuse to critique.
2. Flag explicitly what you couldn't evaluate due to missing detail.
3. Ask one targeted question to unlock the most valuable feedback.

---

## Rules

Failure patterns to avoid. Update this section when new ones are observed.

- **Never soften a critical issue.** If something is fundamental, say so — qualifying language like "might be worth considering" on a blocking problem is misleading.
- **Never manufacture issues to fill the template.** If there are 2 real critical issues, list 2. An inflated critique is less useful than an honest short one.
- **Never give generic praise in "What's Working".** Name the exact element and explain why it works — "good visual hierarchy" without specifics is filler.
- **Never critique at the wrong stage depth.** Pixel-level feedback on an early concept wastes the user's time. Match depth to stage.
- **Never ask multiple clarifying questions.** Ask one, the most important one — then proceed.
- **Never present output that fails the quality bar** — fix it first, then present.
- **When the user approves an output as good, save it as an example.** Append it to `references/examples.md` (create the file if it does not exist) under a dated heading. Future runs should check this file for approved output patterns and match their style and depth.
- **Use subagents for large design docs.** If reviewing a doc with 3+ distinct sections (e.g. onboarding, core flow, settings), spawn parallel subagents to evaluate each section against the five dimensions, then merge findings and de-duplicate before presenting.
