import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lia_simplis/app_controller.dart';
import 'package:lia_simplis/lia_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fluxo principal chega ao resultado e atualiza progresso', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppController();
    await controller.load();
    await tester.pumpWidget(LiaSimplisApp(controller: controller));

    await tester.enterText(find.byKey(const Key('name-field')), 'Maria');
    await tester.tap(find.byKey(const Key('start-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('adjust-continue-button')));
    await tester.pumpAndSettle();
    expect(find.text('Bem-vindo(a), Maria!'), findsOneWidget);

    await tester.tap(find.text('Aprender e treinar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mensagem suspeita'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('begin-simulation-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('answer-safe')));
    await tester.pumpAndSettle();

    expect(find.text('Boa escolha'), findsOneWidget);
    expect(controller.completed, 1);
    expect(controller.protectedChoices, 1);
  });
}
