---
name: dbt-modeler
description: Generate dbt models, sources, schema tests, and docs from schema references or discovery findings. Use this skill whenever the user wants to create a new dbt model, add a staging or mart model, generate schema.yml with tests and documentation, add source definitions, or validate existing models against the actual database schema. Trigger on phrases like "create a dbt model for...", "add a staging model", "generate the gold model", "write the dbt for...", "add tests for this model", "schema.yml for...", "sources.yml entry", "model this table in dbt", or any time the user wants to turn a table, schema reference, or business requirement into working dbt SQL. Also trigger when the user has schema documentation or MCP access and wants to scaffold dbt models from it. Do NOT trigger for data model design (entity relationships, ERDs, source-to-target mappings) — that's the data-modeling skill. This skill writes the actual .sql and .yml files.
---

# dbt Modeler Skill

Your job is to generate working dbt models — SQL files, source definitions, schema tests, and documentation — from schema knowledge. You turn "here's the table" into "here's the tested, documented dbt model."

## Before writing any model

1. **Read the existing dbt project.** Check for:
   - `dbt_project.yml` — project name, model paths, materializations
   - Existing models in `models/` — learn the naming conventions and patterns already in use
   - `models/**/sources.yml` — what sources are already defined
   - `models/**/schema.yml` — what tests and docs exist
   - `profiles.yml` or `profiles.yml.example` — target database type (this affects SQL dialect)

2. **Understand the source schema.** You need column names, types, and relationships. Get these from:
   - Schema documentation in the project (e.g., `docs/discovery/`, schema references)
   - MCP/DAB `SchemaColumns` entity if available (query it for the exact column list)
   - The user's description of the table
   - Existing models that already reference the same source

3. **Match the project's conventions.** If the project already has staging models with a specific pattern (CTE structure, naming, date handling), follow that pattern exactly. Consistency matters more than your preferred style.

## Operations

### 1. Generate a staging model

Staging models clean, rename, and type raw source columns. One staging model per source table (or per logical entity that joins a header + lines table).

**Process:**

1. **Identify the source table(s).** What's the raw table? Is there a related detail/lines table that should be joined at the staging level?

2. **Get the column list.** Query SchemaColumns via MCP, read schema docs, or ask the user. You need every column name and type.

3. **Write the model.** Follow this pattern (adapt to match existing project conventions):

```sql
-- Staging: [Entity description]
-- Source: [schema.table_name]

WITH source AS (
    SELECT
        -- Rename columns to business-friendly names
        column_a AS descriptive_name,
        column_b AS another_name,
        -- Cast dates explicitly
        CAST(date_col AS DATE) AS date_field,
        CAST(datetime_col AS DATETIME) AS timestamp_field,
        -- Decode status codes inline
        CASE status_col
            WHEN 'A' THEN 'Active'
            WHEN 'I' THEN 'Inactive'
            ELSE status_col
        END AS status
    FROM {{ source('source_name', 'table_name') }}
    WHERE is_deleted = 0  -- or equivalent soft-delete filter
)

SELECT * FROM source
```

For entities with header + detail tables, use multiple CTEs and join them:

```sql
WITH headers AS (
    SELECT ... FROM {{ source('source_name', 'header_table') }}
),

lines AS (
    SELECT ... FROM {{ source('source_name', 'lines_table') }}
)

SELECT
    h.*,
    l.line_specific_columns
FROM headers h
INNER JOIN lines l
    ON h.key_col = l.key_col
    AND h.second_key = l.second_key
```

**Naming rules:**
- File: `stg_[entity].sql` (e.g., `stg_orders.sql`, `stg_inventory.sql`)
- Place in `models/staging/`
- Rename cryptic source columns to readable names: `prtnum` → `item_number`, `ordqty` → `ordered_quantity`
- Use snake_case for all column names
- Cast all date/datetime columns explicitly — don't rely on implicit conversion

4. **Add to sources.yml** if the source table isn't already defined (see operation 3).

### 2. Generate a gold/mart model

Gold models serve business consumers — dashboards, reports, APIs. They join staging models, filter, and aggregate.

**Process:**

1. **Understand the business question.** What report or metric does this model serve? What dimensions and measures are needed?

2. **Identify the staging models it reads from.** Gold models should reference `{{ ref('stg_...') }}`, never `{{ source() }}` directly.

3. **Write the model.** Common patterns:

**Filter + denormalize** (most report models):
```sql
SELECT
    o.site_code,
    o.client_id,
    o.order_number,
    o.order_date,
    o.item_number,
    p.item_description,
    o.ordered_quantity,
    o.shipped_quantity,
    o.remaining_quantity
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_items') }} p
    ON o.item_number = p.item_number
    AND o.client_id = p.client_id
WHERE o.status = 'OPEN'
```

**Aggregate** (KPI/summary models):
```sql
WITH daily_metrics AS (
    SELECT
        CAST(ship_date AS DATE) AS metric_date,
        site_code,
        client_id,
        COUNT(DISTINCT shipment_id) AS shipment_count,
        SUM(quantity) AS total_quantity
    FROM {{ ref('stg_shipments') }}
    WHERE status = 'Complete'
    GROUP BY CAST(ship_date AS DATE), site_code, client_id
)

SELECT * FROM daily_metrics
```

