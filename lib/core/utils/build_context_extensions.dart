import 'package:movies_app/core/l10n/app_localizations.dart';
import 'package:movies_app/core/utils/dialog_utils.dart';
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  AppLocalizations get locale => AppLocalizations.of(this)!;

  NavigatorState get navigator => Navigator.of(this);

  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(this, routeName, arguments: arguments);
  }

  void pop<T>([T? result]) {
    Navigator.pop(this, result);
  }

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  void showDialogUtils({
    String message = 'Loading',
    bool barrierDismissible = false,
  }) {
    const DialogUtils dialogUtils = DialogUtils();
    dialogUtils.showAlertDialog(
      this,
      message: message,
      barrierDismissible: barrierDismissible,
    );
  }

  Future<void> showActionDialog({
    String? message,
    String? title,
    String? postActionTitle,
    Future<void> Function()? negativeAction,
    Future<void> Function()? postAction,
    String? negativeActionTitle,
    bool barrierDismissible = false,
  }) async {
    const DialogUtils dialogUtils = DialogUtils();
    await dialogUtils.showActionDialog(
      this,
      message: message,
      title: title,
      postActionTitle: postActionTitle,
      postAction: postAction,
      negativeAction: negativeAction,
      negativeActionTitle: negativeActionTitle,
      barrierDismissible: barrierDismissible,
    );
  }
}
