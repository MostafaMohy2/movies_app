import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../base/base_cubit.dart';
import 'app_config_states.dart';

@lazySingleton
class AppConfigCubit
    extends
        BaseCubit<AppConfigStates, AppConfigAction, AppConfigNavigationAction> {
  static const String _localeStorageKey = 'app_locale';
  final SharedPreferences _preferences;

  AppConfigCubit(this._preferences)
    : super(AppConfigStates(locale: _readInitialLocale(_preferences)));

  static Locale _readInitialLocale(SharedPreferences preferences) {
    final savedCode = preferences.getString(_localeStorageKey);
    if (savedCode == 'ar') {
      return const Locale('ar');
    }
    return const Locale('en');
  }

  @override
  Future<void> doAction(AppConfigAction action) async {
    switch (action) {
      case LoadAppConfigAction():
        emit(state.copyWith(locale: _readInitialLocale(_preferences)));
      case ChangeLocaleAction(:final locale):
        await _preferences.setString(_localeStorageKey, locale.languageCode);
        emit(state.copyWith(locale: locale));
    }
  }
}
