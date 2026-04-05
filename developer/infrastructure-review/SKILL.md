---
name: infrastructure-review
description: >
  Review existing infrastructure code — Terraform, Bicep, Pulumi, CDK,
  Dockerfiles, docker-compose, CI/CD pipelines (GitHub Actions, GitLab CI,
  Azure DevOps), and cloud IAM/networking config — for security risks,
  cost issues, reliability gaps, operational anti-patterns, and structural
  problems. Produces a prioritized findings report with severity levels and
  actionable fixes, then offers to apply corrections. Use this skill whenever
  the user wants infrastructure code reviewed, audited, or hardened, or asks
  things like "review my Terraform", "is this Dockerfile secure", "check my
  GitHub Actions workflow", "audit this IAM policy", "anything wrong with my
  infra", "review the infra/ directory", or "best practices check on this".
  Also trigger when the user shares IaC files and asks if they look right, or
  when they want a pre-apply sanity check. Do NOT trigger for generating new
  infrastructure from scratch (use infrastructure-scaffold), choosing between
  cloud services or tools (use stack-decision), or reviewing application code
  (use code-review).
---

# Infrastructure Review

Review existing infrastructure-as-code and DevOps configuration for problems
that matter: security vulnerabilities, cost surprises, reliability risks, and
operational footguns. The goal is to catch issues before `apply` or `deploy`,
not to enforce style preferences.

---

## Step 1: Scope the review

Identify what you're reviewing. Infrastructure code comes in many forms and
the review approach differs by type:

| Type | Files to look for |
|------|-------------------|
| **IaC** | `*.tf`, `*.bicep`, `*.pulumi.*`, CDK constructs, CloudFormation YAML/JSON |
| **Container** | `Dockerfile*`, `docker-compose*.yml`, `.dockerignore` |
| **CI/CD** | `.github/workflows/*.yml`, `.gitlab-ci.yml`, `azure-pipelines.yml`, `Jenkinsfile` |
| **Cloud config** | IAM policies, security group rules, bucket policies, RBAC definitions |

If the user points you at a specific file or directory, focus there. If they
say "review my infra," scan the project for all of the above and review
everything you find.

Before diving in, understand the context:
- What cloud provider(s) and IaC tool(s) are in use?
- Is there a `STANDARDS.md` with infrastructure conventions? Read it.
- Are there environment files (dev/staging/prod) that affect the review?
- What does this infrastructure support — a data pipeline, a web app, a
  microservices cluster? This shapes what "good" looks like.

---

## Step 2: Load the relevant reference

Based on what you're reviewing, read the appropriate reference file for
domain-specific checks:

- **Terraform / OpenTofu** — `references/terraform.md`
- **Dockerfiles & docker-compose** — `references/docker.md`
- **CI/CD pipelines** — `references/cicd.md`

These contain detailed checklists of common issues. Use them as a lens, not a
rigid rubric — skip checks that don't apply to what you're looking at, and
flag issues not on the list if you spot them.

If the IaC tool is Bicep, Pulumi, or CDK, the Terraform reference still
covers most conceptual issues (state management, secret handling, tagging,
lifecycle protection). Adapt the specifics to the tool's syntax.

---

## Step 3: Review by category

Work through these categories in order. Each category has a "why it matters"
to help you calibrate severity — a finding is more severe when the
consequence is more painful.

### Security

Why it matters: security issues can lead to data breaches, unauthorized
access, or compliance violations. These are almost always Critical or Major.

- Are secrets, keys, or passwords hardcoded anywhere?
- Are IAM permissions scoped to least privilege, or overly broad (`*` actions,
  `*` resources)?
- Is network access restricted appropriately — no `0.0.0.0/0` ingress on
  sensitive ports, no public-facing resources that should be private?
- Is encryption enabled at rest and in transit?
- Are container images pinned to digests or specific versions (not `latest`)?
- Are CI/CD secrets handled safely — no plaintext in workflow files, proper
  use of secret stores?
- Are cloud credentials short-lived (OIDC, managed identities, workload
  identity) rather than long-lived static keys?

### Cost

Why it matters: infrastructure costs compound silently. A wrong SKU or
missing lifecycle rule can cost thousands before anyone notices.

