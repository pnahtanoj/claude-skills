---
name: dbt-modeler
description: Generate dbt models, sources, schema tests, and docs from schema references or discovery findings. Use this skill whenever the user wants to create a new dbt model, add a staging or mart model, generate schema.yml with tests and documentation, add source definitions, or validate existing models against the actual database schema. Trigger on phrases like "create a dbt model for...", "add a staging model", "generate the gold model", "write the dbt for...", "add tests for this model", "schema.yml for...", "sources.yml entry", "model this table in dbt", or any time the user wants to turn a table, schema reference, or business requirement into working dbt SQL. Also trigger when the user has schema documentation or MCP access and wants to scaffold dbt models from it. Do NOT trigger for data model design (entity relationships, ERDs, source-to-target mappings) — that's the data-modeling skill. This skill writes the actual .sql and .yml files.
---

# dbt Modeler Skill

Your job is to generate working dbt models — SQL files, source definitions, schema tests, and documentation — from schema knowledge. You turn "here's the table" into "here's the tested, documented dbt model."

## Before writing any model

1. **Read the existing dbt project.** Check for:
   - `dbt_project.yml` — project name, model paths, materializations, config cascades
   - Existing models in `models/` — learn the naming conventions and layer structure already in use
   - `models/**/sources.yml` or `_*__sources.yml` — what sources are defined
   - `models/**/schema.yml` or `_*__models.yml` — what tests and docs exist
   - `profiles.yml` or `profiles.yml.example` — target database type (this affects SQL dialect)
   - `packages.yml` — whether `dbt_utils` or other packages are available

2. **Understand the source schema.** You need column names, types, and relationships. Get these from:
   - Schema documentation in the project (e.g., `docs/discovery/`, schema references)
   - MCP/DAB `SchemaColumns` entity if available (query it for the exact column list)
   - The user's description of the table
   - Existing models that already reference the same source

3. **Compare project conventions against dbt best practices.** Read the existing models and check for deviations from the standards described in this skill. Common deviations include:
   - Staging models that join multiple source tables (violates 1:1 rule)
   - Missing intermediate layer (joins happening in staging or marts)
   - Naming without source prefix or double underscore (`stg_orders` vs `stg_warehouse__orders`)
   - No materialization config (everything defaulting to views or tables)
   - Missing source freshness config
   - YAML files named `schema.yml` instead of `_[dir]__models.yml`

   **When you find deviations, surface them plainly before writing any code.** Tell the user what the project does, what the dbt standard recommends, and why it matters. Then ask which pattern they want you to follow for the new model. Don't silently pick one.

   Example: *"I notice stg_orders.sql joins ord and ord_line — dbt best practice says staging should be 1:1 with source tables, with joins in intermediate models. This matters because it keeps staging models simple and reusable. Want me to follow the existing pattern for consistency, or follow the dbt standard? If you want the standard, I can also refactor the existing models to match."*

## The three-layer architecture

dbt best practice defines three model layers. Understand which layer you're writing for — it determines what transformations are allowed and how the model is materialized.

### Staging — source-conformed building blocks
- **One model per source table.** Each staging model has a 1:1 relationship with exactly one source table.
- **Materialization:** Views (always). Staging models are lightweight; materializing as tables wastes space.
- **Allowed:** Renaming, type casting, basic calculations (cents → dollars), status decoding via CASE, soft-delete filtering.
- **Not allowed:** Joins across tables, aggregations, business logic. These change the grain or mix concerns — push them to intermediate.
- **Only layer that uses `source()`.** All downstream models use `ref()` to staging models.
- **Source fanout rule:** Each source should feed into exactly one staging model. If two models need the same source, they should both `ref()` the staging model, not `source()` the raw table independently.

