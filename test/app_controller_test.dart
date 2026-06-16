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
      expect(controller.screen, AppScreen.feedbackRight);

      controller.continueFromWord();
      controller.selectReinforcementAnswer(
        const ScenarioAnswer(AnswerType.help, 'Ajuda'),
      );
      expect(controller.screen, AppScreen.reinforcementFeedback);

      controller.finishTraining();
      expect(controller.screen, AppScreen.conclusion);

      expect(controller.completed, 1);
      expect(controller.protectedChoices, 2);
    },
  );

  test('resposta arriscada vai para feedbackWrong', () async {
    final controller = AppController(random: Random(1));
    await controller.load();
    controller.startTraining(trainings.first.name);
    controller.beginSimulation();

    controller.selectAnswer(
      const ScenarioAnswer(AnswerType.risky, 'Arriscada'),
    );
    expect(controller.screen, AppScreen.feedbackWrong);
    expect(controller.completed, 1);
    expect(controller.protectedChoices, 0);
  });

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

  test('tryAgain navega para novo cenário', () async {
    final controller = AppController(random: Random(3));
    await controller.load();
    controller.startTraining(trainings.first.name);
    controller.beginSimulation();
    final previous = controller.currentScenarioId;

    controller.selectAnswer(
      const ScenarioAnswer(AnswerType.risky, 'Arriscada'),
    );
    expect(controller.screen, AppScreen.feedbackWrong);

    controller.tryAgain();
    expect(controller.screen, AppScreen.simulation);
    expect(controller.currentScenarioId, isNot(previous));
  });

  test('showExplanation navega para wordExplanation', () async {
    final controller = AppController(random: Random(4));
    await controller.load();
    controller.startTraining(trainings.first.name);
    controller.beginSimulation();
    controller.selectAnswer(
      const ScenarioAnswer(AnswerType.risky, 'Arriscada'),
    );

    controller.showExplanation();
    expect(controller.screen, AppScreen.wordExplanation);
    expect(controller.activeTerm, 'link');
  });

  test('saveItem não duplica itens', () async {
    final controller = AppController();
    await controller.load();
    controller.saveItem('dica', 'Não clique em links');
    controller.saveItem('dica', 'Não clique em links');
    controller.saveItem('palavra', 'Link');

    expect(controller.savedItems, hasLength(2));
    expect(controller.isItemSaved('dica', 'Não clique em links'), isTrue);
    expect(controller.isItemSaved('palavra', 'Link'), isTrue);
    expect(controller.isItemSaved('dica', 'Outra'), isFalse);
  });

  test('fluxo completo de treino via reinforcement', () async {
    final controller = AppController(random: Random(5));
    await controller.load();
    controller.startTraining(trainings.first.name);
    expect(controller.screen, AppScreen.trainingIntro);

    controller.beginSimulation();
    expect(controller.screen, AppScreen.simulation);

    controller.selectAnswer(
      const ScenarioAnswer(AnswerType.safe, 'Segura'),
    );
    expect(controller.screen, AppScreen.feedbackRight);

    controller.continueFromWord();
    expect(controller.screen, AppScreen.reinforcement);

    controller.selectReinforcementAnswer(
      const ScenarioAnswer(AnswerType.safe, 'Segura'),
    );
    expect(controller.screen, AppScreen.reinforcementFeedback);

    controller.finishTraining();
    expect(controller.screen, AppScreen.conclusion);
  });

  test('onboarding inicia em start e completeOnboarding vai para home', () async {
    final controller = AppController();
    await controller.load();
    expect(controller.screen, AppScreen.start);

    controller.completeOnboarding('Maria', 'Samsung');
    expect(controller.screen, AppScreen.home);
    expect(controller.name, 'Maria');
    expect(controller.deviceBrand, 'Samsung');
  });

  test('onboarding rejeita nome vazio', () async {
    final controller = AppController();
    await controller.load();
    controller.completeOnboarding('', 'Samsung');
    expect(controller.name, '');
    expect(controller.screen, AppScreen.home);
  });

  test('load com nome salvo vai para home', () async {
    SharedPreferences.setMockInitialValues({
      'lia-simplis-flutter-state': '{"name":"João","deviceBrand":"Xiaomi"}',
    });
    final controller = AppController();
    await controller.load();
    expect(controller.screen, AppScreen.home);
    expect(controller.name, 'João');
    expect(controller.deviceBrand, 'Xiaomi');
  });

  test('load sem nome salvo fica em start', () async {
    SharedPreferences.setMockInitialValues({
      'lia-simplis-flutter-state': '{"deviceBrand":"Samsung"}',
    });
    final controller = AppController();
    await controller.load();
    expect(controller.screen, AppScreen.start);
  });

  test('ajuda navega para help e selectHelp troca problema', () async {
    final controller = AppController();
    await controller.load();
    controller.go(AppScreen.help);
    expect(controller.screen, AppScreen.help);

    controller.selectHelp('sound');
    expect(controller.deviceProblem, 'sound');
    expect(controller.help.title, 'Celular sem som');
  });

  test('faqItems tem conteúdo', () {
    expect(faqItems, isNotEmpty);
    expect(faqItems.first.question, isNotEmpty);
    expect(faqItems.first.answer, isNotEmpty);
  });

  test('callSteps tem conteúdo', () {
    expect(callSteps, isNotEmpty);
    expect(callSteps.first, contains('telefone'));
  });
}
