---
name: code-review
description: Review code for bugs, correctness, security issues, and maintainability. Produce a prioritized list of findings with severity levels and actionable fixes. Use this skill whenever the user wants code reviewed, asks for feedback on a file or diff, wants a second opinion on an implementation, or says things like "review this", "look over this code", "what's wrong with this", "any issues here", or "PR review". Also trigger when the user shares code and asks if it looks right, even if they don't use the word "review". ALSO trigger automatically after you finish implementing or significantly modifying code — run the review without being asked, fix any Critical or Major findings, then offer another pass. Do not trigger for product documents, PRDs, specs, or design artifacts — use `design-critique` for those.
---

# Code Review Skill

Your job is to review code and return a prioritized, actionable list of findings. Be direct and specific — vague feedback like "consider improving readability" is not useful. Say exactly what to change and why.

## Before you start

1. **Identify the language** — if it's JS/TS, load and apply `references/js-gotchas.md`. Add reference files for other languages as they're created.
2. **Understand the context** — what is this code supposed to do? If unclear from the code itself, ask before reviewing.
3. **Understand the scope** — are you reviewing a diff, a single file, or multiple files? For a diff, focus on changed lines and their immediate context. Don't flag pre-existing issues unless they interact with the new code.

## Severity tiers

**Critical** — Will cause a bug, data loss, security vulnerability, or broken behaviour. Must fix before shipping.

**Major** — Likely to cause problems under realistic conditions, or makes the code significantly harder to maintain correctly. Should fix soon.

**Minor** — Won't break anything but degrades quality in a meaningful way — unclear naming, missing edge case handling, logic that works but is confusing.

**Nit** — Style, preference, or very low-stakes consistency. Fix if you're already touching the code, skip otherwise.

## What to look for

Work through these in order — stop at Critical/Major if there are many issues, don't pad the review with Nits when there are serious problems.

**Correctness**
- Does the logic actually do what it's supposed to?
- Are edge cases handled (empty input, null/undefined, zero, negative numbers, very large values)?
- Are async operations handled correctly — is every Promise awaited or `.catch()`-ed?
- Are error paths reachable and handled?

**Security**
- Is any user input reflected into the DOM unsanitized (XSS)?
- Are there any obvious injection risks?
- Are secrets or sensitive values hardcoded?

**State and side effects**
- Are there unintended side effects?
- Could state become inconsistent if an operation fails partway through?
- Are event listeners or intervals cleaned up when no longer needed?

**Maintainability**
- Is the intent clear from the code, or does it require a comment to understand?
- Are names accurate — do they describe what the thing actually is/does?
- Is complexity proportionate to the problem? Would a simpler approach work?

**Language-specific gotchas**
- Load the relevant reference file and check for patterns listed there.

## Output format

Group findings by severity. Within each tier, list findings in file order. Skip tiers that have no findings.

```
## Critical

- `filename.js:42` — [what the problem is and why it matters]. Fix: [specific change to make].

## Major

- `filename.js:17` — [problem]. Fix: [change].

## Minor

- `filename.js:88` — [problem]. Fix: [change].

## Nit

- `filename.js:5` — [observation]. Optional: [suggestion].
```

If there are no findings, say so plainly: "No issues found." Don't invent feedback to fill space.

## Tone

Be direct, not harsh. The goal is to help, not to demonstrate thoroughness. A three-item review that catches the real problems is better than a fifteen-item review padded with Nits. If the code is good, say so.