### Intermediate — purpose-built transformation steps
- **Joins, re-graining, complex logic.** This is where header + detail joins, pivots, and multi-table combinations live.
- **Materialization:** Ephemeral (default) or views. These are internal building blocks, not consumer-facing.
- **Naming:** `int_[entity]s_[verb]s.sql` (e.g., `int_orders_joined_with_lines.sql`, `int_payments_pivoted_to_orders.sql`)
- **When to use:** If a mart would need 4+ joins, break the complex parts into intermediate models first. Think "narrow the DAG, widen the tables."
- **When to skip:** Small projects with simple joins can go directly from staging to marts. Don't create intermediate models for the sake of it.

### Marts (or gold) — business-defined entities
- **Materialization:** Tables or incremental models. These serve dashboards and reports directly.
- **References:** Only `ref()` to staging or intermediate models, never `source()`.
- **Design:** Wide and denormalized. Pack in all relevant dimensions — storage is cheap, rejoins are expensive.
- **Naming:** Plain entity names (`orders`, `customers`) or project convention (`gold_open_orders`, `fct_shipments`, `dim_customers`).

### When existing projects deviate

Many projects use a two-layer pattern (staging → gold/marts) without intermediate, or join in staging. When you encounter this:

1. **Name the deviation** — tell the user what you found and what the dbt standard says.
2. **Explain the trade-off** — consistency with existing code vs. alignment with best practices.
3. **Ask the user** — "Follow the existing pattern, or follow the dbt standard?"
4. **Offer to refactor** — if the user wants the standard, offer to refactor existing models to match. Scope the work: which files would change, what the intermediate models would look like, whether downstream refs need updating. Don't start refactoring without explicit approval.

## Operations

### 1. Generate a staging model

**Process:**

1. **Identify the source table.** One staging model per table — no joins.

2. **Get the column list.** Query SchemaColumns via MCP, read schema docs, or ask the user.

3. **Write the model.** Follow the dbt-standard CTE pattern:

```sql
WITH source AS (

    SELECT * FROM {{ source('source_name', 'table_name') }}
    WHERE is_deleted = 0  -- soft-delete filter if applicable

),

renamed AS (

    SELECT
        -- IDs first
        id_column AS entity_id,
        foreign_key AS related_entity_id,

        -- Strings
        name_col AS entity_name,
        CASE status_col
            WHEN 'A' THEN 'Active'
            WHEN 'I' THEN 'Inactive'
            ELSE status_col
        END AS status,

        -- Numerics
        CAST(qty_col AS DECIMAL(12,2)) AS quantity,

        -- Booleans
        CASE WHEN flag_col = 'Y' THEN 1 ELSE 0 END AS is_active,

        -- Dates
        CAST(date_col AS DATE) AS event_date,

        -- Timestamps
        CAST(datetime_col AS DATETIME) AS modified_at

    FROM source

)

SELECT * FROM renamed
```

**Column ordering:** Follow the dbt style guide — ids, then strings, numerics, booleans, dates, timestamps. This improves readability and reduces join errors.

**Naming conventions:**

| Convention | dbt standard | Notes |
|-----------|-------------|-------|
| File name | `stg_[source]__[entity]s.sql` | Double underscore separates source from entity; plural |
| Directory | `models/staging/[source_system]/` | Organized by source system |
| Column names | `snake_case`, business-friendly | `prtnum` → `item_number`, `ordqty` → `ordered_quantity` |
| Booleans | `is_` or `has_` prefix | `is_active`, `has_shipped` |
| Timestamps | `[event]_at` in UTC | `created_at`, `modified_at` |
| Dates | `[event]_date` | `order_date`, `ship_date` |

If the project uses a simpler convention (e.g., `stg_orders.sql` without the source prefix), match that instead.

4. **Add to sources.yml** if the source table isn't already defined.

### 2. Generate an intermediate model

Use intermediate models when a mart would otherwise need complex joins or grain changes.

