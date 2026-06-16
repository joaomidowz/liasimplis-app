import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'app_controller.dart';
import 'app_data.dart';
import 'models.dart';

class LiaSimplisApp extends StatelessWidget {
  const LiaSimplisApp({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LiaSimplis',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF005451),
            primary: const Color(0xFF005451),
            secondary: const Color(0xFF8080FF),
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          cardTheme: const CardThemeData(margin: EdgeInsets.zero),
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(controller.textScale)),
          child: child!,
        ),
        home: LiaShell(controller: controller),
      ),
    );
  }
}

class LiaShell extends StatefulWidget {
  const LiaShell({super.key, required this.controller});

  final AppController controller;

  @override
  State<LiaShell> createState() => _LiaShellState();
}

class _LiaShellState extends State<LiaShell> {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _speech = SpeechToText();

  AppController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('pt-BR');
    _tts.setSpeechRate(0.45);
  }

  @override
  void dispose() {
    _tts.stop();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showChrome = !{
      AppScreen.start,
      AppScreen.adjust,
    }.contains(controller.screen);
    return Scaffold(
      appBar: showChrome
          ? AppBar(
              title: const Text('LiaSimplis'),
              actions: [
                IconButton(
                  key: const Key('listen-button'),
                  tooltip: 'Ouvir esta tela',
                  onPressed: _speak,
                  icon: const Icon(Icons.volume_up_outlined),
                ),
                IconButton(
                  key: const Key('voice-button'),
                  tooltip: 'Comando de voz',
                  onPressed: _listen,
                  icon: const Icon(Icons.mic_none),
                ),
                IconButton(
                  key: const Key('text-size-button'),
                  tooltip: 'Aumentar texto',
                  onPressed: controller.cycleTextSize,
                  icon: const Icon(Icons.text_fields),
                ),
              ],
            )
          : null,
      body: SafeArea(child: _screen()),
      bottomNavigationBar: showChrome ? _navigation() : null,
    );
  }

  Widget _screen() => switch (controller.screen) {
    AppScreen.start => StartScreen(controller: controller),
    AppScreen.adjust => AdjustScreen(controller: controller),
    AppScreen.home => HomeScreen(controller: controller),
    AppScreen.trainings => TrainingsScreen(controller: controller),
    AppScreen.trainingStart => TrainingStartScreen(controller: controller),
    AppScreen.simulation => SimulationScreen(controller: controller),
    AppScreen.result => ResultScreen(controller: controller),
    AppScreen.dictionary => DictionaryScreen(controller: controller),
    AppScreen.conclusion => ConclusionScreen(controller: controller),
    AppScreen.deviceHelp => DeviceHelpScreen(controller: controller),
    AppScreen.favorites => FavoritesScreen(controller: controller),
  };

  NavigationBar _navigation() {
    final destinations = [
      (AppScreen.home, Icons.home_outlined, 'Início'),
      (AppScreen.trainings, Icons.school_outlined, 'Treinos'),
      (AppScreen.deviceHelp, Icons.build_outlined, 'Ajuda'),
      (AppScreen.dictionary, Icons.menu_book_outlined, 'Dicionário'),
      (AppScreen.favorites, Icons.bookmark_outline, 'Salvos'),
    ];
    final index = destinations.indexWhere(
      (item) => item.$1 == controller.screen,
    );
    return NavigationBar(
      selectedIndex: index < 0 ? 0 : index,
      onDestinationSelected: (value) => controller.go(destinations[value].$1),
      destinations: [
        for (final item in destinations)
          NavigationDestination(icon: Icon(item.$2), label: item.$3),
      ],
    );
  }

  Future<void> _speak() async {
    try {
      await _tts.stop();
      await _tts.speak(controller.speechText());
    } catch (_) {
      _message('Leitura em voz alta indisponível neste aparelho.');
    }
  }

  Future<void> _listen() async {
    final available = await _speech.initialize();
    if (!available) {
      _message('Comando de voz indisponível ou sem permissão.');
      return;
    }
    await _speech.listen(
      listenOptions: SpeechListenOptions(
        localeId: 'pt_BR',
        listenFor: const Duration(seconds: 6),
      ),
      onResult: (result) {
        if (!result.finalResult) return;
        final text = result.recognizedWords.toLowerCase();
        if (text.contains('treino')) {
          controller.go(AppScreen.trainings);
        } else if (text.contains('ajuda') || text.contains('celular')) {
          controller.go(AppScreen.deviceHelp);
        } else if (text.contains('dicionário') || text.contains('dicionario')) {
          controller.go(AppScreen.dictionary);
        } else if (text.contains('salvo') || text.contains('favorito')) {
          controller.go(AppScreen.favorites);
        } else if (text.contains('início') || text.contains('inicio')) {
          controller.go(AppScreen.home);
        } else {
          _message(
            'Comando não reconhecido. Diga início, treino, ajuda, dicionário ou salvos.',
          );
        }
      },
    );
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class PageContent extends StatelessWidget {
  const PageContent({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: ListView(padding: const EdgeInsets.all(20), children: children),
    ),
  );
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late final TextEditingController nameController = TextEditingController(
    text: widget.controller.name,
  );

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageContent(
    children: [
      const SizedBox(height: 36),
      Icon(
        Icons.shield_outlined,
        size: 72,
        color: Theme.of(context).colorScheme.primary,
      ),
      const SizedBox(height: 16),
      Text(
        'Aprenda a usar o celular com segurança',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      const Text(
        'Treinos simples, fictícios e sem risco real.',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      TextField(
        key: const Key('name-field'),
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Como podemos chamar você?',
        ),
        onChanged: widget.controller.updateName,
      ),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        key: const Key('device-brand-field'),
        initialValue: widget.controller.deviceBrand,
        decoration: const InputDecoration(labelText: 'Marca do celular'),
        items: [
          for (final brand in deviceBrands)
            DropdownMenuItem(value: brand, child: Text(brand)),
        ],
        onChanged: (value) {
          if (value != null) widget.controller.setDeviceBrand(value);
        },
      ),
      const SizedBox(height: 20),
      const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Nada real será enviado, pago ou alterado durante os treinos.',
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),
      FilledButton(
        key: const Key('start-button'),
        onPressed: () => widget.controller.go(AppScreen.adjust),
        child: const Text('Começar'),
      ),
    ],
  );
}

