import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../settings/app_settings.dart';
import '../settings/preferences.dart';

/// Formats and picks dates using Gregorian or Hijri Shamsi (Jalali).
///
/// Storage stays on [DateTime] (Gregorian timeline). Conversion uses
/// `shamsi_date` / Jalali algorithms for accurate Solar Hijri mapping.
class AppDates {
  AppDates(this.settings);

  final AppSettings settings;

  static AppDates of(BuildContext context) =>
      AppDates(context.read<AppSettings>());

  static AppDates watch(BuildContext context) =>
      AppDates(context.watch<AppSettings>());

  bool get _shamsi => settings.calendar == AppCalendar.hijriShamsi;
  bool get _fa => settings.language == AppLanguage.farsi;

  NumberFormat get money => NumberFormat.currency(
    locale: _fa ? 'fa' : 'en',
    symbol: '\$',
  );

  String formatMoney(num value) => money.format(value);

  String formatTime(DateTime dateTime) {
    if (_fa) {
      final h = dateTime.hour.toString().padLeft(2, '0');
      final m = dateTime.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return DateFormat('h:mm a', 'en').format(dateTime);
  }

  String formatTimeOfDay(BuildContext context, TimeOfDay time) {
    if (_fa) {
      final h = time.hour.toString().padLeft(2, '0');
      final m = time.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return time.format(context);
  }

  String formatDate(DateTime dateTime) {
    if (_shamsi) {
      final j = Jalali.fromDateTime(dateTime);
      final f = j.formatter;
      if (_fa) {
        return '${f.wN} ${f.d} ${f.mN} ${f.yyyy}';
      }
      return '${_jalaliWeekdayEn(j.weekDay)} ${j.day} ${_jalaliMonthEn(j.month)} ${j.year}';
    }
    return DateFormat(
      _fa ? 'EEEE d MMM y' : 'EEE, MMM d',
      _fa ? 'fa' : 'en',
    ).format(dateTime);
  }

  String formatDateTime(DateTime dateTime) {
    if (_shamsi) {
      final j = Jalali.fromDateTime(dateTime);
      final f = j.formatter;
      final time = formatTime(dateTime);
      if (_fa) {
        return '${f.wN} ${f.d} ${f.mN} ${f.yyyy} · $time';
      }
      return '${_jalaliWeekdayEn(j.weekDay)} ${j.day} ${_jalaliMonthEn(j.month)} ${j.year} · $time';
    }
    return DateFormat(
      _fa ? 'EEEE d MMM y · HH:mm' : 'EEE, MMM d · h:mm a',
      _fa ? 'fa' : 'en',
    ).format(dateTime);
  }

  /// Gregorian DateTime → Jalali components (for verification / display).
  Jalali toJalali(DateTime dateTime) => Jalali.fromDateTime(dateTime);

  /// Jalali → Gregorian DateTime at local midnight of that civil day.
  DateTime fromJalali(Jalali jalali) {
    final g = jalali.toDateTime();
    return DateTime(g.year, g.month, g.day);
  }

  Future<DateTime?> pickDate({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    if (_shamsi) {
      final picked = await showPersianDatePicker(
        context: context,
        initialDate: Jalali.fromDateTime(initialDate),
        firstDate: Jalali.fromDateTime(firstDate),
        lastDate: Jalali.fromDateTime(lastDate),
        locale: _fa ? const Locale('fa', 'IR') : const Locale('en', 'US'),
      );
      if (picked == null) return null;
      return fromJalali(picked);
    }

    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: settings.locale,
    );
  }

  String _jalaliMonthEn(int month) => const [
    'Farvardin',
    'Ordibehesht',
    'Khordad',
    'Tir',
    'Mordad',
    'Shahrivar',
    'Mehr',
    'Aban',
    'Azar',
    'Dey',
    'Bahman',
    'Esfand',
  ][month - 1];

  String _jalaliWeekdayEn(int weekDay) => const [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ][weekDay - 1];
}
