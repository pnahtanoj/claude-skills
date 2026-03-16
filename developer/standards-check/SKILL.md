---
name: standards-check
description: Check code compliance against a STANDARDS.md file in the project root. Produces a prioritized findings list with severity levels and actionable fixes, then offers to fix violations. Use this skill whenever the user wants to verify code follows project-specific standards, asks "does this follow our standards", wants a compliance check, says "check standards", "run standards check", or "/standards-check". Also trigger when the user has a STANDARDS.md in their project and asks broadly whether their code is consistent or on-pattern — even if they don't use the word "standards". Do NOT trigger for general code quality reviews unrelated to documented project standards — use `code-review` for those.
---

# Standards Check Skill

Your job is to check code against the project's documented standards and return a prioritized, actionable list of violations. The goal is compliance with deliberate project decisions — not general code quality (that's `code-review`'s job).

## Before you start

1. **Find the standards** — look for `STANDARDS.md` in the project root. If it doesn't exist, stop and tell the user: "No STANDARDS.md found. Create one in the project root to use this skill."
2. **Read the standards fully** before looking at any code. You need to know what you're checking for.
3. **Determine the scope**:
   - If the user named a specific file or directory, check that.
   - Otherwise, default to changed files: run `git diff --name-only HEAD` to find them. If there are no changed files, fall back to `git diff --name-only HEAD~1`.
   - If git isn't available or produces nothing, ask the user which files to check.

## Severity tiers

Use the same tiers as code-review so findings are easy to reason about:

**Critical** — Directly violates a standard marked as required or non-negotiable. The code must not ship this way.

**Major** — Clear violation of a stated standard, even if not explicitly flagged as required. Should fix before merging.

**Minor** — Partially follows the standard but deviates in a way that matters — e.g., naming convention mostly right but inconsistent, pattern applied in some places but not others.

**Nit** — Cosmetic deviation, low stakes. Fix if you're already touching the code.

## How to check

For each file in scope:
- Read the file
- Go through each standard in STANDARDS.md and ask: does this file comply?
- Only flag actual violations — don't invent issues or apply standards that don't exist in STANDARDS.md
- Be specific: cite the exact line(s) and the exact standard being violated

Standards often cover things like:
- Naming conventions (files, variables, functions, classes)
- Code organization and file structure
- Comment and documentation requirements
- Patterns to use or avoid (e.g., "always use X, never use Y")
- Architectural rules (where business logic lives, how layers interact)
- Error handling conventions
- Test requirements or patterns

When a standard is ambiguous, apply reasonable judgment and note the ambiguity in your finding so the user can clarify the standard if needed.

## Output format

Group by severity. Within each tier, list by file. Skip empty tiers.

```
## Critical

- `path/to/file.js:42` — [which standard is violated and how]. Fix: [specific change].

## Major

- `path/to/file.js:17` — [violation]. Fix: [change].

## Minor

- `path/to/file.js:88` — [deviation]. Fix: [change].

## Nit

- `path/to/file.js:5` — [cosmetic deviation]. Optional: [suggestion].
```

If there are no violations, say so plainly: "All checked files comply with STANDARDS.md." Don't invent feedback.

At the end of the findings list, note which standard(s) produced the most violations — this is useful signal for the user about whether the standard needs clarification or the codebase needs broader attention.

## Fix loop

After presenting findings, immediately fix all Critical and Major violations that can be resolved by editing the file directly — no need to ask first. Then re-check and report what was fixed.

Some violations can't be fixed by editing the file alone — they require creating new files, restructuring directories, or making architectural decisions (e.g. "move this DB query to a `repositories/` file that doesn't exist yet"). For these, flag them clearly as **"requires structural change"** and leave them for the user rather than guessing at a fix.

After fixing:
1. Re-check the same files
2. Report what was fixed and what remains
3. Ask the user: *"Want me to go another pass on the Minor/Nit items, or is this good?"*

Cap at 3 passes total.

## Note on future expansion

This skill currently looks only for `STANDARDS.md` at the project root. If your standards grow large enough to warrant splitting into multiple files (e.g., `standards/naming.md`, `standards/architecture.md`), the skill can be extended to read from a `standards/` directory instead.
