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
| `researcher` | Investigates a product space via web research and produces a structured, dated research brief (competitive landscape, user pain points, pricing, gaps) in `research/` |
| `research-review` | Audits a research document (vendor eval, competitive analysis, research brief) for factual accuracy, cross-references against project context, verifies claims via web research, and produces a findings report with recommended edits |
| `user-story-flow` | Turns a product idea into structured user stories, a numbered flow (happy path + alternates + errors), and testable acceptance criteria |
| `requirements-doc` | Consolidates stories, critique findings, and decisions into a lean PRD |
| `design-critique` | Reviews designs across 5 dimensions (UX, visual, feasibility, scope, goal consistency) and returns a prioritized, severity-rated findings list |
| `feature-prioritization` | Stack-ranks features against explicit criteria (impact, fit, effort, confidence, risk) with a visible recommendation |
| `ticket-creator` | Transforms rough ideas into complete engineering tickets with user story, acceptance criteria, test scenarios, and out-of-scope bounds |
| `ticket-review` | Audits existing tickets in `tickets/` for gaps, vague criteria, and missing scope — fixes them in place and reports what changed |
| `ticket-status` | Scans `tickets/` and outputs a live board view (done / in-progress / available / blocked) derived from YAML frontmatter — no memory, always accurate |
| `discovery-doc` | Creates and maintains a living discovery document — structures findings, tracks open questions, synthesizes stakeholder input during early project investigation |

### Developer

| Skill | What it does |
|---|---|
| `architecture-decision` | Guides a technical decision through trade-off analysis and produces a MADR-format ADR saved to `docs/decisions/` |
| `stack-decision` | Same as above but focused on technology/library/framework choices — adds ecosystem health, escape hatch, and maintenance burden lenses |
| `browser-extension-scaffold` | Generates a working Manifest V3 browser extension scaffold (manifest, popup HTML/JS/CSS) and writes files to the project |
| `code-review` | Reviews code with severity-tiered findings (Critical / Major / Minor / Nit) and specific, actionable fixes |
| `standards-check` | Checks code against a project `STANDARDS.md` — severity-tiered findings, auto-fixes in-file violations, flags structural changes for the user |
| `standards-create` | Authors a `STANDARDS.md` from scratch — explores the codebase, surfaces existing conventions, interviews the user, and produces a grounded, checkable standards doc |
| `technical-spike` | Structures and runs a timeboxed technical spike — define a hypothesis, execute the investigation, and produce a findings document with a clear recommendation |
| `data-modeling` | Designs and documents data models, schemas, entity relationships, source-to-target mappings, and data layer architecture (medallion, star schema, etc.) |
| `infrastructure-scaffold` | Generates infrastructure-as-code boilerplate (Terraform, Bicep, CDK) for cloud resources — opinionated, secure defaults, ready to plan and apply |
| `test-writer` | Reads a JS file and writes a Vitest test suite alongside it — covers pure functions, state transitions, and DOM interactions, with jsdom and chrome API setup handled automatically |
| `mcp-manager` | Manages MCP server configurations — adds entities to DAB configs with schema validation, scaffolds new DAB or general MCP servers, and debugs startup failures with a known-issues playbook |
| `dbt-modeler` | Generates dbt models (staging + gold), sources.yml, schema.yml with tests and docs — reads existing project conventions and schema references to produce working SQL files |

### Cross-cutting

| Skill | What it does |
|---|---|
| `context-handoff` | Captures session state into a structured handoff — either a human-readable session summary or a CLAUDE.md block for Claude Code |
| `skills-repo` | Manages this repo — add, update, or remove skills and keeps the skill directory, `install.sh`, and README table in sync |
| `skill-creator` | Creates new skills, runs eval loops with test prompts and benchmarking, iterates based on feedback, and optimizes skill descriptions for triggering accuracy |

---

## Install

### Global install (recommended)

Installs skills into `~/.claude/skills/` so they're available in every project.

```sh
git clone https://github.com/pnahtanoj/claude-skills.git ~/Repos/claude-skills
cd ~/Repos/claude-skills
./install.sh
```

Or install manually:

```sh
mkdir -p ~/.claude/skills
cp -r context-handoff ~/.claude/skills/
cp -r developer/architecture-decision developer/browser-extension-scaffold \
      developer/code-review developer/stack-decision developer/test-writer \
      ~/.claude/skills/
cp -r product-manager/design-critique product-manager/feature-prioritization \
      product-manager/requirements-doc product-manager/ticket-creator \
      product-manager/user-story-flow ~/.claude/skills/
```

> **Note:** Skills must be installed flat into `~/.claude/skills/<skill-name>/` — Claude Code discovers skills one level deep only. The category folders (`developer/`, `product-manager/`) are for repo organisation and are not reproduced in the install location.

### Project-level install

To add skills to a specific project only, copy into `.claude/skills/` at the project root:

```sh
cp -r context-handoff developer product-manager /path/to/your-project/.claude/skills/
```

### Project-level install via git submodule

For teams that want skills pinned to a specific version and committed to the project repo, use a submodule. This means everyone who clones the repo gets the same skills automatically.

```sh
# In your project root
git submodule add https://github.com/pnahtanoj/claude-skills.git .claude/skills
git commit -m "Add claude-skills as submodule"
```

Team members cloning the repo for the first time:

```sh
git clone --recurse-submodules https://github.com/your-org/your-repo.git
# or, if already cloned:
git submodule update --init
```

To update to a newer version of the skills:

```sh
git submodule update --remote .claude/skills
git commit -m "Update claude-skills to latest"
```

**Tradeoffs vs global install:**
- Skills travel with the repo and are version-pinned — good for team consistency
- Updating is a manual, deliberate step — you won't pick up changes accidentally
- `git clone` requires `--recurse-submodules` or a follow-up init step, which is easy to forget
- Submodules have a reputation for being confusing; global install is simpler for most teams

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
├── skills-repo/
│   └── SKILL.md
│       ├── handoff-formats.md
│       ├── mcp-usage.md
│       └── examples.md
├── skill-creator/
│   ├── SKILL.md
│   ├── agents/
│   │   ├── analyzer.md
│   │   ├── comparator.md
│   │   └── grader.md
│   ├── assets/
│   │   └── eval_review.html
│   ├── eval-viewer/
│   │   ├── generate_review.py
│   │   └── viewer.html
│   ├── references/
│   │   └── schemas.md
│   └── scripts/
├── developer/
│   ├── architecture-decision/
│   │   └── SKILL.md
│   ├── browser-extension-scaffold/
│   │   └── SKILL.md
│   ├── code-review/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── js-gotchas.md
│   ├── stack-decision/
│   │   └── SKILL.md
│   ├── test-writer/
│   │   └── SKILL.md
│   ├── standards-check/
│   │   └── SKILL.md
│   ├── standards-create/
│   │   └── SKILL.md
│   ├── technical-spike/
│   │   └── SKILL.md
│   ├── data-modeling/
│   │   └── SKILL.md
│   ├── infrastructure-scaffold/
│   │   └── SKILL.md
│   ├── mcp-manager/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── dab-wrapper-template.sh
│   └── dbt-modeler/
│       ├── SKILL.md
│       └── references/
│           └── best-practices-sources.md
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
    ├── researcher/
    │   └── SKILL.md
    ├── research-review/
    │   └── SKILL.md
    ├── ticket-review/
    │   └── SKILL.md
    ├── ticket-status/
    │   └── SKILL.md
    ├── user-story-flow/
    │   ├── SKILL.md
    │   └── references/
    └── discovery-doc/
        └── SKILL.md
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
