---
name: data-modeling
description: Design and document data models, schemas, entity relationships, and data flow architectures. Use this skill whenever the user needs to define a database schema, map entities and relationships, design a data warehouse or lake structure, plan data pipelines, document source-to-target mappings, or reason through how data should be organized and transformed. Trigger on phrases like "design the schema", "what should the data model look like", "map these entities", "source-to-target", "data flow", "ERD", "dimension and fact tables", "how should we store...", "normalize this", "star schema", or any time the user is deciding how data should be structured, stored, or moved. Do NOT trigger for infrastructure provisioning (use infrastructure-scaffold), technology selection (use stack-decision), or general architecture decisions not specific to data (use architecture-decision).
---

# Data Modeling Skill

Your job is to help the user design, document, and reason through data models — from entity relationships and schemas to pipeline flows and source-to-target mappings.

Data modeling is about making structure decisions explicit before writing code. A good model prevents months of painful migrations later.

## Process

Work conversationally. Don't produce a giant schema diagram on first contact — understand the domain first, then build up the model iteratively.

### 1. Understand the data domain

You need to know:

- **What data exists?** Sources, systems, formats. What's structured vs. unstructured?
- **What questions need answering?** What will downstream consumers (reports, APIs, dashboards, ML models) need from this data?
- **What are the volumes and velocities?** Batch vs. streaming? Thousands of rows or billions?
- **What are the constraints?** Compliance requirements, retention policies, access controls, existing schemas you can't change.

If the user has a discovery doc, spike findings, or existing database to reference — read those first.

### 2. Identify entities and relationships

Map the core entities in the domain. For each entity:

- What uniquely identifies it? (natural key vs. surrogate key)
- What are its core attributes?
- How does it relate to other entities? (1:1, 1:many, many:many)
- Does it change over time? (slowly changing dimension? event stream? snapshot?)

Draw these out as a list first — don't jump to diagrams until the entities are agreed upon.

### 3. Choose a modeling approach

Based on the use case, recommend an approach:

| Use Case | Approach | When to Use |
|----------|----------|-------------|
| Operational / OLTP | Normalized (3NF) | Application databases where write performance and data integrity matter |
| Analytics / OLAP | Star schema (Kimball) | Data warehouses optimized for read queries and aggregation |
| Data lake | Schema-on-read | Raw/semi-structured data where schemas aren't known up front |
| Event-driven | Event sourcing | Systems where the sequence of changes is the primary data model |
| Hybrid | Medallion (bronze/silver/gold) | Data platforms that ingest raw, clean incrementally, and serve curated views |

Be opinionated. If the user is building a data platform, they almost certainly need the medallion pattern or a star schema — say so and explain why rather than listing every option.

### 4. Design the model

Produce the model in a format appropriate to the scope:

**For entity relationships**, use a markdown table:

```markdown
## Entities

### orders
| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| order_id | BIGINT | PK | Surrogate key |
| external_order_id | VARCHAR(50) | UNIQUE, NOT NULL | From source system |
| customer_id | BIGINT | FK → customers | |
| order_date | TIMESTAMP | NOT NULL | UTC |
| status | VARCHAR(20) | NOT NULL | enum: pending, shipped, delivered |
| total_amount | DECIMAL(12,2) | NOT NULL | |

### Relationships
- orders → customers (many:1 via customer_id)
- orders → order_lines (1:many via order_id)
```

**For data flows / pipelines**, use a source-to-target mapping:

```markdown
## Source-to-Target: [Pipeline Name]

Source: [system/table]
Target: [system/table]
Frequency: [batch daily / streaming / on-demand]
Transform: [brief description]

| Source Field | Transform | Target Field | Notes |
|-------------|-----------|-------------|-------|
| BY.orders.order_no | CAST to BIGINT | stg_orders.external_order_id | |
| BY.orders.created_dt | Convert TZ → UTC | stg_orders.order_date | Source is US/Pacific |
| BY.orders.status_cd | Map via lookup | stg_orders.status | See status_mapping table |
```

**For layer architecture** (medallion/staging), describe each layer:

```markdown
## Data Layers

### Bronze (Raw Ingestion)
- Mirror of source tables, no transformation
- Append-only with ingestion timestamp
- Partitioned by ingestion date

### Silver (Cleaned & Conformed)
- Deduplicated, typed, null-handled
- Conformed naming conventions
- Slowly changing dimensions tracked here

### Gold (Business-Ready)
- Star schema for analytics
- Pre-aggregated summary tables
- Serves dashboards and reports directly
```

### 5. Produce the document

Save to `docs/data-models/` — create the directory if it doesn't exist.

Filename: `[domain-or-scope].md` (e.g., `warehouse-schema.md`, `order-pipeline.md`, `bronze-layer.md`).

Use this structure:

```markdown
# Data Model: [Title]

Date: YYYY-MM-DD
Status: Draft | Approved | Implemented
Scope: [what this model covers]

## Overview

[1-3 sentences: what this model represents and what it enables.]

## Sources

| Source System | Tables/Feeds | Access Method | Refresh |
|--------------|-------------|---------------|---------|
| [system] | [tables] | [API/DB/file] | [frequency] |

## Model

[Entity tables, relationships, and/or source-to-target mappings as shown above.]

## Layer Architecture

[If applicable — describe bronze/silver/gold or staging/production layers.]

## Assumptions

- [assumption that the model depends on — e.g., "order_no is unique within a given warehouse"]

## Open Questions

- [anything unresolved that could change the model]
```

### 6. Review with the user

Walk through the model and specifically ask:

- Are there entities or relationships missing?
- Do the data types and constraints look right?
- Does the granularity match what downstream consumers need?
- Are there any source-system quirks that would break these assumptions?

Models are wrong until proven right. Expect iteration.

## Tips

- Start with the questions the data needs to answer, not the source schema. Model for the consumer, not the producer.
- Name things consistently. Pick a convention (snake_case, singular table names, `_id` suffix for keys) and stick to it.
- Always capture the grain of a table — what does one row represent? If you can't answer that in one sentence, the model is unclear.
- Slowly changing dimensions are more common than people expect. If an entity's attributes can change over time and you need historical accuracy, flag it early.
- Don't model what you don't need yet. A good model for three entities you understand is better than a speculative model for twenty.
- Source-to-target mappings are the bridge between "what exists" and "what we want." They're the most practically useful artifact for implementation.
