# Vite + Preact Scaffold

Use this when the project uses Vite as the build tool and Preact for the UI. Requires `@crxjs/vite-plugin` for hot-reload and asset handling during development.

---

## Project structure

```
project/
├── manifest.json
├── package.json
├── vite.config.js
└── src/
    └── popup/
        ├── index.html
        ├── main.jsx
        └── App.jsx
```

Add `src/background/index.js` only if a service worker is needed.

---

## Files to generate

### `manifest.json`

With `@crxjs/vite-plugin`, the manifest is consumed by Vite — keep it at the project root.

```json
{
  "manifest_version": 3,
  "name": "[Extension Name]",
  "version": "0.1.0",
  "description": "[Description]",
  "action": {
    "default_popup": "src/popup/index.html",
    "default_title": "[Extension Name]"
  },
  "permissions": []
}
```

`@crxjs` handles the CSP and asset rewriting automatically — don't add a manual `content_security_policy` entry.

---

### `package.json`

```json
{
  "name": "[extension-name]",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "preact": "^10.0.0"
  },
  "devDependencies": {
    "@crxjs/vite-plugin": "^2.0.0-beta",
    "@preact/preset-vite": "^2.0.0",
    "vite": "^5.0.0"
  }
}
```

---

### `vite.config.js`

```js
import { defineConfig } from 'vite';
import preact from '@preact/preset-vite';
import { crx } from '@crxjs/vite-plugin';
import manifest from './manifest.json';

export default defineConfig({
  plugins: [
    preact(),
    crx({ manifest }),
  ],
});
```

---

### `src/popup/index.html`

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[Extension Name]</title>
</head>
<body>
  <div id="app"></div>
  <script type="module" src="./main.jsx"></script>
</body>
</html>
```

---

### `src/popup/main.jsx`

```jsx
import { render } from 'preact';
import { App } from './App';

render(<App />, document.getElementById('app'));
```

---

### `src/popup/App.jsx`

Generate appropriate starter component based on what the extension does. Always include:

```jsx
import { useState, useEffect } from 'preact/hooks';

export function App() {
  const [state, setState] = useState(null);

  useEffect(() => {
    // Load state from chrome.storage.session on mount
    chrome.storage.session.get('state').then(result => {
      if (result.state) setState(result.state);
    });
  }, []);

  async function handleAction() {
    const newState = { /* ... */ };
    await chrome.storage.session.set({ state: newState });
    setState(newState);
  }

  return (
    <div class="app">
      {/* UI goes here */}
    </div>
  );
}
```

Add a `<style>` block or a sibling `App.css` for component styles. Set explicit popup dimensions on the root element — Chrome sizes the popup to its content.

---

## After generating files

Tell the user to run:

```bash
npm install
npm run dev
```

Then load the extension in Chrome via `chrome://extensions` → "Load unpacked" → select the `dist/` folder (created by `@crxjs` during `dev`).

---

## MV3 gotchas (Vite+Preact specific)

- **`@crxjs/vite-plugin` v2 is in beta** — use the `^2.0.0-beta` tag; the v1 API is different
- **Hot reload works in dev** — `@crxjs` handles HMR without a full extension reload
- **`chrome.storage.session` for state** — do not use `sessionStorage`; use `chrome.storage.session` for any state that needs to survive popup close/reopen within a session
- **`chrome.*` types** — if the user wants TypeScript, add `@types/chrome` to devDependencies
- **Popup dimensions** — set `width` and `min-height` on the root `<div>`, not `body`, when using a component framework
