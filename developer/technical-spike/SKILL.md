---
name: technical-spike
description: Structure and run a timeboxed technical spike — define a hypothesis, plan the investigation, execute it, and produce a findings document with a clear recommendation. Use this skill whenever the user needs to investigate feasibility, test connectivity, evaluate a technology hands-on, prototype an approach, or answer a technical unknown before committing to implementation. Trigger on phrases like "spike on...", "can we connect to...", "is it possible to...", "test whether...", "investigate how...", "proof of concept for...", "feasibility of...", or any time a technical question needs to be answered empirically rather than theoretically. Do NOT trigger for architecture decisions that don't require hands-on investigation — use architecture-decision or stack-decision for those.
---

# Technical Spike Skill

Your job is to help the user structure, execute, and document a timeboxed technical spike. A spike answers a specific technical question through hands-on investigation — not theory, not discussion, but trying things and reporting what happened.

## Process

### 1. Frame the spike

Before touching anything, get clear on what you're investigating. You need:

- **The question** — what specific thing are you trying to find out? ("Can we read from the BY replication DB via pyodbc?" not "look into database stuff")
- **Success criteria** — what does a successful spike look like? Be concrete. ("A Python script that connects, runs a SELECT, and prints rows" not "understand the database")
- **Timebox** — how much effort is this worth? If the user doesn't specify, suggest one. Most spikes should be 1-4 hours of work. If it's bigger, it's probably not a spike — it's a project.
- **Scope boundaries** — what is explicitly NOT part of this spike? This prevents scope creep.

If the user's message already covers these clearly, move straight to step 2. Don't ask questions you already have answers to.

### 2. Plan the approach

Outline 3-7 concrete steps you'll take to answer the question. These should be specific and sequential:

```
1. Install pyodbc and check driver availability
2. Construct connection string from provided credentials
3. Attempt connection and handle auth errors
4. Run a simple SELECT against a known table
5. Inspect result schema and row counts
```

Share this plan with the user before executing. They may know shortcuts or have constraints you're missing.

### 3. Execute and narrate

Work through the steps. As you go:

- **Try the simplest thing first.** Don't over-engineer a spike.
- **Record what works and what doesn't.** Failed attempts are findings too.
- **Note exact error messages, versions, and config** that mattered. Future-you needs these.
- **Stop when you have your answer.** A spike is not a polished implementation. The moment you can answer the question, stop building and start documenting.
- **Only report what actually happened.** Never fabricate specific numbers, latencies, row counts, or error messages. If the spike hasn't been executed yet, leave the Findings section as a template with `[TBD]` markers. A spike document with honest gaps is useful; one with invented data is dangerous.

If you hit a dead end, say so. Pivoting or declaring "this approach doesn't work" is a valid spike outcome.

### 4. Produce the findings document

Once the investigation is complete, write a spike document.

**Where to save:** `docs/spikes/` — create the directory if it doesn't exist. Filename: `YYYY-MM-DD-short-title.md` (e.g., `2026-03-30-by-replication-db-connectivity.md`).

Use this template:

```markdown
# Spike: [Short title]

Date: YYYY-MM-DD
Status: Complete
Timebox: [actual time spent] / [budgeted time]

## Question

[The specific question this spike set out to answer — one sentence.]

## Success Criteria

- [criterion 1]
- [criterion 2]

## Scope

**In scope:**
- [what this spike covers]

**Out of scope:**
- [what this spike explicitly does NOT cover — prevents scope creep]

## Approach

[Brief description of what was tried, in order. Include tools, libraries, and versions.]

## Findings

[What you learned. Be specific — include connection strings (redact secrets), commands that worked, error messages that didn't, versions that matter. Organize by sub-question if the spike had multiple parts.]

### What worked

- [finding]

### What didn't work

- [finding — and why]

### Surprises

- [anything unexpected that's worth knowing]

## Recommendation

[Clear, direct recommendation. "We should proceed with X because..." or "This approach is not viable because..." Don't hedge — the point of a spike is to make a call.]

## Next Steps

- [ ] [concrete action item]
- [ ] [concrete action item]

## Artifacts

[Links or paths to any code, scripts, config files, or screenshots produced during the spike. If you wrote a prototype script, keep it — don't delete spike artifacts.]
```

### 5. Clean up

Spike code is throwaway by default — but don't delete it. Move prototype scripts or config into a `docs/spikes/artifacts/` directory or note their location in the findings doc. Someone will want to reference them later.

## Tips

- A spike that proves something *won't* work is just as valuable as one that proves it will. Document negative results with the same rigour.
- If the spike takes longer than the timebox, stop and document what you know so far. The timebox exists to prevent rabbit holes.
- Keep spike code minimal and ugly. Its job is to answer a question, not to be production-ready. If you catch yourself refactoring spike code, stop.
- The Recommendation section is the most important part. Everything else is supporting evidence for that recommendation.
- If the spike reveals that the original question was wrong or too broad, say so. Reframing the question is a valid outcome.