- Are resource sizes/SKUs appropriate, or over-provisioned for the workload?
- Are there resources that will incur cost even when idle (always-on VMs,
  provisioned throughput, static IPs)?
- Are storage lifecycle rules in place (move cold data to cheaper tiers,
  expire old objects)?
- Are dev/test environments using cheaper tiers than production?
- Are there resources that could use spot/preemptible instances?

**Include dollar estimates.** When you flag a cost issue, estimate the monthly
or annual cost where possible (e.g., "db.r5.2xlarge costs ~$700/month idle").
Approximate numbers are fine — the point is to make the cost tangible so the
user can prioritize. Use publicly available pricing pages for reference.

### Reliability

Why it matters: these issues cause outages, data loss, or painful recovery.

- Is state managed remotely with locking (not local `terraform.tfstate`)?
- Are stateful resources (databases, storage) protected from accidental
  deletion (`prevent_destroy`, deletion protection)?
- Is there a backup or snapshot strategy for data stores?
- Are health checks and restart policies configured for services?
- Are availability zones or regions used for critical workloads?
- Could a partial `apply` leave infrastructure in a broken state?

### Operations

Why it matters: operational gaps turn every change into a stressful manual
process and make incidents harder to diagnose.

- Are all resources tagged consistently (environment, project, owner,
  managed-by)?
- Are outputs defined for values other resources or humans will need
  (endpoints, connection strings, resource IDs)?
- Is there a README or deployment guide with exact commands to plan/apply?
- Are CI/CD pipelines using `plan` before `apply`, with human approval gates
  for production?
- Is drift detection or scheduled plan diffing in place?
- Are logs, metrics, or alerts configured for key resources?

### Structure

Why it matters: poor structure makes infrastructure code hard to change
safely, leading to copy-paste drift and fear of refactoring.

- Are resources organized by concern (networking, storage, compute), not
  dumped into a single file?
- Are reusable patterns extracted into modules (Terraform) or constructs
  (CDK)?
- Are variables documented with descriptions and sensible defaults?
- Is there unnecessary duplication that should be a module or loop?
- Are environment differences handled via variables/parameters, not
  copy-pasted directories?

---

## Step 3b: Identify compound risks

After reviewing individual findings, look for combinations that are worse
together than the sum of their parts. Infrastructure issues rarely exist in
isolation — a finding that looks Major on its own can become Critical when
combined with another.

**Example attack chains:**
- Public database + open security group + hardcoded password = any internet
  user can log into your database right now
- `pull_request_target` + expression injection = any fork contributor can
  exfiltrate all repository secrets via a PR title
- No remote state + no deletion protection + `skip_final_snapshot` = a single
  accidental `terraform destroy` permanently deletes production data with no
  recovery path

**Example failure cascades:**
- No health check + no restart policy = a hung process stays "healthy" forever
  while serving errors
- No concurrency control + no approval gate = two deploys race and leave the
  environment in a half-updated state

When you find a compound risk, call it out explicitly in the findings as an
**Attack Chain** or **Failure Cascade** — describe the sequence of events and
the end state. These compound risks should be presented at the top of the
findings, before the individual severity-grouped items, because they represent
the most dangerous scenarios and set the context for why individual findings
matter.

---

## Step 4: Run available linters

If the relevant tooling is installed, run automated checks to supplement your
review:

| Tool | Command | What it catches |
|------|---------|-----------------|
| `terraform` | `terraform fmt -check -recursive && terraform validate` | Formatting and syntax |
| `tflint` | `tflint --recursive` | Provider-specific issues, deprecated syntax |
| `checkov` | `checkov -d .` | Security and compliance policy violations |
| `trivy` | `trivy config .` | Misconfigurations across IaC and Docker |
| `hadolint` | `hadolint Dockerfile` | Dockerfile best practice violations |
| `actionlint` | `actionlint` | GitHub Actions workflow problems |

Check if each tool is available before running it (e.g., `which tflint`).
Don't ask the user to install tools — just use what's there and note what
additional tools could catch more issues.

Incorporate linter findings into your review rather than presenting them
separately. If a linter catches something you already found, it confirms the
finding. If it catches something new, add it.

---

## Step 5: Present findings

### Severity tiers

**Critical** — Active security vulnerability, data loss risk, or will break
on apply. Must fix before deploying.

