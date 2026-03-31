---
name: discovery-doc
description: Create or update a living discovery document that structures findings, tracks open questions, and synthesizes stakeholder input during the early investigation phase of a project. Use this skill whenever the user is exploring a new problem space, onboarding onto an existing system, mapping out a data landscape, gathering requirements from stakeholders, or needs to organize scattered notes into a structured discovery artifact. Trigger on phrases like "let's start discovery", "what do we know so far", "organize these findings", "I just had a call with...", "update the discovery doc", "add this to our findings", "what questions are still open", or any time the user is in an exploratory phase and needs to capture what they're learning. Do NOT trigger for structured requirements documents (use requirements-doc), architecture decisions (use architecture-decision), or research briefs about external markets (use researcher).
---

# Discovery Document Skill

Your job is to help the user create and maintain a living discovery document — the central artifact for an early-stage project where the team is still figuring out what exists, what's possible, and what to build.

A discovery doc is not a PRD. It's a map of explored and unexplored territory. It tracks what you know, what you don't know, and who can tell you.

## When creating a new discovery doc

### 1. Understand the scope

Ask just enough to understand:

- **What are we discovering?** A new system to integrate with? A problem space? An existing codebase to onboard onto?
- **Who are the stakeholders?** Who has knowledge the team needs?
- **What's already known?** Has there been prior investigation, existing docs, or tribal knowledge?

If the user's message already covers these, proceed directly. Don't re-ask what's been answered.

### 2. Gather and structure findings

Work with whatever the user brings — meeting notes, screenshots, diagrams, scattered bullet points, verbal brain-dumps. Your job is to extract the signal and organize it.

For each finding, determine:
- What is it? (fact, constraint, assumption, or open question)
- How confident are we? (confirmed, likely, uncertain)
- Where did it come from? (stakeholder name, document, direct observation)

### 3. Produce the discovery document

Save to `DISCOVERY.md` in the project root (or update it if one already exists).

Use this structure:

```markdown
# Discovery: [Project or Initiative Name]

Last updated: YYYY-MM-DD

## Purpose

[1-2 sentences: what this discovery effort is about and what decision or phase it feeds into.]

## Current Landscape

[Describe the systems, data sources, teams, or processes that are in scope. Use subsections for each major component. Include diagrams if available.]

### [System/Component A]

- **What it is:** [brief description]
- **Owner/Contact:** [name, role]
- **Access:** [how to get to it, current access status]
- **Key details:** [relevant technical or process details]

### [System/Component B]

...

## Key Findings

[Organized by theme. Each finding should be a clear statement with a confidence indicator.]

| # | Finding | Confidence | Source |
|---|---------|------------|--------|
| 1 | [statement] | Confirmed / Likely / Uncertain | [who or what] |
| 2 | [statement] | Confirmed / Likely / Uncertain | [who or what] |

## Open Questions

[Questions that still need answers. Track status and who can answer them.]

| # | Question | Status | Owner/Contact | Notes |
|---|----------|--------|---------------|-------|
| 1 | [question] | Open / In Progress / Resolved | [who to ask] | [any context] |
| 2 | [question] | Open / In Progress / Resolved | [who to ask] | [any context] |

## Constraints & Guardrails

[Non-negotiable boundaries discovered so far — security policies, data governance rules, budget limits, timeline constraints, access restrictions.]

- [constraint]
- [constraint]

## Action Items

[Concrete next steps with owners and priority.]

| # | Action | Priority | Owner | Status |
|---|--------|----------|-------|--------|
| 1 | [action] | High / Medium / Low | [who] | Not Started / In Progress / Done |

## Key Contacts

| Name | Role | Area | Contact |
|------|------|------|---------|
| [name] | [role] | [what they know about] | [email/phone/slack] |

## Decision Log

[Decisions made during discovery that constrain or direct future work. Link to ADRs if they exist.]

- **YYYY-MM-DD:** [decision and brief rationale]
```

## When updating an existing discovery doc

1. **Read the current document first.** Understand what's already captured before adding to it.
2. **Add new findings** to the Key Findings table with confidence and source.
3. **Update question status** — mark resolved questions, add new ones.
4. **Update action items** — mark completed items, add new ones discovered.
5. **Bump the "Last updated" date.**
6. **Don't reorganize or rewrite existing sections** unless the user asks. The document is a living artifact — continuity matters more than polish.

When the user says "I just talked to [someone]" or shares meeting notes, extract the findings and integrate them into the appropriate sections. Don't just append raw notes — synthesize them into the existing structure.

## Tips

- The Open Questions table is the most operationally useful part. Keep it current — it drives what happens next.
- Confidence levels matter. A finding marked "Uncertain" with a source is more useful than an unattributed "fact."
- Don't remove resolved questions — mark them as Resolved and note the answer. The history of what was unknown is useful context.
- If a discovery effort spans multiple calls or sessions, each update should be incremental. Don't rewrite the whole doc each time.
- When findings contradict each other, flag the contradiction explicitly rather than picking a winner. Resolution is a separate step.
- A discovery doc graduates into other artifacts: requirements docs, ADRs, tickets, spike definitions. When a section is mature enough, suggest the appropriate next skill rather than over-growing the discovery doc.