class AdjustScreen extends StatelessWidget {
  const AdjustScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => PageContent(
    children: [
      Text(
        'Como você prefere aprender?',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20),
      const Text('Tamanho do texto'),
      const SizedBox(height: 8),
      SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'normal', label: Text('Normal')),
          ButtonSegment(value: 'large', label: Text('Grande')),
          ButtonSegment(value: 'extra', label: Text('Maior')),
          ButtonSegment(value: 'huge', label: Text('Muito grande')),
        ],
        selected: {controller.textSize},
        onSelectionChanged: (value) => controller.setTextSize(value.first),
        showSelectedIcon: false,
      ),
      const SizedBox(height: 24),
      const Text('Modo de explicação'),
      const SizedBox(height: 8),
      SegmentedButton<String>(
        segments: const [
          ButtonSegment(value: 'read', label: Text('Ler')),
          ButtonSegment(value: 'listen', label: Text('Ouvir')),
          ButtonSegment(value: 'both', label: Text('Os dois')),
        ],
        selected: {controller.explanationMode},
        onSelectionChanged: (value) =>
            controller.setExplanationMode(value.first),
        showSelectedIcon: false,
      ),
      const SizedBox(height: 28),
      FilledButton(
        key: const Key('adjust-continue-button'),
        onPressed: () => controller.go(AppScreen.home),
        child: const Text('Continuar'),
      ),
    ],
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => PageContent(
    children: [
      Text(
        controller.name.trim().isEmpty
            ? 'Bem-vindo(a)!'
            : 'Bem-vindo(a), ${controller.name.trim()}!',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      Text('${controller.deviceBrand} · Como podemos ajudar hoje?'),
      const SizedBox(height: 20),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seu progresso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: controller.progress),
              const SizedBox(height: 8),
              Text(
                '${controller.completed} testes feitos · ${controller.protectedChoices} escolhas seguras',
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      Card(
        child: ListTile(
          leading: const Icon(Icons.play_circle_outline),
          title: Text(
            controller.completed == 0
                ? 'Comece seu primeiro treino'
                : 'Continuar ${controller.lastTraining}',
          ),
          subtitle: const Text('Retome com um novo cenário seguro.'),
          trailing: const Icon(Icons.chevron_right),
          onTap: controller.completed == 0
              ? () => controller.go(AppScreen.trainings)
              : controller.continueTraining,
        ),
      ),
      const SizedBox(height: 20),
      _ActionCard(
        icon: Icons.school_outlined,
        title: 'Aprender e treinar',
        text: 'Pratique situações comuns sem risco.',
        onTap: () => controller.go(AppScreen.trainings),
      ),
      _ActionCard(
        icon: Icons.build_outlined,
        title: 'Consertar celular',
        text: 'Veja passos simples para problemas comuns.',
        onTap: () => controller.go(AppScreen.deviceHelp),
      ),
      _ActionCard(
        icon: Icons.menu_book_outlined,
        title: 'Tirar dúvida',
        text: 'Consulte o dicionário digital.',
        onTap: () => controller.go(AppScreen.dictionary),
      ),
      _ActionCard(
        icon: Icons.bookmark_outline,
        title: 'Salvos',
        text: 'Encontre seus termos favoritos.',
        onTap: () => controller.go(AppScreen.favorites),
      ),
    ],
  );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(text),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    ),
  );
}

