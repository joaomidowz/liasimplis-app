import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_data.dart';
import 'models.dart';

enum AppScreen {
  start,
  adjust,
  home,
  trainings,
  trainingStart,
  simulation,
  result,
  dictionary,
  conclusion,
  deviceHelp,
  favorites,
}

class AppController extends ChangeNotifier {
  AppController({SharedPreferences? preferences, Random? random})
    : _preferences = preferences,
      _random = random ?? Random();

  static const storageKey = 'lia-simplis-flutter-state';
  final Random _random;
  SharedPreferences? _preferences;

  AppScreen screen = AppScreen.start;
  String name = '';
  String textSize = 'large';
  String explanationMode = 'both';
  String deviceBrand = 'Detectado';
  String selectedTraining = trainings.first.name;
  String currentScenarioId = trainings.first.scenarios.first.id;
  AnswerType selectedAnswer = AnswerType.safe;
  String selectedAnswerLabel = 'Não clicar / parar';
  String activeTerm = 'link';
  String deviceProblem = 'internet';
  bool showDeviceGuide = true;
  int completed = 0;
  int protectedChoices = 0;
  String lastTraining = trainings.first.name;
  final Set<String> favoriteTerms = {};

  Future<void> load() async {
    _preferences ??= await SharedPreferences.getInstance();
    final raw = _preferences?.getString(storageKey);
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      name = data['name'] as String? ?? name;
      textSize = data['textSize'] as String? ?? textSize;
      explanationMode = data['explanationMode'] as String? ?? explanationMode;
      deviceBrand = data['deviceBrand'] as String? ?? deviceBrand;
      selectedTraining =
          data['selectedTraining'] as String? ?? selectedTraining;
      currentScenarioId =
          data['currentScenarioId'] as String? ?? currentScenarioId;
      activeTerm = data['activeTerm'] as String? ?? activeTerm;
      deviceProblem = data['deviceProblem'] as String? ?? deviceProblem;
      showDeviceGuide = data['showDeviceGuide'] as bool? ?? showDeviceGuide;
      completed = data['completed'] as int? ?? completed;
      protectedChoices = data['protectedChoices'] as int? ?? protectedChoices;
      lastTraining = data['lastTraining'] as String? ?? lastTraining;
      favoriteTerms
        ..clear()
        ..addAll(
          (data['favoriteTerms'] as List<dynamic>? ?? const [])
              .whereType<String>(),
        );
      screen = AppScreen.home;
      notifyListeners();
    } on FormatException {
      await _preferences?.remove(storageKey);
    }
  }

  Training get training => trainingByName(selectedTraining);
  Scenario get scenario => training.scenarios.firstWhere(
    (item) => item.id == currentScenarioId,
    orElse: () => training.scenarios.first,
  );
  DictionaryTerm get term => termByKey(activeTerm);
  DeviceHelp get help => helpByKey(deviceProblem);
  int get totalScenarios =>
      trainings.fold(0, (total, item) => total + item.scenarios.length);
  double get progress => (completed / totalScenarios).clamp(0, 1);
  double get textScale => switch (textSize) {
    'normal' => 1.0,
    'large' => 1.15,
    'extra' => 1.3,
    'huge' => 1.5,
    _ => 1.15,
  };

  void go(AppScreen target) {
    screen = target;
    _changed();
  }

  void updateName(String value) {
    name = value;
    _changed();
  }

  void setTextSize(String value) {
    textSize = value;
    _changed();
  }

  void cycleTextSize() {
    const values = ['normal', 'large', 'extra', 'huge'];
    textSize = values[(values.indexOf(textSize) + 1) % values.length];
    _changed();
  }

  void setExplanationMode(String value) {
    explanationMode = value;
    _changed();
  }

  void setDeviceBrand(String value) {
    deviceBrand = value;
    _changed();
  }

  void startTraining(String name) {
    selectedTraining = name;
    lastTraining = name;
    currentScenarioId =
        training.scenarios[_random.nextInt(training.scenarios.length)].id;
    screen = AppScreen.trainingStart;
    _changed();
  }

  void continueTraining() => startTraining(lastTraining);

  void beginSimulation() {
    screen = AppScreen.simulation;
    _changed();
  }

  void chooseAnotherScenario() {
    final candidates = training.scenarios
        .where((item) => item.id != currentScenarioId)
        .toList();
    if (candidates.isNotEmpty) {
      currentScenarioId = candidates[_random.nextInt(candidates.length)].id;
    }
    screen = AppScreen.simulation;
    _changed();
  }

  void selectAnswer(ScenarioAnswer answer) {
    selectedAnswer = answer.type;
    selectedAnswerLabel = answer.label;
    completed += 1;
    if (answer.type != AnswerType.risky) protectedChoices += 1;
    lastTraining = selectedTraining;
    screen = AppScreen.result;
    _changed();
  }

  void selectTerm(String key) {
    activeTerm = key;
    screen = AppScreen.dictionary;
    _changed();
  }

  void toggleFavorite() {
    favoriteTerms.contains(activeTerm)
        ? favoriteTerms.remove(activeTerm)
        : favoriteTerms.add(activeTerm);
    _changed();
  }

  void selectHelp(String key) {
    deviceProblem = key;
    _changed();
  }

  void toggleDeviceGuide() {
    showDeviceGuide = !showDeviceGuide;
    _changed();
  }

  String speechText() => switch (screen) {
    AppScreen.simulation =>
      '${scenario.title}. ${scenario.message}. Sinal de atenção: ${scenario.clue}.',
    AppScreen.result =>
      '${resultTitle(selectedAnswer)}. ${scenario.safeAction}',
    AppScreen.dictionary => '${term.title}. ${term.description}. ${term.alert}',
    AppScreen.deviceHelp =>
      '${help.title}. ${(help.steps[deviceBrand] ?? help.steps['Detectado']!).join(' ')}',
    _ => 'LiaSimplis. Aprenda e treine com segurança.',
  };

  String resultTitle(AnswerType type) => switch (type) {
    AnswerType.safe => 'Boa escolha',
    AnswerType.help => 'Escolha segura',
    AnswerType.risky => 'Atenção',
  };

  Future<void> _save() async {
    _preferences ??= await SharedPreferences.getInstance();
    await _preferences?.setString(
      storageKey,
      jsonEncode({
        'name': name,
        'textSize': textSize,
        'explanationMode': explanationMode,
        'deviceBrand': deviceBrand,
        'selectedTraining': selectedTraining,
        'currentScenarioId': currentScenarioId,
        'activeTerm': activeTerm,
        'deviceProblem': deviceProblem,
        'showDeviceGuide': showDeviceGuide,
        'completed': completed,
        'protectedChoices': protectedChoices,
        'lastTraining': lastTraining,
        'favoriteTerms': favoriteTerms.toList(),
      }),
    );
  }

  void _changed() {
    notifyListeners();
    _save();
  }
}
