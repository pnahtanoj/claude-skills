# dbt Best Practices — Sources

This skill's guidance is grounded in the following authoritative sources, reviewed 2026-04-09.

## Official dbt Documentation

- [How we structure our dbt projects](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview) — three-layer architecture overview (staging → intermediate → marts)
- [Staging: Preparing our atomic building blocks](https://docs.getdbt.com/best-practices/how-we-structure/2-staging) — 1:1 source rule, allowed transformations, CTE pattern, view materialization, source fanout
- [Intermediate: Purpose-built transformation steps](https://docs.getdbt.com/best-practices/how-we-structure/3-intermediate) — when to use, naming (`int_[entity]s_[verb]s`), ephemeral materialization, 4-6 join limit
- [Marts: Business-defined entities](https://docs.getdbt.com/best-practices/how-we-structure/4-marts) — wide/denormalized design, table materialization, plain entity naming
- [The rest of the project](https://docs.getdbt.com/best-practices/how-we-structure/5-the-rest-of-the-project) — YAML file naming (`_[dir]__models.yml`), config cascades, folder-based organization
- [How we style our dbt models](https://docs.getdbt.com/best-practices/how-we-style/1-how-we-style-our-dbt-models) — naming conventions (plural, snake_case, `is_`/`has_` booleans, `_at`/`_date` timestamps), column ordering (ids → strings → numerics → booleans → dates → timestamps)
- [How we style our YAML](https://docs.getdbt.com/best-practices/how-we-style/5-how-we-style-our-yaml) — 2-space indentation, 80-char line limit, Prettier formatting
- [Model contracts](https://docs.getdbt.com/docs/mesh/govern/model-contracts) — enforcing schema/types/constraints on consumer-facing marts
- [Incremental strategies](https://docs.getdbt.com/docs/build/incremental-strategy) — merge, delete+insert, append, microbatch patterns
- [Data tests](https://docs.getdbt.com/docs/build/data-tests) — generic vs singular tests, CI integration

## Community & Tooling

- [dbt-project-evaluator modeling rules](https://dbt-labs.github.io/dbt-project-evaluator/latest/rules/modeling/) — automated rule enforcement: source fanout, staging dependency restrictions, model fanout threshold (>3), join count threshold (>7), no hard-coded references, no root models
- [dbt testing best practices (Metaplane)](https://www.metaplane.dev/blog/dbt-test-examples-best-practices) — test placement, coverage philosophy, generic vs singular, common mistakes
- [dbt codegen package](https://hub.getdbt.com/dbt-labs/codegen/latest/) — `generate_base_model`, `generate_model_yaml`, `generate_source` macros for automation

## Key Rules Encoded in This Skill

| Rule | Source | Section |
|------|--------|---------|
| Staging 1:1 with source tables | dbt structure guide, dbt-project-evaluator | Staging layer |
| No joins/aggregations in staging | dbt structure guide | Staging layer |
| Only staging uses `source()` | dbt structure guide, dbt-project-evaluator | Three-layer architecture |
| Source fanout: each source → one staging model | dbt-project-evaluator | Source fanout rule |
| Model fanout: flag >3 downstream dependents | dbt-project-evaluator | Model fanout threshold |
| Max 4-6 joins per model | dbt structure guide, dbt-project-evaluator | Intermediate layer |
| Views for staging, ephemeral for intermediate, tables for marts | dbt structure guide | Materialization |
| Column ordering: ids → strings → numerics → booleans → dates → timestamps | dbt style guide | Column ordering |
| Double underscore naming: `stg_[source]__[entity]s` | dbt structure guide | Naming conventions |
| YAML naming: `_[dir]__models.yml` | dbt structure guide | YAML organization |
| `loaded_at_field` + `freshness` for source monitoring | dbt docs | Source freshness |
