# MCP Tool Usage Notes

## When This Skill Uses MCP Tools

If GitHub or Linear/Jira MCP tools are available, ticket-creator can post
tickets directly or pre-fill templates rather than just producing markdown.

### GitHub Issues
- Use `create_issue` to post the ticket directly after user approval
- Always show the drafted ticket to the user first — never post without confirmation

### Linear
- Use `create_issue` with appropriate team and project context
- Map ticket fields: Title → title, User Story → description, AC → body

### Jira
- Use `create_issue` with project key and issue type
- Map: Title → summary, Background → description, AC → acceptance criteria field

**How to use:** After presenting a drafted ticket, if a relevant MCP tool is
connected, offer: *"Want me to post this directly to [GitHub/Linear/Jira]?"*
Wait for explicit confirmation before creating any issue.
