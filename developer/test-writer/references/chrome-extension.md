# Chrome Extension Test Patterns

Load this reference when writing tests for a browser extension — i.e., when the source file uses `chrome.*` APIs, `navigator.clipboard`, or manages timers that need cleanup.

---

## Full chrome mock setup

Place this in a `beforeAll` or at the top of the describe block. Only include the APIs the code under test actually calls — don't paste the whole block blindly.

```js
beforeAll(() => {
  global.chrome = {
    tabs: {
      query: vi.fn().mockResolvedValue([]),
      get: vi.fn().mockResolvedValue({}),
    },
    storage: {
      local: {
        get: vi.fn().mockResolvedValue({}),
        set: vi.fn().mockResolvedValue(undefined),
        remove: vi.fn().mockResolvedValue(undefined),
      },
      session: {
        get: vi.fn().mockResolvedValue({}),
        set: vi.fn().mockResolvedValue(undefined),
        remove: vi.fn().mockResolvedValue(undefined),
      },
    },
    runtime: {
      sendMessage: vi.fn().mockResolvedValue(undefined),
      onMessage: {
        addListener: vi.fn(),
        removeListener: vi.fn(),
      },
    },
    action: {
      setIcon: vi.fn().mockResolvedValue(undefined),
      setBadgeText: vi.fn().mockResolvedValue(undefined),
      setBadgeBackgroundColor: vi.fn().mockResolvedValue(undefined),
    },
  };
});
```

Reset mocks between tests so state doesn't bleed across:

```js
beforeEach(() => {
  vi.clearAllMocks();
});
```

---

## Controlling storage return values per test

The default mock returns `{}` (empty). Override per-test with `mockResolvedValueOnce`:

```js
it('resumes a session when one is stored', async () => {
  chrome.storage.session.get.mockResolvedValueOnce({
    activeSession: { startedAt: Date.now() - 60000, attendees: 3 }
  });

  await loadSession();

  expect(chrome.storage.session.set).toHaveBeenCalledWith(
    expect.objectContaining({ activeSession: expect.any(Object) })
  );
});
```

---

## navigator.clipboard

jsdom does not implement `navigator.clipboard`. Mock it manually:

```js
beforeAll(() => {
  Object.defineProperty(navigator, 'clipboard', {
    value: {
      writeText: vi.fn().mockResolvedValue(undefined),
      readText: vi.fn().mockResolvedValue(''),
    },
    writable: true,
  });
});
```

Test copy behaviour:

```js
it('copies the formatted cost to the clipboard', async () => {
  await copyResult('$12.50');
  expect(navigator.clipboard.writeText).toHaveBeenCalledWith('$12.50');
});
```

---

## setInterval / setTimeout cleanup

Use Vitest's fake timers to control time and verify that intervals fire (or don't) without real waiting. Also verify cleanup so you don't test a component that leaks timers.

```js
beforeEach(() => {
  vi.useFakeTimers();
});

afterEach(() => {
  vi.useRealTimers();
  vi.clearAllTimers();
});
```

Advance time explicitly:

```js
it('updates the elapsed display every second', () => {
  startTimer();
  vi.advanceTimersByTime(3000);
  expect(document.getElementById('elapsed').textContent).toBe('0:03');
});
```

Verify cleanup by checking that `clearInterval` was called with the right ID:

```js
it('clears the interval on stop', () => {
  const clearSpy = vi.spyOn(global, 'clearInterval');
  const id = startTimer();
  stopTimer();
  expect(clearSpy).toHaveBeenCalledWith(id);
});
```

---

## Testing async message passing

If the code sends a `chrome.runtime.sendMessage` and acts on the response:

```js
it('updates state after receiving a pong', async () => {
  chrome.runtime.sendMessage.mockResolvedValueOnce({ status: 'active' });

  await sendPing();

  expect(chrome.storage.session.set).toHaveBeenCalledWith(
    expect.objectContaining({ status: 'active' })
  );
});
```

---

## Common pitfalls

- **Don't forget `// @vitest-environment jsdom`** at the top of the file — chrome mocks still need the DOM environment.
- **`chrome.storage` is async** — always `await` calls to `.get()` and `.set()`, and use `mockResolvedValue` not `mockReturnValue`.
- **`vi.clearAllMocks()` vs `vi.resetAllMocks()`** — `clearAllMocks` clears call history but keeps the mock implementation; `resetAllMocks` removes the implementation too. Use `clearAllMocks` unless you want to re-specify return values in every test.
- **Fake timers interact with Promises** — if code uses `setTimeout` inside an async function, you may need `await vi.runAllTimersAsync()` instead of `vi.advanceTimersByTime()`.
