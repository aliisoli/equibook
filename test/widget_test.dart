import 'package:equibook/app.dart';
import 'package:equibook/data/app_store.dart';
import 'package:equibook/settings/app_settings.dart';
import 'package:equibook/settings/preferences.dart';
import 'package:equibook/utils/app_dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Welcome screen shows EquiBook brand', (tester) async {
    final settings = AppSettings()..ready = true;
    final store = AppStore()..ready = true;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settings),
          ChangeNotifierProvider.value(value: store),
        ],
        child: const EquiBookApp(),
      ),
    );

    expect(find.text('EquiBook'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('فارسی'), findsOneWidget);
  });

  test('Jalali and Gregorian conversion is accurate for Nowruz samples', () {
    final settings = AppSettings()..calendar = AppCalendar.hijriShamsi;
    final dates = AppDates(settings);

    // 1 Farvardin 1403 = 20 March 2024
    final nowruz1403 = dates.fromJalali(Jalali(1403, 1, 1));
    expect(nowruz1403, DateTime(2024, 3, 20));
    expect(dates.toJalali(DateTime(2024, 3, 20)), Jalali(1403, 1, 1));

    // 1 Farvardin 1404 = 21 March 2025
    final nowruz1404 = dates.fromJalali(Jalali(1404, 1, 1));
    expect(nowruz1404, DateTime(2025, 3, 21));
    expect(dates.toJalali(DateTime(2025, 3, 21)), Jalali(1404, 1, 1));

    // Round-trip a mid-year Gregorian instant through Jalali civil day
    final mid = DateTime(2024, 7, 15, 14, 30);
    final j = dates.toJalali(mid);
    final back = dates.fromJalali(j);
    expect(back.year, mid.year);
    expect(back.month, mid.month);
    expect(back.day, mid.day);

    // Known leap Esfand boundary: 30 Esfand 1399 = 20 March 2021
    expect(dates.fromJalali(Jalali(1399, 12, 30)), DateTime(2021, 3, 20));
    expect(dates.toJalali(DateTime(2021, 3, 20)), Jalali(1399, 12, 30));
  });

  testWidgets('Switching to Farsi updates welcome copy and RTL', (tester) async {
    final settings = AppSettings()..ready = true;
    final store = AppStore()..ready = true;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: settings),
          ChangeNotifierProvider.value(value: store),
        ],
        child: const EquiBookApp(),
      ),
    );

    await settings.setLanguage(AppLanguage.farsi);
    await tester.pumpAndSettle();

    expect(find.text('ساخت حساب'), findsOneWidget);
    expect(find.text('هجری شمسی'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('EquiBook'))),
        TextDirection.rtl);
  });
}
