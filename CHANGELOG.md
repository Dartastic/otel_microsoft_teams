# Changelog

## [0.1.0-beta.2-wip]

## [0.1.0-beta.1] - 2026-06-04

### Added

- Initial release.
- `tracedMicrosoftTeams<T>(...)` — wraps a otel_microsoft_teams call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutMicrosoftTeamsInstrumentation()` / `Async()`.
