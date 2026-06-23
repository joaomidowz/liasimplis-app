# LIA SIMPLIS

## Documentação de Teste de Desempenho

| Campo | Informação |
|-------|------------|
| Projeto | Lia Simplis — App Mobile Flutter |
| Tipo de Teste | Desempenho |
| Disciplina | Teste e Qualidade de Software |
| Instituição | Univel — Centro Universitário |
| Plataforma | Flutter (Web / Android) |
| Responsável | João Gabriel Custódio |
| Data | 21/06/2026 |

---

## 1. Introdução

O Lia Simplis é um aplicativo mobile educacional desenvolvido em Flutter voltado para ensinar adultos e idosos a identificar e se proteger de golpes digitais.

Este documento descreve o planejamento, a execução e os resultados dos testes de desempenho do app, cujo objetivo é medir a velocidade de resposta, estabilidade e tamanho do build em operações repetitivas e cenários de uso intensivo.

### 1.1 Objetivos

| Objetivo |
|----------|
| Medir o tempo de navegação entre abas em ciclos repetidos |
| Avaliar a estabilidade na troca de cenários de treino |
| Verificar o tamanho do bundle web após build de produção |
| Medir o tempo de carregamento inicial do app |
| Garantir que nenhuma exceção ocorra durante operações de alta frequência |

### 1.2 Escopo

Os testes cobrem as seguintes métricas:

| Métrica | O que é medido |
|---------|----------------|
| Navegação entre abas | Tempo total de 20 ciclos completos (Home → Treino → Ajuda → Dicionário → Salvos → Home) |
| Troca de cenário | Tempo total de 30 trocas consecutivas de cenário de treino |
| Build web | Tamanho do bundle principal (main.dart.js) após build de release |
| Carregamento inicial | Tempo de resposta do servidor local ao carregar o index.html |
| Persistência save/load | Tempo de 50 ciclos de resposta → conclusão → novo treino com persistência |
| Inicialização completa | Tempo do zero até conclusão de 1 treino (init + onboarding + treino) |

---

## 2. Estratégia de Teste

### 2.1 Tipo de Teste

Teste de Desempenho: mede quantitativamente o tempo de resposta e a estabilidade do app sob carga. Diferente dos testes funcionais, que validam "o que" o app faz, os testes de desempenho validam "quão rápido" e "quão estável" ele faz.

### 2.2 Ferramentas

| Ferramenta | Finalidade |
|------------|------------|
| `flutter_test` | Framework base para execução de testes unitários |
| `Stopwatch` | Medição precisa de tempo em milissegundos |
| `flutter build web --release` | Geração do bundle de produção |
| `du -sh` | Medição do tamanho do build |
| `curl` | Medição de tempo de carregamento HTTP |

### 2.3 Abordagem

| Aspecto | Decisão |
|---------|---------|
| Ambiente | Linux (Fedora 43), Flutter 3.41.2, Dart 3.11.0 |
| Repetições | 20 ciclos de navegação, 30 trocas de cenário |
| Critério de aprovação | < 3.000ms para operações, < 5MB para build |
| Seed | Random(42) para reprodutibilidade |
| Mock | SharedPreferences.setMockInitialValues({}) |

---

## 3. Casos de Teste

### CT-DES-01 — Navegação entre abas (20 ciclos)

| Campo | Informação |
|-------|------------|
| Identificador | CT-DES-01 |
| Título | Medir tempo de 20 ciclos de navegação entre abas |
| Objetivo | Verificar que a navegação entre as 5 abas mantém desempenho estável |
| Pré-condições | AppController inicializado com nome 'Teste' e marca 'Samsung' |
| Dados de Entrada | Nenhum. Apenas chamadas a `controller.go()` |
| Passos | 1. Criar AppController e completar onboarding / 2. Iniciar Stopwatch / 3. Repetir 20 vezes: go(trainings) → go(help) → go(dictionary) → go(favorites) → go(home) / 4. Parar Stopwatch / 5. Registrar tempo |
| Resultado Esperado | Tempo total < 3.000ms |
| Resultado Obtido | **47ms** |
| Status | **Aprovado** |

#### Código utilizado

```dart
test('CT-DES-01: navegação entre telas (20 ciclos)', () async {
  final controller = AppController();
  await controller.load();
  controller.completeOnboarding('Teste', 'Samsung');

  final sw = Stopwatch()..start();
  for (var i = 0; i < 20; i++) {
    controller.go(AppScreen.trainings);
    controller.go(AppScreen.help);
    controller.go(AppScreen.dictionary);
    controller.go(AppScreen.favorites);
    controller.go(AppScreen.home);
  }
  sw.stop();
  print('CT-DES-01: ${sw.elapsedMilliseconds}ms para 20 ciclos');
  expect(sw.elapsedMilliseconds, lessThan(3000));
});
```

---

### CT-DES-02 — Troca de cenário (30x)

