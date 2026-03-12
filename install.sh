#!/usr/bin/env bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing claude-skills to $SKILLS_DIR..."

mkdir -p "$SKILLS_DIR"

cp -r "$SCRIPT_DIR/context-handoff" "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/developer" "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/product-manager" "$SKILLS_DIR/"

echo "Done. Skills installed:"
echo ""
echo "  context-handoff"
echo ""
echo "  developer/"
echo "    architecture-decision"
echo "    browser-extension-scaffold"
echo "    code-review"
echo "    stack-decision"
echo ""
echo "  product-manager/"
echo "    design-critique"
echo "    feature-prioritization"
echo "    requirements-doc"
echo "    ticket-creator"
echo "    user-story-flow"
echo ""
echo "Skills are active in all Claude Code sessions."
echo "See README.md for customization instructions."