class TrainingsScreen extends StatelessWidget {
  const TrainingsScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => PageContent(
    children: [
      Text(
        'Treinos',
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      const Text('Escolha um treino. Nada real será enviado ou pago.'),
      const SizedBox(height: 20),
      for (final training in trainings)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: ListTile(
              key: Key('training-${training.name}'),
              leading: Icon(
                training.name.startsWith('Mensagem')
                    ? Icons.chat_outlined
                    : Icons.payments_outlined,
              ),
              title: Text(training.name),
              subtitle: Text(
                '${training.subtitle} · ${training.minutes} · ${training.scenarios.length} casos',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => controller.startTraining(training.name),
            ),
          ),
        ),
    ],
  );
}

class TrainingStartScreen extends StatelessWidget {
  const TrainingStartScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => PageContent(
    children: [
      Text(
        controller.training.name,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Este treino é fictício. Nada será enviado, pago ou alterado.',
          ),
        ),
      ),
      const SizedBox(height: 20),
      const ListTile(
        leading: CircleAvatar(child: Text('1')),
        title: Text('Identifique o sinal de risco.'),
      ),
      const ListTile(
        leading: CircleAvatar(child: Text('2')),
        title: Text('Escolha uma ação segura.'),
      ),
      const ListTile(
        leading: CircleAvatar(child: Text('3')),
        title: Text('Entenda o motivo da escolha.'),
      ),
      const SizedBox(height: 20),
      FilledButton(
        key: const Key('begin-simulation-button'),
        onPressed: controller.beginSimulation,
        child: const Text('Iniciar treino'),
      ),
    ],
  );
}

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final item = controller.scenario;
    return PageContent(
      children: [
        Text(
          item.title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(item.sender),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.message),
                const SizedBox(height: 12),
                Text(
                  item.link,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: Theme.of(context).colorScheme.errorContainer,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.warning_amber),
                const SizedBox(width: 10),
                Expanded(child: Text('Sinal de atenção: ${item.clue}')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'O que você faria?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (final answer in item.answers)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton(
              key: Key('answer-${answer.type.name}'),
              onPressed: () => controller.selectAnswer(answer),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(answer.label),
              ),
            ),
          ),
      ],
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final safe = controller.selectedAnswer != AnswerType.risky;
    final detail = switch (controller.selectedAnswer) {
      AnswerType.safe => 'Você parou antes de agir.',
      AnswerType.help => 'Pedir ajuda é uma boa decisão.',
      AnswerType.risky => 'Essa opção poderia colocar você em risco.',
    };
    return PageContent(
      children: [
        Icon(
          safe ? Icons.verified_user_outlined : Icons.warning_amber,
          size: 72,
          color: safe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: 12),
        Text(
          controller.resultTitle(controller.selectedAnswer),
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(detail, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Ação segura: ${controller.scenario.safeAction}'),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          key: const Key('another-scenario-button'),
          onPressed: controller.chooseAnotherScenario,
          child: const Text('Outro caso'),
        ),
        OutlinedButton(
          onPressed: () => controller.selectTerm('link'),
          child: const Text('O que é link?'),
        ),
        TextButton(
          onPressed: () => controller.go(AppScreen.home),
          child: const Text('Voltar ao início'),
        ),
      ],
    );
  }
}

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final term = controller.term;
    return PageContent(
      children: [
        Text(
          'Dicionário digital',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in dictionaryTerms)
              ChoiceChip(
                label: Text(item.title),
                selected: item.key == term.key,
                onSelected: (_) => controller.selectTerm(item.key),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Text(term.description),
                const SizedBox(height: 12),
                Text('Exemplo: ${term.example}'),
                const SizedBox(height: 12),
                Text(
                  term.alert,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          key: const Key('favorite-button'),
          onPressed: controller.toggleFavorite,
          icon: Icon(
            controller.favoriteTerms.contains(term.key)
                ? Icons.bookmark
                : Icons.bookmark_outline,
          ),
          label: Text(
            controller.favoriteTerms.contains(term.key)
                ? 'Salvo'
                : 'Salvar termo',
          ),
        ),
        OutlinedButton(
          onPressed: () => controller.go(AppScreen.conclusion),
          child: const Text('Entendi'),
        ),
      ],
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final favorites = dictionaryTerms
        .where((term) => controller.favoriteTerms.contains(term.key))
        .toList();
    return PageContent(
      children: [
        Text(
          'Salvos',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (favorites.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Nenhum termo salvo ainda. Abra o dicionário para escolher um.',
              ),
            ),
          ),
        for (final term in favorites)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              child: ListTile(
                title: Text(term.title),
                subtitle: Text(term.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => controller.selectTerm(term.key),
              ),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => controller.go(AppScreen.dictionary),
          child: const Text('Abrir dicionário'),
        ),
      ],
    );
  }
}