**Major** — Will cause real problems under normal conditions: cost overruns,
reliability gaps, operational pain. Should fix before deploying.

**Minor** — Won't break anything but degrades quality: missing tags, no
variable descriptions, suboptimal structure. Fix when convenient.

**Nit** — Style or preference. Mention but don't dwell on.

### Output format

Group findings by severity, then by category within each tier. Skip empty
tiers.

```
## Critical

- **Security** — `main.tf:24` — S3 bucket has no encryption configured and
  public access block is disabled. Any object uploaded is publicly readable
  in plaintext. Fix: add `aws_s3_bucket_public_access_block` and enable
  `server_side_encryption_configuration` with AES-256 or KMS.

## Major

- **Cost** — `compute.tf:15` — RDS instance uses `db.r5.2xlarge` in the dev
  environment. This costs ~$700/month idle. Fix: use `db.t3.medium` for dev
  and parameterize the instance class per environment.

- **Reliability** — `main.tf:1` — No remote backend configured. State is
  local, meaning no locking and no team collaboration. Fix: add an S3 + 
  DynamoDB backend (or equivalent).

## Minor

- **Operations** — `variables.tf` — 8 of 12 variables have no `description`.
  Fix: add descriptions so `terraform plan` output is understandable.
```

After the findings list, include:

### Remediation roadmap

Sequence the fixes into a practical plan. Group by what can be done together
and note the effort level and risk of each step. The goal is to turn a wall
of findings into a clear action plan.

**Example:**
```
## Remediation roadmap

1. **Rotate credentials and remove hardcoded secrets** (immediate, ~30 min)
   Move AWS creds to environment variables, DB password to Secrets Manager.
   This is urgent — the current creds should be considered compromised if
   this repo has ever been shared or public.

2. **Lock down network access** (same PR as #1, ~20 min)
   Set `publicly_accessible = false`, restrict security group to required
   ports and source CIDRs.

3. **Set up remote state** (separate PR, ~1 hour)
   Requires creating an S3 bucket + DynamoDB table first. Migrate with
   `terraform init -migrate-state`.

4. **Add lifecycle protection and backups** (separate PR, ~15 min)
   Add `prevent_destroy`, `deletion_protection`, `backup_retention_period`.
```

Also include:
- Total findings by severity
- Any tools that weren't available but would add value (e.g., "tflint wasn't
  installed — it would catch provider-specific issues")

---

## Step 6: Fix and re-review

After presenting findings, fix all Critical and Major issues directly. Then
re-review the changed files. Run up to 3 passes:

1. Review -> fix Critical/Major -> re-review
2. Review -> fix remaining Critical/Major -> re-review
3. Final review -> report what remains

Exit early if a pass finds no Critical or Major findings. Minor and Nit items
are reported but not auto-fixed — present them and ask if the user wants
another pass.

After the loop, report:
- **Pass count** — how many review cycles ran
- **What was fixed** — brief list of the most significant changes
- **Remaining issues** — Minor/Nit items, or anything requiring a product or
  architecture decision
- Then ask: *"Want me to go another round on the remaining items?"*

---

## Step 7: Standards compliance

If a `STANDARDS.md` exists, note it at the end:

> "This project has a `STANDARDS.md` — run `/standards-check` to verify
> compliance with project-specific conventions beyond what this review covers."

Don't duplicate `standards-check`'s job. This skill covers infrastructure
best practices; that one covers project-specific rules.

---

## Principles

**Prioritize by blast radius.** A misconfigured IAM role that grants admin
access to every service is more important than a missing tag. Order your
findings by how much damage they could cause, not by how many files they
appear in.

**Be specific about consequences.** Don't say "this is a security risk" —
say what an attacker could do, or what would happen in a failure scenario.
"This security group allows SSH from any IP, meaning anyone on the internet
can attempt to brute-force the instance" is actionable. "Consider restricting
SSH access" is not.

**Don't flag intentional trade-offs.** Dev environments often skip HA, use
cheaper tiers, and have looser security. That's fine if the environment is
clearly dev. Flag it only if there's no environment separation (same config
for dev and prod) or if the trade-off is dangerous even in dev (public
database with no password).

**Know when to stop.** A 5-finding review that catches the real problems is
better than a 30-finding review where the important stuff gets buried. If the
infrastructure is solid, say so.
