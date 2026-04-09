---
name: mcp-manager
description: Manage MCP server configurations — add entities to DAB (Data API Builder) configs, scaffold new MCP server instances, validate connectivity, and debug startup failures. Use this skill whenever the user wants to add a database table to an MCP server, set up a new MCP server for a database, troubleshoot MCP connection issues, check server health, or manage dab-config.json entities. Trigger on phrases like "add this table to MCP", "set up MCP for this database", "new MCP server", "MCP not working", "DAB won't start", "add entity", "check MCP servers", "configure MCP", or any time the user needs to connect a data source to Claude Code via MCP. Covers both DAB-based servers (SQL Server, PostgreSQL, MySQL, Cosmos DB) and general MCP stdio servers. Do NOT trigger for using MCP tools to query data — that's just normal tool use. This skill is for configuring and managing the servers themselves.
---

# MCP Server Manager Skill

Your job is to help the user configure, extend, and troubleshoot MCP servers in their project. Most database MCP servers use Microsoft Data API Builder (DAB), so this skill has deep DAB knowledge, but it also handles general MCP server configuration in `.mcp.json`.

## Before any operation

1. **Read `.mcp.json`** at the project root to understand what servers are configured.
2. **Check for an `mcp/` directory** — if it exists, read the server configs inside.
3. **Identify server type** — DAB servers have `dab-config.json` files and `start-dab.sh` wrappers. Other servers may be Node scripts, Python scripts, or direct command invocations.

## Operations

### 1. Add entity to a DAB server

This is the most common operation. The user wants to expose a new database table or view through an existing DAB MCP server.

**Process:**

1. **Identify the target server.** Which `dab-config.json` should this entity go in? If ambiguous, ask.

2. **Validate the table exists.** Query the server's `SchemaColumns` entity (every DAB config should have one) to confirm the table name and get its columns:
   - Filter by `TABLE_NAME` (and `TABLE_SCHEMA` if not `dbo`)
   - If SchemaColumns isn't configured or the server isn't running, read the `dab-config.json` to check the database connection, then use the project's schema documentation as a fallback

3. **Determine key-fields.** DAB requires `key-fields` for views and tables without a primary key. Choose key-fields that uniquely identify each row:
   - For tables with an obvious primary key (e.g., `id`, `order_id`), use that
   - For composite keys common in warehouse systems, use the natural key (e.g., `[client_id, ordnum, wh_id]`)
   - For views or tables with no clear key, look for a `_row_id` or synthetic key column; if none exists, use the narrowest combination of columns that is unique
   - **Never guess key-fields.** If you can't determine them from schema inspection, ask the user
   - **Even when the user provides key-fields, verify them via SchemaColumns before adding.** Users frequently get column names wrong in abbreviated schemas — WMS and ERP databases use terse naming conventions where `blng_tran_id` vs `blng_trn_id` vs `tran_id` are all plausible but only one exists. A wrong key-field takes down the entire server, not just that entity. Trust SchemaColumns over the user's memory.

4. **Add the entity to `dab-config.json`.** Use this format:

```json
"EntityName": {
  "description": "Brief description — what this table contains, approximate row count if known.",
  "source": {
    "object": "schema.table_name",
    "type": "table",
    "key-fields": ["col1", "col2"]
  },
  "permissions": [{ "role": "anonymous", "actions": [{ "action": "read" }] }]
}
```

Rules:
- `type` is `"table"` for tables, `"view"` for views. Views always need explicit `key-fields`.
- Tables with a single-column primary key detected by DAB don't need `key-fields` — but include them anyway for clarity.
- `EntityName` should be PascalCase and descriptive (e.g., `Orders`, `ShipmentLines`, `InventoryDetail`).
- Set permissions to read-only unless the user explicitly asks for write access.
- Include `"object": "schema.table_name"` with the full schema-qualified name. Use `dbo.table_name` for default schema.