class DeviceHelpScreen extends StatelessWidget {
  const DeviceHelpScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final help = controller.help;
    final steps =
        help.steps[controller.deviceBrand] ?? help.steps['Detectado']!;
    return PageContent(
      children: [
        Text(
          'Consertar celular',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text('Passos para ${controller.deviceBrand}'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final item in deviceHelpItems)
              ChoiceChip(
                label: Text(item.title),
                selected: item.key == help.key,
                onSelected: (_) => controller.selectHelp(item.key),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(help.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                for (var i = 0; i < steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('${i + 1}. ${steps[i]}'),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (controller.showDeviceGuide)
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.phone_android, size: 54),
                    const SizedBox(height: 10),
                    Text(help.visual, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          ),
        TextButton(
          key: const Key('toggle-guide-button'),
          onPressed: controller.toggleDeviceGuide,
          child: Text(
            controller.showDeviceGuide ? 'Ocultar print' : 'Ver print',
          ),
        ),
      ],
    );
  }
}

class ConclusionScreen extends StatelessWidget {
  const ConclusionScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) => PageContent(
    children: [
      const Icon(Icons.celebration_outlined, size: 72),
      Text(
        'Muito bem!',
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Text(
            'Você fez ${controller.completed} testes, tomou ${controller.protectedChoices} decisões seguras e salvou ${controller.favoriteTerms.length} termos.',
          ),
        ),
      ),
      const SizedBox(height: 20),
      FilledButton(
        onPressed: () => controller.go(AppScreen.trainings),
        child: const Text('Fazer outro treino'),
      ),
      OutlinedButton(
        onPressed: () => controller.go(AppScreen.home),
        child: const Text('Voltar ao início'),
      ),
    ],
  );
}
