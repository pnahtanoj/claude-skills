# tsconfig.json Templates

Choose the template that matches the project's stack. Adjust `include`/`exclude` paths to match the actual project structure.

---

## Vite + Preact

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "jsxImportSource": "preact",
    "strict": true,
    "noEmit": true,
    "skipLibCheck": true
  },
  "include": ["src"]
}
```

---

## Vite + React

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "strict": true,
    "noEmit": true,
    "skipLibCheck": true
  },
  "include": ["src"]
}
```

---

## Browser Extension (vanilla TS, no build tool)

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ES2020",
    "moduleResolution": "node",
    "lib": ["ES2020", "DOM"],
    "strict": true,
    "outDir": "dist",
    "rootDir": "src",
    "skipLibCheck": true
  },
  "include": ["src"]
}
```

Note: requires `@types/chrome` for `chrome.*` API types.

---

## Browser Extension + Vite

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ES2020", "DOM"],
    "strict": true,
    "noEmit": true,
    "skipLibCheck": true
  },
  "include": ["src"]
}
```

Note: requires `@types/chrome` for `chrome.*` API types.

---

## Node (scripts, CLIs, servers)

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "strict": true,
    "outDir": "dist",
    "rootDir": "src",
    "skipLibCheck": true
  },
  "include": ["src"]
}
```

---

## Common settings reference

| Setting | When to use |
|---|---|
| `"noEmit": true` | Vite/Vitest handles compilation — TS is type-check only |
| `"outDir": "dist"` | TS handles compilation (no Vite) |
| `"skipLibCheck": true` | Almost always — skips type errors in `node_modules` |
| `"moduleResolution": "bundler"` | Vite projects |
| `"moduleResolution": "Node16"` | Node ESM projects |
| `"jsxImportSource": "preact"` | Preact — makes JSX use Preact's runtime automatically |