5. **Tell the user to restart the MCP server.** DAB reads config at startup — changes require a restart. The user can restart by running `/mcp` in Claude Code or restarting the session.

**Common failure: wrong key-fields.** If a key-field column doesn't exist on the table, DAB will fail to start entirely — not just for that entity, but the whole server goes down. This is why step 2 (validation) is critical. If you add an entity and the server fails to restart, check key-fields first.

### 2. Scaffold a new DAB MCP server

The user wants to connect a new database to Claude Code via DAB.

**Process:**

1. **Gather connection info:**
   - Database type (`mssql`, `postgresql`, `mysql`, `cosmosdb_nosql`)
   - Server hostname and port
   - Database name
   - Authentication (user/password or Azure AD)
   - Whether VPN is required

2. **Choose a port.** Check existing DAB configs for port usage (grep for `ASPNETCORE_URLS` in `mcp/*/start-dab.sh`). Assign the next available port starting from 5000.

3. **Create the directory structure:**
   ```
   mcp/<server-name>/
   ├── start-dab.sh
   └── dab-config.json
   ```

4. **Generate `start-dab.sh`.** Read `references/dab-wrapper-template.sh` for the template. This wrapper handles:
   - .NET 8 runtime path
   - Port assignment via `ASPNETCORE_URLS`
   - Killing stale processes on the port
   - A Python proxy that strips null `annotations`/`_meta` fields (DAB v1.7.92 bug)
   
   Customize only the `ASPNETCORE_URLS` port. Make it executable: `chmod +x mcp/<server-name>/start-dab.sh`

5. **Generate `dab-config.json`.** Start with this minimal config:
   - Connection string with the user's credentials
   - REST and GraphQL disabled (MCP only)
   - MCP enabled with read-only DML tools
   - Two bootstrap entities: `SchemaTables` and `SchemaColumns` (for schema discovery)
   - Host mode set to `development`

   See any existing `dab-config.json` in the project for the exact structure — match the pattern.

6. **Add to `.mcp.json`:**
   ```json
   "<server-name>": {
     "command": "bash",
     "args": ["mcp/<server-name>/start-dab.sh"],
     "cwd": "/absolute/path/to/project"
   }
   ```
   Note: `.mcp.json` does NOT support a `timeout` field. If DAB startup is slow (it takes ~10 seconds), the user should set `MCP_TIMEOUT=30000` in their shell profile (`~/.zshrc` or `~/.bashrc`).

7. **Test.** Tell the user to restart Claude Code, then verify by querying `SchemaTables` to confirm connectivity. Once confirmed, add real entities.

8. **Check credential safety.** Connection strings contain passwords. Before finishing:
   - Read `.gitignore` and check whether `dab-config.json` or `mcp/*/dab-config.json` is covered
   - If not, add `mcp/*/dab-config.json` to `.gitignore`
   - Check whether a `.mcp.example.json` exists with placeholder credentials. If not, create one from `.mcp.json` with `PLACEHOLDER` values so other contributors know the expected structure
   - Never commit real credentials. If `dab-config.json` is already tracked by git, warn the user and suggest `git rm --cached`

### 3. Scaffold a non-DAB MCP server

For MCP servers that aren't DAB (e.g., a custom API wrapper, a file-based server):

1. **Understand what the server does** and how it's launched (Node, Python, binary, etc.)
2. **Add to `.mcp.json`** with the correct `command`, `args`, and `cwd`
3. **Test connectivity** by restarting and checking `/mcp`

There's less to automate here — the value is in getting the `.mcp.json` entry right and troubleshooting if it doesn't connect.

**PostgreSQL shortcut:** For Postgres databases, consider `@modelcontextprotocol/server-postgres` instead of DAB. It's simpler — no .NET runtime, no wrapper script, no null-stripping workaround. Just add to `.mcp.json`:
```json
"my-postgres": {
  "command": "npx",
  "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://user:password@host:5432/dbname"]
}
```
Trade-off: you lose DAB's entity-level descriptions, key-field control, and granular DML permissions. For quick schema exploration this is fine; for production use with access control, DAB is better.

