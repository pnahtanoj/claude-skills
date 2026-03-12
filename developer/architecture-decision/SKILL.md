---
name: architecture-decision
description: Guide the user through a structured Architecture Decision Record (ADR) using the MADR format. Use this skill whenever the user needs to make a technical decision, evaluate trade-offs between approaches, choose between implementation options, or document why a particular path was chosen. Trigger on phrases like "should we use X or Y", "what's the best approach for...", "help me decide...", "we need to choose between...", "document this decision", "write an ADR", or any time a technical fork in the road needs to be reasoned through and recorded. Also trigger when an open question is blocking implementation — even if the user doesn't frame it as a decision.
---

# Architecture Decision Record Skill

Your job is to help the user reason through a technical decision and produce a clean MADR-format ADR file saved to `docs/decisions/`.

## Process

Work conversationally. Don't dump a form on the user — draw the decision out through dialogue, then produce the document at the end.

### 1. Understand the decision

You need to know: what problem needs solving, what constraints exist (time, tech stack, team size, reversibility), and what options are already on the table.

If the user's message already answers these — proceed directly to step 2. Don't ask questions you already have answers to. Only pause to ask if something is genuinely ambiguous or missing and would meaningfully change the analysis.

If the user comes in with a vague problem, help them articulate it clearly before moving to options. A well-framed question is half the answer.

### 2. Enumerate options

If the user has options in mind, work with those. If they're missing obvious alternatives, suggest them — it's better to consider and reject an option than to miss it entirely. Aim for 2–4 options. More than that and the decision is probably not scoped tightly enough.

### 3. Evaluate trade-offs

For each option, think through:
- What does this make easy?
- What does it make hard or impossible?
- What are the risks?
- How reversible is it?

Don't just list pros and cons mechanically — help the user think. Push back if an option is being unfairly dismissed or over-romanticised. Flag any option that is technically irreversible or high-risk.

### 4. Surface a recommendation

Once trade-offs are clear, offer a recommendation with reasoning. Be direct — "I'd go with Option B because..." is more useful than "both have merit." The user can disagree; your job is to give them something to push against.

### 5. Confirm and produce the ADR

Once the user confirms the decision (or overrides your recommendation), write the ADR file.

## Output format

Save to `docs/decisions/` using the next available number (check what's already there; create the directory if it doesn't exist). Filename: `NNN-short-title.md` (e.g., `001-background-persistence.md`).

Use this MADR template exactly:

```markdown
# NNN. [Short title of the decision]

Date: YYYY-MM-DD

## Status

Accepted

## Context and Problem Statement

[1–3 sentences describing the situation and what needs to be decided. Written so that someone reading this months later understands why the decision was necessary.]

## Considered Options

- Option A: [name]
- Option B: [name]
- Option C: [name] (if applicable)

## Decision Outcome

Chosen option: **[Option X]**, because [concise justification — 1–2 sentences].

### Consequences

- Good: [positive outcome]
- Good: [positive outcome]
- Bad: [accepted downside or risk]
- Neutral: [side effect worth noting]

## Options Analysis

### Option A: [name]

[1–2 sentence description]

**Pros:**
- [pro]
- [pro]

**Cons:**
- [con]
- [con]

### Option B: [name]

[1–2 sentence description]

**Pros:**
- [pro]

**Cons:**
- [con]
```

## Tips

- Status is almost always "Accepted" — if the decision hasn't been made yet, don't write the ADR.
- Keep the language plain. ADRs are for future-you and new teammates, not for impressing anyone.
- The Consequences section is the most important part — be honest about the downsides of the chosen option.
- If the decision is reversible, say so. If it isn't, say that too.
