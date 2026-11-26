// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Movies App';

  @override
  String get popularMovies => 'Popular Movies';

  @override
  String get topRatedMovies => 'Top Rated Movies';

  @override
  String get nowPlaying => 'Now Playing';

  @override
  String get upcomingMovies => 'Upcoming Movies';

  @override
  String get searchHint => 'Search movies, actors, directors...';

  @override
  String get seeAll => 'See All';

  @override
  String get watchlist => 'Watchlist';

  @override
  String get favorites => 'Favorites';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get rating => 'Rating';

  @override
  String get releaseDate => 'Release Date';

  @override
  String get overview => 'Overview';

  @override
  String get cast => 'Cast';

  @override
  String get noMoviesFound => 'No movies found';

  @override
  String get retry => 'Retry';

  @override
  String get errorLoadingMovies => 'Failed to load movies. Please try again.';

  @override
  String get invalidName => 'Invalid Name';

  @override
  String get nameCantBeEmpty => 'Name Can\'t Be Empty';

  @override
  String get nameisinInvalidFormat => 'Name is in Invalid Format';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get emailCantBeEmpty => 'Email can\'t be empty';

  @override
  String get emailIsInInvalidFormat => 'Please enter a valid email address';

  @override
  String get invalidPassword => 'Invalid password';

  @override
  String get passwordCantBeEmpty => 'Password can\'t be empty';

  @override
  String get passwordIsInInvalidFormat =>
      'Password must be at least 8 characters and include uppercase, lowercase, number, and special character';

  @override
  String get invalidPasswordConfirmation => 'Invalid password confirmation';

  @override
  String get passwordConfirmationCantBeEmpty =>
      'Password confirmation can\'t be empty';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get forgotPassword => 'Forgot Password';
}
