import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lia_simplis/app_controller.dart';
import 'package:lia_simplis/lia_app.dart';
import 'package:lia_simplis/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('fluxo principal: onboarding → home → treino → resultado', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppController(random: Random(1));
    await controller.load();
    await tester.pumpWidget(LiaSimplisApp(controller: controller));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo ao Lia Simplis'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('name-field')), 'Maria');
    await tester.scrollUntilVisible(
      find.byKey(const Key('start-button')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('start-button')));
    await tester.pumpAndSettle();

    expect(find.text('Olá, Maria!'), findsOneWidget);

    await tester.tap(find.text('Começar treino'));
    await tester.pumpAndSettle();

    expect(find.text('Treinos'), findsOneWidget);

    await tester.tap(find.text('Mensagem suspeita'));
    await tester.pumpAndSettle();

    expect(find.text('Começar'), findsOneWidget);

    await tester.tap(find.text('Começar'));
    await tester.pumpAndSettle();

    expect(find.text('O que você faria primeiro?'), findsOneWidget);

    final safeAnswer = controller.scenario.answers.firstWhere(
      (a) => a.type == AnswerType.safe,
    );
    await tester.scrollUntilVisible(
      find.text(safeAnswer.label),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(safeAnswer.label));
    await tester.pumpAndSettle();

    expect(
      find.text('Muito bem! Você escolheu o caminho mais seguro.'),
      findsOneWidget,
    );
    expect(controller.completed, 1);
    expect(controller.protectedChoices, 1);
  });
}
