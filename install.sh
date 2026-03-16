#!/usr/bin/env bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing claude-skills to $SKILLS_DIR..."

mkdir -p "$SKILLS_DIR"

# Skills are installed flat into ~/.claude/skills/<skill-name>/
# regardless of the category structure in this repo.
# Claude Code discovers skills one level deep only.

cp -r "$SCRIPT_DIR/context-handoff"                        "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/skills-repo"                            "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/developer/architecture-decision"        "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/developer/browser-extension-scaffold"   "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/developer/code-review"                  "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/developer/stack-decision"               "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/developer/js-to-ts"                     "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/developer/test-writer"                  "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/product-manager/design-critique"        "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/product-manager/feature-prioritization" "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/product-manager/requirements-doc"       "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/product-manager/ticket-creator"         "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/product-manager/ticket-review"          "$SKILLS_DIR/"
cp -r "$SCRIPT_DIR/product-manager/user-story-flow"        "$SKILLS_DIR/"

echo "Done. Skills installed to $SKILLS_DIR:"
echo ""
echo "  context-handoff"
echo "  skills-repo"
echo "  architecture-decision"
echo "  browser-extension-scaffold"
echo "  code-review"
echo "  stack-decision"
echo "  js-to-ts"
echo "  test-writer"
echo "  design-critique"
echo "  feature-prioritization"
echo "  requirements-doc"
echo "  ticket-creator"
echo "  ticket-review"
echo "  user-story-flow"
echo ""
echo "Skills are active in all Claude Code sessions."
echo "See README.md for customization instructions."
