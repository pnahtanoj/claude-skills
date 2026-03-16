---
name: standards-create
description: Author or update a STANDARDS.md — explore the codebase, surface existing conventions, interview the user about team preferences, and produce a grounded, checkable standards document. Use this skill whenever the user wants to set up coding standards, create a STANDARDS.md, add a rule to an existing standards doc, update or change a standard, document conventions, establish a style guide, or says things like "set up standards for this repo", "create a STANDARDS.md", "write up our coding conventions", "I want to document how we do things", "establish guidelines for this project", "add this to our standards", "should this be in our standards", "we need a style guide", or "update our coding standards". Also trigger when the user makes a code style decision (like preferring braces or a naming convention) and asks whether it should be captured in standards. Do NOT trigger for checking or enforcing existing standards — use `standards-check` for that.
---

# Standards Create Skill

Your job is to produce a `STANDARDS.md` file grounded in the actual codebase — not a generic template. The best standards documents reflect what the team already does well (making it explicit) plus a few deliberate decisions about things the codebase is inconsistent on.

## Existing STANDARDS.md vs. creating from scratch

If a `STANDARDS.md` already exists, read it first. You're adding to or amending a living document, not replacing it. Follow the same explore → interview → propose → write sequence, but scope your work to the change at hand:

- If the user made a specific style decision (e.g., "I prefer braces around all if-body statements"), propose the rule, check it doesn't conflict with existing tooling (Prettier, ESLint, etc.), and write it into the right section
- If the user asks "should this be in our standards?", give your recommendation with reasoning before writing anything
- If you're adding a new category, make sure it fits the existing document's structure and tone

The same quality bar applies regardless: specific, checkable, and reasoned.

---

## Phase 1: Explore the codebase

Before asking the user anything, do your own research. You want to arrive at the interview already knowing the answers to the obvious questions. Look at:

- **Stack and language** — what's in `package.json`, `pyproject.toml`, `go.mod`, `Gemfile`, etc.?
- **Directory structure** — where does code live? Are there clear layers (e.g., `routes/`, `services/`, `models/`)?
- **Naming patterns** — are files, functions, and variables consistently named? What conventions are already in use?
- **Existing style tooling** — `.eslintrc`, `.prettierrc`, `ruff.toml`, `.editorconfig`, etc. These represent already-decided standards.
- **Test patterns** — where do tests live? What framework? What's the coverage like?
- **Any existing docs** — `README.md`, `CONTRIBUTING.md`, `docs/` — do any conventions live here already?
- **Recent git history** — `git log --oneline -20` to see the commit message style the team uses

The goal is to understand what the codebase already does consistently — those are your candidate standards.

## Phase 2: Targeted interview

Ask 3–5 focused questions to fill in what the code can't tell you. These should be specific, not open-ended. Good examples:

- "Your code uses both `camelCase` and `snake_case` for variable names — is one preferred, or does it depend on context?"
- "I see no tests in this repo yet — are tests a requirement before shipping, or optional?"
- "You're using both `async/await` and `.then()` chains — is there a preference?"
- "I don't see a pattern for error handling across the codebase — do you have one in mind?"

Avoid generic questions like "what are your coding standards?" — that's what this skill is for.

Also ask: **"What's burned you before?"** — past incidents often reveal the most important standards. A team that got bitten by a race condition in async code will care deeply about a rule the code doesn't surface.

## Phase 3: Draft STANDARDS.md

Write standards grounded in what you found. Structure the document by category, but only include categories that are relevant to this project. Typical categories:

- **Naming conventions** — files, functions, variables, classes, constants
- **File and directory organization** — where things go, what belongs in each layer
- **Code patterns** — idioms to prefer or avoid, with rationale
- **Error handling** — how errors should be surfaced and propagated
- **Comments and documentation** — when to comment, what format
- **Testing** — what to test, where tests live, coverage expectations
- **Git workflow** — commit message format, branch naming, PR expectations
- **Dependencies** — how to add them, what to avoid

### What makes a good standard

Each standard should be:

1. **Specific and checkable** — "Use `const` for all variables unless reassignment is required" is checkable. "Write clean code" is not.
2. **Grounded** — it reflects an actual decision or pattern in this codebase, not a generic best practice
3. **Reasoned** — include a short "why" for non-obvious rules. Future team members will understand and follow rules better when they know the reason.

### Things to avoid

- Don't enumerate every possible rule — a focused document of 20 real standards beats a comprehensive list of 80 that nobody reads
- Don't copy-paste generic style guides wholesale — pull in only what's relevant
- Don't add standards for things that are already enforced by existing tooling (e.g., don't document indentation rules if Prettier handles it — just note that Prettier is authoritative)

### STANDARDS.md format

Use this structure (adapt sections as needed):

```markdown
# [Project Name] Coding Standards

> This document defines the conventions and patterns for this codebase.
> When in doubt, match what's already here. When changing an existing pattern,
> update this document.

## [Category 1]

### Rule name
Description of the rule, specific enough to check.

**Why:** Reason this matters for this project.

**Example:** (only when the rule benefits from illustration)

---

## [Category 2]
...

## Tooling

List any tools that enforce standards automatically (linters, formatters, etc.)
and note that they take precedence over manual rules.
```

## Phase 4: Review and write

Present the draft to the user as a proposal — not as a finished document. Offer to:
- Add/remove/modify any rule
- Adjust the level of strictness on any category
- Add sections you didn't include

Once the user approves, write the file to `STANDARDS.md` in the project root.

Finish by noting: "You can run `/standards-check` at any time to check your code against these standards."

## Important context

This skill is the starting point. Standards documents evolve — the first version just needs to capture the most important decisions and existing patterns. It doesn't have to be complete. A 10-rule STANDARDS.md that's accurate and followed beats a 50-rule one that no one reads.
