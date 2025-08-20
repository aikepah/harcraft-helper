# GitHub Copilot Instructions for This Rails Application

## General Principles
- Follow Rails conventions (MVC, RESTful routes, naming, etc.).
- Use Hotwire (Turbo + Stimulus) for interactivity and real-time updates.
- Use SQLite for local development and testing.
- Prefer server-rendered HTML over heavy frontend JavaScript frameworks.
- Keep controllers thin, models fat (business logic in models).
- Use partials and helpers to keep views DRY.
- Write tests for controllers, models, and system/integration flows.

## Rails
- Use strong parameters in controllers.
- Use background jobs for long-running tasks.
- Use Rails validations and callbacks in models.
- Use Rails form helpers and path helpers.
- Use Rails generators for scaffolding when possible.

## Hotwire (Turbo & Stimulus)
- Use Turbo Frames and Turbo Streams for partial page updates.
- Use Stimulus controllers for client-side behavior.
- Keep Stimulus controllers small and focused.
- Prefer Turbo Streams for real-time updates (e.g., broadcasting changes).
- Avoid custom JavaScript unless necessary; use Stimulus for JS needs.

## Database (SQLite)
- Use SQLite for development and testing only.
- Use Rails migrations for schema changes.
- Seed data using `db/seeds.rb`.

## Code Quality
- Use RuboCop for linting and code style.
- Use Brakeman for security checks.
- Use `rails test` or `rails spec` for running tests.

## File Organization
- Place all assets in `app/assets` or `app/javascript` as appropriate.
- Place reusable view code in `app/views/shared` or as partials.
- Place Stimulus controllers in `app/javascript/controllers`.

## Miscellaneous
- Document non-obvious code with comments.
- Use environment variables for secrets (never commit secrets).
- Keep dependencies minimal and up-to-date.

---

_These instructions are for GitHub Copilot and contributors. Please follow these best practices to ensure code quality and maintainability._
