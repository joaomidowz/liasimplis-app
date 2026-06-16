# Ponto de retomada

Última atualização: 10 de junho de 2026.

## Concluído

- Projeto Flutter funcional criado em `frontend-projects/lia-simplis-flutter`.
- Migração das principais funcionalidades do protótipo HTML.
- `flutter analyze` executado sem problemas.
- Quatro testes unitários aprovados.
- Um teste de fluxo de interface aprovado.
- Build Web concluído com sucesso.
- Documentação criada na pasta `docs/`.

## Onde paramos

O build Android falhou porque o Gradle está usando Java `25.0.3`, versão incompatível com o compilador Kotlin atual do projeto.

Na próxima sessão:

1. Instalar ou localizar Java 17 ou Java 21.
2. Configurar `JAVA_HOME` ou o Flutter para usar essa versão.
3. Executar novamente:

```bash
flutter build apk --debug
```

4. Confirmar a geração do APK.
5. Depois, executar os testes de desempenho em aparelho ou emulador junto com o usuário.
