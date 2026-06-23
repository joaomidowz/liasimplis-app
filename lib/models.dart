enum AnswerType { safe, help, risky }

class ScenarioAnswer {
  const ScenarioAnswer(this.type, this.label);

  final AnswerType type;
  final String label;
}

class Scenario {
  const Scenario({
    required this.id,
    required this.sender,
    required this.title,
    required this.message,
    required this.link,
    required this.clue,
    required this.safeAction,
    required this.answers,
  });

  final String id;
  final String sender;
  final String title;
  final String message;
  final String link;
  final String clue;
  final String safeAction;
  final List<ScenarioAnswer> answers;
}

class Training {
  const Training({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.difficulty,
    required this.minutes,
    required this.tag,
    required this.scenarios,
    required this.feedback,
    this.safetyNotice = 'Simulação educativa. Nenhuma ação real será feita.',
  });

  final String id;
  final String name;
  final String subtitle;
  final String category;
  final String difficulty;
  final String minutes;
  final String tag;
  final List<Scenario> scenarios;
  final String feedback;
  final String safetyNotice;
}

class DictionaryTerm {
  const DictionaryTerm({
    required this.key,
    required this.title,
    required this.category,
    required this.description,
    required this.example,
    required this.alert,
    required this.tip,
    this.related = const [],
    this.tags = const [],
  });

  final String key;
  final String title;
  final String category;
  final String description;
  final String example;
  final String alert;
  final String tip;
  final List<String> related;
  final List<String> tags;
}

class DeviceHelp {
  const DeviceHelp({
    required this.key,
    required this.title,
    required this.category,
    required this.steps,
    required this.visual,
    required this.whenToAskHelp,
    this.alert = '',
  });

  final String key;
  final String title;
  final String category;
  final Map<String, List<String>> steps;
  final String visual;
  final String whenToAskHelp;
  final String alert;
}

class FaqItem {
  const FaqItem({
    required this.question,
    required this.answer,
    this.category = 'Geral',
  });

  final String question;
  final String answer;
  final String category;
}

class QuizAlternative {
  const QuizAlternative({required this.id, required this.text});

  final String id;
  final String text;
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.alternatives,
    required this.correctAnswerId,
    required this.explanation,
    required this.category,
    required this.level,
  });

  final String id;
  final String question;
  final List<QuizAlternative> alternatives;
  final String correctAnswerId;
  final String explanation;
  final String category;
  final String level;
}
