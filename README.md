# LiaSimplis Flutter

Migração funcional do protótipo HTML/CSS/JavaScript do LiaSimplis para Flutter.

## Funcionalidades

- Onboarding com nome, marca do aparelho e aviso de segurança.
- Preferências de tamanho de texto e modo de explicação.
- Home com progresso e continuidade.
- Dois treinos e 15 cenários educativos.
- Resultados para escolhas seguras, pedido de ajuda e escolhas arriscadas.
- Dicionário com cinco termos e favoritos.
- Ajuda para quatro problemas em cinco marcas/fallbacks.
- Persistência local com `shared_preferences`.
- Síntese e comando de voz com fallback.
- Testes unitários, de widget e integração/desempenho.

## Executar

```bash
flutter pub get
flutter run -d chrome
```

Para Android, conecte um aparelho ou inicie um emulador e execute:

```bash
flutter devices
flutter run -d <ID_DO_DISPOSITIVO>
```

## Testes

```bash
flutter analyze
flutter test
flutter test integration_test/performance_test.dart -d <ID_DO_DISPOSITIVO>
```

Consulte [docs/como-executar-e-testar.md](docs/como-executar-e-testar.md) para o roteiro completo e [docs/plano-de-testes.md](docs/plano-de-testes.md) para a documentação acadêmica.
