import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Title of the application
  ///
  /// In en, this message translates to:
  /// **'Movies App'**
  String get appTitle;

  /// Header for popular movies section
  ///
  /// In en, this message translates to:
  /// **'Popular Movies'**
  String get popularMovies;

  /// Header for top rated movies section
  ///
  /// In en, this message translates to:
  /// **'Top Rated Movies'**
  String get topRatedMovies;

  /// Header for now playing movies section
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// Header for upcoming movies section
  ///
  /// In en, this message translates to:
  /// **'Upcoming Movies'**
  String get upcomingMovies;

  /// Placeholder in the search bar
  ///
  /// In en, this message translates to:
  /// **'Search movies, actors, directors...'**
  String get searchHint;

  /// Button to view full list
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Watchlist tab or button title
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get watchlist;

  /// Favorites tab or button title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// Theme mode selection label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// Movie rating label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Movie release date label
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDate;

  /// Movie overview/synopsis header
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// Movie cast/actors header
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// Empty state text when search yields no results
  ///
  /// In en, this message translates to:
  /// **'No movies found'**
  String get noMoviesFound;

  /// Retry action button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Error message displayed when movie fetching fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load movies. Please try again.'**
  String get errorLoadingMovies;

  /// Validation error for invalid name
  ///
  /// In en, this message translates to:
  /// **'Invalid Name'**
  String get invalidName;

  /// Validation error when name is empty
  ///
  /// In en, this message translates to:
  /// **'Name Can\'\'t Be Empty'**
  String get nameCantBeEmpty;

  /// Validation error when name format is invalid
  ///
  /// In en, this message translates to:
  /// **'Name is in Invalid Format'**
  String get nameisinInvalidFormat;

  /// Validation error for invalid email
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// Validation error when email is empty
  ///
  /// In en, this message translates to:
  /// **'Email can\'\'t be empty'**
  String get emailCantBeEmpty;

  /// Validation error when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailIsInInvalidFormat;

  /// Validation error for invalid password
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPassword;

  /// Validation error when password is empty
  ///
  /// In en, this message translates to:
  /// **'Password can\'\'t be empty'**
  String get passwordCantBeEmpty;

  /// Validation error when password requirements are not met
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters and include uppercase, lowercase, number, and special character'**
  String get passwordIsInInvalidFormat;

  /// Validation error for invalid password confirmation
  ///
  /// In en, this message translates to:
  /// **'Invalid password confirmation'**
  String get invalidPasswordConfirmation;

  /// Validation error when password confirmation is empty
  ///
  /// In en, this message translates to:
  /// **'Password confirmation can\'\'t be empty'**
  String get passwordConfirmationCantBeEmpty;

  /// Validation error when passwords do not match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Login screen title and action label
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register screen title and action label
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Forgot password screen title
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
