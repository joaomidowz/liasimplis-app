import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_controller.dart';
import 'app_data.dart';
import 'design_tokens.dart';
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
        title: 'Lia Simplis',
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: LiaColors.greenDark,
            onPrimary: Colors.white,
            secondary: LiaColors.greenMedium,
            onSecondary: Colors.white,
            error: LiaColors.red,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: LiaColors.textDark,
          ),
          scaffoldBackgroundColor: LiaColors.cream,
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          cardTheme: CardThemeData(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(LiaRadii.lg),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              backgroundColor: LiaColors.greenDark,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(LiaRadii.lg),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: LiaColors.greenDark,
              side: const BorderSide(color: LiaColors.greenDark, width: 2),
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(LiaRadii.lg),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
          ),
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

  AppController get controller => widget.controller;

  static const _trainingScreens = {
    AppScreen.start,
    AppScreen.trainingIntro,
    AppScreen.simulation,
    AppScreen.feedbackWrong,
    AppScreen.feedbackRight,
    AppScreen.wordExplanation,
    AppScreen.reinforcement,
    AppScreen.reinforcementFeedback,
    AppScreen.conclusion,
  };

  @override
  void initState() {
    super.initState();
    _tts.setLanguage('pt-BR');
    _tts.setSpeechRate(0.45);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showChrome = !_trainingScreens.contains(controller.screen);
    return Scaffold(
      appBar: showChrome
          ? AppBar(
              backgroundColor: LiaColors.cream,
              elevation: 0,
              actions: [
                IconButton(
                  key: const Key('listen-button'),
                  tooltip: 'Ouvir esta tela',
                  onPressed: _speak,
                  icon: const Icon(Icons.volume_up_outlined),
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
      bottomNavigationBar: showChrome ? _bottomNav() : null,
    );
  }

  Widget _screen() => switch (controller.screen) {
    AppScreen.start => StartScreen(controller: controller),
    AppScreen.home => HomeScreen(controller: controller),
    AppScreen.trainings => TrainingsScreen(controller: controller),
    AppScreen.trainingIntro => TrainingIntroScreen(controller: controller),
    AppScreen.simulation => SimulationScreen(controller: controller),
    AppScreen.feedbackWrong => FeedbackWrongScreen(controller: controller),
    AppScreen.feedbackRight => FeedbackRightScreen(controller: controller),
    AppScreen.wordExplanation => WordExplanationScreen(controller: controller),
    AppScreen.reinforcement => ReinforcementScreen(controller: controller),
    AppScreen.reinforcementFeedback => ReinforcementFeedbackScreen(
      controller: controller,
    ),
    AppScreen.conclusion => ConclusionScreen(controller: controller),
    AppScreen.quiz => QuizScreen(controller: controller),
    AppScreen.dictionary => DictionaryScreen(controller: controller),
    AppScreen.help => HelpScreen(controller: controller),
    AppScreen.favorites => FavoritesScreen(controller: controller),
  };

  Widget _bottomNav() {
    final destinations = [
      (AppScreen.home, Icons.home, 'Início'),
      (AppScreen.trainings, Icons.shield_outlined, 'Treino'),
      (AppScreen.help, Icons.help_outline, 'Ajuda'),
      (AppScreen.dictionary, Icons.menu_book_outlined, 'Termos'),
      (AppScreen.favorites, Icons.bookmark_outline, 'Salvos'),
    ];
    final currentIndex = destinations.indexWhere(
      (item) => item.$1 == controller.screen,
    );
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: LiaColors.borderGray, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: destinations[i].$2,
                    label: destinations[i].$3,
                    active: currentIndex == i,
                    onTap: () => controller.go(destinations[i].$1),
                  ),
                ),
            ],
          ),
        ),
      ),
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

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: active ? LiaColors.greenLight : Colors.transparent,
              borderRadius: BorderRadius.circular(LiaRadii.md),
            ),
            child: Icon(
              icon,
              size: 24,
              color: active ? LiaColors.greenDark : LiaColors.textGray,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: active ? LiaColors.greenDark : LiaColors.textGray,
              letterSpacing: 0.01,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Start Screen (Onboarding) ───────────────────────────────────────────────

class StartScreen extends StatefulWidget {
  const StartScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late final TextEditingController _nameCtrl = TextEditingController();
  String _brand = 'Samsung';

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: LiaColors.greenLight,
                  borderRadius: BorderRadius.circular(LiaRadii.xxl),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: LiaColors.greenDark,
                  size: 38,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Bem-vindo ao Lia Simplis',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: LiaColors.textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aprenda a usar o celular com segurança.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: LiaColors.textMuted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Como podemos chamar você?',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: LiaColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                key: const Key('name-field'),
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Seu nome ou apelido',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    borderSide: const BorderSide(color: LiaColors.borderGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    borderSide: const BorderSide(color: LiaColors.borderGray),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Qual é a marca do seu celular?',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: LiaColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(LiaRadii.lg),
                  border: Border.all(color: LiaColors.borderGray, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    key: const Key('brand-dropdown'),
                    value: _brand,
                    isExpanded: true,
                    items: [
                      for (final b in deviceBrands.where(
                        (b) => b != 'Detectado',
                      ))
                        DropdownMenuItem(value: b, child: Text(b)),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _brand = v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: LiaColors.greenPale,
                  borderRadius: BorderRadius.circular(LiaRadii.lg),
                  border: Border.all(color: LiaColors.greenBorder, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: LiaColors.greenDark,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Nada será enviado, pago ou alterado. Tudo fica no seu celular.',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: LiaColors.textMedium,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              FilledButton(
                key: const Key('start-button'),
                onPressed: () {
                  final name = _nameCtrl.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, informe seu nome.'),
                      ),
                    );
                    return;
                  }
                  widget.controller.completeOnboarding(name, _brand);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_forward, size: 22),
                    SizedBox(width: 10),
                    Text('Começar'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Home Screen ──────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.name.trim().isEmpty
                    ? 'Olá!'
                    : 'Olá, ${controller.name.trim()}!',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: LiaColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Assistente de aprendizado',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: LiaColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              _HeroCard(onStart: () => controller.go(AppScreen.trainings)),
              const SizedBox(height: 16),
              const _DescriptionCard(),
              const SizedBox(height: 16),
              _ProgressSummary(controller: controller),
              const SizedBox(height: 24),
              Text(
                'ACESSO RÁPIDO',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: LiaColors.textMuted,
                  letterSpacing: 0.04,
                ),
              ),
              const SizedBox(height: 12),
              _QuickAccessCard(
                icon: Icons.shield_outlined,
                iconBg: LiaColors.greenLight,
                iconColor: LiaColors.greenDark,
                label: 'Treino',
                description: 'Pratique com situações reais.',
                onTap: () => controller.go(AppScreen.trainings),
              ),
              const SizedBox(height: 10),
              _QuickAccessCard(
                icon: Icons.menu_book_outlined,
                iconBg: LiaColors.amberLight,
                iconColor: LiaColors.amberDark,
                label: 'Dicionário',
                description: 'Consulte termos digitais.',
                onTap: () => controller.go(AppScreen.dictionary),
              ),
              const SizedBox(height: 10),
              _QuickAccessCard(
                icon: Icons.help_outline,
                iconBg: LiaColors.blueLight,
                iconColor: LiaColors.blueDark,
                label: 'Ajuda',
                description: 'Ligar, problemas e perguntas frequentes.',
                onTap: () => controller.go(AppScreen.help),
              ),
              const SizedBox(height: 10),
              _QuickAccessCard(
                icon: Icons.quiz_outlined,
                iconBg: LiaColors.greenLight,
                iconColor: LiaColors.greenDark,
                label: 'Teste educativo',
                description: 'Responda perguntas rápidas e revise dicas.',
                onTap: controller.startQuiz,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressSummary extends StatelessWidget {
  const _ProgressSummary({required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(LiaRadii.xl),
        border: Border.all(color: LiaColors.borderGray, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seu progresso',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: LiaColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Último módulo: ${controller.lastModule}',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: LiaColors.textMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(
                icon: Icons.flag_outlined,
                text: '${controller.completedTrainings.length} treinos',
              ),
              _InfoPill(
                icon: Icons.bookmark_outline,
                text: '${controller.favoriteTerms.length} termos salvos',
              ),
              _InfoPill(
                icon: Icons.check_circle_outline,
                text:
                    '${controller.quizCorrect}/${quizQuestions.length} acertos',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: LiaColors.greenPale,
        borderRadius: BorderRadius.circular(LiaRadii.md),
        border: Border.all(color: LiaColors.greenBorder, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: LiaColors.greenDark),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: LiaColors.greenDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LiaColors.gradient,
        borderRadius: BorderRadius.circular(LiaRadii.xxl),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: LiaColors.amber,
                  borderRadius: BorderRadius.circular(LiaRadii.md),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: LiaColors.greenDark,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Proteja-se de golpes',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Treine com situações reais e aprenda a identificar mensagens suspeitas.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: LiaColors.greenDark,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(LiaRadii.lg),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shield_outlined, size: 22),
                      SizedBox(width: 10),
                      Text('Começar treino'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: LiaColors.greenPale,
        borderRadius: BorderRadius.circular(LiaRadii.xl),
        border: Border.all(color: LiaColors.greenBorder, width: 1.5),
      ),
      child: Text(
        'Aqui você aprende a identificar golpes digitais de forma segura e sem risco. Nada será enviado, comprado ou apagado.',
        style: GoogleFonts.inter(
          fontSize: 15,
          color: LiaColors.textMedium,
          height: 1.6,
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(LiaRadii.lg),
          border: Border.all(color: LiaColors.borderGray, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(LiaRadii.md),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: LiaColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: LiaColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: LiaColors.textLightGray,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Trainings Screen ─────────────────────────────────────────────────────────

class TrainingsScreen extends StatelessWidget {
  const TrainingsScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Treinos',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: LiaColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Escolha um treino. Nada real será enviado ou pago.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: LiaColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              for (final training in trainings)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TrainingCard(
                    training: training,
                    selected: controller.lastTraining == training.name,
                    onTap: () => controller.startTraining(training.name),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrainingCard extends StatelessWidget {
  const _TrainingCard({
    required this.training,
    required this.onTap,
    this.selected = false,
  });

  final Training training;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label:
          '${training.name}. ${training.category}. ${training.difficulty}. ${training.minutes}. ${training.scenarios.length} casos.',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(LiaRadii.lg),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected ? LiaColors.greenPale : Colors.white,
            borderRadius: BorderRadius.circular(LiaRadii.lg),
            border: Border.all(
              color: selected ? LiaColors.greenDark : LiaColors.borderGray,
              width: selected ? 2 : 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: LiaColors.greenLight,
                  borderRadius: BorderRadius.circular(LiaRadii.md),
                ),
                child: Icon(
                  _trainingIcon(training.category),
                  color: LiaColors.greenDark,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: LiaColors.greenLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        training.tag,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: LiaColors.greenDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      training.name,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: LiaColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      training.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: LiaColors.textMuted,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _TinyMeta(text: training.category),
                        _TinyMeta(text: training.difficulty),
                        _TinyMeta(
                          text:
                              '${training.minutes} · ${training.scenarios.length} casos',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      training.safetyNotice,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: LiaColors.textMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: LiaColors.textLightGray,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _trainingIcon(String category) => switch (category) {
    'Banco digital' => Icons.payments_outlined,
    'WhatsApp' => Icons.chat_outlined,
    'Celular' => Icons.phone_android,
    _ => Icons.shield_outlined,
  };
}

class _TinyMeta extends StatelessWidget {
  const _TinyMeta({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: LiaColors.chatGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LiaColors.chatBorder),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: LiaColors.textMedium,
        ),
      ),
    );
  }
}

// ─── Training Intro (Step 1) ─────────────────────────────────────────────────

class TrainingIntroScreen extends StatelessWidget {
  const TrainingIntroScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return _TrainingLayout(
      step: 1,
      totalSteps: 6,
      onBack: () => controller.go(AppScreen.home),
      controller: controller,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: LiaColors.greenLight,
                    borderRadius: BorderRadius.circular(LiaRadii.md),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: LiaColors.greenDark,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  controller.training.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: LiaColors.textDark,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _TinyMeta(text: controller.training.category),
                    _TinyMeta(text: controller.training.difficulty),
                    _TinyMeta(text: controller.training.minutes),
                    _TinyMeta(
                      text: '${controller.training.scenarios.length} casos',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  controller.training.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: LiaColors.textMuted,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: LiaColors.amberLight,
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    border: Border.all(color: LiaColors.amber, width: 2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: LiaColors.amberDark,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${controller.training.safetyNotice} Você pode errar sem problema e tentar novamente.',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: LiaColors.amberText,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: controller.beginSimulation,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, size: 22),
                      SizedBox(width: 10),
                      Text('Começar'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => controller.go(AppScreen.home),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrainingLayout extends StatelessWidget {
  const _TrainingLayout({
    required this.step,
    required this.totalSteps,
    required this.onBack,
    required this.child,
    required this.controller,
  });

  final int step;
  final int totalSteps;
  final VoidCallback onBack;
  final Widget child;
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(
              bottom: BorderSide(color: LiaColors.borderGray, width: 1),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: LiaColors.greenLight,
                      borderRadius: BorderRadius.circular(LiaRadii.md),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: LiaColors.greenDark,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Etapa $step de $totalSteps',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: LiaColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: LiaColors.borderGray,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: step / totalSteps,
            child: Container(
              decoration: BoxDecoration(
                color: LiaColors.greenDark,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}

// ─── Simulation Screen (Step 2) ──────────────────────────────────────────────

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final item = controller.scenario;
    return _TrainingLayout(
      step: 2,
      totalSteps: 6,
      onBack: () => controller.go(AppScreen.home),
      controller: controller,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Veja essa mensagem que chegou no celular:',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: LiaColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _ChatBubble(scenario: item),
                const SizedBox(height: 24),
                Text(
                  'O que você faria primeiro?',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: LiaColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                for (final answer in item.answers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _AnswerOption(
                      label: answer.label,
                      onTap: () => controller.selectAnswer(answer),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.scenario});
  final Scenario scenario;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LiaColors.chatGray,
        borderRadius: BorderRadius.circular(LiaRadii.lg),
        border: Border.all(color: LiaColors.chatBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: LiaColors.borderGray,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD4D4CE),
                  ),
                  child: const Center(
                    child: Text(
                      '?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: LiaColors.textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  scenario.sender,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: LiaColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: LiaColors.chatBorder, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scenario.message,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: LiaColors.textDark,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(LiaRadii.xs),
                    border: Border.all(color: LiaColors.redBorder, width: 1.5),
                  ),
                  child: Text(
                    scenario.link,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: LiaColors.redDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(LiaRadii.md),
          border: Border.all(color: LiaColors.borderGrayLight, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: LiaColors.borderGrayLight, width: 2),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: LiaColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Feedback Wrong (Step 3a) ────────────────────────────────────────────────

class FeedbackWrongScreen extends StatelessWidget {
  const FeedbackWrongScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return _TrainingLayout(
      step: 3,
      totalSteps: 6,
      onBack: () => controller.go(AppScreen.home),
      controller: controller,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: LiaColors.redLight,
                    borderRadius: BorderRadius.circular(LiaRadii.xl),
                    border: Border.all(color: LiaColors.redBorder, width: 2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.cancel_outlined,
                        color: LiaColors.red,
                        size: 26,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cuidado. Essa ação pode ser perigosa.',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: LiaColors.redDark,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Clicar em links desconhecidos pode roubar seus dados ou instalar vírus.',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: const Color(0xFF7F1D1D),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: LiaColors.greenPale,
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    border: Border.all(
                      color: LiaColors.greenBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sinais de golpe:',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: LiaColors.greenDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _InfoItem(text: 'Mensagem com pressa ou urgência'),
                      _InfoItem(text: 'Promessa de benefício ou prêmio'),
                      _InfoItem(text: 'Link suspeito ou desconhecido'),
                      _InfoItem(text: 'Pedido de dados pessoais'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: controller.tryAgain,
                  child: const Text('Tentar de novo'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: controller.showExplanation,
                  child: const Text('Ver explicação'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber, color: LiaColors.amberDark, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: LiaColors.textMedium,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Feedback Right (Step 3b) ────────────────────────────────────────────────

class FeedbackRightScreen extends StatefulWidget {
  const FeedbackRightScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<FeedbackRightScreen> createState() => _FeedbackRightScreenState();
}

class _FeedbackRightScreenState extends State<FeedbackRightScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return _TrainingLayout(
      step: 3,
      totalSteps: 6,
      onBack: () => widget.controller.go(AppScreen.home),
      controller: widget.controller,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: LiaColors.greenSuccessLight,
                    borderRadius: BorderRadius.circular(LiaRadii.xl),
                    border: Border.all(
                      color: LiaColors.greenSuccessAccent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: LiaColors.greenSuccess,
                        size: 26,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Muito bem! Você escolheu o caminho mais seguro.',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: LiaColors.greenSuccessText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.controller.scenario.safeAction,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: const Color(0xFF14532D),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _ChecklistItem(text: 'Não clique em links desconhecidos.'),
                const SizedBox(height: 10),
                _ChecklistItem(text: 'Não envie senha, CPF ou código.'),
                const SizedBox(height: 10),
                _ChecklistItem(text: 'Desconfie de mensagens com pressa.'),
                const SizedBox(height: 10),
                _ChecklistItem(text: 'Procure canais oficiais.'),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: widget.controller.continueFromWord,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continuar'),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _saved
                      ? null
                      : () {
                          widget.controller.saveItem(
                            'dica',
                            'Não clique em links desconhecidos.',
                          );
                          setState(() => _saved = true);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _saved ? Icons.bookmark : Icons.bookmark_outline,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(_saved ? 'Dica salva!' : 'Salvar esta dica'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(LiaRadii.md),
        border: Border.all(color: LiaColors.borderGray, width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: LiaColors.greenSuccess,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: LiaColors.textDark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Word Explanation (Step 4) ───────────────────────────────────────────────

class WordExplanationScreen extends StatefulWidget {
  const WordExplanationScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<WordExplanationScreen> createState() => _WordExplanationScreenState();
}

class _WordExplanationScreenState extends State<WordExplanationScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final term = widget.controller.term;
    return _TrainingLayout(
      step: 4,
      totalSteps: 6,
      onBack: () => widget.controller.go(AppScreen.home),
      controller: widget.controller,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: LiaColors.amberLight,
                    borderRadius: BorderRadius.circular(LiaRadii.md),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: LiaColors.amberDark,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Palavra importante: ${term.title}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: LiaColors.textDark,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(LiaRadii.xl),
                    border: Border.all(color: LiaColors.borderGray, width: 1.5),
                  ),
                  child: Text(
                    term.description,
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      color: LiaColors.textDark,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: LiaColors.greenPale,
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    border: Border.all(
                      color: LiaColors.greenBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: LiaColors.greenDark,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          term.example,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: LiaColors.textMedium,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: LiaColors.redLight,
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    border: Border.all(color: LiaColors.redBorder, width: 1.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        color: LiaColors.red,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          term.alert,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: LiaColors.redDark,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: widget.controller.continueFromWord,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continuar treino'),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _saved
                      ? null
                      : () {
                          widget.controller.saveItem('palavra', term.title);
                          widget.controller.toggleFavorite();
                          setState(() => _saved = true);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _saved ? Icons.bookmark : Icons.bookmark_outline,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(_saved ? 'Palavra salva!' : 'Salvar palavra'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Reinforcement (Step 5) ──────────────────────────────────────────────────

class ReinforcementScreen extends StatelessWidget {
  const ReinforcementScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final item = controller.scenario;
    return _TrainingLayout(
      step: 5,
      totalSteps: 6,
      onBack: () => controller.go(AppScreen.home),
      controller: controller,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Agora uma nova mensagem chegou:',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: LiaColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                _ChatBubble(scenario: item),
                const SizedBox(height: 24),
                Text(
                  'O que você faria?',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: LiaColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                for (final answer in item.answers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _AnswerOption(
                      label: answer.label,
                      onTap: () => controller.selectReinforcementAnswer(answer),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Reinforcement Feedback (Step 5 feedback) ────────────────────────────────

class ReinforcementFeedbackScreen extends StatelessWidget {
  const ReinforcementFeedbackScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final isCorrect = controller.selectedAnswer != AnswerType.risky;
    return _TrainingLayout(
      step: 5,
      totalSteps: 6,
      onBack: () => controller.go(AppScreen.home),
      controller: controller,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? LiaColors.greenSuccessLight
                        : LiaColors.amberLight,
                    borderRadius: BorderRadius.circular(LiaRadii.xl),
                    border: Border.all(
                      color: isCorrect
                          ? LiaColors.greenSuccessAccent
                          : LiaColors.amber,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isCorrect
                            ? Icons.check_circle_outline
                            : Icons.info_outline,
                        color: isCorrect
                            ? LiaColors.greenSuccess
                            : LiaColors.amberDark,
                        size: 26,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCorrect
                                  ? 'Exatamente! Senhas e códigos nunca devem ser enviados por mensagem.'
                                  : 'Quase lá. O maior perigo é pedir senha.',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isCorrect
                                    ? LiaColors.greenSuccessText
                                    : LiaColors.amberText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.scenario.safeAction,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: isCorrect
                                    ? const Color(0xFF14532D)
                                    : LiaColors.amberText,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: controller.finishTraining,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.flag_outlined, size: 22),
                      SizedBox(width: 10),
                      Text('Finalizar treino'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Conclusion Screen (Step 6) ──────────────────────────────────────────────

class ConclusionScreen extends StatefulWidget {
  const ConclusionScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<ConclusionScreen> createState() => _ConclusionScreenState();
}

class _ConclusionScreenState extends State<ConclusionScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return _TrainingLayout(
      step: 6,
      totalSteps: 6,
      onBack: () => widget.controller.go(AppScreen.home),
      controller: widget.controller,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LiaColors.gradient,
                    borderRadius: BorderRadius.circular(LiaRadii.xxl),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: LiaColors.amber,
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Treino completo!',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Você aprendeu a se proteger melhor.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'O QUE VOCÊ APRENDEU:',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: LiaColors.textMuted,
                    letterSpacing: 0.04,
                  ),
                ),
                const SizedBox(height: 14),
                _ChecklistItem(text: 'Você identificou um link suspeito.'),
                const SizedBox(height: 10),
                _ChecklistItem(text: 'Você aprendeu o que é link.'),
                const SizedBox(height: 10),
                _ChecklistItem(
                  text: 'Você reconheceu que senha não deve ser enviada.',
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => widget.controller.go(AppScreen.home),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home, size: 22),
                      SizedBox(width: 10),
                      Text('Ir para o início'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _saved
                      ? null
                      : () {
                          widget.controller.saveItem(
                            'resumo',
                            'Sinais de golpe em mensagens',
                          );
                          setState(() => _saved = true);
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _saved ? Icons.bookmark : Icons.bookmark_outline,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(_saved ? 'Resumo salvo!' : 'Salvar resumo'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => widget.controller.startTraining(
                    widget.controller.selectedTraining,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.refresh, size: 20, color: LiaColors.textMuted),
                      const SizedBox(width: 10),
                      Text(
                        'Treinar novamente',
                        style: GoogleFonts.inter(
                          color: LiaColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Dictionary Screen ───────────────────────────────────────────────────────

class DictionaryScreen extends StatelessWidget {
  const DictionaryScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final term = controller.term;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dicionário digital',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: LiaColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${dictionaryTerms.length} termos em linguagem simples. Toque em um termo para revisar.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: LiaColors.textMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: term.key,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Escolha um termo',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    borderSide: const BorderSide(color: LiaColors.borderGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    borderSide: const BorderSide(
                      color: LiaColors.borderGray,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    borderSide: const BorderSide(
                      color: LiaColors.greenDark,
                      width: 2,
                    ),
                  ),
                ),
                items: [
                  for (final item in dictionaryTerms)
                    DropdownMenuItem(
                      value: item.key,
                      child: Text(item.title, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) controller.selectTerm(value);
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(LiaRadii.xl),
                  border: Border.all(color: LiaColors.borderGray, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      term.title,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: LiaColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _TinyMeta(text: term.category),
                    const SizedBox(height: 14),
                    Text(
                      term.description,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        color: LiaColors.textDark,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: LiaColors.greenPale,
                        borderRadius: BorderRadius.circular(LiaRadii.md),
                      ),
                      child: Text(
                        term.example,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: LiaColors.textMedium,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: LiaColors.blueLight,
                        borderRadius: BorderRadius.circular(LiaRadii.md),
                      ),
                      child: Text(
                        'Dica: ${term.tip}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: LiaColors.blueDark,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      term.alert,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: LiaColors.redDark,
                      ),
                    ),
                    if (term.related.isNotEmpty || term.tags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final item in [...term.related, ...term.tags])
                            _TinyMeta(text: item),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Help Screen ─────────────────────────────────────────────────────────────

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key, required this.controller});
  final AppController controller;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int? _expandedFaq;

  @override
  Widget build(BuildContext context) {
    final help = widget.controller.help;
    final steps =
        help.steps[widget.controller.deviceBrand] ?? help.steps['Detectado']!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: LiaColors.blueLight,
                      borderRadius: BorderRadius.circular(LiaRadii.md),
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: LiaColors.blueDark,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajuda',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: LiaColors.textDark,
                          ),
                        ),
                        Text(
                          '${deviceHelpItems.length} problemas comuns e perguntas frequentes.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: LiaColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _SectionLabel(text: 'COMO LIGAR'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(LiaRadii.xl),
                  border: Border.all(color: LiaColors.borderGray, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: LiaColors.greenLight,
                            borderRadius: BorderRadius.circular(LiaRadii.md),
                          ),
                          child: const Icon(
                            Icons.phone_outlined,
                            color: LiaColors.greenDark,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Fazer uma ligação',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: LiaColors.textDark,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (var i = 0; i < callSteps.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: LiaColors.greenLight,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: LiaColors.greenDark,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                callSteps[i],
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: LiaColors.textDark,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _SectionLabel(text: 'PROBLEMAS COMUNS'),
              const SizedBox(height: 12),
              Text(
                'Passos para ${widget.controller.deviceBrand}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: LiaColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: help.key,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Escolha o problema',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    borderSide: const BorderSide(color: LiaColors.borderGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    borderSide: const BorderSide(
                      color: LiaColors.borderGray,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(LiaRadii.lg),
                    borderSide: const BorderSide(
                      color: LiaColors.greenDark,
                      width: 2,
                    ),
                  ),
                ),
                items: [
                  for (final item in deviceHelpItems)
                    DropdownMenuItem(
                      value: item.key,
                      child: Text(item.title, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) widget.controller.selectHelp(value);
                },
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(LiaRadii.xl),
                  border: Border.all(color: LiaColors.borderGray, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      help.title,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: LiaColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _TinyMeta(text: help.category),
                    const SizedBox(height: 14),
                    for (var i = 0; i < steps.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: LiaColors.greenLight,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: LiaColors.greenDark,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                steps[i],
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: LiaColors.textDark,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (help.alert.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: LiaColors.redLight,
                          borderRadius: BorderRadius.circular(LiaRadii.md),
                          border: Border.all(color: LiaColors.redBorder),
                        ),
                        child: Text(
                          help.alert,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: LiaColors.redDark,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: LiaColors.blueLight,
                        borderRadius: BorderRadius.circular(LiaRadii.md),
                      ),
                      child: Text(
                        'Quando pedir ajuda: ${help.whenToAskHelp}',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: LiaColors.blueDark,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (widget.controller.showDeviceGuide)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: LiaColors.greenPale,
                    borderRadius: BorderRadius.circular(LiaRadii.xl),
                    border: Border.all(
                      color: LiaColors.greenBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.phone_android,
                          size: 54,
                          color: LiaColors.greenDark,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          help.visual,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: LiaColors.textMedium,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              TextButton(
                key: const Key('toggle-guide-button'),
                onPressed: widget.controller.toggleDeviceGuide,
                child: Text(
                  widget.controller.showDeviceGuide
                      ? 'Ocultar guia visual'
                      : 'Ver guia visual',
                ),
              ),
              const SizedBox(height: 28),
              _SectionLabel(text: 'PERGUNTAS FREQUENTES'),
              const SizedBox(height: 12),
              for (var i = 0; i < faqItems.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _FaqCard(
                    item: faqItems[i],
                    expanded: _expandedFaq == i,
                    onTap: () => setState(() {
                      _expandedFaq = _expandedFaq == i ? null : i;
                    }),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: LiaColors.textMuted,
        letterSpacing: 0.04,
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final FaqItem item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(LiaRadii.lg),
          border: Border.all(color: LiaColors.borderGray, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.question,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: LiaColors.textDark,
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: LiaColors.textMuted,
                  size: 24,
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: LiaColors.borderGray, width: 1),
                  ),
                ),
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  item.answer,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: LiaColors.textMedium,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Quiz Screen ─────────────────────────────────────────────────────────────

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final question = controller.quizQuestion;
    final answered = controller.lastQuizAnswerId != null;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: LiaColors.greenLight,
                      borderRadius: BorderRadius.circular(LiaRadii.md),
                    ),
                    child: const Icon(
                      Icons.quiz_outlined,
                      color: LiaColors.greenDark,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teste educativo',
                          style: GoogleFonts.inter(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: LiaColors.textDark,
                          ),
                        ),
                        Text(
                          '${controller.answeredQuestions.length}/${quizQuestions.length} respondidas',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: LiaColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: controller.quizProgress,
                minHeight: 8,
                backgroundColor: LiaColors.borderGray,
                color: LiaColors.greenDark,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(LiaRadii.xl),
                  border: Border.all(color: LiaColors.borderGray, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _TinyMeta(text: question.category),
                        _TinyMeta(text: question.level),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      question.question,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: LiaColors.textDark,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 18),
                    for (final option in question.alternatives)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _QuizOption(
                          text: option.text,
                          selected: controller.lastQuizAnswerId == option.id,
                          correct:
                              answered && option.id == question.correctAnswerId,
                          disabled: answered,
                          onTap: () => controller.answerQuiz(option.id),
                        ),
                      ),
                  ],
                ),
              ),
              if (answered) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: controller.lastQuizWasCorrect == true
                        ? LiaColors.greenSuccessLight
                        : LiaColors.amberLight,
                    borderRadius: BorderRadius.circular(LiaRadii.xl),
                    border: Border.all(
                      color: controller.lastQuizWasCorrect == true
                          ? LiaColors.greenSuccessAccent
                          : LiaColors.amber,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        controller.lastQuizWasCorrect == true
                            ? Icons.check_circle_outline
                            : Icons.info_outline,
                        color: controller.lastQuizWasCorrect == true
                            ? LiaColors.greenSuccess
                            : LiaColors.amberDark,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          controller.lastQuizWasCorrect == true
                              ? question.explanation
                              : 'Quase. ${question.explanation}',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: controller.lastQuizWasCorrect == true
                                ? LiaColors.greenSuccessText
                                : LiaColors.amberText,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: controller.nextQuizQuestion,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Próxima pergunta'),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'Este teste é educativo. Ele não pede senha, CPF, código real nem faz operação bancária.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: LiaColors.textMuted,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  const _QuizOption({
    required this.text,
    required this.selected,
    required this.correct,
    required this.disabled,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final bool correct;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = correct
        ? LiaColors.greenSuccess
        : selected
        ? LiaColors.greenDark
        : LiaColors.borderGray;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(LiaRadii.lg),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: correct
                ? LiaColors.greenSuccessLight
                : selected
                ? LiaColors.greenPale
                : Colors.white,
            borderRadius: BorderRadius.circular(LiaRadii.lg),
            border: Border.all(
              color: borderColor,
              width: selected || correct ? 2 : 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                correct
                    ? Icons.check_circle_outline
                    : selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: correct ? LiaColors.greenSuccess : LiaColors.greenDark,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: LiaColors.textDark,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Favorites Screen ────────────────────────────────────────────────────────

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final favorites = dictionaryTerms
        .where((term) => controller.favoriteTerms.contains(term.key))
        .toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bookmark,
                    color: LiaColors.greenDark,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Salvos',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: LiaColors.textDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Seus conteúdos guardados ficam aqui.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: LiaColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              if (favorites.isEmpty && controller.savedItems.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(LiaRadii.xl),
                    border: Border.all(color: LiaColors.borderGray, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.bookmark_outline,
                        color: LiaColors.textLightGray,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum item salvo ainda.',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: LiaColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Salve dicas, palavras e resumos durante os treinos.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: LiaColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ),
              for (final item in controller.savedItems)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SavedItemCard(
                    type: item['type'] ?? '',
                    text: item['text'] ?? '',
                    onTap: () {
                      if (item['type'] == 'palavra') {
                        controller.selectTerm(
                          dictionaryTerms
                              .firstWhere(
                                (t) => t.title == item['text'],
                                orElse: () => dictionaryTerms.first,
                              )
                              .key,
                        );
                      }
                    },
                  ),
                ),
              for (final term in favorites)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SavedItemCard(
                    type: 'palavra',
                    text: term.title,
                    onTap: () => controller.selectTerm(term.key),
                  ),
                ),
              if (favorites.isNotEmpty || controller.savedItems.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton(
                    onPressed: () => controller.go(AppScreen.dictionary),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.menu_book_outlined, size: 20),
                        SizedBox(width: 10),
                        Text('Abrir dicionário'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedItemCard extends StatelessWidget {
  const _SavedItemCard({
    required this.type,
    required this.text,
    required this.onTap,
  });

  final String type;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final config = _savedItemConfig(type);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(LiaRadii.xl),
          border: Border.all(color: LiaColors.borderGray, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: config.$2,
                    borderRadius: BorderRadius.circular(LiaRadii.md),
                  ),
                  child: Icon(config.$1, color: config.$3, size: 26),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: config.$2,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        config.$4,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: config.$3,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: LiaColors.textDark,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: LiaColors.borderGray, width: 1),
                ),
              ),
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: LiaColors.textLightGray,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Salvo durante o treino',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: LiaColors.textLightGray,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: config.$2,
                      borderRadius: BorderRadius.circular(LiaRadii.sm),
                    ),
                    child: Text(
                      'Abrir',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: config.$3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, Color, String) _savedItemConfig(String type) {
    return switch (type) {
      'dica' => (
        Icons.check_circle_outline,
        LiaColors.greenLight,
        LiaColors.greenDark,
        'DICA DE SEGURANÇA',
      ),
      'palavra' => (
        Icons.menu_book,
        LiaColors.amberLight,
        LiaColors.amberDark,
        'PALAVRA DO DICIONÁRIO',
      ),
      'resumo' => (
        Icons.description_outlined,
        LiaColors.blueLight,
        LiaColors.blueDark,
        'RESUMO DO TREINO',
      ),
      _ => (
        Icons.bookmark_outline,
        LiaColors.borderGray,
        LiaColors.textMuted,
        'ITEM',
      ),
    };
  }
}
