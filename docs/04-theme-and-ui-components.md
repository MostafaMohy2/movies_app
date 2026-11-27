# Shared UI Catalogue

This catalogue documents all shared UI primitives in `lib/core/common_ui/`. Every new shared widget must have an entry here before commit.

## Primitives Catalogue

| Widget | File Path | Constructor Signature | Purpose |
| :--- | :--- | :--- | :--- |
| `MovieCard` | `lib/core/common_ui/movie_card/movie_card.dart` | `MovieCard({Key? key, required MovieEntity movie, VoidCallback? onTap, double? width, double? height, double aspectRatio = 2 / 3, double borderRadius = 16})` | Minimal movie poster card displaying the poster image and top-left rating badge (⭐) matching Figma design |
| `AppTextField` | `lib/core/common_ui/inputs/app_text_field.dart` | `AppTextField({Key? key, TextEditingController? controller, required String hintText, required IconData prefixIcon, String? Function(String?)? validator, TextInputType keyboardType = TextInputType.text, TextInputAction textInputAction = TextInputAction.next, bool isPassword = false, List<TextInputFormatter>? inputFormatters, String? obscureTooltip, ValueChanged<String>? onChanged, ValueChanged<String>? onFieldSubmitted, bool enabled = true})` | Dark rounded `TextFormField` with RTL-safe padding, prefix icon, and optional password visibility toggle |
| `AppButton` | `lib/core/common_ui/buttons/app_button.dart` | `AppButton({Key? key, required String label, required VoidCallback? onPressed, bool isLoading = false, bool isEnabled = true, Widget? leading, Color backgroundColor = AppColors.primary, Color foregroundColor = Colors.black, double? height, double borderRadius = 15})` | Primary/custom `ElevatedButton` supporting loading spinner, disabled state, and optional leading icon |
| `LanguageToggleSwitch` | `lib/core/common_ui/toggles/language_toggle_switch.dart` | `LanguageToggleSwitch({Key? key, required Locale currentLocale, required ValueChanged<Locale> onLocaleSelected})` | Accessible EN/AR pill toggle switch with 48dp minimum touch targets |