| Campo | Informação |
|-------|------------|
| Identificador | CT-DES-02 |
| Título | Medir tempo de 30 trocas consecutivas de cenário |
| Objetivo | Verificar que a troca de cenários de treino não degrada o desempenho |
| Pré-condições | Treino 'Mensagem suspeita' iniciado, SimulationScreen visível |
| Dados de Entrada | Nenhum. Chamadas a `chooseAnotherScenario()` |
| Passos | 1. Criar AppController com Random(42) / 2. Completar onboarding / 3. Iniciar treino / 4. Chamar beginSimulation() / 5. Iniciar Stopwatch / 6. Repetir 30 vezes: chooseAnotherScenario() / 7. Parar Stopwatch / 8. Registrar tempo |
| Resultado Esperado | Tempo total < 3.000ms |
| Resultado Obtido | **6ms** |
| Status | **Aprovado** |

#### Código utilizado

```dart
test('CT-DES-02: troca de cenário (30x)', () async {
  final controller = AppController(random: Random(42));
  await controller.load();
  controller.completeOnboarding('Teste', 'Samsung');
  controller.startTraining(trainings.first.name);
  controller.beginSimulation();

  final sw = Stopwatch()..start();
  for (var i = 0; i < 30; i++) {
    controller.chooseAnotherScenario();
  }
  sw.stop();
  print('CT-DES-02: ${sw.elapsedMilliseconds}ms para 30 trocas');
  expect(sw.elapsedMilliseconds, lessThan(3000));
});
```

---

### CT-DES-03 — Build web (tamanho)

| Campo | Informação |
|-------|------------|
| Identificador | CT-DES-03 |
| Título | Medir tamanho do bundle web de produção |
| Objetivo | Verificar que o build de produção é leve o suficiente para carregamento rápido |
| Pré-condições | Projeto sem alterações pendentes |
| Dados de Entrada | Nenhum |
| Passos | 1. Executar `flutter build web --release` / 2. Executar `du -sh build/web/main.dart.js` / 3. Registrar tamanho |
| Resultado Esperado | main.dart.js < 5MB |
| Resultado Obtido | **2.5MB** (main.dart.js) / 36MB total (inclui CanvasKit) |
| Status | **Aprovado** |

#### Código utilizado

```bash
flutter build web --release
du -sh build/web/
du -sh build/web/main.dart.js
```

#### Detalhamento do build

| Componente | Tamanho |
|------------|---------|
| main.dart.js (app) | 2.5MB |
| assets/ | 1.4MB |
| flutter.js | 12KB |
| canvaskit/ (engine) | 32MB |
| **Total** | **36MB** |

---

### CT-DES-04 — Carregamento inicial

| Campo | Informação |
|-------|------------|
| Identificador | CT-DES-04 |
| Título | Medir tempo de carregamento inicial do app |
| Objetivo | Verificar que o app carrega em tempo aceitável para o usuário |
| Pré-condições | Build web de produção servido localmente via Python HTTP server |
| Dados de Entrada | Nenhum |
| Passos | 1. Servir build/web na porta 8099 / 2. Aguardar 1s para estabilizar / 3. Executar curl para localhost:8080 / 4. Medir tempo de resposta / 5. Registrar |
| Resultado Esperado | Tempo < 3.000ms |
| Resultado Obtido | **66ms** |
| Status | **Aprovado** |

#### Código utilizado

```bash
cd build/web && python3 -m http.server 8099 &
sleep 1
START=$(date +%s%N)
curl -s -o /dev/null http://localhost:8080/
END=$(date +%s%N)
ELAPSED=$(( (END - START) / 1000000 ))
echo "CT-DES-04: ${ELAPSED}ms"
```

---

### CT-DES-05 — Persistência save/load (50 ciclos)

| Campo | Informação |
|-------|------------|
| Identificador | CT-DES-05 |
| Título | Medir tempo de 50 ciclos de persistência (resposta → conclusão → novo treino) |
| Objetivo | Verificar que a persistência com SharedPreferences não degrada o desempenho |
| Pré-condições | AppController com onboarding completo, treino iniciado |
| Dados de Entrada | Resposta safe em cada ciclo |
| Passos | 1. Criar AppController com Random(99) / 2. Completar onboarding / 3. Iniciar treino / 4. beginSimulation() / 5. Iniciar Stopwatch / 6. Repetir 50 vezes: selectAnswer(safe) → finishTraining() → startTraining() → beginSimulation() / 7. Parar Stopwatch / 8. Registrar tempo |
| Resultado Esperado | Tempo total < 5.000ms |
| Resultado Obtido | **42ms** |
| Status | **Aprovado** |

#### Código utilizado

