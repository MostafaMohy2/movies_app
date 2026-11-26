// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تطبيق الأفلام';

  @override
  String get popularMovies => 'الأفلام الأكثر شعبية';

  @override
  String get topRatedMovies => 'الأفلام الأعلى تقييماً';

  @override
  String get nowPlaying => 'يعرض حالياً';

  @override
  String get upcomingMovies => 'أفلام قادمة قريباً';

  @override
  String get searchHint => 'ابحث عن أفلام، ممثلين، مخرجين...';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get watchlist => 'قائمة المشاهدة';

  @override
  String get favorites => 'المفضلة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get theme => 'المظهر';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get rating => 'التقييم';

  @override
  String get releaseDate => 'تاريخ الإصدار';

  @override
  String get overview => 'نبذة عن الفيلم';

  @override
  String get cast => 'طاقم العمل';

  @override
  String get noMoviesFound => 'لم يتم العثور على أفلام';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errorLoadingMovies =>
      'فشل في تحميل الأفلام. يرجى المحاولة مرة أخرى.';

  @override
  String get invalidName => 'اسم غير صالح';

  @override
  String get nameCantBeEmpty => 'لا يمكن أن يكون الاسم فارغاً';

  @override
  String get nameisinInvalidFormat => 'صيغة الاسم غير صالحة';

  @override
  String get invalidEmail => 'البريد الإلكتروني غير صالح';

  @override
  String get emailCantBeEmpty => 'لا يمكن أن يكون البريد الإلكتروني فارغاً';

  @override
  String get emailIsInInvalidFormat => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get invalidPassword => 'كلمة المرور غير صالحة';

  @override
  String get passwordCantBeEmpty => 'لا يمكن أن تكون كلمة المرور فارغة';

  @override
  String get passwordIsInInvalidFormat =>
      'يجب ألا تقل كلمة المرور عن 8 أحرف وتحتوي على حرف كبير وصغير ورقم ورمز خاص';

  @override
  String get invalidPasswordConfirmation => 'تأكيد كلمة المرور غير صالح';

  @override
  String get passwordConfirmationCantBeEmpty =>
      'لا يمكن أن يكون تأكيد كلمة المرور فارغاً';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';
}
