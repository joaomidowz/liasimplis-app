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
    required this.name,
    required this.subtitle,
    required this.minutes,
    required this.tag,
    required this.scenarios,
  });

  final String name;
  final String subtitle;
  final String minutes;
  final String tag;
  final List<Scenario> scenarios;
}

class DictionaryTerm {
  const DictionaryTerm({
    required this.key,
    required this.title,
    required this.description,
    required this.example,
    required this.alert,
  });

  final String key;
  final String title;
  final String description;
  final String example;
  final String alert;
}

class DeviceHelp {
  const DeviceHelp({
    required this.key,
    required this.title,
    required this.steps,
    required this.visual,
  });

  final String key;
  final String title;
  final Map<String, List<String>> steps;
  final String visual;
}

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}
