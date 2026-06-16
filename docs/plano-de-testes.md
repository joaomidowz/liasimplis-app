# Plano de Testes de Software - LiaSimplis Flutter

> Documento preparado para posterior formatação em PDF com fonte Arial, tamanho 14, conforme o enunciado da atividade.

## Capa

**Instituição:** [preencher]  
**Disciplina:** Teste e Qualidade de Software  
**Projeto:** LiaSimplis Flutter  
**Equipe:** [preencher nomes]  
**Professor(a):** [preencher]  
**Data:** junho de 2026

## 1. Introdução

O LiaSimplis é um aplicativo educacional de inclusão digital. Ele oferece treinos fictícios e seguros sobre mensagens suspeitas e transferências instantâneas, além de dicionário digital e orientações para problemas comuns de celular.

O protótipo original foi desenvolvido em HTML, CSS e JavaScript. Esta etapa converteu o produto para Flutter, preservando os requisitos existentes e preparando testes automatizados e manuais para verificar qualidade, desempenho, usabilidade, compatibilidade e aceitação.

### 1.1 Objetivos

- Verificar a paridade funcional entre o protótipo HTML e o aplicativo Flutter.
- Validar regras de progresso, favoritos, cenários e persistência.
- Confirmar a integração entre estado, dados locais e interface.
- Avaliar desempenho em navegação e troca de cenários.
- Verificar usabilidade e acessibilidade para pessoas com baixa confiança digital.
- Avaliar compatibilidade em diferentes telas e ambientes.
- Confirmar os critérios de aceitação definidos para o produto.

### 1.2 Escopo

Serão testados:

- onboarding e preferências de acessibilidade;
- Home, navegação e continuidade;
- dois treinos e 15 cenários;
- respostas e resultado educativo;
- dicionário, favoritos e persistência;
- ajuda por problema e marca;
- síntese e comando de voz;
- comportamento em Android e Web;
- tempo de resposta, memória e estabilidade.

Não fazem parte deste escopo: backend, login, banco remoto, painel administrativo, notificações e relatórios para cuidadores.

## 2. Requisitos a serem testados

| ID | Requisito | Tipo principal |
|---|---|---|
| RF-001 | Iniciar sem dados na tela de apresentação. | Sistema |
| RF-002 | Salvar nome e exibi-lo na Home. | Integração |
| RF-003 | Permitir escolher marca do celular. | Funcional |
| RF-004 | Aplicar quatro tamanhos de texto. | Usabilidade |
| RF-005 | Persistir preferências, progresso e favoritos. | Integração |
| RF-006 | Navegar entre Início, Treinos, Ajuda, Dicionário e Salvos. | Sistema |
| RF-007 | Disponibilizar dois treinos e 15 cenários. | Unitário |
| RF-008 | Classificar respostas como segura, ajuda ou arriscada. | Unitário |
| RF-009 | Atualizar progresso conforme a resposta. | Unitário |
| RF-010 | Exibir resultado e ação segura do cenário. | Sistema |
| RF-011 | Disponibilizar cinco termos no dicionário. | Unitário |
| RF-012 | Favoritar e desfavoritar sem duplicação. | Unitário/Integração |
| RF-013 | Exibir quatro problemas de celular por marca. | Sistema |
| RF-014 | Oferecer leitura e comando de voz com fallback. | Compatibilidade |
| RNF-001 | Responder sem atraso perceptível. | Desempenho |
| RNF-002 | Permanecer utilizável com fonte em 150% e 200%. | Usabilidade |
| RNF-003 | Não executar ação real durante os treinos. | Aceitação |

## 3. Estratégias

### 3.1 Teste unitário

Testa dados e regras sem abrir o aplicativo completo. São verificados inventário de conteúdo, tipos de resposta, progresso, favoritos, persistência e seleção de cenário.

### 3.2 Teste de integração

Testa a comunicação entre controlador, armazenamento local e telas. O fluxo automatizado cobre início, preferências, Home, treino, simulação e resultado.

### 3.3 Teste de sistema

Valida o aplicativo completo em Android ou Web, incluindo navegação, persistência, voz, acessibilidade e comportamento após reiniciar.

