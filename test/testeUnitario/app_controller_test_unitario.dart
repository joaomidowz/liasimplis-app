import 'package:flutter_test/flutter_test.dart';
import 'package:lia_simplis/app_controller.dart';
import 'package:lia_simplis/app_data.dart';
import 'package:lia_simplis/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Garante que cada teste comece sem dados gravados no celular.
    SharedPreferences.setMockInitialValues({});
  });

  group('AppController - testes unitarios', () {
    test('CT-UNI-001 - load sem dados salvos mantem onboarding', () async {
      final controller = AppController();

      await controller.load();

      expect(controller.screen, AppScreen.start);
    });

    test('CT-UNI-002 - completeOnboarding salva nome, marca e vai para home', () async {
      final controller = AppController();
      await controller.load();

      controller.completeOnboarding('Maria', 'Samsung');

      expect(controller.name, 'Maria');
      expect(controller.deviceBrand, 'Samsung');
      expect(controller.screen, AppScreen.home);
    });

    test('CT-UNI-003 - startTraining inicia Mensagem suspeita', () async {
      final controller = AppController();
      await controller.load();

      final training = trainingByName('Mensagem suspeita');
      controller.startTraining(training.name);

      expect(controller.training.name, 'Mensagem suspeita');
      expect(controller.scenario, isA<Scenario>());
      expect(controller.screen, AppScreen.trainingIntro);
    });

    test('CT-UNI-004 - resposta segura direciona para feedback positivo', () async {
      final controller = AppController();
      await controller.load();

      final training = trainingByName('Mensagem suspeita');
      controller.startTraining(training.name);
      final scenario = controller.scenario;
      final safeAnswer = scenario.answers.firstWhere(
        (answer) => answer.type == AnswerType.safe,
      );

      controller.selectAnswer(safeAnswer);

      expect(controller.selectedAnswer, safeAnswer.type);
      expect(controller.selectedAnswerLabel, safeAnswer.label);
      expect(controller.screen, AppScreen.feedbackRight);
    });

    test('CT-UNI-005 - resposta arriscada direciona para feedback de alerta', () async {
      final controller = AppController();
      await controller.load();

      final training = trainingByName('Mensagem suspeita');
      controller.startTraining(training.name);
      final scenario = controller.scenario;
      final riskyAnswer = scenario.answers.firstWhere(
        (answer) => answer.type == AnswerType.risky,
      );

      controller.selectAnswer(riskyAnswer);

      expect(controller.selectedAnswer, riskyAnswer.type);
      expect(controller.selectedAnswerLabel, riskyAnswer.label);
      expect(controller.screen, AppScreen.feedbackWrong);
    });

    test('CT-UNI-006 - toggleFavorite adiciona e remove termo sem duplicar', () async {
      final controller = AppController();
      await controller.load();

      controller.selectTerm('link');
      controller.toggleFavorite();
      expect(controller.favoriteTerms.contains('link'), isTrue);

      controller.toggleFavorite();
      expect(controller.favoriteTerms.contains('link'), isFalse);
    });

    test('CT-UNI-007 - dicb3Link', () {
      final term = termByKey('link');

      expect(term, isNotNull);
      expect(term.title.toLowerCase(), contains('link'));
    });
  });
}