**Pivot/conditional aggregation** (aging, status breakdown):
```sql
SELECT
    site_code,
    client_id,
    item_number,
    SUM(CASE WHEN status = 'Available' THEN quantity ELSE 0 END) AS available_qty,
    SUM(CASE WHEN status = 'Hold' THEN quantity ELSE 0 END) AS hold_qty,
    SUM(quantity) AS total_qty
FROM {{ ref('stg_inventory') }}
GROUP BY site_code, client_id, item_number
```

**Naming rules:**
- File: `gold_[report_name].sql` or `fct_[entity].sql` / `dim_[entity].sql` — match the project's existing convention
- Place in `models/gold/` or `models/marts/` — match existing directory structure

### 3. Add source definitions

When a model references a source that isn't defined yet, add it to `sources.yml`.

**Format:**
```yaml
version: 2

sources:
  - name: source_name
    description: >
      Brief description of the source system.
    schema: schema_name
    tables:
      - name: table_name
        description: What this table contains.
      - name: another_table
        description: What this table contains.
```

**Rules:**
- One `sources.yml` per directory (staging models and their sources live together)
- Source `name` should reflect the system, not the schema: `datamart` not `dm`, `blue_yonder` not `dbo`
- Include a description for every table — even one sentence helps future readers
- If a table isn't accessible yet (pending access, future source), add it commented out with a note

### 4. Generate schema.yml with tests and docs

Every model should have a `schema.yml` with at minimum:
- A model-level description (what does one row represent?)
- Column descriptions for key columns
- Tests for data quality

**Format:**
```yaml
version: 2

models:
  - name: stg_orders
    description: >
      Cleaned order data — one row per order line.
      Joins order headers with line items.
    columns:
      - name: site_code
        description: Warehouse site identifier
        tests:
          - not_null
      - name: client_id
        description: Client/customer code
        tests:
          - not_null
      - name: order_number
        description: Order identifier, unique within site + client
        tests:
          - not_null
      - name: ordered_quantity
        tests:
          - not_null
      - name: status
        tests:
          - accepted_values:
              values: ['OPEN', 'PARTIAL', 'COMPLETE']
```

**Test selection guidance:**
- `not_null` on every column that should never be null (keys, required fields, measures)
- `unique` on natural keys or surrogate keys — use `dbt_utils.unique_combination_of_columns` for composite keys
- `accepted_values` on status/type columns where the domain is known
- `relationships` to verify foreign key integrity between models
- Don't over-test: skip `not_null` on optional/nullable columns, skip `unique` on non-key columns

**Composite key uniqueness** (requires dbt-utils):
```yaml
      - name: order_number
        tests:
          - dbt_utils.unique_combination_of_columns:
              combination_of_columns:
                - site_code
                - client_id
                - order_number
```

### 5. Validate existing models

When asked to validate, check:

1. **Source references exist.** Every `{{ source('x', 'y') }}` should have a matching entry in `sources.yml`.
2. **Ref targets exist.** Every `{{ ref('model_name') }}` should have a matching `.sql` file.
3. **Column names match schema.** If MCP/SchemaColumns is available, query the source table and compare column names used in the model against actual columns. Flag mismatches.
4. **Tests cover keys.** Check that primary/composite key columns have uniqueness tests.
5. **No direct source references in gold models.** Gold/mart models should use `ref()` to staging models, not `source()` to raw tables.

Report findings and offer to fix them.

## SQL dialect awareness

Check the project's target database and adjust SQL accordingly:

| Feature | SQL Server / Synapse | PostgreSQL | BigQuery | Snowflake |
|---------|---------------------|------------|----------|-----------|
| Current date | `GETDATE()` | `CURRENT_DATE` | `CURRENT_DATE()` | `CURRENT_DATE()` |
| Date diff | `DATEDIFF(DAY, a, b)` | `DATE_PART('day', b - a)` | `DATE_DIFF(b, a, DAY)` | `DATEDIFF('day', a, b)` |
| Cast date | `CAST(x AS DATE)` | `x::DATE` | `CAST(x AS DATE)` | `x::DATE` |
| String concat | `+` or `CONCAT()` | `\|\|` | `CONCAT()` | `\|\|` |
| Boolean | `1`/`0` (BIT) | `TRUE`/`FALSE` | `TRUE`/`FALSE` | `TRUE`/`FALSE` |

If no `profiles.yml` exists, ask the user what database they're targeting. Don't guess — the wrong dialect means models won't compile.

## Tips

- **Read before writing.** If the project has existing models, match their patterns exactly. Don't introduce a new style.
- **One model, one grain.** Every model should have a clear answer to "what does one row represent?" If you can't answer that, the model needs refactoring.
- **Staging is mechanical, gold is business.** Staging models do renames, casts, and joins. Business logic (filters, aggregations, calculations) belongs in gold models. Don't put business rules in staging.
- **Don't generate tests you can't explain.** Every test should correspond to a real data quality expectation. Random `not_null` tests on optional fields create noise.
- **Incremental models are an optimization, not a default.** Start with `table` or `view` materialization. Add `incremental` only when full refreshes become too slow. When you do, you need a reliable watermark column.
- **Comment the non-obvious.** If a join has a tricky condition, a status decode uses domain knowledge, or a filter exists because of a data quality issue — add a brief comment. Don't comment the obvious.
