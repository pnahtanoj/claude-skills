---
name: test-writer
description: Generate Vitest unit tests for a JavaScript file and write them to disk. Use this skill whenever the user wants tests written, asks to add test coverage, wants a test file generated, or says things like "write tests for...", "add tests to...", "test this file", "generate a test suite", or "what should we test here". Also trigger when the user shares a new JS file and testing hasn't been discussed yet — proactively suggest it. Tests are written to a .test.js file alongside the source and are ready to run with `npx vitest`.
---

# Test Writer Skill

Your job is to read a JavaScript source file, understand what it does, and write a Vitest test suite that covers its meaningful behaviour. Write the tests to a `.test.js` file alongside the source.

## Before writing tests

1. **Read the source file in full.** Don't skim — you need to understand every function, its inputs, outputs, and side effects.
2. **Identify what's testable.** Not everything is worth testing equally. Prioritise in this order:
   - Pure functions (take input, return output, no side effects) — easiest and highest value
   - State transitions (functions that read/write sessionStorage or update module-level state)
   - DOM interactions — test last; they require more setup and are more brittle
3. **Check for side effects on module load.** If the file calls a function at the bottom (e.g. `boot()`, `init()`, `setup()`), note it — you'll need to handle module isolation so tests don't trigger unintended effects.
4. **Check if a `vitest.config.js` exists** in the project root. If not, create one (see template below).

## Test file location and naming

- Place the test file alongside the source: if source is `popup.js`, tests go in `popup.test.js`
- Use `describe` blocks to group related tests
- Use `it()` with plain-English descriptions: `it('returns zero cost for zero elapsed time')`

## Environment setup

For browser extension popup code, always configure jsdom so DOM APIs and `sessionStorage` are available:

```js
// @vitest-environment jsdom
```

Add this as the first line comment in the test file. This tells Vitest to use jsdom for this file without needing a global config change.

**If the source file uses any `chrome.*` APIs, `navigator.clipboard`, or manages timers** — load `references/chrome-extension.md` before writing the test file. It contains ready-to-use mock patterns for `chrome.storage.local`, `chrome.storage.session`, `navigator.clipboard`, `setInterval`/`setTimeout` cleanup, and async message passing, along with common pitfalls. Use only the mocks the code under test actually calls.

## sessionStorage

jsdom provides a working `sessionStorage`. Use `beforeEach` to clear it between tests:

```js
beforeEach(() => {
  sessionStorage.clear();
});
```

## Handling module-level side effects

If the source file runs code on load (e.g. `boot()` at the bottom), importing it directly will trigger that code. Options:

1. **Extract and export** the functions you want to test — the cleanest long-term solution, but requires editing the source
2. **Mock the side-effecting call** using `vi.mock()` before import
3. **Test the functions in isolation** by copying their logic into the test or refactoring to accept dependencies as parameters

Note which approach you used and why. If the source would benefit from refactoring for testability, say so — but don't refactor it yourself unless asked.

## What to test

For each testable unit, write tests that cover:

- **Happy path** — the normal case with valid inputs
- **Edge cases** — zero, empty string, null/undefined, boundary values (e.g. attendee count of 1 and 40)
- **Error cases** — what happens when something is missing or malformed

Don't write tests for things that can't fail (e.g. a function that just sets a constant). Don't test implementation details — test observable behaviour.

## vitest.config.js template

If no config exists at the project root, check whether the project uses a framework (Preact, React, Vue, Svelte) or TypeScript. If it does, load `references/frameworks.md` for the right config template. For vanilla JS, use:

```js
// vitest.config.js
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'jsdom',
  },
});
```

## Output summary

After writing the files, tell the user:
- What file was created and where
- How many tests were written and what they cover
- Any functions that couldn't be tested without refactoring, and why
- How to run: `npx vitest`
