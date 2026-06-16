# Ponto de retomada

Última atualização: 16 de junho de 2026.

## Concluído

- Migração do protótipo Figma para Flutter aplicada.
- Cores, fonte Inter e layout do protótipo implementados.
- Wizard de 6 etapas para treinos funcionando.
- Tela Ajuda com: Como ligar, Problemas comuns (por marca), Perguntas Frequentes.
- Tela de Onboarding: coleta nome e marca do celular antes de acessar o app.
- HomeScreen exibe nome do usuário.
- Bottom nav com 5 tabs: Início, Treino, Ajuda, Dicionário, Salvos.
- Persistência com SharedPreferences mantida.
- `flutter analyze` sem issues.
- 17 testes passando.
- Build Web bem-sucedido.

## Onde paramos

O build Android continua bloqueado pelo Java 25.0.3. Na próxima sessão:

1. Instalar Java 17 ou Java 21.
2. Configurar `JAVA_HOME`.
3. Executar `flutter build apk --debug`.
4. Testes de desempenho em dispositivo.

## Estrutura atual

```
lib/
├── main.dart
├── models.dart          # FaqItem adicionado
├── app_data.dart        # faqItems, callSteps adicionados
├── app_controller.dart  # AppScreen.start, .help; completeOnboarding()
├── design_tokens.dart   # Cores, raios
└── lia_app.dart         # StartScreen, HelpScreen, HomeScreen com nome
```
