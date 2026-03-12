# MCP Tool Usage Notes

## When This Skill Uses MCP Tools

If MCP tools are available in the session (e.g. GitHub, Linear, Jira, Slack),
context-handoff can read from them directly rather than relying on the
conversation history alone. This produces richer, more accurate handoffs.

### GitHub
- Use to read open PRs, recent commits, and issue status
- Useful for: capturing what code was changed, what's still open, what shipped

### Linear / Jira
- Use to read ticket status, sprint state, and blockers
- Useful for: capturing what's in progress, what's blocked, what just closed

### Slack
- Use to read recent thread context or decisions made in DMs / channels
- Useful for: capturing decisions that happened outside the coding session

**How to use:** When producing a handoff, check which MCP tools are available.
If any of the above are connected, query them for state that supplements the
conversation. Note in the handoff which sources were consulted.
