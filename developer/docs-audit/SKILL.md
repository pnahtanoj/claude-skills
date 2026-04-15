---
name: docs-audit
description: >
  Audit a project's documentation tree for navigation gaps, staleness,
  duplication, broken cross-references, inconsistent formatting, and
  structural problems. Produces a prioritized findings report with severity
  levels, a proposed navigation index, and a remediation roadmap — then
  offers to fix issues directly. Use this skill whenever the user wants
  documentation reviewed, asks about doc quality, wants to clean up a docs
  directory, or says things like "review my docs", "audit the documentation",
  "are the docs well organized", "is the documentation getting unwieldy",
  "clean up the docs", "docs health check", "is anything stale in docs",
  or "create a docs index". Also trigger when a project has 15+ markdown
  files and the user mentions documentation being hard to navigate or find
  things in. Do NOT trigger for reviewing a single document's content quality
  (use research-review or design-critique), reviewing code (use code-review),
  or creating new documentation from scratch.
---

# Documentation Audit

Audit a project's documentation tree for problems that make docs hard to
use: missing navigation, stale content, duplication, broken references,
inconsistent structure, and readability issues. The goal is to make the
documentation set work as a coherent whole — not just a pile of files.

---

## Step 1: Scope the audit

Find all documentation in the project. Documentation can live in many places:

