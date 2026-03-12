---
name: context-handoff
description: >
  Capture the current state of a session into a structured handoff summary.
  Use this skill whenever the user wants to wrap up a session, hand off work
  to another tool or person, continue in a new session, or document decisions
  before moving to implementation. Triggers on phrases like "wrap this up",
  "summarize where we got to", "capture this for later", "create a handoff",
  "what have we decided", "prep this for Claude Code", "write this up for the
  engineer", or any time the user signals a context boundary is approaching.
  Also trigger mid-session if the user wants to park a thread and return to it.
  Do NOT trigger for general summaries of a document or article — this skill
  is specifically for capturing the state of a working session.
---

# Context Handoff Skill

Capture the state of a working session into a structured summary that survives
context loss — whether that's a new session, a different tool, or a human
handoff.

## Core Behavior

**Reconstruct from the conversation — don't ask the user to re-explain what
you already have.** Read the session history, extract what was decided, what
was produced, what's still open, and what assumptions were made. Only ask
clarifying questions for things that are genuinely ambiguous or missing.

**Distinguish decided from assumed.** This is the most important distinction
in a handoff. A decision was made consciously; an assumption was never
explicitly validated. Flag assumptions clearly — they're the most likely
source of problems downstream.

**Before producing output, check `references/handoff-formats.md`** for the
two output formats (session summary and CLAUDE.md block) and any project-specific
conventions in the Notes for Customization section.

---

## Step 1: Determine Output Format

Ask the user which format they need — or infer from context:

- **Session summary** → continuing in a new claude.ai session, sharing with a
  colleague, or parking work to return to later
- **CLAUDE.md block** → handing off to Claude Code for implementation
- **Both** → when work moves from product thinking to engineering

If it's obvious from context (e.g., "prep this for Claude Code"), skip asking.

---

## Step 2: Reconstruct Session State

From the conversation history, extract:

1. **Goal** — what problem were we trying to solve? What outcome were we working toward?
2. **Decisions made** — what was explicitly chosen, and why (capture the reasoning, not just the choice)
3. **Artifacts produced** — user stories, tickets, critique findings, docs, specs; note which skill produced them if relevant
4. **Open questions** — things that came up but weren't resolved
5. **Assumptions** — things treated as true but never explicitly validated; flag these clearly
6. **Constraints** — known limitations, dependencies, or non-negotiables that emerged
7. **Next actions** — what should happen next, and who/what should do it

**Before finalising the decisions list, apply this test to each item:** Did someone explicitly say "we decided", "let's go with", or "we agreed on" this? If not, it belongs in Assumptions, not Decisions. Watch for signal words that mark something as an assumption rather than a decision: "we assumed", "I think", "probably", "I imagine", "I guess", "I'd expect", or anything framed as a working hypothesis. When genuinely ambiguous, default to Assumptions — a false assumption is safer to surface than a false decision, because assumptions get validated while decisions get built on.

If any of these are genuinely unclear from the conversation, ask — but keep
questions targeted. One focused question beats five vague ones.

---

## Step 3: Produce the Handoff

Load `references/handoff-formats.md` and produce the appropriate format(s).

Apply the quality bar before presenting:

- [ ] A person (or Claude instance) with no session history could pick this up and continue without losing ground
- [ ] Decisions include their reasoning, not just the outcome
- [ ] Assumptions are explicitly flagged and separated from decisions
- [ ] Open questions are specific enough to be actionable
- [ ] Next actions are concrete — not "figure out X" but "decide X by doing Y"
- [ ] CLAUDE.md block (if produced) is terse and directive, not conversational
- [ ] Project-specific conventions from Notes for Customization are applied

---

## Step 4: Offer a Paste-Ready Block

After presenting the handoff, offer a clean copy-paste version:
*"Want me to give you just the raw text to paste, without any surrounding commentary?"*

---

## Handling Thin Sessions

If the session was short or exploratory and there isn't much to capture:
- Still produce the structure, but mark sections as "not yet established" rather than leaving them empty
- A thin handoff is still useful — it signals what ground hasn't been covered yet

---

## Rules

Failure patterns to avoid. Update this section when new ones are observed.

- **Never conflate decisions with assumptions.** A decision requires an explicit moment of agreement — someone saying "let's do X" or "we agreed on Y." Implicit acceptance, unstated defaults, and things treated as given without discussion are assumptions, not decisions. The test: could a reasonable person have walked away from that conversation thinking the question was still open? If yes, it's an assumption. When in doubt, put it in Assumptions.
- **Never ask the user to re-explain what's already in the conversation.** Reconstruct from session history first — only ask for genuine gaps.
- **Never write next actions as vague intentions.** "Figure out X" is not an action. "Decide X by doing Y" is.
- **Never produce a CLAUDE.md block in conversational prose.** It must be terse and directive — one line per item wherever possible.
- **Never omit the reasoning behind decisions.** The outcome alone isn't useful to a future session. The reasoning is what prevents the same debate from happening again.
- **Never present a handoff that a fresh Claude instance couldn't act on** — if it would need to ask follow-up questions to proceed, the handoff isn't complete.
- **When the user approves an output as good, save it as an example.** Append it to `references/examples.md` (create the file if it does not exist) under a dated heading. Future runs should check this file for approved output patterns and match their style and depth.
- **Use subagents for multi-file context.** If the session references 3+ distinct documents or codebases to be read for handoff, spawn parallel subagents to extract the relevant state from each, then synthesize into the handoff summary.
