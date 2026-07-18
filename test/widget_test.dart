import 'package:equibook/app.dart';
import 'package:equibook/data/app_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Welcome screen shows EquiBook brand', (tester) async {
    final store = AppStore();
    store.ready = true;

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: store,
        child: const EquiBookApp(),
      ),
    );

    expect(find.text('EquiBook'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });
}