#### 3.3.1 Desempenho

Serão medidos abertura fria, navegação repetida, troca de cenário, quadros lentos e memória. A execução deve ocorrer em modo `profile` em aparelho Android.

Critérios propostos:

- nenhuma exceção ou travamento;
- resposta visual sem atraso perceptível;
- 30 trocas de cenário em menos de três segundos no teste automatizado;
- ausência de crescimento contínuo de memória após navegação repetida;
- interface estável com fonte em 200%.

#### 3.3.2 Usabilidade

Um usuário representativo deve concluir onboarding, treino, dicionário e ajuda com pouca ou nenhuma orientação. Devem ser observadas hesitações, entendimento do aviso de segurança, clareza dos botões e compreensão do resultado.

#### 3.3.3 Compatibilidade

Serão testados Chrome, Android físico ou emulador, larguras próximas de 360, 390 e 412 pixels, escalas de fonte padrão/150%/200%, ausência de microfone e execução sem internet após instalação.

### 3.4 Teste de aceitação

O aplicativo será aceito quando o fluxo principal puder ser concluído sem erro, os 15 cenários estiverem disponíveis, progresso e favoritos persistirem, nenhum treino executar ação real e as telas permanecerem compreensíveis com texto grande.

### 3.5 Ferramentas

| Ferramenta | Uso |
|---|---|
| Flutter Test | Testes unitários e de widget. |
| Integration Test | Fluxos completos e medição de navegação. |
| Flutter Analyze | Análise estática. |
| Flutter DevTools | Timeline, quadros e memória. |
| Shared Preferences Mock | Testar persistência isolada. |
| Android Studio/ADB | Executar em aparelho ou emulador. |
| Captura de tela/vídeo | Evidências manuais. |

## 4. Equipe, recursos e infraestrutura

| Papel | Responsável | Responsabilidade |
|---|---|---|
| Coordenação | [preencher] | Aprovar escopo e aceite. |
| Desenvolvimento Flutter | João Gabriel / equipe | Implementar e corrigir o aplicativo. |
| QA | [preencher] | Executar testes e registrar evidências. |
| Usuário avaliador | [preencher] | Participar do teste de usabilidade. |

Recursos necessários: computador com Flutter 3.41.2 ou compatível, Dart 3.11 ou compatível, Chrome, aparelho Android ou emulador, cabo USB e acesso ao Flutter DevTools.

## 5. Cronograma

| Tarefa | Responsável | Início | Término previsto | Término real |
|---|---|---|---|---|
| Análise do protótipo e requisitos | Desenvolvimento | 09/06/2026 | 10/06/2026 | 10/06/2026 |
| Migração para Flutter | Desenvolvimento | 10/06/2026 | 18/06/2026 | 10/06/2026 |
| Preparação dos testes automatizados | Desenvolvimento/QA | 10/06/2026 | 20/06/2026 | 10/06/2026 |
| Execução em Android e coleta de desempenho | QA | [preencher] | 22/06/2026 | Pendente |
| Entrega para pré-correção | Equipe | 23/06/2026 | 23/06/2026 | Pendente |
| Ajustes após pré-correção | Equipe | 24/06/2026 | 29/06/2026 | Pendente |
| Entrega final | Equipe | 30/06/2026 | 30/06/2026 | Pendente |

## 6. Casos de teste

### CT-UNIT-001 - Validar inventário de conteúdo

- **Objetivo:** confirmar a presença de dois treinos, 15 cenários, cinco termos e quatro problemas.
- **Pré-condições:** dependências instaladas.
- **Entrada:** dados de `app_data.dart`.
- **Passos:** executar `flutter test test/app_controller_test.dart`.
- **Resultado esperado:** todas as contagens e tipos são válidos.
- **Resultado obtido:** aprovado em 10/06/2026.
- **Status:** Aprovado.
- **Responsável:** desenvolvimento.

### CT-INT-001 - Fluxo principal

