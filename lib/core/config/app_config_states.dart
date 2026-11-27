import 'package:flutter/material.dart';

class AppConfigStates {
  final Locale locale;

  const AppConfigStates({this.locale = const Locale('en')});

  AppConfigStates copyWith({Locale? locale}) =>
      AppConfigStates(locale: locale ?? this.locale);
}

sealed class AppConfigAction {}

class LoadAppConfigAction extends AppConfigAction {}

class ChangeLocaleAction extends AppConfigAction {
  final Locale locale;
  ChangeLocaleAction(this.locale);
}

sealed class AppConfigNavigationAction {}