| Location | What to look for |
|----------|------------------|
| `/docs/` or `/documentation/` | Primary docs directory |
| Root-level `.md` files | README, PROJECT, CONTRIBUTING, CHANGELOG, etc. |
| `wiki/` or `guides/` | Alternative doc locations |
| Nested READMEs | `src/*/README.md`, module-level docs |
| Config docs | CLAUDE.md, STANDARDS.md, .github/*.md |

Build an inventory: every markdown file, its path, line count, and last
modified date (`git log -1 --format="%ai" -- <file>` for each file, or
`ls -la` if not in a git repo).

Before diving in, understand the project context:
- What is this project? Read the README and any CLAUDE.md.
- Who are the docs for — the team, external users, onboarding, or a mix?
- Is there an existing organizational scheme (directories, naming conventions)?
- How many total docs and total lines are you dealing with?

State these numbers up front so the user knows the scale.

### Scale the audit to the project

The depth and shape of the audit should match the size of the docs set.
A 10-doc project doesn't need the same treatment as a 60-doc one.

| Project size | Approach |
|--------------|----------|
| **< 10 docs** | Short report. Skip dimensions that obviously don't apply (e.g., "navigation index" for 5 files). Focus on the 1-3 most impactful findings rather than grinding through all 7 dimensions. |
| **10–25 docs** | Full dimension sweep, but compressed findings. Usually doesn't need a separate standalone index file — a section within the report is enough. |
| **25+ docs** | Full audit with separate navigation index file, compound problems section, detailed health summary. |

The principle: the audit should be proportionate to the problem. A
10-finding report for a 9-doc project isn't thorough — it's padded.
A 5-finding report that names the real problems is better.

---

## Step 2: Audit by dimension

Work through each dimension in order. Not every dimension will have
findings — skip the ones that are clean.

### Navigation & Discoverability

Why it matters: if people can't find docs, they don't exist. This is
the single most impactful thing to get right.

- Is there an index or table of contents at the docs root (`/docs/README.md`
  or equivalent)?
- Can a new team member figure out where to start and what to read next?
- Are docs organized into logical groups (directories, naming prefixes)?
- Is there a clear reading order for onboarding, or does every doc feel
  equally weighted?
- Are related docs placed near each other, or scattered across the tree?

### Freshness & Staleness

Why it matters: stale docs are worse than no docs — they actively mislead.

- Do docs have "Last updated" dates, or can freshness be inferred from git?
- Are any docs clearly outdated — referencing things that no longer exist,
  describing states that have changed, or using past dates as future ones?
- Are there placeholder/stub docs that were never completed? Are they
  marked as such?
- Are meeting notes or session logs that are purely historical still
  sitting alongside active reference docs?

Flag docs as stale only with evidence — a file being old isn't the same
as being wrong. Check git log and content before calling something stale.

### Cross-file factual consistency

Why it matters: when the same fact is stated in multiple docs, any one
of them being wrong creates confusion — but all of them being wrong in
different ways creates paralysis. The reader can't tell which is correct.

- Are key numbers consistent across docs (site counts, model counts,
  file counts, dates)? Grep for recurring metrics and compare.
- Do docs contradict each other on status, ownership, or decisions?
- If the README says "19 warehouses" and another doc says "20", that's
  not a style issue — that's a fact that needs to be resolved.

This often turns up alongside duplication: when the same topic is
covered in multiple places, the details drift. Catching it is one of
the most valuable things an audit can do.

### Overlap & Duplication

Why it matters: duplicated content drifts. When the same fact lives in
two places, one will be updated and the other won't — creating
contradictions.

- Do any docs cover substantially the same topic?
- Is the same information repeated across files (architecture described
  in both an overview doc and an ADR, a process described in both a
  reference doc and meeting notes)?
- If overlap exists, is there a clear "source of truth" and do the other
  docs defer to it?
- Are there superseded docs that should be archived or removed?
- Are there multiple docs competing to be the "start here" or "current
  state" reference with no clear winner? That's overlap too.

Overlap between an overview and a detailed doc is fine if the overview
explicitly points to the detail. Overlap where both docs act as
authoritative is the problem.

**Name it explicitly.** When you find overlap, label the finding clearly
— use the word "Overlap" or "Duplication" in the finding header. This
is a common pattern that auditors see and describe but then file under
vaguer labels like "unclear structure" or "confusing entry points."
Readers skim severity-tiered reports looking for known categories.
If they're scanning for duplication issues, they should see the word.

Common cases worth calling out explicitly:
- **Superseded docs still in the active tree** — e.g., ADR-005 marked
  superseded by ADR-006 but still sitting in `decisions/`. This is
  overlap between the old authority and the new one.
- **Competing entry points** — README, a session handoff, and a
  PROJECT.md all acting as "start here" with different subsets of info.
  This is overlap between docs that should have distinct roles.
- **Multiple docs covering the same subsystem** — three API references,
  two onboarding guides, four "current status" docs. Pick the source
  of truth and mark the others as historical or delete them.

### Cross-References & Links

Why it matters: docs that reference each other by name but don't link
force readers to search manually. Broken links are dead ends.

- Are cross-references between docs implemented as markdown links, or
  just plain text mentions?
- Do any markdown links point to files that don't exist (broken links)?
- Are there docs that should reference each other but don't?
- Is there a consistent linking convention (relative paths, absolute
  paths, mixed)?

To check broken links, extract all markdown links (`[text](path)`) and
verify each target file exists. Report the count and list the broken ones.

### Structure & Organization

Why it matters: poor structure means every new doc gets dropped wherever
is convenient, accelerating entropy.

- Does the directory structure reflect logical groupings?
- Are directories named clearly — would someone unfamiliar know what's
  in `reference/` vs. `docs/`?
- Are there docs in the wrong directory (meeting notes in architecture/,
  architecture docs in reference/)?
- Is the top level cluttered with files that belong in subdirectories?
- Are naming conventions consistent (kebab-case, dates in filenames, etc.)?

### Consistency & Formatting

Why it matters: inconsistent formatting creates cognitive overhead and
signals neglect.

- Do docs follow a consistent header structure (title, status/date, body)?
- Are status indicators used consistently (same emoji set, same banner
  format, same status vocabulary)?
- Is the heading hierarchy clean (H1 for title, H2 for sections, etc.)?
- Are tables, code blocks, and lists formatted consistently across docs?
- Is there a mix of styling conventions that suggests different authors
  with different habits?

Don't flag style preferences — flag inconsistencies within the same
project that make docs harder to scan.

### Length & Readability

Why it matters: a 2,000-line doc without a table of contents is a wall
that people skim past or avoid entirely.

- Are any docs over 500 lines? If so, do they have a table of contents
  or clear section structure?
- Could any long docs be split into a summary + detailed appendix?
- Are there docs that try to cover too many topics in one file?
- Are there docs so short they could be merged with a related doc?

---

## Step 3: Identify compound problems

After reviewing individual dimensions, look for combinations that make
the documentation worse than the sum of the parts:

- **No index + deep nesting** = docs are effectively unfindable without
  someone telling you the path
- **Duplication + no dates** = impossible to tell which version is current
- **Stale stubs + no status markers** = readers can't tell if a doc is
  incomplete or intentionally brief
- **Long docs + no cross-references** = readers re-read sections they've
  seen in another doc because they can't tell the docs are related
- **Inconsistent structure + many authors** = each doc reads like it
  belongs to a different project

Call these out as compound problems at the top of your findings — they
set the context for why individual findings matter.

---

## Step 4: Build a navigation map

Regardless of findings severity, produce a proposed navigation map — a
recommended reading order organized by audience or purpose. This becomes
the basis for a `/docs/README.md` or equivalent index.

**Use clickable markdown links, not plain text paths or code blocks.**
This sounds obvious but it's the single most common place this skill's
output beats a casual audit: write `[Platform Overview](docs/architecture/platform-overview.md)`,
not `` `docs/architecture/platform-overview.md` `` or an ASCII tree
with `├──` characters. A navigation index whose entries aren't
clickable is a list of filenames — it's not actually a navigation aid.
Verify the relative paths are calibrated for where the index will live.

Structure it as:

```markdown
## Proposed Navigation Index

### Start here
- [Project Overview](README.md) — what this project is and why it exists
- [Architecture Overview](docs/architecture/platform-overview.md) — how the system works

### Key references
- [Schema Reference](docs/discovery/by-schema-reference.md) — authoritative data dictionary
- ...

### Decisions
- [ADR-001: ...](docs/architecture/decisions/001-...)
- ...

### Meeting notes & session history
- [Session Log](docs/meeting-notes/session-log.md)
- ...
```

Group docs by how people actually use them (onboarding, reference,
decisions, historical), not by the directory structure. If the directory
structure doesn't match usage patterns, note that in the findings.

### When the navigation index IS the primary ask

If the user explicitly asked for a navigation index (e.g., "create a docs
index", "I need a navigation guide", "the team can't find anything"),
produce the index as a **standalone file** — not embedded in the middle
of the findings report. Save it as `navigation-index.md` (or a similarly
named file) ready to drop in at `/docs/README.md`.

The audit report should still surface the other findings, but in this
case it's supporting material. The index is the deliverable. Two files
beats one in this scenario because:

- The user can commit the index without editing it out of a larger report
- The paths in the index are calibrated for its final location, not for
  wherever the report lives
- It signals that you've actually produced a thing that solves the
  problem, not just written about the problem

Even when the nav index isn't the primary ask, producing it as a
standalone file is often the right call if the project is large enough
that the index would be a real artifact (say, 20+ docs).

---

## Step 5: Present findings

### Severity tiers

**Critical** — Docs are actively misleading: contradictions between docs
that claim to be authoritative, broken links in high-traffic paths,
stale content presented as current with no warning. Must fix now.

**Major** — Docs are hard to use: no navigation index, significant
duplication without a clear source of truth, long docs with no TOC,
important cross-references missing. Should fix soon.

**Minor** — Docs have rough edges: inconsistent date formats, mixed
linking conventions, a few misplaced files, placeholder stubs without
status markers. Fix when convenient.

**Nit** — Style preferences: heading capitalization, emoji choices,
file naming conventions for new docs. Mention but don't dwell.

### Output format

Present findings grouped by severity, then by dimension within each tier.
Skip empty tiers.

```
## Compound Problems

- **No index + 58 files across 11 directories** — A new team member has
  no entry point. They must either know the right filename or browse every
  directory. This is the single highest-impact fix. Create a `/docs/README.md`
  with a reading-order navigation map.

## Major

- **Navigation** — No `/docs/README.md` or index file. With 58 docs across
  11 subdirectories, there's no guided entry point for new readers.
  Fix: create a navigation index (proposed map below).

- **Length** — `docs/discovery/widget-sql-analysis.md` (1,995 lines) has
  no table of contents. Fix: add a TOC at the top, or split into summary
  + appendix.

## Minor

- **Cross-references** — 12 plain-text references to other docs that
  should be markdown links. Fix: convert to `[text](relative/path.md)`.

- **Consistency** — 8 docs have "Last updated:" headers, 14 don't. Either
  add dates to all docs or rely on git history and remove the headers.
```

After findings, include:

### Documentation health summary

| Metric | Value |
|--------|-------|
| Total docs | 58 |
| Total lines | ~14,800 |
| Docs with dates | 8 / 58 |
| Broken links | 3 |
| Docs over 500 lines | 4 |
| Findings | 2 Critical, 5 Major, 8 Minor, 3 Nit |

### Remediation roadmap

Sequence fixes into a practical order. Group by what can be done together
and note effort level.

**Example:**
```
## Remediation roadmap

1. **Create navigation index** (~30 min)
   Write /docs/README.md with reading-order links grouped by purpose.
   Highest-impact single change.

2. **Add TOCs to long docs** (~20 min)
   Add markdown TOCs to the 4 docs over 500 lines.

3. **Convert plain-text references to links** (~15 min)
   Fix the 12 plain-text cross-references identified above.

4. **Standardize date headers** (~10 min)
   Add "Last updated:" to the 14 docs missing it, using git log dates.
```

---

## Step 6: Fix and re-review

After presenting findings, offer to fix issues. If the user accepts,
**fix in severity order — Critical first, then Major, then Minor** —
regardless of category. Don't follow a fixed category sequence when a
Critical finding sits lower in the list.

Within a severity tier, sequence by impact and effort:

1. **Critical** — broken links in high-traffic paths, contradictions
   between authoritative docs, factual errors that would mislead readers.
   Fix before anything else.
2. **Major** — the big structural work: create the navigation index
   (almost always the highest-impact Major fix), add TOCs to long docs,
   resolve duplication between "source of truth" docs.
3. **Minor** — consistency work: convert plain-text references to
   markdown links, standardize date headers, add status banners to stubs.

If there are no Critical findings, start with the Major fix that has
the largest reach — typically the navigation index, because it affects
how every other doc is found.

Do NOT:
- Rewrite doc content (that's not this skill's job)
- Delete docs without asking (even stale ones — the user may want to archive)
- Reorganize the directory structure without confirmation (too disruptive)
- Add content to stub docs (flag them; the user decides what to write)

After fixes, re-review the changed files. Run up to 2 passes:
1. Fix -> re-review -> fix remaining
2. Final review -> report what remains

Then report:
- **What was fixed** — brief list of changes
- **What remains** — items requiring user decisions (deletions, reorganization,
  content rewrites)
- Ask: *"Want me to go another round on the remaining items?"*

---

## Principles

**Navigation is the number-one problem.** In almost every project, the
biggest documentation issue isn't content quality — it's findability.
Prioritize navigation and discoverability findings above all others.

**Stale is worse than missing.** A doc that doesn't exist produces a
"file not found." A doc that exists but is wrong produces a confident
mistake. When flagging staleness, explain what's wrong, not just that
the file is old.

**Don't confuse "long" with "bad."** An authoritative 1,200-line reference
doc is fine if it has a TOC and clear sections. A 200-line doc that
covers three unrelated topics is worse. Judge by whether a reader can
find what they need, not by line count alone.

**Respect intentional structure.** If docs are organized by topic
(architecture/, discovery/, meeting-notes/), don't reorganize by
audience unless the user asks. Instead, bridge the gap with an index
that provides the audience-oriented view on top of the topic-oriented
structure.

**Audit the forest, not the trees.** This skill reviews the documentation
set as a whole. Don't critique individual doc content quality — that's
research-review's or design-critique's job. Focus on how docs relate to
each other, whether people can find them, and whether the set is
consistent and maintainable.

**But flag serious adjacent issues if you see them.** If a config file
has hardcoded credentials, if a doc reveals a security problem, if
there's a clear factual contradiction with real consequences — mention
it, even if it's technically out of scope for a docs audit. Call it out
as an "Adjacent finding" section so it's clear you're stepping outside
the primary audit. The user came for a docs review, but they'd rather
learn about the credential leak than have you ignore it to stay in lane.

**Know when the docs are healthy.** If the documentation is well-organized,
navigable, consistent, and fresh — say so. Not every audit needs a long
findings list. A clean bill of health is a valid and valuable result.
