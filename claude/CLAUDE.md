# CLAUDE.md

## Who you're working with

Staff-level software engineer. Don't explain fundamentals, hedge obvious tradeoffs, or
pad answers with caveats — assume mistakes will be caught and pushed back on if needed.
Primary languages: Ruby, Go, and SQL.

## Style

- Be explicit over clever. No implicit magic, no hidden side effects.
- Concise. No filler, no restating the question, no "great question!"-style padding.
- Inline comments only when the *why* isn't obvious from the code — never comment the *what* unless writing API docs.
- Comments and docs describe the code as it stands, never how it got there. No references to previous
  implementations, rejected alternatives, or what changed — git holds that history. Avoid phrasing like
  "now", "instead of", "no longer", "used to", "rather than X".
- Prefer editing existing code/config over introducing new abstractions, frameworks, or
  dependencies to solve a small problem.
- Match existing conventions in a file/module before imposing new patterns.
- Wrap code and comments at a max of 120 characters per line.

## Ruby

- Follow Rubocop defaults unless a project's `.rubocop.yml` says otherwise — don't
  impose personal style over an existing project config.
- `frozen_string_literal: true` at the top of new files.
- Prefer keyword arguments once a method takes more than 1-2 params. Never use them for a method
  that defines a single parameter — that one takes a positional argument.
- Avoid metaprogramming (`method_missing`, `define_method`, `send` on privates) unless
  it removes real duplication — it costs readability and breaks jump-to-definition.
- Service objects / POROs for non-trivial business logic; keep ActiveRecord models
  focused on persistence and associations, not orchestration.
- Skinny controllers: no business logic, just params -> service/model -> response.
- Always add YARD documentation when adding or changing code, to aid intellisense tools. Use this format:
    ```ruby
    # Brief description of 'what' the method does
    #
    # Optional extra context, including the 'why' or examples if necessary
    #
    # @param user_id [Integer] id of the user to look up
    # @param strict [Boolean] whether to raise if the user is not found
    #
    # @raise [ActiveRecord::RecordNotFound] if strict is true and the user is not found
    #
    # @return [User, nil] the matching user, else nil
    ```

### Testing

- RSpec, `describe`/`context`/`it` structure, one expectation focus per `it`.
- Prefer real objects and DB-backed factories (FactoryBot) over mocks/stubs; only
  stub external services (HTTP, third-party APIs) or genuinely slow boundaries.
- Match existing spec conventions (shared examples, `let` vs instance vars) in a
  given file before introducing new patterns.
- Don't write tests for configuration, only test behavior.

## Working conventions

- **Never** utilize any authenticated CLI tools that interact with infrastructure (e.g. heroku, aws, terraform, etc).
- **Never** perform any destructive actions using git.
- **Never** read any environment variable files (e.g. .env, .env.development, etc)
- Flag platform/environment assumptions (OS, shell, package manager) that could break
  elsewhere instead of silently baking them in.
- **Never** add `Co-Authored-By` trailers or any other Claude attribution to commit messages or PR descriptions.
- Commit messages: title line max 50 characters (including any ticket prefix), every other line max 72 characters.
