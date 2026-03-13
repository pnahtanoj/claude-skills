# Vanilla JS Scaffold

Use this when the project needs no build step — plain HTML, CSS, and JS loaded directly by Chrome.

---

## Files to generate

### `manifest.json`

```json
{
  "manifest_version": 3,
  "name": "[Extension Name]",
  "version": "0.1.0",
  "description": "[Description]",
  "action": {
    "default_popup": "popup.html",
    "default_title": "[Extension Name]"
  },
  "permissions": [],
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'"
  }
}
```

Only include permissions the extension actually uses. Chrome warns users about over-permissioned extensions.

If a background service worker is needed: add `"background": {"service_worker": "background.js"}`. For popup-only extensions, omit it.

---

### `popup.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Extension Name]</title>
  <link rel="stylesheet" href="popup.css">
</head>
<body>
  <!-- UI goes here -->
  <script src="popup.js" type="module"></script>
</body>
</html>
```

- `type="module"` defers execution until DOM is ready — no `DOMContentLoaded` wrapper needed
- No inline scripts or `onclick=` attributes — CSP blocks them

---

### `popup.js`

Always include a comment header. Add stub functions for the main interactions the extension needs.

**If state persistence is needed**, use `chrome.storage.session` — it persists across popup open/close cycles within a browser session and clears on browser restart. Do not use `sessionStorage` for extension state; it behaves unreliably across popup lifecycle events.

```js
// popup.js

const STATE_KEY = 'state';

async function loadState() {
  const result = await chrome.storage.session.get(STATE_KEY);
  return result[STATE_KEY] ?? null;
}

async function saveState(state) {
  await chrome.storage.session.set({ [STATE_KEY]: state });
}

async function clearState() {
  await chrome.storage.session.remove(STATE_KEY);
}

// On popup open: read state and render
const state = await loadState();
if (state) {
  // Restore UI from state
} else {
  // Show initial UI
}
```

Note: top-level `await` works because the script is loaded as a module (`type="module"`).

**If no persistence is needed**, omit the state pattern entirely.

---

### `popup.css`

```css
/* popup.css */
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  width: 320px;
  min-height: 200px;
  font-family: system-ui, sans-serif;
  font-size: 14px;
  padding: 16px;
  background: #fff;
  color: #111;
}
```

---

## MV3 gotchas

- **Inline scripts blocked by CSP** — all JS must be in external files
- **`chrome.storage` is async** — all reads/writes return Promises
- **`chrome.storage.session` vs `sessionStorage`** — use `chrome.storage.session` for extension state; `sessionStorage` can behave unexpectedly across popup open/close cycles
- **Service workers terminate after ~30s idle** — don't rely on them to hold in-memory state
- **Popup dimensions are content-sized** — set explicit `width` and `min-height` on `body`