- **Objetivo:** validar a integração do onboarding até o resultado.
- **Pré-condições:** armazenamento simulado vazio.
- **Entrada:** nome `Maria` e resposta segura.
- **Passos:** iniciar, ajustar preferências, abrir treino, iniciar simulação e responder.
- **Resultado esperado:** exibir `Boa escolha` e progresso igual a um.
- **Resultado obtido:** aprovado em 10/06/2026.
- **Status:** Aprovado.
- **Responsável:** desenvolvimento.

### CT-SIS-001 - Persistência após reiniciar

- **Objetivo:** verificar nome, preferências, progresso e favoritos.
- **Pré-condições:** aplicativo instalado.
- **Dados:** nome e termo favorito definidos pelo executor.
- **Passos:** usar o app, fechar completamente e abrir novamente.
- **Resultado esperado:** dados permanecem disponíveis.
- **Resultado obtido:** Pendente.
- **Status:** Não executado.
- **Responsável:** [preencher].

### CT-DES-001 - Navegação repetida

- **Objetivo:** medir estabilidade e resposta entre telas.
- **Pré-condições:** aparelho Android e execução em modo `profile`.
- **Passos:** executar `performance_test.dart` e alternar 20 vezes entre Início, Treinos e Ajuda.
- **Resultado esperado:** sem travamento, exceção ou atraso perceptível.
- **Resultado obtido:** Pendente.
- **Status:** Não executado.
- **Responsável:** [preencher].

### CT-DES-002 - Troca de cenário

- **Objetivo:** verificar 30 mudanças consecutivas de cenário.
- **Pré-condições:** teste de integração configurado.
- **Passos:** executar o segundo caso de `performance_test.dart`.
- **Resultado esperado:** concluir em menos de três segundos e sem exceção.
- **Resultado obtido:** Pendente.
- **Status:** Não executado.
- **Responsável:** [preencher].

### CT-USA-001 - Uso com texto em 200%

- **Objetivo:** verificar leitura, rolagem e controles com fonte ampliada.
- **Pré-condições:** Android configurado com fonte em 200%.
- **Passos:** percorrer todas as telas principais.
- **Resultado esperado:** nenhum texto essencial cortado e todos os botões acessíveis.
- **Resultado obtido:** Pendente.
- **Status:** Não executado.
- **Responsável:** [preencher].

### CT-COMP-001 - Voz sem permissão

- **Objetivo:** verificar o fallback do comando de voz.
- **Pré-condições:** permissão de microfone negada.
- **Passos:** tocar no botão de microfone.
- **Resultado esperado:** mensagem de indisponibilidade sem encerramento do app.
- **Resultado obtido:** Pendente.
- **Status:** Não executado.
- **Responsável:** [preencher].

### CT-ACE-001 - Aceitação do fluxo educativo

- **Objetivo:** confirmar que um usuário entende que a simulação é fictícia e aprende a ação segura.
- **Pré-condições:** participante representativo e termo de consentimento, se aplicável.
- **Passos:** pedir que conclua um treino sem instrução detalhada e explique o que aprendeu.
- **Resultado esperado:** concluir o fluxo, reconhecer que nada real ocorre e repetir a ação segura.
- **Resultado obtido:** Pendente.
- **Status:** Não executado.
- **Responsável:** [preencher].

## Anexo A - Matriz de validação

| Caso | Data | Ambiente | Esperado | Obtido | Status | Evidência |
|---|---|---|---|---|---|---|
| CT-UNIT-001 | 10/06/2026 | Flutter Test | Contagens válidas | 4 testes aprovados | Aprovado | Saída do terminal |
| CT-INT-001 | 10/06/2026 | Flutter Test | Fluxo completo | 1 teste aprovado | Aprovado | Saída do terminal |
| CT-SIS-001 | | | Persistência | | | |
| CT-DES-001 | | | Navegação estável | | | |
| CT-DES-002 | | | Menos de 3 s | | | |
| CT-USA-001 | | | Layout utilizável | | | |
| CT-COMP-001 | | | Fallback visível | | | |
| CT-ACE-001 | | | Usuário conclui e compreende | | | |

## Anexo B - Comandos

```bash
flutter analyze
flutter test --reporter expanded
flutter run --profile -d <ID_DO_DISPOSITIVO>
flutter test integration_test/performance_test.dart -d <ID_DO_DISPOSITIVO>
```
