---
name: skills-repo
description: Manage the claude-skills repository — add, update, or remove skills and keep the repo, install script, and README in sync. Use this skill whenever the user wants to add a new skill, edit an existing skill's content or metadata, remove a skill, or re-install skills globally. Trigger on phrases like "add a skill to the library", "create a new skill", "update the skills repo", "remove a skill from the repo", "install the skills", "I want a skill that does X", or any time changes need to be made to the shared skills library. Also trigger when someone describes a workflow they want captured as a reusable skill, even if they don't use the word "skill" — if it sounds like something they'd want Claude to do repeatedly across projects, this is the right skill.
---

# Skills Repo Manager

Manage the claude-skills repository at `~/Repos/claude-skills`. The repo is the source of truth for shared skills — changes made here get installed globally and are available in every Claude Code session.

Three things must always stay in sync. When any one of them is out of date, the skill either doesn't work, doesn't install, or doesn't appear in the README for others to discover:

1. **The skill directory** — `<category>/<skill-name>/SKILL.md` (and optional `references/`)
2. **`install.sh`** — copies each skill flat into `~/.claude/skills/`
3. **README.md** — the skills table is how people know what exists

---

## Repo structure

```
~/Repos/claude-skills/
├── install.sh
├── README.md
├── context-handoff/        ← top-level for cross-cutting skills
├── skills-repo/            ← this skill
├── developer/              ← category folder (not reproduced on install)
│   └── <skill-name>/
│       ├── SKILL.md
│       └── references/     (optional)
└── product-manager/        ← category folder (not reproduced on install)
    └── <skill-name>/
        ├── SKILL.md
        └── references/     (optional)
```

**Why the flat install matters:** Claude Code discovers skills exactly one level deep in `~/.claude/skills/`. If a skill lands at `~/.claude/skills/developer/code-review/`, Claude won't find it — only `~/.claude/skills/code-review/` works. The category folders (`developer/`, `product-manager/`) are purely for repo organisation and must not be reproduced in the install location.

---

## Adding a skill

1. Determine the category — `developer/`, `product-manager/`, or top-level for cross-cutting skills
2. Create `<category>/<skill-name>/SKILL.md` with frontmatter:
   ```markdown
   ---
   name: skill-name
   description: [when to trigger and what it does — include positive and negative trigger examples]
   ---
   ```
3. Add a `references/` directory if the skill needs templates, examples, or tooling notes
4. Add a line to `install.sh` that copies the skill directly into `$SKILLS_DIR/`:
   ```sh
   cp -r "$SCRIPT_DIR/category/skill-name" "$SKILLS_DIR/"
   ```
   Also add the skill name to the output list at the bottom of the script. Each skill needs its own `cp -r` line — copying a whole category folder would put skills one level too deep and break discovery. **Only new skill directories need a new `cp -r` line** — adding or editing files inside an existing skill directory doesn't require touching `install.sh`.
5. Add a row to the appropriate table in `README.md` with the skill name and a one-line description. Also add the directory to the repo structure diagram in the README.
6. Re-run install: `cd ~/Repos/claude-skills && ./install.sh`
7. Commit and push

---

## Updating a skill

1. Edit `SKILL.md` and any `references/` files directly in the repo. Adding a new file inside an existing skill's `references/` directory doesn't require touching `install.sh` — the existing `cp -r` line copies everything in the skill directory.
2. Re-run install to sync the changes to `~/.claude/skills/`: `cd ~/Repos/claude-skills && ./install.sh`
3. If the skill name changed, update `install.sh` and the README too — then delete the old installed skill manually (`rm -rf ~/.claude/skills/<old-name>`) since install only copies, it never cleans
4. Commit and push

---

## Removing a skill

1. Delete the skill directory from the repo
2. Remove its `cp -r` line from `install.sh` and its entry in the output list
3. Remove its row from the README table and its entry from the repo structure diagram
4. Delete the installed copy: `rm -rf ~/.claude/skills/<skill-name>` — install won't do this automatically
5. Commit and push

---

## Re-installing globally

```sh
cd ~/Repos/claude-skills && ./install.sh
```

Safe to run any time — it overwrites existing installed skills with the current repo versions. Run this after any change to make sure the global install reflects the repo.

---

## After any change

Always commit. The repo is the canonical source — uncommitted changes can get lost or cause confusion about what's actually installed vs. what's in the repo.
