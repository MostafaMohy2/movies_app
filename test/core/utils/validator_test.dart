import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/core/l10n/app_localizations.dart';
import 'package:movies_app/core/utils/validator.dart';

void main() {
  final enLocale = lookupAppLocalizations(const Locale('en'));
  final arLocale = lookupAppLocalizations(const Locale('ar'));

  group('Validator - Name', () {
    test('validates English names successfully', () {
      expect(Validator.nameValidator('John Doe', enLocale), isNull);
      expect(Validator.nameValidator('Mary-Jane', enLocale), isNull);
    });

    test('validates Arabic names successfully', () {
      expect(Validator.nameValidator('أحمد محمد', arLocale), isNull);
      expect(Validator.nameValidator('فاطمة الزهراء', enLocale), isNull);
    });

    test('returns error for empty or null name', () {
      expect(Validator.nameValidator(null, enLocale), enLocale.invalidName);
      expect(Validator.nameValidator('', enLocale), enLocale.nameCantBeEmpty);
      expect(
        Validator.nameValidator('   ', enLocale),
        enLocale.nameCantBeEmpty,
      );
    });

    test('returns error for invalid symbols in name', () {
      expect(
        Validator.nameValidator('John@Doe#', enLocale),
        enLocale.nameisinInvalidFormat,
      );
    });
  });

  group('Validator - Email', () {
    test('validates valid emails', () {
      expect(Validator.emailValidator('test@example.com', enLocale), isNull);
      expect(
        Validator.emailValidator('user.name+tag@sub.domain.org', enLocale),
        isNull,
      );
    });

    test('returns error for invalid emails', () {
      expect(Validator.emailValidator(null, enLocale), enLocale.invalidEmail);
      expect(Validator.emailValidator('', enLocale), enLocale.emailCantBeEmpty);
      expect(
        Validator.emailValidator('invalid-email', enLocale),
        enLocale.emailIsInInvalidFormat,
      );
    });
  });

  group('Validator - Password', () {
    test('validates strong password', () {
      expect(Validator.passwordValidator('Password123!', enLocale), isNull);
    });

    test('returns error for weak or invalid password', () {
      expect(
        Validator.passwordValidator(null, enLocale),
        enLocale.invalidPassword,
      );
      expect(
        Validator.passwordValidator('', enLocale),
        enLocale.passwordCantBeEmpty,
      );
      expect(
        Validator.passwordValidator('weak', enLocale),
        enLocale.passwordIsInInvalidFormat,
      );
    });
  });

  group('Validator - Password Confirmation', () {
    test('validates matching password confirmation', () {
      expect(
        Validator.passwordConfirmationValidator(
          'Secret123!',
          'Secret123!',
          enLocale,
        ),
        isNull,
      );
    });

    test('returns error when confirmation does not match', () {
      expect(
        Validator.passwordConfirmationValidator(
          'Mismatch123!',
          'Secret123!',
          enLocale,
        ),
        enLocale.passwordsDoNotMatch,
      );
    });
  });
}
