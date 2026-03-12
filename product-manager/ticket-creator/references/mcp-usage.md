# MCP Tool Usage Notes

> **Status: future / secondary path.** The primary output for ticket-creator is
> local markdown files (see Step 2b in SKILL.md). MCP posting is a potential
> enhancement once local file output is stable.

## When This Skill May Use MCP Tools

If GitHub or Linear/Jira MCP tools are available in a future version, ticket-creator
could post tickets directly or pre-fill templates rather than writing local files.

### GitHub Issues
- Use `create_issue` to post the ticket directly after user approval
- Always show the drafted ticket to the user first — never post without confirmation

### Linear
- Use `create_issue` with appropriate team and project context
- Map ticket fields: Title → title, User Story → description, AC → body

### Jira
- Use `create_issue` with project key and issue type
- Map: Title → summary, Background → description, AC → acceptance criteria field

**If/when implemented:** After writing the local file, if a relevant MCP tool is
connected, offer: *"Want me to also post this to [GitHub/Linear/Jira]?"*
Wait for explicit confirmation before creating any issue.
