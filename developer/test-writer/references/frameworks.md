# Framework-Specific Vitest Config

Load this reference when the project uses a UI framework (Preact, React, Vue, Svelte, etc.) and no `vitest.config.js` exists yet.

**Before creating a new config**: check if `vite.config.js` already exists. If it does, copy its `plugins` array into `vitest.config.js` rather than writing one from scratch — this ensures the test environment matches the build environment.

---

## Preact + Vite

Source files use `.jsx`. Requires `@preact/preset-vite` to handle JSX transformation.

```js
// vitest.config.js
import { defineConfig } from 'vitest/config';
import preact from '@preact/preset-vite';

export default defineConfig({
  plugins: [preact()],
  test: {
    environment: 'jsdom',
  },
});
```

If not already installed: `npm install -D @preact/preset-vite`

---

## React + Vite

Source files use `.jsx` or `.tsx`. Requires `@vitejs/plugin-react`.

```js
// vitest.config.js
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
  },
});
```

If not already installed: `npm install -D @vitejs/plugin-react`

---

## Vue + Vite

Source files use `.vue`. Requires `@vitejs/plugin-vue`.

```js
// vitest.config.js
import { defineConfig } from 'vitest/config';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [vue()],
  test: {
    environment: 'jsdom',
  },
});
```

If not already installed: `npm install -D @vitejs/plugin-vue`

---

## Svelte + Vite

Source files use `.svelte`. Requires `@sveltejs/vite-plugin-svelte`.

```js
// vitest.config.js
import { defineConfig } from 'vitest/config';
import { svelte } from '@sveltejs/vite-plugin-svelte';

export default defineConfig({
  plugins: [svelte({ hot: !process.env.VITEST })],
  test: {
    environment: 'jsdom',
  },
});
```

If not already installed: `npm install -D @sveltejs/vite-plugin-svelte`

---

## TypeScript (no framework)

No plugin needed — Vitest handles `.ts` files natively. Just ensure `tsconfig.json` exists.

```js
// vitest.config.js
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'jsdom',
  },
});
```
