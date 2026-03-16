# Coding Standards

## Naming Conventions
- Files must use kebab-case
- Functions must use camelCase
- Constants must use SCREAMING_SNAKE_CASE

## Error Handling
- All async functions must have try/catch blocks
- Errors must be logged before being rethrown or swallowed

## Module Structure
- Each module must export a default object grouping related functions
- Named exports are allowed for types/interfaces only
