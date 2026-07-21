enum AppLanguage {
  english,
  farsi;

  String get code => switch (this) {
    AppLanguage.english => 'en',
    AppLanguage.farsi => 'fa',
  };

  String get nativeLabel => switch (this) {
    AppLanguage.english => 'English',
    AppLanguage.farsi => 'فارسی',
  };

  static AppLanguage fromCode(String? code) => switch (code) {
    'en' => AppLanguage.english,
    'fa' => AppLanguage.farsi,
    _ => AppLanguage.farsi,
  };
}

/// Gregorian vs Iranian Solar Hijri (Hijri Shamsi / Jalali).
enum AppCalendar {
  gregorian,
  hijriShamsi;

  String label(AppLanguage language) => switch (this) {
    AppCalendar.gregorian =>
      language == AppLanguage.farsi ? 'میلادی' : 'Gregorian',
    AppCalendar.hijriShamsi =>
      language == AppLanguage.farsi ? 'هجری شمسی' : 'Hijri Shamsi',
  };

  static AppCalendar fromName(String? name) => switch (name) {
    'gregorian' => AppCalendar.gregorian,
    'hijriShamsi' => AppCalendar.hijriShamsi,
    _ => AppCalendar.hijriShamsi,
  };
}
