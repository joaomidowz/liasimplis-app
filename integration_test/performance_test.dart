import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lia_simplis/app_controller.dart';
import 'package:lia_simplis/lia_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mede navegação repetida entre Home, Treinos e Ajuda', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppController();
    await controller.load();
    controller.go(AppScreen.home);
    await tester.pumpWidget(LiaSimplisApp(controller: controller));
    await tester.pumpAndSettle();

    await binding.traceAction(() async {
      for (var i = 0; i < 20; i++) {
        await tester.tap(find.text('Treinos').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ajuda').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Início').last);
        await tester.pumpAndSettle();
      }
    }, reportKey: 'navigation_performance');
  });

  testWidgets('mede 30 trocas de cenário sem travamento', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final controller = AppController();
    await controller.load();
    controller.startTraining('Mensagem suspeita');
    controller.beginSimulation();
    await tester.pumpWidget(LiaSimplisApp(controller: controller));
    await tester.pumpAndSettle();

    final stopwatch = Stopwatch()..start();
    for (var i = 0; i < 30; i++) {
      controller.chooseAnotherScenario();
      await tester.pump();
    }
    stopwatch.stop();

    expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    expect(tester.takeException(), isNull);
  });
}
