---
name: js-to-ts
description: Migrate a JavaScript project to TypeScript — audit files, install TypeScript, add tsconfig, rename files, resolve type errors iteratively, and update build tooling. Use this skill whenever the user wants to convert a JS project to TS, add TypeScript to an existing codebase, or says things like "migrate to TypeScript", "add types to this project", "convert this to TS", or "set up TypeScript". Also trigger when the user is starting to add .ts files to a .js project and hasn't set up TypeScript properly yet.
---

# JS to TypeScript Migration Skill

Migrate a JavaScript project to TypeScript in a controlled, iterative way. The goal is a clean `tsc --noEmit` build with no `any` escapes — but get it compiling first, then tighten types.

The skill's main value is the **structured workflow** — particularly the audit before touching files and the tsc iteration loop. The tsconfig settings themselves (jsxImportSource, moduleResolution, etc.) you already know; the skill keeps you from skipping steps.

---

## Step 1: Audit the project

Before touching any files:

1. Read `package.json` — identify the build tool (Vite, webpack, none), existing scripts, and any `@types/*` already installed.
2. Scan for `.js` and `.jsx` files — list them, note which are entry points, utilities, components.
3. Check if `tsconfig.json` already exists. If it does, read it — do not overwrite it. Work with what's there.
4. Check the framework (Preact, React, Vue, none) — affects tsconfig jsx settings.
5. Check for `vite.config.js` or similar build config.

Summarise what you found and confirm before proceeding. If anything is ambiguous, ask.

---

## Step 2: Install TypeScript

If TypeScript is not in `devDependencies`, install it:

```bash
npm install -D typescript
```

Install `@types/*` for whatever APIs the project actually uses — `@types/chrome` for browser extensions, `@types/node` for Node, etc. Preact ships its own types.

---

## Step 3: Add tsconfig.json

If no `tsconfig.json` exists, create one appropriate for the project's stack. Always include:
- `"strict": true` — don't start loose and promise to tighten later
- `"noEmit": true` if a bundler (Vite, etc.) handles compilation
- Correct `"jsx"` and `"moduleResolution"` for the stack
- `"lib"` entries that cover the APIs actually used — e.g. `["ES2020", "DOM"]` if the code touches `document`, `crypto`, `Intl`, or other browser globals; `ES2020` alone won't cover them

Load `references/tsconfig-templates.md` if you need a starting point for an unfamiliar stack.

---

## Step 4: Rename files

Rename `.js` → `.ts` and `.jsx` → `.tsx`. Prioritise entry points and utilities first so downstream files have typed imports to work with. Don't rename build config files (`vite.config.js`, etc.) unless asked.

After renaming, run the type checker to get the initial error count:

```bash
npx tsc --noEmit 2>&1 | tail -20
```

Report the count before starting fixes.

---

## Step 5: Fix type errors — tsc iteration loop

This is the core of the migration. Run up to **5 passes**:

### Each pass:
1. Run `npx tsc --noEmit` and read all errors.
2. Fix errors by priority:
   - **Unresolved names** (missing `@types/*`, wrong `lib`) — fix the config or install types
   - **Missing parameter/return types** — add explicit types
   - **`possibly undefined` / `possibly null`** — add null checks or narrow the type
   - **Implicit `any`** — type the value properly; use `unknown` for genuinely unknown shapes
   - **Module resolution errors** — check import paths
3. Re-run `tsc --noEmit` and check the new error count.
4. Exit early if error count reaches zero.

### Hard rules:
- No `// @ts-ignore` or `any` to silence errors — fix the underlying issue
- If a fix requires a product decision (e.g. "should this accept null?"), add `// TODO(ts-migration): [reason]` and move on — list these at the end
- Don't add types more permissive than actual runtime behaviour

---

## Step 6: Update build tooling

After a clean `tsc --noEmit`:

- **Vite** handles `.ts`/`.tsx` natively — verify entry points still resolve
- **package.json** — add `"typecheck": "tsc --noEmit"` if it's missing, so CI can run type checking independently
- **Test runner** — Vitest also handles TS natively; no config change usually needed

---

## Step 7: Report

1. **Error count trajectory** — started at N, finished at M after P passes
2. **What was typed** — most significant type additions
3. **Open questions** — `TODO(ts-migration)` items requiring product/architectural decisions
4. **Remaining `any` uses** — list them; ask if the user wants to tighten now or track separately
5. Ask: *"Want me to do another pass to tighten types further, or is this good to ship?"*
