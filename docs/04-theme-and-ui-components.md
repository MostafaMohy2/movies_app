# Shared UI Catalogue

This catalogue documents all shared UI primitives in `lib/core/common_ui/`. Every new shared widget must have an entry here before commit.

## Primitives Catalogue

| Widget | File Path | Constructor Signature | Purpose |
| :--- | :--- | :--- | :--- |
| `MovieCard` | `lib/core/common_ui/movie_card/movie_card.dart` | `MovieCard({Key? key, required MovieEntity movie, VoidCallback? onTap, double? width, double? height, double aspectRatio = 2 / 3, double borderRadius = 16})` | Minimal movie poster card displaying the poster image and top-left rating badge (⭐) matching Figma design |
