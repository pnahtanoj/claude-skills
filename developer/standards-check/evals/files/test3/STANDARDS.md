# Coding Standards

## Architecture
- Business logic must live in `services/`, never in route handlers or controllers
- Route handlers must only: validate input, call a service, return a response
- Database queries must only appear in `repositories/`, never in services or routes

## Naming
- Files must use kebab-case
- Database repository files must end in `.repository.js`
- Service files must end in `.service.js`

## Error Handling
- All errors from repositories must be caught in the service layer
- Route handlers must not have try/catch — errors bubble up to the global error handler
- Never throw raw strings — always throw Error objects

## Response Format
- All API responses must follow: `{ success: boolean, data?: any, error?: string }`
