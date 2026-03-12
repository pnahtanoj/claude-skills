---
name: stack-decision
description: Guide the user through evaluating and selecting a technology, library, framework, or tooling choice, then document the decision as a MADR-format ADR. Use this skill whenever the user needs to choose between technologies, languages, runtimes, libraries, or tools — especially when the choice has long-term implications. Trigger on phrases like "what should we use for...", "should we use X or Y library", "which framework", "what's the right tool for...", "help me pick a...", "should we write this in X", or any time a technology choice needs to be reasoned through and recorded. Also trigger when the user is evaluating whether to add a dependency, adopt a new tool, or replace an existing one.
---

# Stack Decision Skill

Your job is to help the user pick the right technology for the job and produce a MADR-format ADR saved to `docs/decisions/`.

Stack decisions are different from general architecture decisions. The technical trade-offs matter, but so do softer factors that are easy to overlook: ecosystem health, team familiarity, maintenance burden, and how hard it is to escape the choice later. Your job is to make sure those angles get considered even if the user doesn't raise them.

## Process

### 1. Understand the choice

You need to know:
- What problem is this technology meant to solve?
- What's the team size and their familiarity with the options?
- What are the project's longevity expectations — quick v1, or something maintained for years?
- Are there any hard constraints (license, performance, bundle size, platform support)?

If the user's message already answers these, proceed directly. Only ask if something is genuinely missing and would change the analysis.

### 2. Enumerate options

Work with what the user has in mind, but always sense-check: is there an obvious option they haven't mentioned? Is one of their options a poor fit for this category (e.g. a general-purpose tool where a purpose-built one exists)? Aim for 2–4 options.

### 3. Evaluate across the stack-decision lens

For each option, assess across these dimensions. Not all will be equally relevant — use judgment about which matter most for this decision:

**Technical fit**
- Does it actually solve the problem well?
- Performance, bundle size, platform support?
- How well does it compose with the rest of the stack?

**Ecosystem health**
- Is it actively maintained? When was the last release?
- Is the community growing or shrinking?
- Are there known deprecation risks or ownership concerns (single-maintainer, corporate-controlled)?

**Team fit**
- How familiar is the team with it?
- What's the learning curve if they're not?
- Is expertise findable if the team grows?

**Maintenance burden**
- How often does it have breaking changes?
- How much configuration and boilerplate does it require?
- What happens when it goes wrong — is it debuggable?

**Escape hatch**
- How hard is it to replace later?
- Does adopting it create vendor lock-in or deep coupling?
- Is the migration path to an alternative reasonable?

**What else does this pull in?**
- Does choosing this introduce new infrastructure (a package.json, a build step, a lockfile) that wasn't there before?
- Are there transitive dependencies or runtime requirements worth flagging?
- Is the surface area proportionate to the problem?

### 4. Surface a recommendation

Be direct: "Use X because..." Don't hedge unless the options are genuinely equivalent. If they are equivalent, say so and explain what would break the tie (team preference, existing familiarity, etc.).

Flag clearly if any option is a trap — looks appealing but creates long-term pain.

### 5. Produce the ADR

Once the user confirms (or overrides), write the file.

## Output format

Save to `docs/decisions/` using the next available number (check what's already there; create the directory if it doesn't exist). Filename: `NNN-short-title.md` (e.g., `004-testing-library.md`).

Use this MADR template exactly:

```markdown
# NNN. [Short title — e.g. "Use Vitest for unit testing"]

Date: YYYY-MM-DD

## Status

Accepted

## Context and Problem Statement

[1–3 sentences: what are we choosing and why does it matter? Written so that someone reading this months later understands the situation.]

## Considered Options

- Option A: [name]
- Option B: [name]
- Option C: [name] (if applicable)

## Decision Outcome

Chosen option: **[Option X]**, because [concise justification — 1–2 sentences].

### Consequences

- Good: [positive outcome]
- Good: [positive outcome]
- Bad: [accepted downside or trade-off]
- Neutral: [side effect worth noting]

## Options Analysis

### Option A: [name]

[1–2 sentence description]

**Pros:**
- [pro]

**Cons:**
- [con]

### Option B: [name]

[1–2 sentence description]

**Pros:**
- [pro]

**Cons:**
- [con]
```

## Tips

- The Escape hatch dimension is the most commonly skipped and the most regretted. Always address it.
- "Popular" is not a pro. Explain *why* the ecosystem matters for this specific decision.
- If the team has no experience with any option, weight the learning curve heavily — v1 timelines are usually tighter than expected.
- If reversibility is high (easy to swap later), say so — it changes how much deliberation the decision deserves.
