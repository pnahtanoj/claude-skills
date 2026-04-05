# Terraform / OpenTofu Review Checklist

Domain-specific checks for Terraform and OpenTofu configurations. Use this
alongside the main review workflow — not every check applies to every project.

---

## Table of Contents

1. [State & Backend](#state--backend)
2. [Provider Configuration](#provider-configuration)
3. [Resource Security](#resource-security)
4. [Resource Lifecycle](#resource-lifecycle)
5. [Variables & Outputs](#variables--outputs)
6. [Modules](#modules)
7. [Data Sources](#data-sources)
8. [Common Provider-Specific Issues](#common-provider-specific-issues)

---

## State & Backend

- **Remote backend configured** — Local state (`terraform.tfstate` on disk) is
  the #1 source of Terraform disasters. Look for a `backend` block in
  `terraform {}`. Common backends: S3 + DynamoDB (AWS), azurerm (Azure), gcs
  (GCP).
- **State locking enabled** — The backend should support locking (DynamoDB for
  S3, built-in for azurerm/gcs). Without it, concurrent applies corrupt state.
- **State file not in git** — Check `.gitignore` for `*.tfstate`,
  `*.tfstate.backup`, `.terraform/`. If these are committed, flag as Critical.
- **Sensitive values in state** — Resources like `aws_secretsmanager_secret_version`
  store plaintext secrets in state. Ensure the state backend is encrypted and
  access-controlled.

## Provider Configuration

- **Provider version pinned** — `required_providers` should use version
  constraints (e.g., `~> 5.0`), not unconstrained. Unpinned providers can
  break on major version bumps.
- **Terraform version pinned** — `required_version` should be set in the
  `terraform {}` block to prevent accidental use of incompatible versions.
- **No hardcoded credentials in provider blocks** — Provider `access_key`,
  `secret_key`, `subscription_id`, or similar should come from environment
  variables or a credentials file, never inline.
- **Default tags configured** — Most providers support `default_tags` in the
  provider block. Using them avoids tag drift across resources.

## Resource Security

- **No `0.0.0.0/0` ingress on management ports** — Security groups or NSGs
  allowing SSH (22), RDP (3389), or database ports from anywhere. Flag as
  Critical.
- **S3/GCS/Blob storage not publicly accessible** — Look for
  `acl = "public-read"`, missing `aws_s3_bucket_public_access_block`, or
  `public_network_access_enabled = true`.
- **Database not publicly accessible** — `publicly_accessible = true` on RDS,
  `public_network_access_enabled = true` on Azure SQL.
- **Encryption at rest enabled** — Databases, storage, disks, and queues
  should have encryption configured. Many providers default to off.
- **KMS/CMK vs provider-managed keys** — Provider-managed encryption is
  acceptable for most use cases. Flag only if compliance requires CMK and
  it's not configured.
- **IAM least privilege** — `Action: "*"` or `Resource: "*"` in IAM policies
  is almost always too broad. Look for overly permissive `aws_iam_policy`,
  `azurerm_role_assignment` with Owner/Contributor at subscription scope, or
  `google_project_iam_member` with `roles/editor`.
- **Managed identities preferred** — Using access keys or service account
  keys when managed identities (AWS IAM roles, Azure managed identity, GCP
  workload identity) would work.

## Resource Lifecycle

- **`prevent_destroy` on stateful resources** — Databases, storage accounts,
  and key vaults should have `lifecycle { prevent_destroy = true }` to prevent
  accidental `terraform destroy`.
- **`create_before_destroy` where needed** — Resources that can't tolerate
  downtime during replacement (load balancers, DNS records) should use this.
- **`ignore_changes` used appropriately** — Should only be used for fields
  managed outside Terraform (auto-scaling counts, externally-managed tags).
  Overuse hides drift.
- **Deletion protection** — Many resources have a provider-level deletion
  protection flag (RDS `deletion_protection`, GCP `deletion_protection`).
  Use in addition to `prevent_destroy`.
- **Timeouts configured for slow resources** — Some resources (large
  databases, VPN gateways) take longer than Terraform's defaults. Missing
  timeouts cause false failures.

## Variables & Outputs

- **Every variable has a `description`** — `terraform plan` output shows
  descriptions. Without them, the plan is hard to interpret.
- **Sensitive variables marked `sensitive = true`** — Prevents values from
  appearing in plan output and logs.
- **Validation rules for constrained inputs** — Environment names, regions,
  CIDR blocks, and SKU names benefit from `validation {}` blocks.
- **No default on required decisions** — Variables like `environment` or
  `region` shouldn't have defaults if the choice matters for every deployment.
- **Outputs exist for integration points** — Resource IDs, endpoints,
  connection strings, and generated names should be outputs so other
  configurations or scripts can reference them.

## Modules

- **Module sources pinned** — Registry modules should pin a version
  (`version = "3.1.0"`). Git modules should pin a ref
  (`?ref=v1.2.0`). Unpinned modules change under you.
- **Module inputs validated** — Modules should use `validation {}` on
  variables that have constraints.
- **No deeply nested modules** — More than 2 levels of module nesting makes
  debugging plan output painful. Flatten if possible.
- **Module outputs are intentional** — Modules should expose what consumers
  need, not everything. Over-exposing internal resource attributes creates
  coupling.

## Data Sources

- **Data sources for lookups, not config** — `data` blocks should look up
  existing resources (AMIs, subnets, DNS zones), not substitute for managing
  resources in Terraform. If a data source is reading something that should
  be a managed resource, flag it.
- **Data source filters are specific enough** — A `data "aws_ami"` with
  `most_recent = true` and a broad `name_prefix` can silently pick up the
  wrong AMI after a new one is published.

## Provider-Specific Gotchas

Read only the section for the provider in use.

### AWS
- S3/CloudWatch log group retention defaults to "never expire" — accumulating
  costs indefinitely
- Default VPC is permissive — production should use a custom VPC
- Globally unique bucket names need random suffixes

### Azure
- Resource name length limits vary wildly (3-24 for storage accounts)
- Soft-delete on Key Vaults is enforced — recreating a deleted vault by name
  fails

### GCP
- `google_project_iam_binding` replaces all members for a role — prefer
  `google_project_iam_member` for additive grants
- Many resources require enabling the API first — use
  `google_project_service`
