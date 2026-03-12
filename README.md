# claude-skills

A collection of Claude Code skills for product and engineering teams. Install once globally and use them across every project.

---

## What are skills?

Skills are prompt files that teach Claude Code how to run specific workflows — producing PRDs, writing tickets, reviewing code, making architecture decisions, and more. Each skill has a trigger description that tells Claude when to activate it, and a structured set of instructions that shape how it works.

Skills live in your Claude config directory and are available in every Claude Code session.

---

## Skills

### Product Manager

| Skill | What it does |
|---|---|
| `user-story-flow` | Turns a product idea into structured user stories, a numbered flow (happy path + alternates + errors), and testable acceptance criteria |
| `requirements-doc` | Consolidates stories, critique findings, and decisions into a lean PRD |
| `design-critique` | Reviews designs across 5 dimensions (UX, visual, feasibility, scope, goal consistency) and returns a prioritized, severity-rated findings list |
| `feature-prioritization` | Stack-ranks features against explicit criteria (impact, fit, effort, confidence, risk) with a visible recommendation |
| `ticket-creator` | Transforms rough ideas into complete engineering tickets with user story, acceptance criteria, test scenarios, and out-of-scope bounds |

### Developer

| Skill | What it does |
|---|---|
| `architecture-decision` | Guides a technical decision through trade-off analysis and produces a MADR-format ADR saved to `docs/decisions/` |
| `stack-decision` | Same as above but focused on technology/library/framework choices — adds ecosystem health, escape hatch, and maintenance burden lenses |
| `browser-extension-scaffold` | Generates a working Manifest V3 browser extension scaffold (manifest, popup HTML/JS/CSS) and writes files to the project |
| `code-review` | Reviews code with severity-tiered findings (Critical / Major / Minor / Nit) and specific, actionable fixes |

### Cross-cutting

| Skill | What it does |
|---|---|
| `context-handoff` | Captures session state into a structured handoff — either a human-readable session summary or a CLAUDE.md block for Claude Code |

---

## Install

### Global install (recommended)

Installs skills into `~/.claude/skills/` so they're available in every project.

```sh
git clone https://github.com/YOUR_ORG/claude-skills.git ~/Repos/claude-skills
cd ~/Repos/claude-skills
./install.sh
```

Or install manually:

```sh
cp -r context-handoff developer product-manager ~/.claude/skills/
```

### Project-level install

To add skills to a specific project only, copy into `.claude/skills/` at the project root:

```sh
cp -r context-handoff developer product-manager /path/to/your-project/.claude/skills/
```

---

## Usage

After installing, skills activate automatically when you use Claude Code. Just describe what you want:

- *"Write user stories for the onboarding flow"* → `user-story-flow`
- *"Review this code"* → `code-review`
- *"Should we use Redis or in-memory state?"* → `stack-decision`
- *"Turn this into a ticket"* → `ticket-creator`
- *"Wrap up this session"* → `context-handoff`

You can also invoke skills explicitly by name: *"Use the design-critique skill on this flow."*

---

## Customizing for your project

Each skill has a `references/` directory containing templates and a **Notes for Customization** section. This is where you add project-specific conventions — personas, ticket formats, sizing guidelines, design system standards, etc.

Claude reads these sections automatically when running the skill. Entries there are treated as hard requirements, not suggestions.

**Example:** To add ticket sizing to `ticket-creator`, edit `ticket-creator/references/ticket-template.md` and add your sizing guidelines to the Notes for Customization section at the bottom.

---

## How skills learn from your feedback

Each skill's `references/examples.md` file stores approved outputs. When you tell Claude an output is good, it appends it there as a style reference for future sessions.

These files accumulate project-specific quality patterns over time — the skill gets better at matching your team's preferences without you having to explain them again.

---

## Structure

```
claude-skills/
├── context-handoff/
│   ├── SKILL.md
│   └── references/
│       ├── handoff-formats.md
│       ├── mcp-usage.md
│       └── examples.md
├── developer/
│   ├── architecture-decision/
│   │   └── SKILL.md
│   ├── browser-extension-scaffold/
│   │   └── SKILL.md
│   ├── code-review/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── js-gotchas.md
│   └── stack-decision/
│       └── SKILL.md
└── product-manager/
    ├── design-critique/
    │   ├── SKILL.md
    │   └── references/
    ├── feature-prioritization/
    │   ├── SKILL.md
    │   └── references/
    ├── requirements-doc/
    │   ├── SKILL.md
    │   └── references/
    ├── ticket-creator/
    │   ├── SKILL.md
    │   └── references/
    └── user-story-flow/
        ├── SKILL.md
        └── references/
```

Each skill is a directory with a `SKILL.md` (the main prompt) and an optional `references/` folder for templates, examples, and tooling notes.

---

## Contributing

To add a new skill:

1. Create a directory under the appropriate category (`developer/`, `product-manager/`, or top-level for cross-cutting)
2. Write a `SKILL.md` with frontmatter (`name`, `description`) and skill instructions
3. Add a `references/` directory if the skill needs templates or examples
4. Test it in a Claude Code session before opening a PR

The `description` frontmatter field is critical — it controls when Claude activates the skill automatically. Include positive triggers ("use when...") and negative ones ("do NOT trigger for...") to prevent false positives.
