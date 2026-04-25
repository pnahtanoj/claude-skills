# Config Schema — `.claude/meeting-prep.json`

Per-project config for the meeting-prep skill. Read in Phase 0. If absent or incomplete, prompt the user inline and offer to save.

## Schema

```json
{
  "$schema": "meeting-prep-v1",
  "user": {
    "name": "string — full name as it appears in the agenda doc (used to filter 'your' sections)",
    "git_author": "string — git --author match string, can be email or name fragment",
    "granola_email": "string — the email Granola identifies the user by (for filtering own attendance)"
  },
  "meeting": {
    "title_pattern": "string — substring or regex matching the recurring meeting's title in Outlook",
    "organizer": "string — optional, email of the organizer (helps disambiguate)",
    "day_of_week": "string — optional, e.g. 'Thursday'",
    "cadence": "string — 'weekly' | 'biweekly' | 'monthly'"
  },
  "agenda_doc": {
    "sharepoint_url": "string — direct URL to the shared agenda doc, or pattern with {date}",
    "sections": [
      "string — names of the user's sections in the doc, in order, e.g. 'Last Week's To-Dos', 'Roadmap Rocks', 'Team Headlines', 'IDS', 'Proposed new To-Dos'"
    ]
  },
  "evidence": {
    "repos": [
      "string — paths to local git repos to scan for commits (typically just the project root)"
    ],
    "doc_paths": [
      "string — directories to scan for new/modified docs, e.g. 'docs/', 'research/', 'docs/decisions/'"
    ],
    "jira_jql_extra": "string — optional extra JQL constraint, e.g. 'AND project = PE'"
  },
  "cross_ownership": {
    "shared_owners": {
      "billing-architecture": "string — name/email of the actual owner",
      "data-platform": "string — name/email of the actual owner",
      "identity": "string — name/email of the actual owner"
    }
  }
}
```

## Example

```json
{
  "$schema": "meeting-prep-v1",
  "user": {
    "name": "Jonathan Price",
    "git_author": "Jonathan Price",
    "granola_email": "jonathan.price@idcintl.com"
  },
  "meeting": {
    "title_pattern": "L10",
    "organizer": "steve@idcintl.com",
    "day_of_week": "Thursday",
    "cadence": "weekly"
  },
  "agenda_doc": {
    "sharepoint_url": "https://idcintl.sharepoint.com/sites/leadership/Shared Documents/L10 - Weekly.docx",
    "sections": [
      "Last Week's To-Dos",
      "Roadmap Rocks",
      "Team Headlines",
      "IDS candidates",
      "Proposed new To-Dos"
    ]
  },
  "evidence": {
    "repos": ["."],
    "doc_paths": ["docs/", "research/", "docs/decisions/"],
    "jira_jql_extra": "AND project = PE"
  },
  "cross_ownership": {
    "shared_owners": {
      "billing-architecture": "alex@idcintl.com",
      "data-platform": "priya@idcintl.com"
    }
  }
}
```

## Notes

- The skill should treat missing fields gracefully. If `cross_ownership.shared_owners` is empty, skip the cross-ownership check rather than asking. If `evidence.doc_paths` is empty, default to `["docs/"]`.
- If `meeting.title_pattern` is missing, ask the user. There's no safe default.
- If `agenda_doc.sharepoint_url` is missing, ask. The skill cannot reconcile without the prior agenda.
- The config is per-project. A user with multiple recurring meetings (one per project) has one config per project. A user with multiple meetings in the *same* project should — for now — keep separate config files (e.g. `.claude/meeting-prep-l10.json`) and the skill's prompt resolution can be ambiguous; future work.

## Migration

If the config exists but uses a `$schema` value other than `meeting-prep-v1`, treat as legacy and prompt to confirm fields before proceeding. Do not silently coerce.
