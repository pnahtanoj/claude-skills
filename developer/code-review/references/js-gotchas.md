# JavaScript Gotchas

Patterns to check specifically when reviewing JavaScript or TypeScript code.

## Async / Promises

- **Unawaited Promises** — a `Promise` returned from an async call that isn't `await`-ed or `.then()`-ed will run silently and its errors will be swallowed. Look for calls to async functions without `await`.
- **Missing error handling** — `async/await` without a `try/catch`, or `.then()` without a `.catch()`. Especially dangerous for `fetch`, `chrome.storage`, and `navigator.clipboard`.
- **`async` in `forEach`** — `array.forEach(async fn)` doesn't wait for each iteration to complete. Use `for...of` or `Promise.all()` instead.
- **Returning inside `async` without `await`** — `return someAsyncFn()` from an `async` function works, but `return await someAsyncFn()` is needed if there's a `try/catch` that should catch it.

## Type coercion

- **Loose equality (`==`)** — almost always wrong. `0 == ''`, `null == undefined`, `[] == false`. Use `===`.
- **`parseInt` without radix** — `parseInt('08')` can behave unexpectedly. Always pass the radix: `parseInt(str, 10)`.
- **Implicit string/number coercion** — adding a string to a number gives a string. Watch for `+` operations on values that could be either type.

## DOM

- **`innerHTML` with unsanitized input** — XSS risk. Use `textContent` for text, or sanitize before using `innerHTML`.
- **DOM queries that can return `null`** — `document.getElementById()` returns `null` if the element doesn't exist. Accessing `.textContent` on `null` throws. Guard or assert.
- **Event listeners added multiple times** — if setup code runs more than once (e.g. on popup reopen), listeners accumulate. Either use `{ once: true }`, remove before adding, or gate with a flag.
- **Inline event handlers** — `onclick="..."` attributes are blocked by MV3's default CSP. Always use `addEventListener`.

## Intervals and timers

- **`setInterval` not cleared** — if the interval reference is lost or `clearInterval` is never called, the interval runs forever. Store the ID and clear it explicitly on stop/reset.
- **`setTimeout`/`setInterval` with string argument** — `setInterval("doThing()", 1000)` uses `eval`. Always pass a function reference.

## Scope and closures

- **`var` in loops** — `var` is function-scoped, not block-scoped. Loop variables declared with `var` share the same binding across iterations. Use `let` or `const`.
- **Stale closures** — a closure that captures a variable by reference will see the value at call time, not at definition time. Common source of bugs in event handlers and async callbacks.
- **Mutating function parameters** — mutating an object passed as a parameter mutates the caller's reference. Use spread or `Object.assign` to copy if mutation isn't intended.

## sessionStorage / localStorage

- **`JSON.parse` without try/catch** — if stored data is malformed or was written by a different version of the code, `JSON.parse` throws. Wrap in try/catch or validate before parsing.
- **Assuming values exist** — `sessionStorage.getItem()` returns `null` if the key doesn't exist, not `undefined` or `0`. Guard before using the value.
- **Storing non-serializable values** — `sessionStorage` only stores strings. Functions, `undefined`, and circular references will be lost or throw on `JSON.stringify`.

## Browser extension specifics

- **`chrome.*` APIs are async** — most `chrome.*` calls (storage, tabs, runtime) return Promises in MV3. Don't treat them as synchronous.
- **`activeTab` vs `tabs` permission** — `activeTab` only grants access to the tab the user just interacted with. Querying all tabs requires the `tabs` permission.
- **Service worker termination** — MV3 service workers are killed after ~30s of inactivity. Don't rely on in-memory state in a service worker surviving across popup open/close cycles.
- **CSP blocks `eval` and inline scripts** — `eval()`, `new Function()`, and inline event handlers are blocked by the default MV3 CSP. Any dynamic code execution will silently fail or throw.
