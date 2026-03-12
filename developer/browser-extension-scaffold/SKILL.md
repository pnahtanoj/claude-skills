---
name: browser-extension-scaffold
description: Generate Manifest V3 browser extension boilerplate and write the files directly to the project. Use this skill whenever the user wants to start a new browser extension, scaffold the initial file structure, or set up the MV3 popup plumbing. Trigger on phrases like "scaffold a browser extension", "set up an extension", "create the boilerplate for...", "generate the manifest", "start a new extension", or any time the user is beginning extension development and needs the initial files created. Also trigger if the user has a blank repo and describes what their extension should do — even if they don't use the word "scaffold".
---

# Browser Extension Scaffold Skill

Your job is to generate a working Manifest V3 browser extension scaffold and write the files to the project directory.

## Step 1: Gather requirements

You need:
- **Extension name** — what it's called (used in manifest and UI)
- **Description** — one sentence for the manifest
- **Permissions** — which Chrome APIs does it need? Common ones: `storage`, `activeTab`, `tabs`, `alarms`. If unsure, ask — wrong permissions either break the extension or trigger unnecessary permission prompts.
- **State persistence** — does the popup need to remember state when closed and reopened? If yes, use the sessionStorage pattern (see below). If the popup is purely stateless (just reads something on open), skip it.
- **Target directory** — where to write the files. Default: current working directory. Ask if unclear.

If the user's message already answers these, proceed without asking. Only pause for genuinely missing information.

## Step 2: Generate the files

Write these four files:

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
  "permissions": [/* only what's needed */],
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'"
  }
}
```

MV3 rules to follow:
- Always `manifest_version: 3`
- Use `action`, not `browser_action`
- No `background.persistent` — if a service worker is needed, use `"background": {"service_worker": "background.js"}`. For popup-only extensions with sessionStorage state, no background entry is needed.
- Permissions array must only include what's actually used — Chrome will warn users about over-permissioned extensions
- CSP must not include `unsafe-inline` or `unsafe-eval`

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
```

Rules:
- Always `type="module"` on the script tag — enables ES modules and defers execution until DOM is ready, avoiding the need for DOMContentLoaded listeners
- Script tag at end of body
- No inline scripts or inline event handlers (`onclick=` etc.) — CSP will block them
- Link stylesheet in head

### `popup.js`

Generate appropriate starter logic based on what the extension does. Always include:

```js
// popup.js
```

**If sessionStorage state is needed**, use this pattern as the foundation:

```js
const STATE_KEY = 'ext_state';

function loadState() {
  const raw = sessionStorage.getItem(STATE_KEY);
  return raw ? JSON.parse(raw) : null;
}

function saveState(state) {
  sessionStorage.setItem(STATE_KEY, JSON.stringify(state));
}

function clearState() {
  sessionStorage.removeItem(STATE_KEY);
}

// On popup open: read state and render
const state = loadState();
if (state) {
  // Restore UI from state
} else {
  // Show initial UI
}
```

**If no persistence is needed**, omit the state pattern entirely.

Add stub functions for the main interactions the extension needs, with comments explaining what each should do. Don't leave a blank file — give the user a working skeleton they can fill in.

### `popup.css`

```css
/* popup.css */
*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  width: 320px;          /* standard popup width */
  min-height: 200px;
  font-family: system-ui, sans-serif;
  font-size: 14px;
  padding: 16px;
  background: #fff;
  color: #111;
}
```

Add any additional layout stubs that match what the popup needs to display.

## Step 3: Confirm and write

Tell the user what files you're about to write and where, then write them. Don't ask for confirmation unless something is ambiguous — the files are easy to edit and nothing here is destructive.

After writing, print a brief summary:
- Files created and their paths
- Any permissions included and why
- One gotcha to watch out for (pick the most relevant for their specific extension)

## Common MV3 gotchas (pick the most relevant for the summary)

- **Inline scripts blocked by CSP** — `onclick="..."` and `<script>alert()</script>` won't run. All JS must be in external files.
- **`type="module"` defers execution** — no need for `DOMContentLoaded` wrappers; the DOM is ready when the module runs.
- **sessionStorage is per-origin but clears on browser restart** — right for session state, wrong for persistent preferences (use `chrome.storage.local` for those).
- **Service workers terminate after ~30s idle** — don't rely on a service worker to hold in-memory state across popup open/close cycles.
- **Popup dimensions are content-sized** — set an explicit `width` and `min-height` on `body`, or the popup will collapse to nothing.
- **`chrome.storage` is async** — if using it, all reads return Promises, not values.
