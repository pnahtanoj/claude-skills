---
name: jira-pe-tickets
description: >
  Create and structure Jira issues on the iDC Holdings Platform Engineering
  (PE) board — epics, tasks under epics, and subtasks under tasks — with the
  team's labelling conventions, hierarchy rules, and what-not-to-ticket
  guidance. Use this skill whenever the user says "create a jira ticket",
  "new epic in PE", "task under PE-N", "subtask under PE-N", "add to the PE
  board", "ticket in jira", "PE board", or otherwise asks to put work onto
  the PE Jira project. Also use when reviewing or labelling existing PE
  issues. **Load this skill before calling any `mcp__claude_ai_Atlassian__*` tool
  against project PE** — the conventions encoded here change the call
  shape, not just the metadata around it. The common failure when this
  skill is skipped: defaulting to issueType "Story" (PE has no Story),
  creating Subtasks without a Task parent (orphans), labels outside the
  five-category taxonomy, and pre-creating future-phase tickets that
  clutter the kanban — each of which the team then has to clean up.
  Encodes the cloudId, project key, hierarchy semantics, the five-category
  label taxonomy (domain / source-system / activity / wait-state /
  cross-cutting), the five labelling rules, and the
  no-future-phase-clutter convention. Do NOT trigger on bare "ticket" or
  "track this" — those collide with the local `tickets/` directory pattern
  and the `ticket-creator` skill, which writes markdown ticket files
  rather than Jira issues. Do NOT trigger for non-PE Jira projects.
---

# Jira PE Tickets

Conventions and MCP call shapes for the iDC Holdings Platform Engineering (`PE`) Jira board. The board is greenfield — these conventions exist so multiple contributors stay coherent without cloning the data-platform repo.

## Why this exists

`mcp__claude_ai_Atlassian__createJiraIssue` will happily accept whatever you pass it. That's the problem: the default failure mode is calling it with issueType "Story" (PE has no Story), no parent, no labels, and a summary that duplicates what should be in labels. Every such issue gets reworked. This skill encodes the project's call-shape rules and labelling vocabulary so you produce something the team doesn't need to fix.

Treat this as routing-before-call, not commentary-after-the-fact: load the skill, pick the issue type, identify the parent, choose the labels, then make the MCP call.

## Constants

- **cloudId:** `2557a919-ef56-45df-9c0d-10bac6ef8b9e` (site: `idcintl.atlassian.net`)
- **projectKey:** `PE`
- **Issue types in PE:** `Epic`, `Task`, `Subtask`. There is no `Story` type — `Task` fills the story role.

## Hierarchy

| Level | Role | Lifespan | On the kanban board? |
|---|---|---|---|
| Epic | Capex / initiative rollup | Long-lived | No — lives in the Backlog/Epics panel |
| Task | A phase or significant chunk of an epic | Weeks | Yes |
| Subtask | A granular execution unit under a Task | Hours-to-days | Depends on board config (TBD) |

Pick the level by what the work is, not how big it feels in the moment. A vague "I should track this" is almost always a Task or a Subtask, not a new Epic.

## Creating issues — MCP call shapes

Use generic `PE-N` placeholders below. Replace with the actual key when calling.

**Epic** (no parent):
```
mcp__claude_ai_Atlassian__createJiraIssue
  cloudId: <cloudId>
  projectKey: PE
  issueTypeName: "Epic"
  summary: "<title>"
  description: "<body>"
  labels: [<see taxonomy>]
```

**Task under an Epic:**
```
mcp__claude_ai_Atlassian__createJiraIssue
  cloudId: <cloudId>
  projectKey: PE
  issueTypeName: "Task"
  summary, description, labels: ...
  parent: "PE-N"      # the epic key
```

**Subtask under a Task:**
```
mcp__claude_ai_Atlassian__createJiraIssue
  cloudId: <cloudId>
  projectKey: PE
  issueTypeName: "Subtask"
  summary, description, labels: ...
  parent: "PE-N"      # the task key
```

**Hard "blocked by" links.** Use `mcp__claude_ai_Atlassian__createIssueLink` after the issue is created. Call `getIssueLinkTypes` first if you're unsure of the exact link-type name on this site (the standard "Blocks / is blocked by" pair is usually present). State the link you're creating in plain prose before calling so the user can correct.

## Label taxonomy

Five categories. Pick from the listed vocabulary — don't invent new tokens without flagging it to the user.

| Category | When to use | Vocabulary |
|---|---|---|
| Domain (always) | What kind of work it is | infra, dbt, mcp, pipeline, data-modeling, security, docs, research, analysis, app |
| Source system (when applicable) | If a single source system dominates the work | by, toolbox, datamart, netsuite, adena, folio |
| Activity type (always) | What mode of work | build, discovery, decision, audit, ops, enablement |
| Wait state (only when blocked) | External dependency naming | wait-andrew, wait-paul, wait-by-support, wait-matilda, wait-vendor |
| Cross-cutting (rare, deliberate) | Truly board-wide concerns | capex (deferred — don't use yet), customer-facing, breaking-change |

Every issue gets at least one **Domain** and one **Activity type** label. The other categories are situational.

## Five labelling rules

1. **Don't repeat the epic.** If a card lives under an epic whose name carries the domain (e.g., a "dbt foundation" epic), don't re-label that domain on every child.
2. **Don't label what's a field.** Status, priority, assignee, due date are Jira fields, not labels. Putting them in labels duplicates state and rots fast.
3. **Don't label what's in the title.** Phase numbers, epic abbreviations, and similar are already in the summary — labels are for filtering across summaries, not echoing them.
4. **Cap at 4 labels.** If you need 5, the ticket is doing too much — split it.
5. **Wait labels are temporary.** Add when blocked, remove when unblocked. They're the one "state-ish" label allowed because external dependencies recur and the assignee field doesn't capture them.

## Don't pre-create future phases

Ticket only what's flowing in the next 1–2 weeks. Future phases stay in markdown plans and epic descriptions until they're real work. A kanban with 40–60 visible cards stops being readable; a kanban full of speculative phase-3 cards stops being a kanban at all.

If the user asks to create a tranche of forward-looking tickets, push back: ask which ones are starting in the next two weeks, ticket those, and leave the rest in the epic description.

## Open conventions (TBD)

These are unresolved as of skill-write time. When one of these comes up, surface the open question rather than inventing an answer:

- **Grain calibration** — Task vs Subtask boundary. Pending stakeholder conversations.
- **Automation rules** — transitions, auto-assign on label changes.
- **Subtask board display** — whether subtasks render on the kanban or only inside their parent.
- **Story points / estimate scale** — whether and how to estimate.
- **`capex` label usage** — pending finance/exec conversation.
- **Issue-link / "blocked by" patterns** — when to use formal Jira links vs `wait-*` labels vs both.

## Pre-create checklist

Before firing `createJiraIssue`, confirm:

1. **Right level?** Epic / Task / Subtask — see hierarchy table.
2. **Right parent?** Tasks need an epic parent; Subtasks need a task parent. State the parent key in plain prose before the call so the user can redirect.
3. **At least one Domain + one Activity label?** And ≤ 4 labels total.
4. **Is this work flowing in the next 1–2 weeks?** If not, stop and put it in the epic description instead.
5. **State the call** — issue type, parent, label set — in one short line before creating, so the user can correct.
