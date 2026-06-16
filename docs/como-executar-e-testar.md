# Como executar e testar o LiaSimplis Flutter

## 1. Preparação

No terminal, entre na pasta do projeto:

```bash
cd /home/joao/worktree/frontend-projects/lia-simplis-flutter
flutter doctor
flutter pub get
```

## 2. Abrir o aplicativo

### Navegador Chrome

```bash
flutter run -d chrome
```

### Android físico ou emulador

```bash
flutter devices
flutter run -d <ID_DO_DISPOSITIVO>
```

O Android é o ambiente recomendado para testar voz, microfone, desempenho e comportamento em aparelho de entrada.

## 3. Verificações automatizadas

### Análise estática

```bash
flutter analyze
```

Resultado esperado: `No issues found!`.

### Testes unitários e de widget

```bash
flutter test --reporter expanded
```

Os testes verificam:

- inventário dos 15 cenários, cinco termos e quatro tipos de ajuda;
- cálculo de progresso e escolhas seguras;
- favoritos e persistência;
- troca de cenário sem repetição imediata;
- fluxo do onboarding até o resultado de uma simulação.

### Teste de desempenho e integração

Com um aparelho ou emulador disponível:

```bash
flutter test integration_test/performance_test.dart -d <ID_DO_DISPOSITIVO>
```

O teste executa navegação repetida e 30 trocas de cenário. Guarde a saída do terminal e os dados de `navigation_performance` para preencher o resultado obtido no plano de testes.

## 4. Roteiro manual funcional

1. Abra o aplicativo sem dados anteriores.
2. Informe um nome e selecione a marca do celular.
3. Confira o aviso de que nenhuma ação real será executada.
4. Escolha cada tamanho de texto e verifique se nada fica cortado.
5. Entre em `Mensagem suspeita`, responda um cenário e confira o resultado.
6. Repita com `Transferência instantânea`.
7. Abra `Link` no dicionário, salve o termo e confira a tela `Salvos`.
8. Abra `Consertar celular`, alterne os quatro problemas e mostre/oculte o print simulado.
9. Feche e abra novamente o aplicativo para validar a persistência.
10. Teste os botões de ouvir e comando de voz, concedendo microfone quando solicitado.

## 5. Roteiro manual de desempenho

Execute em modo `profile`, nunca use apenas o modo `debug` para concluir sobre desempenho:

```bash
flutter run --profile -d <ID_DO_DISPOSITIVO>
```

No DevTools, registre:

| Medição | Resultado obtido |
|---|---|
| Tempo de abertura fria | Pendente |
| Quadros lentos durante navegação | Pendente |
| Pico de memória | Pendente |
| Tempo médio para trocar de tela | Pendente |
| Comportamento com fonte em 200% | Pendente |
| Consumo durante uso de voz | Pendente |

Também valide 20 ciclos entre Início, Treinos e Ajuda e 30 trocas de cenário. Não deve haver travamento, exceção ou atraso perceptível.

## 6. Registro dos resultados

Para cada teste manual, registre:

- aparelho e versão do sistema;
- modo de execução (`profile` ou `release`);
- data e responsável;
- resultado esperado e obtido;
- status `Aprovado` ou `Reprovado`;
- evidência, como captura de tela, vídeo ou saída do terminal.
