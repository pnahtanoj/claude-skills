# CI/CD Pipeline Review Checklist

Domain-specific checks for GitHub Actions, GitLab CI, Azure DevOps Pipelines,
and general CI/CD configuration. Use alongside the main review workflow.

---

## Table of Contents

1. [Security](#security)
2. [Reliability](#reliability)
3. [Efficiency](#efficiency)
4. [Structure](#structure)
5. [Platform-Specific Issues](#platform-specific-issues)

---

## Security

- **No plaintext secrets** — Secrets should reference the platform's secret
  store (`${{ secrets.X }}` in GitHub Actions, CI/CD variables in GitLab,
  variable groups in Azure DevOps). Grep for API keys, tokens, passwords,
  and connection strings in workflow files.
- **Minimal permissions** — GitHub Actions workflows should set `permissions`
  explicitly rather than inheriting the default token permissions. Look for
  `permissions: write-all` or missing `permissions` block entirely.
- **Third-party action pinning** — Actions should be pinned to a commit SHA,
  not a mutable tag. `uses: actions/checkout@v4` can be hijacked if the tag
  is moved. Use `uses: actions/checkout@<sha>` instead. This is one of the
  most common supply chain attack vectors.
- **No self-hosted runner abuse potential** — Self-hosted runners that process
  `pull_request_target` or `workflow_run` events from forks can be exploited
  to run arbitrary code with access to secrets.
- **Artifact and cache poisoning** — Untrusted PRs shouldn't produce
  artifacts or caches that trusted workflows consume. Check for
  `actions/cache` usage in workflows triggered by PRs from forks.
- **OIDC for cloud authentication** — Prefer OIDC federation over long-lived
  credentials for authenticating to cloud providers from CI. Look for
  `aws-actions/configure-aws-credentials` with `role-to-assume` (good) vs.
  `aws-access-key-id` (less good).

## Reliability

- **Idempotent steps** — Every step should be safe to re-run. If a step
  creates a resource, it should check if it already exists or use
  create-if-not-exists patterns.
- **Failure handling** — Are there steps that should fail the pipeline if
  they fail but don't (missing `set -e`, `|| true` suppressing real errors)?
  Conversely, are there steps that fail on non-critical issues and block the
  pipeline unnecessarily?
- **Timeout configured** — Jobs without timeouts can run indefinitely if
  something hangs, consuming runner minutes. Set `timeout-minutes` (GitHub
  Actions), `timeout` (GitLab CI), or equivalent.
- **Concurrency controls** — Deployments to the same environment should not
  run concurrently. Look for `concurrency` groups (GitHub Actions),
  `resource_group` (GitLab CI), or exclusive locks.
- **Retry on flaky steps** — Network-dependent steps (package installs, image
  pulls, API calls) benefit from retry logic. But retries should be targeted,
  not blanket — retrying a failing test suite hides real failures.

## Efficiency

- **Caching** — Are dependencies cached between runs? Look for
  `actions/cache` or built-in caching (`actions/setup-node` with `cache`
  parameter, GitLab CI `cache` key). Missing cache means every run downloads
  the internet.
- **Conditional execution** — Do expensive jobs run when they don't need to?
  A full test suite shouldn't re-run when only docs changed. Look for path
  filters (`on.push.paths`, `on.pull_request.paths`, GitLab CI `rules`).
- **Parallel where possible** — Independent jobs should run in parallel, not
  sequentially. Check that `needs` dependencies (GitHub Actions) or `stage`
  ordering (GitLab CI) reflect actual dependencies, not just convention.
- **Minimal checkout** — For large repos, `actions/checkout` with
  `fetch-depth: 1` (shallow clone) is faster and uses less bandwidth. Full
  history is only needed for specific operations (changelog generation, blame).
- **Build matrix** — Testing across multiple versions/platforms should use a
  matrix strategy, not duplicated job definitions.

## Structure

- **DRY workflows** — Duplicated steps across workflows should be extracted
  into reusable workflows (`workflow_call`) or composite actions. Copy-paste
  across workflow files means bugs get fixed in one place and not another.
- **Clear job naming** — Job and step names should describe what they do, not
  just "Build" and "Test." Good names make the GitHub Actions / GitLab CI UI
  useful for debugging.
- **Environment separation** — Deployments to different environments should
  use the platform's environment feature (GitHub Environments, GitLab CI
  environments) for protection rules and secret scoping.
- **Approval gates for production** — Production deployments should require
  manual approval. Check for `environment` with `reviewers` (GitHub),
  `when: manual` (GitLab), or approval gates (Azure DevOps).

## Platform-Specific Issues

### GitHub Actions

- `pull_request` vs `pull_request_target` — `pull_request_target` runs with
  write permissions and access to secrets even for fork PRs. It should never
  checkout and run untrusted PR code.
- Composite actions can't use `secrets` context — they must receive secrets
  as inputs, which may expose them in logs if inputs are printed.
- `GITHUB_TOKEN` permissions — default is overly broad in many orgs.
  Workflows should declare minimum required permissions.
- Expression injection — `${{ github.event.pull_request.title }}` in a `run`
  step is a script injection vector. Use an intermediate environment variable
  instead.

### GitLab CI

- `only/except` is deprecated — use `rules` instead for clearer conditional
  logic.
- Shared runners vs. group runners — sensitive jobs shouldn't run on shared
  runners where other projects on the instance can observe timing or
  resource usage.
- `artifacts:expire_in` — Without expiration, artifacts accumulate
  indefinitely, consuming storage.
- Protected branches and tags — deployment jobs should be restricted to
  protected refs to prevent unauthorized deployments.

### Azure DevOps

- Service connections should use workload identity federation, not service
  principal secrets.
- Pipeline variables marked as secret still appear in debug logs — use
  variable groups linked to Key Vault for true secret management.
- Template expressions (`${{ }}`) are processed at compile time, runtime
  expressions (`$[ ]`) at runtime. Mixing them up causes confusing failures.
