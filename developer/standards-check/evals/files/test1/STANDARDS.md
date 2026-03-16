# Coding Standards

## Naming Conventions
- Files must use kebab-case (e.g., `user-profile.js`, not `userProfile.js` or `UserProfile.js`)
- Functions must use camelCase
- Constants must use SCREAMING_SNAKE_CASE
- React components must use PascalCase

## Error Handling
- All async functions must have try/catch blocks
- Errors must be logged before being rethrown or swallowed
- Never use empty catch blocks

## Comments
- All exported functions must have a JSDoc comment describing what they do
- Inline comments should explain "why", not "what"

## Imports
- Third-party imports must come before local imports
- Each import group must be separated by a blank line
