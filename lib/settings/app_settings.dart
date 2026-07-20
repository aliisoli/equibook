import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preferences.dart';
import '../l10n/app_strings.dart';

class AppSettings extends ChangeNotifier {
  static const _languageKey = 'equibook_language';
  static const _calendarKey = 'equibook_calendar';

  AppLanguage language = AppLanguage.english;
  AppCalendar calendar = AppCalendar.gregorian;
  bool ready = false;

  Locale get locale => Locale(language.code);
  bool get isRtl => language == AppLanguage.farsi;
  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  AppStrings get strings => AppStrings(language);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    language = AppLanguage.fromCode(prefs.getString(_languageKey));
    calendar = AppCalendar.fromName(prefs.getString(_calendarKey));
    ready = true;
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage value) async {
    if (language == value) return;
    language = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, value.code);
    notifyListeners();
  }

  Future<void> setCalendar(AppCalendar value) async {
    if (calendar == value) return;
    calendar = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_calendarKey, value.name);
    notifyListeners();
  }
}
