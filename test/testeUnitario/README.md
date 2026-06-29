# Documentacao dos Testes Unitarios - AppController

## Arquivo testado

`test/testeUnitario/app_controller_test_unitario.dart`

## Objetivo

Validar o comportamento principal da classe `AppController`, responsavel por controlar o estado do aplicativo Lia Simplis.

Os testes verificam se o controlador:

- inicia corretamente sem dados salvos;
- conclui o onboarding;
- inicia um treino;
- direciona respostas seguras e arriscadas para as telas corretas;
- adiciona e remove favoritos;
- localiza termos do dicionario.

## Dependencias usadas

O teste utiliza:

- `flutter_test`: biblioteca de testes do Flutter;
- `shared_preferences`: usado com valores simulados para testar persistencia local;
- `AppController`: classe principal testada;
- `app_data.dart`: dados fixos do aplicativo;
- `models.dart`: modelos como `Scenario` e `AnswerType`.

## Preparacao dos testes

Antes de cada teste, o seguinte codigo e executado:

```dart
SharedPreferences.setMockInitialValues({});
```

Isso garante que cada teste comece sem dados salvos anteriormente, evitando interferencia entre os casos de teste.

## Casos de teste

### CT-UNI-001 - Load sem dados salvos mantem onboarding

Verifica se, ao carregar o app sem dados persistidos, a tela inicial permanece em `AppScreen.start`.

Resultado esperado:

```dart
controller.screen == AppScreen.start
```

### CT-UNI-002 - CompleteOnboarding salva nome, marca e vai para home

Verifica se o metodo `completeOnboarding` salva o nome do usuario, a marca do aparelho e muda a tela para `AppScreen.home`.

Resultado esperado:

```dart
controller.name == 'Maria'
controller.deviceBrand == 'Samsung'
controller.screen == AppScreen.home
```

### CT-UNI-003 - StartTraining inicia Mensagem suspeita

Verifica se o treino `Mensagem suspeita` e iniciado corretamente.

O teste valida:

- o nome do treino ativo;
- se existe um cenario carregado;
- se a tela atual passa a ser `AppScreen.trainingIntro`.

Resultado esperado:

```dart
controller.training.name == 'Mensagem suspeita'
controller.scenario is Scenario
controller.screen == AppScreen.trainingIntro
```

### CT-UNI-004 - Resposta segura direciona para feedback positivo

Verifica se uma resposta do tipo `AnswerType.safe` leva o usuario para a tela de feedback positivo.

Resultado esperado:

```dart
controller.selectedAnswer == safeAnswer.type
controller.selectedAnswerLabel == safeAnswer.label
controller.screen == AppScreen.feedbackRight
```

### CT-UNI-005 - Resposta arriscada direciona para feedback de alerta

Verifica se uma resposta do tipo `AnswerType.risky` leva o usuario para a tela de alerta.

Resultado esperado:

```dart
controller.selectedAnswer == riskyAnswer.type
controller.selectedAnswerLabel == riskyAnswer.label
controller.screen == AppScreen.feedbackWrong
```

### CT-UNI-006 - ToggleFavorite adiciona e remove termo sem duplicar

Verifica se o metodo `toggleFavorite` adiciona o termo selecionado aos favoritos e remove o mesmo termo quando chamado novamente.

Fluxo testado:

```dart
controller.selectTerm('link');
controller.toggleFavorite();
controller.toggleFavorite();
```

Resultado esperado:

- apos a primeira chamada, `link` deve estar nos favoritos;
- apos a segunda chamada, `link` deve ser removido.

### CT-UNI-007 - Dicionario localiza termo Link

Verifica se a funcao `termByKey('link')` retorna corretamente o termo do dicionario.

Resultado esperado:

```dart
term.title.toLowerCase().contains('link')
```

## Como executar

Na raiz do projeto, execute:

```powershell
flutter test test/testeUnitario/app_controller_test_unitario.dart
```

Ou, no Windows:

```powershell
flutter test .\test\testeUnitario\app_controller_test_unitario.dart
```

## Resultado esperado geral

Todos os testes devem passar sem falhas.

Exemplo de resultado esperado:

```text
All tests passed!
```

## Observacao

Este arquivo testa apenas a logica do `AppController`. Ele nao valida elementos visuais da interface. Para validar telas, botoes e fluxos visuais, devem ser usados testes de widget ou integracao.