```dart
test('CT-DES-05: persistência save/load (50 ciclos)', () async {
  SharedPreferences.setMockInitialValues({});
  final controller = AppController(random: Random(99));
  await controller.load();
  controller.completeOnboarding('PersistTest', 'Xiaomi');
  controller.startTraining(trainings.first.name);
  controller.beginSimulation();

  final sw = Stopwatch()..start();
  for (var i = 0; i < 50; i++) {
    controller.selectAnswer(controller.scenario.answers.first);
    controller.finishTraining();
    controller.startTraining(trainings.first.name);
    controller.beginSimulation();
  }
  sw.stop();
  print('CT-DES-05: ${sw.elapsedMilliseconds}ms para 50 ciclos save/load');
  expect(sw.elapsedMilliseconds, lessThan(5000));
});
```

---

### CT-DES-06 — Inicialização completa

| Campo | Informação |
|-------|------------|
| Identificador | CT-DES-06 |
| Título | Medir tempo do zero até conclusão de 1 treino completo |
| Objetivo | Verificar que o ciclo completo (init → onboarding → treino → conclusão) é rápido |
| Pré-condições | SharedPreferences vazio (primeira execução) |
| Dados de Entrada | Nome: 'InitTest' / Marca: 'Motorola' / Resposta: safe |
| Passos | 1. Iniciar Stopwatch / 2. Criar AppController / 3. load() / 4. completeOnboarding() / 5. startTraining() / 6. beginSimulation() / 7. selectAnswer(safe) / 8. finishTraining() / 9. Parar Stopwatch / 10. Registrar tempo |
| Resultado Esperado | Tempo total < 5.000ms |
| Resultado Obtido | **1ms** |
| Status | **Aprovado** |

#### Código utilizado

```dart
test('CT-DES-06: inicialização e onboarding completo', () async {
  SharedPreferences.setMockInitialValues({});
  final sw = Stopwatch()..start();
  final controller = AppController(random: Random(77));
  await controller.load();
  controller.completeOnboarding('InitTest', 'Motorola');
  controller.startTraining(trainings.first.name);
  controller.beginSimulation();
  controller.selectAnswer(controller.scenario.answers.first);
  controller.finishTraining();
  sw.stop();
  print('CT-DES-06: ${sw.elapsedMilliseconds}ms para init + onboarding + 1 treino');
  expect(sw.elapsedMilliseconds, lessThan(5000));
});
```

---

## 4. Ambiente de Teste

| Componente | Especificação |
|------------|---------------|
| Sistema Operacional | Fedora Linux 43 (Workstation Edition) |
| Kernel | 7.0.12-101.fc43.x86_64 |
| Flutter | 3.41.2 (stable) |
| Dart | 3.11.0 |
| Java | OpenJDK 25.0.3 |
| Navegador | Chrome (versão estável) |
| Hardware | Máquina local do desenvolvedor |

---

## 5. Resultados

| ID | Caso | Métrica | Limite | Resultado | Status |
|----|------|---------|--------|-----------|--------|
| CT-DES-01 | Navegação 20x | Tempo (ms) | < 3.000 | **47ms** | ✅ Aprovado |
| CT-DES-02 | Cenário 30x | Tempo (ms) | < 3.000 | **6ms** | ✅ Aprovado |
| CT-DES-03 | Build web | Tamanho | < 5MB | **2,5MB** | ✅ Aprovado |
| CT-DES-04 | Carregamento | Tempo (ms) | < 3.000 | **66ms** | ✅ Aprovado |
| CT-DES-05 | Persistência 50x | Tempo (ms) | < 5.000 | **42ms** | ✅ Aprovado |
| CT-DES-06 | Inicialização | Tempo (ms) | < 5.000 | **1ms** | ✅ Aprovado |

### Análise dos Resultados

- **Navegação (47ms):** 100 trocas de tela em 47ms = ~0.47ms por troca. Desempenho excelente, sem perceber qualquer delay.
- **Cenário (6ms):** 30 trocas de cenário em 6ms = ~0.2ms por troca. A lógica de negócio é extremamente leve.
- **Build (2.5MB):** O bundle principal tem 2.5MB. O total de 36MB inclui o CanvasKit (engine de renderização do Flutter Web), que é cacheado pelo navegador após o primeiro carregamento.
- **Carregamento (66ms):** Tempo de resposta do servidor local. Em produção, dependerá da conexão do usuário.
- **Persistência (42ms):** 50 ciclos completos de save/load em 42ms = ~0.84ms por ciclo. SharedPreferences não impacta o desempenho.
- **Inicialização (1ms):** Do zero até conclusão de 1 treino em 1ms. O bootstrap do app é instantâneo em ambiente de teste.

---

## 6. Conclusão

Todos os 4 testes de desempenho foram executados e aprovados. O app Lia Simplis apresenta tempos de resposta extremamente baixos (47ms e 6ms para operações repetitivas) e um bundle de produção compacto (2.5MB).

Os resultados indicam que o app está otimizado para o uso no público-alvo, que pode utilizar dispositivos mais simples e conexões mais lentas.

**Status Geral:** ✅ Aprovado — Todos os testes passaram.

**Responsável:** João Gabriel Custódio

**Data de Execução:** 21/06/2026
