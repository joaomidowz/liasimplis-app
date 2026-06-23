import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lia_simplis/app_controller.dart';
import 'package:lia_simplis/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('CT-DES-01: navegação entre telas (20 ciclos)', () async {
    final controller = AppController();
    await controller.load();
    controller.completeOnboarding('Teste', 'Samsung');

    final sw = Stopwatch()..start();
    for (var i = 0; i < 20; i++) {
      controller.go(AppScreen.trainings);
      controller.go(AppScreen.help);
      controller.go(AppScreen.dictionary);
      controller.go(AppScreen.favorites);
      controller.go(AppScreen.home);
    }
    sw.stop();
    debugPrint(
      'CT-DES-01: ${sw.elapsedMilliseconds}ms para 20 ciclos de navegação',
    );
    expect(sw.elapsedMilliseconds, lessThan(3000));
  });

  test('CT-DES-02: troca de cenário (30x)', () async {
    final controller = AppController(random: Random(42));
    await controller.load();
    controller.completeOnboarding('Teste', 'Samsung');
    controller.startTraining(trainings.first.name);
    controller.beginSimulation();

    final sw = Stopwatch()..start();
    for (var i = 0; i < 30; i++) {
      controller.chooseAnotherScenario();
    }
    sw.stop();
    debugPrint(
      'CT-DES-02: ${sw.elapsedMilliseconds}ms para 30 trocas de cenário',
    );
    expect(sw.elapsedMilliseconds, lessThan(3000));
  });

  test('CT-DES-05: persistência save/load (50 ciclos)', () async {
    final controller = AppController(random: Random(99));
    await controller.load();
    controller.completeOnboarding('PersistTest', 'Xiaomi');
    controller.startTraining(trainings.first.name);
    controller.beginSimulation();

    final sw = Stopwatch()..start();
    for (var i = 0; i < 50; i++) {
      controller.selectAnswer(controller.scenario.answers.first);
      controller.finishTraining();
      controller.startTraining(trainings.first.name);
      controller.beginSimulation();
    }
    sw.stop();
    debugPrint(
      'CT-DES-05: ${sw.elapsedMilliseconds}ms para 50 ciclos save/load',
    );
    expect(sw.elapsedMilliseconds, lessThan(5000));
  });

  test('CT-DES-06: inicialização e onboarding completo', () async {
    final sw = Stopwatch()..start();
    final controller = AppController(random: Random(77));
    await controller.load();
    controller.completeOnboarding('InitTest', 'Motorola');
    controller.startTraining(trainings.first.name);
    controller.beginSimulation();
    controller.selectAnswer(controller.scenario.answers.first);
    controller.finishTraining();
    sw.stop();
    debugPrint(
      'CT-DES-06: ${sw.elapsedMilliseconds}ms para init + onboarding + 1 treino completo',
    );
    expect(sw.elapsedMilliseconds, lessThan(5000));
  });
}