```sql
-- Intermediate: Orders joined with line items
-- Grain changes from order-level to order-line-level

WITH orders AS (

    SELECT * FROM {{ ref('stg_warehouse__orders') }}

),

order_lines AS (

    SELECT * FROM {{ ref('stg_warehouse__order_lines') }}

)

SELECT
    o.site_code,
    o.client_id,
    o.order_number,
    o.order_date,
    ol.order_line,
    ol.item_number,
    ol.ordered_quantity,
    ol.shipped_quantity,
    ol.ordered_quantity - ol.shipped_quantity AS remaining_quantity,
    CASE
        WHEN ol.shipped_quantity = 0 THEN 'OPEN'
        WHEN ol.shipped_quantity < ol.ordered_quantity THEN 'PARTIAL'
        ELSE 'COMPLETE'
    END AS line_status
FROM orders o
INNER JOIN order_lines ol
    ON o.site_code = ol.site_code
    AND o.client_id = ol.client_id
    AND o.order_number = ol.order_number
```

**Naming:** `int_[entity]s_[verb]s.sql` — the verb describes the transformation (joined, pivoted, aggregated, filtered).

### 3. Generate a mart/gold model

**Process:**

1. **Understand the business question.** What report or metric does this model serve?

2. **Identify upstream models.** Use `ref()` to staging or intermediate models, never `source()`.

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
FROM {{ ref('int_orders_joined_with_lines') }} o
LEFT JOIN {{ ref('stg_warehouse__items') }} p
    ON o.item_number = p.item_number
    AND o.client_id = p.client_id
WHERE o.line_status = 'OPEN'
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
    FROM {{ ref('stg_warehouse__shipments') }}
    WHERE status = 'Complete'
    GROUP BY CAST(ship_date AS DATE), site_code, client_id

)

SELECT * FROM daily_metrics
```

**Materialization:** Set in `dbt_project.yml` via config cascade or in the model file:
```sql
{{ config(materialized='table') }}
```

### 4. Add source definitions

```yaml
version: 2

sources:
  - name: warehouse
    description: >
      Blue Yonder WMS replication database. Read-only access.
    schema: dbo
    loader: azure_data_factory  # optional: how data gets here
    loaded_at_field: moddte  # enables source freshness checks
    freshness:
      warn_after: {count: 24, period: hour}
      error_after: {count: 48, period: hour}
    tables:
      - name: ord
        description: >
          Order headers — one row per order.
          Key is (client_id, ordnum, wh_id).
      - name: ord_line
        description: >
          Order line items — one row per SKU per order.
          Key is (client_id, ordnum, wh_id, ordlin, ordsln).
```

**Rules:**
- Source `name` should reflect the system: `warehouse`, `datamart`, `salesforce` — not the schema
- Include `loaded_at_field` and `freshness` when you know the watermark column — this enables `dbt source freshness` checks
- Include a description for every table — state what one row represents and the natural key
- YAML file naming: `_[source]__sources.yml` (leading underscore, double underscore) or match project convention

### 5. Generate schema.yml with tests and docs

Every model should have a YAML file with at minimum:
- A model-level description stating the grain (what does one row represent?)
- Column descriptions for key business columns
- Tests for data quality

```yaml
version: 2

models:
  - name: stg_warehouse__orders
    description: >
      Cleaned order headers from Blue Yonder — one row per order.
      Excludes purged records.
    columns:
      - name: site_code
        description: Warehouse site identifier (from wh_id)
        tests:
          - not_null

      - name: client_id
        description: Client/customer code
        tests:
          - not_null

      - name: order_number
        description: Order identifier, unique within site + client (from ordnum)
        tests:
          - not_null
          - dbt_utils.unique_combination_of_columns:
              combination_of_columns:
                - site_code
                - client_id
                - order_number

      - name: order_status
        description: >
          Order status decoded from raw status code.
          OPEN = nothing shipped, PARTIAL = partially shipped, COMPLETE = fully shipped.
        tests:
          - accepted_values:
              values: ['OPEN', 'PARTIAL', 'COMPLETE']

      - name: ordered_quantity
        tests:
          - not_null
