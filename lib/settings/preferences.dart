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
    'fa' => AppLanguage.farsi,
    _ => AppLanguage.english,
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
    'hijriShamsi' => AppCalendar.hijriShamsi,
    _ => AppCalendar.gregorian,
  };
}
