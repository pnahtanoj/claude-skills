---
name: browser-extension-scaffold
description: Generate Manifest V3 browser extension boilerplate and write the files directly to the project. Use this skill whenever the user wants to start a new browser extension, scaffold the initial file structure, or set up the MV3 popup plumbing. Trigger on phrases like "scaffold a browser extension", "set up an extension", "create the boilerplate for...", "generate the manifest", "start a new extension", or any time the user is beginning extension development and needs the initial files created. Also trigger if the user has a blank repo and describes what their extension should do — even if they don't use the word "scaffold".
---

# Browser Extension Scaffold Skill

Your job is to gather requirements, select the right scaffold template, and write the files to the project directory.

## Step 1: Gather requirements

You need:

- **Extension name** — used in the manifest and UI
- **Description** — one sentence for the manifest
- **Build stack** — does the project use a build tool (Vite + Preact, Vite + React, etc.) or plain vanilla JS? If there's already a `package.json` or `vite.config.js` in the directory, read it to determine the stack. If unclear, ask.
- **Permissions** — which Chrome APIs does it need? Common: `storage`, `activeTab`, `tabs`, `alarms`. If unsure, ask — wrong permissions either break the extension or trigger unnecessary user prompts.
- **State persistence** — does the popup need to remember state when closed and reopened? If yes, the scaffold will use `chrome.storage.session`. (Do not suggest `sessionStorage` for extension state — it behaves unreliably across popup open/close cycles.)
- **Background service worker** — is any logic needed that runs outside the popup (alarms, message passing, tab monitoring)? If yes, include a `background.js` / `background/index.js` stub.
- **Target directory** — where to write the files. Default: current working directory. Ask if unclear.

If the user's message already answers these, proceed without asking. Only pause for genuinely missing information.

## Step 2: Load the right template

Based on the build stack, load the corresponding reference file before generating any files:

- **Vanilla JS** (no build tool) → load `references/vanilla-js.md`
- **Vite + Preact** → load `references/vite-preact.md`
- **Other Vite framework** — the Vite + Preact reference is a useful structural guide; adapt the framework plugin accordingly

Follow the reference file's file list, templates, and gotchas exactly. Customise the content (extension name, permissions, UI stubs, state shape) to match the project — don't just copy the template verbatim.

## Step 3: Confirm and write

Tell the user what files you're about to write and where, then write them. Don't ask for confirmation unless something is ambiguous — the files are easy to edit and nothing here is destructive.

After writing, print a brief summary:
- Files created and their paths
- Any permissions included and why
- Next steps (e.g. `npm install && npm run dev`, or just "load unpacked" for vanilla)
- One gotcha most relevant to their specific extension (pick from the reference file's gotchas list)
