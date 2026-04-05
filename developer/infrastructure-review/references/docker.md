# Docker Review Checklist

Domain-specific checks for Dockerfiles, docker-compose files, and
`.dockerignore`. Use alongside the main review workflow.

---

## Table of Contents

1. [Image Selection](#image-selection)
2. [Build Security](#build-security)
3. [Build Efficiency](#build-efficiency)
4. [Runtime Configuration](#runtime-configuration)
5. [docker-compose](#docker-compose)
6. [.dockerignore](#dockerignore)

---

## Image Selection

- **Base image pinned to digest or specific version** — `FROM node:latest` or
  `FROM python:3` will silently change when upstream publishes a new image.
  Use `FROM node:20.11-alpine` or better, pin to a SHA256 digest for
  reproducible builds.
- **Minimal base image** — Use `-alpine`, `-slim`, or distroless variants
  unless the full image is needed. Smaller images have fewer vulnerabilities
  and faster pull times.
- **Official or verified images** — Base images should come from Docker
  Official Images or Verified Publishers, not random Docker Hub repos.

## Build Security

- **No secrets in build args or ENV** — `ARG` and `ENV` values are visible in
  image history (`docker history`). Secrets should be mounted at runtime, not
  baked into the image.
- **No secrets copied into the image** — Check for `COPY .env`, `COPY
  credentials.json`, or similar. Even if a later layer deletes them, they
  persist in earlier layers.
- **Non-root user** — The container should run as a non-root user. Look for
  `USER` instruction before `CMD`/`ENTRYPOINT`. Running as root means a
  container escape gives host root.
- **No `--privileged` or unnecessary capabilities** — In compose or runtime
  config, check for `privileged: true` or broad `cap_add` entries.
- **COPY is specific** — `COPY . .` copies everything including `.git`,
  `.env`, `node_modules`. Use specific paths or ensure `.dockerignore` is
  comprehensive.

## Build Efficiency

- **Multi-stage builds** — Build dependencies (compilers, dev packages)
  shouldn't be in the final image. Use multi-stage builds to separate build
  and runtime stages.
- **Layer ordering for cache efficiency** — Instructions that change
  infrequently (installing OS packages, copying lockfiles) should come before
  instructions that change often (copying source code). A common pattern:
  ```dockerfile
  COPY package.json package-lock.json ./
  RUN npm ci
  COPY . .
  ```
- **Combined RUN instructions** — Multiple consecutive `RUN` commands that
  could be a single command create unnecessary layers. Combine with `&&`.
- **Cache mounts for package managers** — Use `--mount=type=cache` for pip,
  npm, apt, etc. to avoid re-downloading packages on every build.
- **No unnecessary files in image** — Check for `.git/`, `node_modules/`,
  test files, docs, or other development artifacts making it into the final
  image.

## Runtime Configuration

- **HEALTHCHECK defined** — Without a health check, orchestrators can't tell
  if the application inside the container is actually working. Define a
  `HEALTHCHECK` instruction or configure health checks in compose/k8s.
- **Explicit EXPOSE** — `EXPOSE` documents which ports the container listens
  on. Missing it isn't a bug but makes the image harder to use.
- **CMD vs ENTRYPOINT** — `CMD` provides defaults that can be overridden.
  `ENTRYPOINT` makes the container behave like a binary. Using both together
  is the most flexible pattern. Using only `ENTRYPOINT` with no `CMD` means
  users can't easily override the command.
- **Signal handling** — Use `exec` form (`CMD ["node", "server.js"]`) not
  shell form (`CMD node server.js`). Shell form wraps the process in `/bin/sh`
  which doesn't forward signals, causing slow/ungraceful shutdown.
- **Appropriate restart policy** — In compose, `restart: unless-stopped` or
  `restart: on-failure` is usually better than `restart: always` (which
  restarts even on clean exit).

## docker-compose

- **Version field** — The `version` field in docker-compose.yml is obsolete
  in Compose V2. Remove it to avoid confusion.
- **Named volumes for persistent data** — Anonymous volumes are hard to
  manage and back up. Use named volumes for databases and persistent state.
- **Network isolation** — Services that don't need to communicate shouldn't
  share a network. Use explicit `networks` to segment.
- **Environment variables vs env_file** — Inline `environment` blocks with
  secrets are committed to git. Prefer `env_file` pointing to a `.env` that's
  in `.gitignore`.
- **Resource limits** — For production compose files, set `mem_limit` and
  `cpus` to prevent a single container from consuming all host resources.
- **Dependency ordering** — Use `depends_on` with `condition:
  service_healthy` (not just `service_started`) to wait for actual readiness.

## .dockerignore

- **Exists** — If there's a Dockerfile but no `.dockerignore`, the entire
  build context (potentially gigabytes) is sent to the Docker daemon.
- **Covers the basics** — Should include at minimum: `.git`, `node_modules`,
  `.env`, `*.log`, `__pycache__`, `.pytest_cache`, `.vscode`, `.idea`.
- **Matches the project** — Check that language-specific artifacts are
  excluded (e.g., `target/` for Rust/Java, `dist/` if it shouldn't be in
  the image, `venv/` for Python).
