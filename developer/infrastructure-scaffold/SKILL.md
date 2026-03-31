---
name: infrastructure-scaffold
description: Generate infrastructure-as-code boilerplate for cloud resources — Terraform, Bicep, Pulumi, or CDK. Use this skill whenever the user needs to scaffold cloud infrastructure, set up a new IaC project, provision resources (storage accounts, databases, networking, compute, data pipelines), or generate a starting Terraform/Bicep/CDK configuration from a description of what they need. Trigger on phrases like "scaffold the infrastructure", "set up Terraform for...", "write Bicep for...", "provision a...", "IaC for...", "infrastructure for the data platform", "create the Azure resources", "AWS setup for...", or any time the user needs cloud resource definitions written as code. Do NOT trigger for application code scaffolding (that's just writing code), architecture decisions about which cloud services to use (use stack-decision), or deployment pipeline configuration (different concern).
---

# Infrastructure Scaffold Skill

Your job is to generate a working, opinionated infrastructure-as-code scaffold for cloud resources. The output should be files the user can `plan` and `apply` (or deploy) immediately — not pseudocode or documentation.

## Process

### 1. Understand the target

You need to know:

- **Cloud provider** — Azure, AWS, or GCP. If the project has existing IaC or a discovery doc, check those first.
- **IaC tool** — Terraform, Bicep, Pulumi, CDK, or CloudFormation. If not specified, recommend based on the provider:
  - Azure → Bicep (native, zero dependencies) or Terraform (if multi-cloud or team preference)
  - AWS → Terraform or CDK
  - GCP → Terraform
- **What resources are needed** — storage, compute, networking, databases, data pipeline services, etc.
- **Environment strategy** — single environment? dev/staging/prod? If not specified, scaffold for a single environment with a clear path to parameterize later.
- **Naming conventions** — does the org have naming standards? Check for a STANDARDS.md or existing resources.

If the user's message or project context already answers these, proceed directly.

### 2. Design the resource graph

Before writing any code, lay out what you'll create and why:

```
Resource Group: rg-dataplatform-dev
├── Storage Account: stdata[env][random] (Data Lake Storage Gen2)
│   ├── Container: bronze (raw ingestion)
│   ├── Container: silver (cleaned)
│   └── Container: gold (business-ready)
├── Azure Data Factory: adf-dataplatform-dev
├── Key Vault: kv-dataplatform-dev
│   └── Secrets: connection strings, API keys
└── SQL Database: sql-dataplatform-dev (if needed)
```

Share this with the user for confirmation before writing files. Adding resources later is easy; ripping out wrong ones is not.

### 3. Generate the scaffold

Write the IaC files into an `infra/` directory at the project root (or wherever existing IaC lives).

#### Terraform scaffold structure

```
infra/
├── main.tf          # Provider config + resource group / project
├── variables.tf     # Input variables with descriptions and defaults
├── outputs.tf       # Useful outputs (resource IDs, connection strings, endpoints)
├── storage.tf       # Storage resources (grouped by concern, not by resource type)
├── data.tf          # Data pipeline resources
├── network.tf       # Networking (if applicable)
├── locals.tf        # Computed values, naming conventions
└── terraform.tfvars.example  # Example variable values (NEVER real secrets)
```

#### Bicep scaffold structure

```
infra/
├── main.bicep       # Orchestrator — deploys modules
├── modules/
│   ├── storage.bicep
│   ├── data.bicep
│   └── network.bicep
├── parameters/
│   ├── dev.bicepparam
│   └── prod.bicepparam (template only)
└── README.md        # How to deploy
```

### 4. Code standards

Follow these regardless of tool:

**Naming:**
- Use the provider's naming conventions and length limits. Azure has notoriously short name limits for some resources — respect them.
- Parameterize environment name, project name, and region. Derive resource names from these.
- Use a `locals` block (Terraform) or variables (Bicep) for naming patterns so they're consistent and changeable.

**Security:**
- Never hardcode secrets, connection strings, or passwords.
- Use Key Vault / Secrets Manager / Secret Manager for sensitive values.
- Default to private networking where available (private endpoints, service endpoints).
- Enable encryption at rest and in transit by default.
- Use managed identities / service accounts over keys where possible.

**Structure:**
- Group resources by concern (all storage together, all networking together), not by resource type.
- Every variable should have a `description` and a sensible `default` where appropriate.
- Every output should have a `description`.
- Add brief comments only where the "why" isn't obvious from the resource name and config.

**Lifecycle:**
- Tag every resource with at minimum: `environment`, `project`, and `managed-by: terraform` (or equivalent).
- Set `prevent_destroy` on stateful resources (databases, storage) in Terraform. Use `@description` annotations in Bicep.
- Include a `terraform.tfvars.example` (or equivalent) with placeholder values — never commit real `.tfvars` files.
- Add `*.tfvars`, `*.tfstate`, `*.tfstate.backup`, `.terraform/` to `.gitignore` if not already there.

### 5. Add deployment instructions

Include a brief `infra/README.md` with:

```markdown
# Infrastructure

## Prerequisites

- [tool] installed (version X+)
- [provider] CLI authenticated
- [any required permissions]

## Deploy

[exact commands to init, plan, and apply]

## Environments

[how to switch between dev/staging/prod]
```

### 6. Verify

After writing the files:

- If Terraform is installed, run `terraform fmt` and `terraform validate` in the `infra/` directory.
- If Bicep CLI is available, run `az bicep build` to check syntax.
- Flag any resources that will incur cost — the user should know what they're about to pay for before applying.

## Tips

- Start minimal. It's better to scaffold 3 resources the user definitely needs than 15 they might need. They can always ask for more.
- State backend configuration (remote state in a storage account or S3 bucket) is critical for team use but can be added later for solo work. Mention it but don't block on it.
- If the project has a data model or discovery doc, use it to inform what storage and compute resources to scaffold. Don't ask the user to repeat what's already documented.
- Cost matters. Default to the cheapest SKU/tier that meets the functional requirements. Call out any resource that might surprise the user on the bill.
- The scaffold should work on first apply. If a resource requires manual steps (like DNS verification or marketplace acceptance), document them clearly in the README.
