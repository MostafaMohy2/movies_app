import 'package:movies_app/core/l10n/app_localizations.dart';

class Validator {
  const Validator._();

  static String? nameValidator(String? input, AppLocalizations locale) {
    if (input == null) {
      return locale.invalidName;
    }
    if (input.trim().isEmpty) {
      return locale.nameCantBeEmpty;
    }
    if (!RegExp(r"^[\p{L}\p{M}\s\-']+$", unicode: true).hasMatch(input)) {
      return locale.nameisinInvalidFormat;
    }
    return null;
  }

  static String? emailValidator(String? input, AppLocalizations locale) {
    if (input == null) {
      return locale.invalidEmail;
    }
    if (input.trim().isEmpty) {
      return locale.emailCantBeEmpty;
    }
    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(input.trim())) {
      return locale.emailIsInInvalidFormat;
    }
    return null;
  }

  static String? passwordValidator(String? input, AppLocalizations locale) {
    if (input == null) {
      return locale.invalidPassword;
    }
    if (input.isEmpty) {
      return locale.passwordCantBeEmpty;
    }
    if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    ).hasMatch(input)) {
      return locale.passwordIsInInvalidFormat;
    }
    return null;
  }

  static String? passwordConfirmationValidator(
    String? input,
    String password,
    AppLocalizations locale,
  ) {
    if (input == null) {
      return locale.invalidPasswordConfirmation;
    }
    if (input.isEmpty) {
      return locale.passwordConfirmationCantBeEmpty;
    }
    if (input != password) {
      return locale.passwordsDoNotMatch;
    }
    return null;
  }

  @Deprecated('Use passwordConfirmationValidator instead (fixed typo)')
  static String? passwordConfirmaitonValidator(
    String? input,
    String password,
    AppLocalizations locale,
  ) {
    return passwordConfirmationValidator(input, password, locale);
  }
}
