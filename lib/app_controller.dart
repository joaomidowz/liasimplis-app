import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_data.dart';
import 'models.dart';

enum AppScreen {
  start,
  home,
  trainings,
  trainingIntro,
  simulation,
  feedbackWrong,
  feedbackRight,
  wordExplanation,
  reinforcement,
  reinforcementFeedback,
  conclusion,
  quiz,
  dictionary,
  help,
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
  int currentQuizIndex = 0;
  int quizCorrect = 0;
  String lastTraining = trainings.first.name;
  String lastModule = 'Início';
  String? lastQuizAnswerId;
  bool? lastQuizWasCorrect;
  final Set<String> favoriteTerms = {};
  final Set<String> completedTrainings = {};
  final Set<String> answeredQuestions = {};
  final List<Map<String, String>> savedItems = [];

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
      currentQuizIndex = data['currentQuizIndex'] as int? ?? currentQuizIndex;
      quizCorrect = data['quizCorrect'] as int? ?? quizCorrect;
      lastTraining = data['lastTraining'] as String? ?? lastTraining;
      lastModule = data['lastModule'] as String? ?? lastModule;
      favoriteTerms
        ..clear()
        ..addAll(
          (data['favoriteTerms'] as List<dynamic>? ?? const [])
              .whereType<String>(),
        );
      completedTrainings
        ..clear()
        ..addAll(
          (data['completedTrainings'] as List<dynamic>? ?? const [])
              .whereType<String>(),
        );
      answeredQuestions
        ..clear()
        ..addAll(
          (data['answeredQuestions'] as List<dynamic>? ?? const [])
              .whereType<String>(),
        );
      screen = name.trim().isEmpty ? AppScreen.start : AppScreen.home;
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
  QuizQuestion get quizQuestion {
    final index = currentQuizIndex < 0
        ? 0
        : currentQuizIndex >= quizQuestions.length
        ? quizQuestions.length - 1
        : currentQuizIndex;
    return quizQuestions[index];
  }

  int get totalScenarios =>
      trainings.fold(0, (total, item) => total + item.scenarios.length);
  double get progress => (completed / totalScenarios).clamp(0, 1);
  double get quizProgress => answeredQuestions.length / quizQuestions.length;
  double get textScale => switch (textSize) {
    'normal' => 1.0,
    'large' => 1.15,
    'extra' => 1.3,
    'huge' => 1.5,
    _ => 1.15,
  };

  void go(AppScreen target) {
    screen = target;
    lastModule = _moduleName(target);
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

  void completeOnboarding(String userName, String brand) {
    name = userName.trim();
    deviceBrand = brand;
    screen = AppScreen.home;
    lastModule = 'Início';
    _changed();
  }

  void startTraining(String name) {
    selectedTraining = name;
    lastTraining = name;
    lastModule = 'Treinos';
    currentScenarioId =
        training.scenarios[_random.nextInt(training.scenarios.length)].id;
    screen = AppScreen.trainingIntro;
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
    screen = answer.type == AnswerType.risky
        ? AppScreen.feedbackWrong
        : AppScreen.feedbackRight;
    _changed();
  }

  void tryAgain() {
    chooseAnotherScenario();
  }

  void showExplanation() {
    activeTerm = 'link';
    screen = AppScreen.wordExplanation;
    _changed();
  }

  void continueFromWord() {
    final candidates = training.scenarios
        .where((item) => item.id != currentScenarioId)
        .toList();
    if (candidates.isNotEmpty) {
      currentScenarioId = candidates[_random.nextInt(candidates.length)].id;
    }
    screen = AppScreen.reinforcement;
    _changed();
  }

  void selectReinforcementAnswer(ScenarioAnswer answer) {
    selectedAnswer = answer.type;
    selectedAnswerLabel = answer.label;
    if (answer.type != AnswerType.risky) protectedChoices += 1;
    screen = AppScreen.reinforcementFeedback;
    _changed();
  }

  void finishTraining() {
    completedTrainings.add(training.id);
    screen = AppScreen.conclusion;
    _changed();
  }

  void selectTerm(String key) {
    activeTerm = key;
    screen = AppScreen.dictionary;
    lastModule = 'Dicionário';
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
    lastModule = 'Ajuda rápida';
    _changed();
  }

  void startQuiz() {
    currentQuizIndex = 0;
    lastQuizAnswerId = null;
    lastQuizWasCorrect = null;
    screen = AppScreen.quiz;
    lastModule = 'Teste educativo';
    _changed();
  }

  void answerQuiz(String answerId) {
    lastQuizAnswerId = answerId;
    final correct = answerId == quizQuestion.correctAnswerId;
    lastQuizWasCorrect = correct;
    final firstAnswer = answeredQuestions.add(quizQuestion.id);
    if (correct && firstAnswer) quizCorrect += 1;
    _changed();
  }

  void nextQuizQuestion() {
    currentQuizIndex = (currentQuizIndex + 1) % quizQuestions.length;
    lastQuizAnswerId = null;
    lastQuizWasCorrect = null;
    _changed();
  }

  void toggleDeviceGuide() {
    showDeviceGuide = !showDeviceGuide;
    _changed();
  }

  void saveItem(String type, String text) {
    final key = '$type:$text';
    if (!savedItems.any((item) => '${item['type']}:${item['text']}' == key)) {
      savedItems.add({'type': type, 'text': text});
      _changed();
    }
  }

  bool isItemSaved(String type, String text) {
    return savedItems.any(
      (item) => item['type'] == type && item['text'] == text,
    );
  }

  String speechText() => switch (screen) {
    AppScreen.simulation =>
      '${scenario.title}. ${scenario.message}. Sinal de atenção: ${scenario.clue}.',
    AppScreen.feedbackRight => 'Boa escolha. ${scenario.safeAction}',
    AppScreen.feedbackWrong => 'Atenção. ${scenario.safeAction}',
    AppScreen.dictionary => '${term.title}. ${term.description}. ${term.alert}',
    AppScreen.quiz => '${quizQuestion.question}. ${quizQuestion.explanation}',
    _ => 'Lia Simplis. Aprenda e treine com segurança.',
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
        'currentQuizIndex': currentQuizIndex,
        'quizCorrect': quizCorrect,
        'lastTraining': lastTraining,
        'lastModule': lastModule,
        'favoriteTerms': favoriteTerms.toList(),
        'completedTrainings': completedTrainings.toList(),
        'answeredQuestions': answeredQuestions.toList(),
      }),
    );
  }

  String _moduleName(AppScreen target) => switch (target) {
    AppScreen.home => 'Início',
    AppScreen.trainings ||
    AppScreen.trainingIntro ||
    AppScreen.simulation ||
    AppScreen.feedbackWrong ||
    AppScreen.feedbackRight ||
    AppScreen.wordExplanation ||
    AppScreen.reinforcement ||
    AppScreen.reinforcementFeedback ||
    AppScreen.conclusion => 'Treinos',
    AppScreen.quiz => 'Teste educativo',
    AppScreen.dictionary => 'Dicionário',
    AppScreen.help => 'Ajuda rápida',
    AppScreen.favorites => 'Salvos',
    AppScreen.start => 'Boas-vindas',
  };

  void _changed() {
    notifyListeners();
    _save();
  }
}