```

**Test selection guidance:**
- `not_null` — keys, required fields, measures. Skip on genuinely nullable columns.
- `unique` or `dbt_utils.unique_combination_of_columns` — on natural/composite keys.
- `accepted_values` — status/type columns where the domain is known and finite.
- `relationships` — foreign key integrity between models (e.g., `stg_order_lines.order_id` → `stg_orders.order_id`).
- Don't over-test. Each test should correspond to a real expectation. Random `not_null` on optional fields creates noise that teams learn to ignore.

**YAML file naming:** `_[directory]__models.yml` (leading underscore sorts to top of folder) or match project convention.

### 6. Validate existing models

When asked to validate, check:

1. **Source references exist.** Every `{{ source('x', 'y') }}` has a matching entry in sources YAML.
2. **Ref targets exist.** Every `{{ ref('model_name') }}` has a matching `.sql` file.
3. **Column names match schema.** If MCP/SchemaColumns is available, query the source and compare column names used in the model against actual columns.
4. **Layer discipline.** No `source()` calls in mart/gold models. Staging models should be 1:1 with sources (no joins).
5. **Tests cover keys.** Primary/composite key columns have uniqueness tests. Required columns have `not_null`.
6. **Source fanout.** Each source is referenced by at most one staging model.
7. **Model fanout.** Flag models with >3 direct downstream dependents — may indicate logic should be centralized.
8. **Naming conventions.** Compare file names, YAML names, and column names against dbt standards.
9. **Materialization.** Check that staging uses views, marts use tables/incremental, and intermediate uses ephemeral/views.

Report findings in two categories:
- **Errors** — things that will break (missing refs, wrong column names)
- **Deviations from dbt standards** — things that work but don't follow best practices

For deviations, explain what the standard is and why it matters, then offer to refactor. Scope the refactor: list which files would change, what new files would be created (e.g., intermediate models to replace staging joins), and whether downstream `ref()` calls need updating. Don't start refactoring without the user's go-ahead.

## SQL dialect awareness

Check the project's target database and adjust SQL accordingly:

| Feature | SQL Server / Synapse | PostgreSQL | BigQuery | Snowflake |
|---------|---------------------|------------|----------|-----------|
| Current date | `GETDATE()` | `CURRENT_DATE` | `CURRENT_DATE()` | `CURRENT_DATE()` |
| Date diff | `DATEDIFF(DAY, a, b)` | `DATE_PART('day', b - a)` | `DATE_DIFF(b, a, DAY)` | `DATEDIFF('day', a, b)` |
| Cast date | `CAST(x AS DATE)` | `x::DATE` | `CAST(x AS DATE)` | `x::DATE` |
| String concat | `+` or `CONCAT()` | `\|\|` | `CONCAT()` | `\|\|` |
| Boolean | `1`/`0` (BIT) | `TRUE`/`FALSE` | `TRUE`/`FALSE` | `TRUE`/`FALSE` |

If no `profiles.yml` exists, ask the user what database they're targeting. The wrong dialect means models won't compile.

## Tips

- **Read before writing, then surface what you find.** If the project deviates from dbt standards, say so plainly — don't silently copy non-standard patterns. Let the user choose between consistency and correctness.
- **One model, one grain.** The model-level description must answer "what does one row represent?" If you can't say it in one sentence, the model needs work.
- **Staging is mechanical, marts are business.** Staging renames and casts. Business logic (filters, aggregations, derived metrics) belongs downstream.
- **Don't skip intermediate when you need it.** If a mart has 5+ joins, break the complex parts into intermediate models. But don't create intermediate models for simple pass-throughs.
- **Materialization: views → tables → incremental.** Start with the simplest. Add complexity only when performance demands it. Incremental models need a reliable watermark column and a clear `unique_key`.
- **Comment the non-obvious.** Domain-specific status decodes, tricky join conditions, data quality workarounds — add a brief comment. Skip the obvious.
- **Use config cascades.** Set materializations in `dbt_project.yml` by directory rather than in each model file. Override only when a specific model needs different treatment.
