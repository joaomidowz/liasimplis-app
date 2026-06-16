import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:lia_simplis/app_controller.dart';
import 'package:lia_simplis/app_data.dart';
import 'package:lia_simplis/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('inventário de conteúdo mantém paridade com o protótipo HTML', () {
    expect(trainings, hasLength(2));
    expect(trainings.expand((item) => item.scenarios), hasLength(15));
    expect(dictionaryTerms, hasLength(5));
    expect(deviceHelpItems, hasLength(4));
    for (final item in trainings.expand((training) => training.scenarios)) {
      expect(
        item.answers.map((answer) => answer.type).toSet(),
        AnswerType.values.toSet(),
      );
    }
  });

  test(
    'respostas seguras e de ajuda incrementam escolhas protegidas',
    () async {
      final controller = AppController(random: Random(1));
      await controller.load();
      controller.startTraining(trainings.first.name);

      controller.selectAnswer(const ScenarioAnswer(AnswerType.safe, 'Segura'));
      controller.selectAnswer(const ScenarioAnswer(AnswerType.help, 'Ajuda'));
      controller.selectAnswer(
        const ScenarioAnswer(AnswerType.risky, 'Arriscada'),
      );

      expect(controller.completed, 3);
      expect(controller.protectedChoices, 2);
      expect(controller.progress, closeTo(3 / 15, 0.001));
    },
  );

  test('favoritos alternam sem duplicação e persistem', () async {
    final controller = AppController();
    await controller.load();
    controller.selectTerm('link');
    controller.toggleFavorite();
    controller.toggleFavorite();
    controller.toggleFavorite();
    await Future<void>.delayed(Duration.zero);

    final restored = AppController();
    await restored.load();
    expect(restored.favoriteTerms, {'link'});
  });

  test('outro caso evita repetir o cenário atual', () async {
    final controller = AppController(random: Random(2));
    await controller.load();
    controller.startTraining(trainings.first.name);
    final previous = controller.currentScenarioId;
    controller.chooseAnotherScenario();
    expect(controller.currentScenarioId, isNot(previous));
  });
}
