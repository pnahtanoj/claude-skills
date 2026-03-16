---
name: js-to-ts
description: Migrate a JavaScript project to TypeScript — audit files, install TypeScript, add tsconfig, rename files, resolve type errors iteratively, and update build tooling. Use this skill whenever the user wants to convert a JS project to TS, add TypeScript to an existing codebase, or says things like "migrate to TypeScript", "add types to this project", "convert this to TS", or "set up TypeScript". Also trigger when the user is starting to add .ts files to a .js project and hasn't set up TypeScript properly yet.
---

# JS to TypeScript Migration Skill

Migrate a JavaScript project to TypeScript in a controlled, iterative way. The goal is a clean build with no `any` escapes — but get it compiling first, then tighten types.

---

## Step 1: Audit the project

Before touching any files:

1. Read `package.json` — identify the build tool (Vite, webpack, esbuild, none), existing scripts, and any `@types/*` packages already installed.
2. Scan for `.js` and `.jsx` files — list them, note which are entry points, which are utilities, which have complex logic.
3. Check if `tsconfig.json` already exists. If it does, read it — don't overwrite settings the user has already made.
4. Check if the project uses a framework (Preact, React, Vue) — affects which tsconfig lib/jsx settings to use.
5. Check for a `vite.config.js` or other build config — it may need updating.

Summarise what you found before proceeding. If anything is ambiguous (e.g. unclear build target, mixed CJS/ESM), ask before continuing.

---

## Step 2: Install TypeScript

If TypeScript is not already in `devDependencies`:

```bash
npm install -D typescript
```

For common frameworks, also install type definitions:
- **Browser extension**: `npm install -D @types/chrome`
- **Node**: `npm install -D @types/node`
- **React**: `npm install -D @types/react @types/react-dom`
- Preact ships its own types — no `@types/preact` needed

Only install what the project actually uses.

---

## Step 3: Add tsconfig.json

If no `tsconfig.json` exists, load `references/tsconfig-templates.md` and choose the right template for the project's stack. Write it to the project root.

Key settings to always include:
- `"strict": true` — catches the most bugs; don't start with a loose config and promise to tighten later
- `"noEmit": true` if Vite or another tool handles compilation (TS is just for type-checking)
- `"moduleResolution": "bundler"` for Vite projects
- Correct `"jsx"` setting for the framework in use

---

## Step 4: Rename files

Rename files in this order — entry points and utilities first, so downstream files have typed imports to work with:

- `.js` → `.ts`
- `.jsx` → `.tsx`

Don't rename config files (`vite.config.js`, `vitest.config.js`) unless the user specifically wants to — they usually work fine as JS.

After renaming, run the type checker to get the initial error count:

```bash
npx tsc --noEmit
```

Report the count to the user before starting fixes.

---

## Step 5: Fix type errors — iterative loop

Run up to **5 passes**:

### Each pass:
1. Run `npx tsc --noEmit` and read the output.
2. Fix errors in priority order:
   - **Missing types on function parameters and return values** — add explicit types
   - **`possibly undefined` / `possibly null`** — add null checks or non-null assertions where safe
   - **Implicit `any`** — type the value properly; use `unknown` if the shape is genuinely unknown, not `any`
   - **Module resolution errors** — check import paths; `.js` extensions in imports may need updating
3. After fixing, re-run and check the new count.
4. Exit early if error count reaches zero.

### What NOT to do:
- Don't use `// @ts-ignore` or `any` to silence errors — fix the underlying issue. If a fix genuinely requires a product decision (e.g. "should this function accept null?"), flag it as an open question rather than papering over it.
- Don't add types that are more permissive than the actual runtime behaviour — a function that always returns a string shouldn't be typed as `string | undefined`.

### If an error is genuinely unresolvable in this pass:
Add a `// TODO(ts-migration): [reason]` comment and move on. List these at the end.

---

## Step 6: Update build tooling

After a clean `tsc --noEmit`:

- **Vite**: Vite handles `.ts`/`.tsx` natively — no plugin needed. Check `vite.config.js` still references the right entry points.
- **Test runner**: If using Vitest, it also handles TS natively. Check `vitest.config.js` — load `references/tsconfig-templates.md` if the test config needs updating.
- **`package.json` scripts**: If there was a `build` or `check` script, consider adding a `"typecheck": "tsc --noEmit"` script so CI can run type checking separately.

---

## Step 7: Report

After the loop completes:

1. **Error count trajectory** — started at N, finished at M after P passes
2. **What was typed** — brief summary of the most significant type additions
3. **Open questions** — any `TODO(ts-migration)` items that need a product or architectural decision
4. **Remaining `any` uses** — list them; ask if the user wants to tighten them now or track them separately
5. Ask: *"Want me to do another pass to tighten types further, or is this good enough to ship?"*

---

## Rules

- Always run `tsc --noEmit` to verify, never assume a fix worked.
- Prefer explicit types over inferred ones at function boundaries — inference is fine inside function bodies.
- If the project has tests, run them after migration to catch runtime regressions.
- Don't rename config files unless asked.
