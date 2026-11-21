# Project Guidelines & Agents for `movies_app`

Welcome to `movies_app`. This project is a cross-platform Flutter application built with Dart.

## Project Specialized Subagents

### `flutter_developer`
- **Role**: Senior Flutter & Dart Specialist for `movies_app`.
- **Definition Path**: [flutter_developer.md](file:///d:/Flutter%20Projects/movies_app/.agents/agents/flutter_developer.md)
- **When to Invoke / Delegate**:
  - Developing new UI screens (Movie lists, detail views, search screens, cast profiles).
  - Building custom widgets, animations, and Hero transitions.
  - Designing and implementing state management (BLoC/Cubit, Riverpod, or Provider).
  - Integrating REST/GraphQL movie data APIs (e.g. TMDB) with robust error handling and pagination.
  - Resolving layout bugs (`RenderFlex` overflows, unbounded height/width).
  - Writing widget tests, unit tests, and running static analysis (`flutter analyze`).

## Code Standards
- **Dart & Flutter Version**: Modern Dart 3+ with sound null safety.
- **Widgets**: Prefer `const` constructors wherever possible to avoid unnecessary rebuilds.
- **Responsiveness**: Ensure layouts look great across mobile, tablet, desktop, and web using `LayoutBuilder`, `MediaQuery`, or adaptive widgets.
- **Architecture**: Keep presentation, business logic, and data layers cleanly decoupled.