### 4. Validate and debug

**Health check process:**

1. Read `.mcp.json` to enumerate configured servers
2. For each server, check if it's a DAB server (has `mcp/*/dab-config.json`)
3. For DAB servers, verify:
   - The `start-dab.sh` wrapper exists and is executable
   - The `dab-config.json` is valid JSON
   - The port isn't conflicting with another server
   - Key-fields reference real columns (cross-reference with SchemaColumns if available)
4. Report status and any issues found

**Common DAB issues and fixes:**

| Symptom | Cause | Fix |
|---------|-------|-----|
| Server doesn't appear in `/mcp` | Startup timeout | Set `MCP_TIMEOUT=30000` in shell profile (milliseconds, not seconds) |
| Server crashes on startup | Wrong key-fields on any entity | Check DAB stderr output. Remove the last-added entity and restart. Validate column names via SchemaColumns. |
| Server crashes on startup | .NET version mismatch | DAB requires .NET 8. Check `DOTNET_ROOT` in `start-dab.sh` points to .NET 8 (not 9 or 10). Install with `brew install dotnet@8` (macOS) or equivalent. |
| Port already in use | Stale process from previous session | `lsof -iTCP:<port> -sTCP:LISTEN -t \| xargs kill` |
| Connection timeout to database | VPN not connected / credentials wrong | Check VPN status for remote databases. Verify connection string in `dab-config.json`. |
| Entity returns no data but table has rows | Filter or permission issue | Check `permissions` block allows `read` for `anonymous` role. DAB in development mode with Simulator auth should work. |
| Claude Code rejects MCP responses | DAB null serialization bug | Ensure `start-dab.sh` uses the Python proxy wrapper (not a direct `dab start` call). The proxy strips null `annotations`/`_meta` fields. |
| `dab: command not found` | DAB CLI not installed | `dotnet tool install --global Microsoft.DataApiBuilder` |
| DAB can't find config | Wrong working directory | `start-dab.sh` must `cd "$(dirname "$0")"` before launching DAB. DAB looks for `dab-config.json` in the current directory. |

**When debugging a startup failure:**
1. Run the wrapper script directly: `bash mcp/<server>/start-dab.sh` and read stderr
2. If that works, the issue is with how Claude Code launches it — check `.mcp.json` paths
3. If it fails, the error message almost always points to the cause (key-field mismatch, connection failure, port conflict)

## Entity naming conventions

- Use **PascalCase** for entity names: `ShipmentLines`, `InventoryDetail`, `OrderHeaders`
- Use **descriptive names** that reflect business meaning, not raw table names: `Orders` not `Ord`, `Customers` not `Cstmst`
- Include **row count and context** in descriptions: `"Orders — client/warehouse scoped. ~46K rows on Prod1."`
- Always include `SchemaTables` and `SchemaColumns` as discovery entities in every DAB server — they enable self-service schema exploration

## Tips

- **Start small.** When setting up a new server, begin with just `SchemaTables` and `SchemaColumns`. Confirm connectivity works before adding real entities. Adding 20 entities to an untested config means a startup failure could be any of them.
- **One entity at a time.** When adding entities to an existing config, add one, restart, test, then add the next. If a bad key-field crashes DAB, you'll know exactly which entity caused it.
- **Key-fields are the #1 failure mode.** If a column in `key-fields` doesn't exist, DAB won't start at all — it takes down the entire server, not just that entity. Always validate column names against the actual schema before adding.
- **DAB startup takes ~10 seconds.** This is normal. The MCP_TIMEOUT environment variable (set to 30000ms) accounts for this. Don't add a `timeout` field to `.mcp.json` — it's not a valid MCP config field.
- **The null-stripping proxy is required** for DAB v1.7.92. Without it, Claude Code will reject responses. Always use the wrapper script template, never a bare `dab start --mcp-stdio` call.
