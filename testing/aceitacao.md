# LIA SIMPLIS

## Documentação de Teste de Aceitação

| Campo | Informação |
|-------|------------|
| Projeto | Lia Simplis — App Mobile Flutter |
| Tipo de Teste | Aceitação |
| Disciplina | Teste e Qualidade de Software |
| Instituição | Univel — Centro Universitário |
| Plataforma | Flutter (Web / Android) |
| Data | 21/06/2026 |

---

## 1. Introdução

O Lia Simplis é um aplicativo mobile educacional desenvolvido em Flutter voltado para ensinar adultos e idosos a identificar e se proteger de golpes digitais — como phishing, links maliciosos e mensagens suspeitas.

Este documento descreve o planejamento e a execução dos testes de aceitação do app, cujo objetivo é validar que as funcionalidades atendem aos requisitos do ponto de vista do usuário final, garantindo que o app está pronto para uso.

### 1.1 Objetivos

| Objetivo |
|----------|
| Validar que o onboarding coleta nome e marca do celular corretamente |
| Confirmar que o fluxo de treino é compreensível e funcional do início ao fim |
| Verificar que a tela Ajuda exibe conteúdo útil e correto por marca |
| Garantir que dados do usuário persistem entre sessões |
| Avaliar se a navegação principal é intuitiva e completa |
| Confirmar que o feedback educativo é claro e acolhedor |

### 1.2 Escopo

Os testes cobrem as seguintes funcionalidades:

| Funcionalidade | O que é testado |
|----------------|-----------------|
| Onboarding | Coleta de nome e marca, validação de nome vazio |
| Home | Saudação personalizada, cards de acesso rápido |
| Treino | Fluxo completo de 6 etapas (intro → simulação → feedback → palavra → reforço → conclusão) |
| Ajuda | Como ligar, problemas por marca, perguntas frequentes |
| Dicionário | Alternância de termos, favoritos |
| Salvos | Persistência de itens entre sessões |
| Navegação | Bottom nav com 5 abas funcionando |
| Voz | TTS lê a tela atual |

---

## 2. Estratégia de Teste

### 2.1 Tipo de Teste

Teste de Aceitação: valida se o app atende às expectativas do usuário final. Diferente dos testes de integração (que validam componentes técnicos), o teste de aceitação foca na experiência do usuário e na conformidade com os requisitos funcionais.

### 2.2 Ferramentas

| Ferramenta | Finalidade |
|------------|------------|
| Navegador Chrome | Ambiente de execução do app web |
| Flutter web-server | Servidor local para acessar o app |
| Checklist de critérios | Lista de verificação manual |
| Gravação de tela | Registro visual da execução |

### 2.3 Abordagem

| Aspecto | Decisão |
|---------|---------|
| Execução | Manual, com roteiro guiado |
| Participantes | 3 a 5 pessoas do público-alvo |
| Duração | 25 a 35 minutos por participante |
| Registro | Tela, áudio/comentários e tempo de execução |
| Critério de aprovação | 80% dos participantes concluem sem ajuda |

---

## 3. Critérios de Aceite

| ID | Critério | Meta |
|----|----------|------|
| CA-01 | Onboarding coleta nome e marca | 100% dos participantes concluem |
| CA-02 | Home exibe nome do usuário | Correto após onboarding |
| CA-03 | Treino percorre 6 etapas | 80% concluem sem ajuda |
| CA-04 | Feedback correto/errado é compreensível | 80% entendem a mensagem |
| CA-05 | Ajuda mostra passos por marca | Conteúdo varia conforme dispositivo |
| CA-06 | FAQ expande e recolhe | Todas as perguntas funcionam |
| CA-07 | Dicionário alterna termos | 5 termos acessíveis |
| CA-08 | Salvos persistem entre sessões | Dados mantidos após recarregar |
| CA-09 | Bottom nav navega corretamente | 5 abas funcionam |
| CA-10 | Nenhum texto essencial cortado | Em 150% de zoom |

---

## 4. Casos de Teste

### CT-ACE-01 — Onboarding completo

| Campo | Informação |
|-------|------------|
| Identificador | CT-ACE-01 |
| Título | Onboarding coleta nome e marca do celular |
| Objetivo | Validar que o usuário consegue preencher nome, escolher marca e iniciar o app |
| Pré-condições | Primeira execução (SharedPreferences vazio) |
| Dados de Entrada | Nome: 'Maria' / Marca: 'Samsung' |
| Passos | 1. Abrir o app / 2. Verificar tela de boas-vindas / 3. Inserir nome / 4. Selecionar marca / 5. Tocar em 'Começar' |
| Resultado Esperado | HomeScreen exibe 'Olá, Maria!'. Onboarding não aparece novamente. |
| Resultado Obtido | — |
| Status | Pendente |

### CT-ACE-02 — Fluxo de treino com resposta segura

| Campo | Informação |
|-------|------------|
| Identificador | CT-ACE-02 |
| Título | Treino completo com resposta correta |
| Objetivo | Validar o caminho feliz do treino: intro → simulação → feedback positivo |
| Pré-condições | Usuário autenticado, na HomeScreen |
| Dados de Entrada | Treino: 'Mensagem suspeita' / Resposta: safe |
| Passos | 1. Tocar em 'Começar treino' / 2. Selecionar 'Mensagem suspeita' / 3. Tocar em 'Começar' / 4. Ler cenário / 5. Escolher resposta segura / 6. Verificar feedback |
| Resultado Esperado | 'Muito bem! Você escolheu o caminho mais seguro.' exibido. Checklist de 4 itens visível. |
| Resultado Obtido | — |
| Status | Pendente |

### CT-ACE-03 — Resposta errada e tentar novamente

| Campo | Informação |
|-------|------------|
| Identificador | CT-ACE-03 |
| Título | Resposta arriscada exibe feedback de erro e permite retry |
| Objetivo | Validar o fluxo alternativo: resposta errada → feedback → tentar novamente |
| Pré-condições | Usuário em SimulationScreen |
| Dados de Entrada | Resposta do tipo risky |
| Passos | 1. Escolher resposta arriscada / 2. Verificar feedback vermelho / 3. Ler explicação / 4. Tocar em 'Tentar de novo' / 5. Verificar novo cenário |
| Resultado Esperado | FeedbackWrongScreen exibida. Após retry, SimulationScreen com cenário diferente. |
| Resultado Obtido | — |
| Status | Pendente |

### CT-ACE-04 — Ajuda com problemas por marca

| Campo | Informação |
|-------|------------|
| Identificador | CT-ACE-04 |
| Título | Ajuda exibe passos corretos conforme marca do celular |
| Objetivo | Validar que a tela Ajuda mostra instruções específicas para cada marca |
| Pré-condições | Usuário autenticado, marca 'Samsung' |
| Dados de Entrada | Problema: 'Estou sem internet' |
| Passos | 1. Ir em Ajuda / 2. Verificar seção 'Como ligar' / 3. Selecionar 'Estou sem internet' / 4. Verificar passos para Samsung / 5. Ver guia visual |
| Resultado Esperado | Passos específicos para Samsung exibidos. Guia visual aparece/oculta ao tocar. |
| Resultado Obtido | — |
| Status | Pendente |

### CT-ACE-05 — FAQ expande e recolhe

| Campo | Informação |
|-------|------------|
| Identificador | CT-ACE-05 |
| Título | Perguntas frequentes expandem e recolhem ao toque |
| Objetivo | Validar que todas as FAQs funcionam e exibem respostas corretas |
| Pré-condições | Usuário na tela Ajuda, seção FAQ |
| Dados de Entrada | Nenhuma. Apenas toques nas perguntas. |
| Passos | 1. Rolar até 'PERGUNTAS FREQUENTES' / 2. Tocar na primeira pergunta / 3. Verificar resposta / 4. Tocar novamente para recolher / 5. Repetir para todas as 6 perguntas |
| Resultado Esperado | Cada pergunta expande mostrando resposta e recolhe ao tocar novamente. |
| Resultado Obtido | — |
| Status | Pendente |

### CT-ACE-06 — Persistência entre sessões

| Campo | Informação |
|-------|------------|
| Identificador | CT-ACE-06 |
| Título | Dados do usuário persistem após recarregar o app |
| Objetivo | Validar que nome, favoritos e progresso são mantidos entre sessões |
| Pré-condições | Usuário completou onboarding, favoritou termo, fez pelo menos 1 treino |
| Dados de Entrada | Estado persistido |
| Passos | 1. Completar onboarding / 2. Favoritar termo 'Link' no Dicionário / 3. Completar 1 treino / 4. Recarregar a página / 5. Verificar nome na Home / 6. Verificar favorito em Salvos / 7. Verificar progresso |
| Resultado Esperado | 'Olá, {nome}!' na Home. Termo 'Link' em Salvos. Progresso mantido. Onboarding não reaparece. |
| Resultado Obtido | — |
| Status | Pendente |

---

## 5. Roteiro de Execução com Participantes

**Participantes recomendados:** 3 a 5 pessoas do público-alvo (pessoas com baixa confiança digital).

**Duração estimada:** 25 a 35 minutos por participante.

**Registro:** tela, áudio/comentários e tempo de execução das tarefas, mediante consentimento.

### Passos

1. Apresentar o aplicativo sem explicar os botões e solicitar que o participante pense em voz alta.
2. Pedir que informe nome/apelido, escolha a marca do celular e explique com suas próprias palavras o significado do aviso de segurança.
3. Solicitar que encontre e inicie o treino "Mensagem Suspeita".
4. Pedir que responda um cenário e explique por que escolheu determinada opção.
5. Solicitar que utilize o dicionário para pesquisar o termo "Link" e o salve.
6. Pedir que localize os itens salvos.
7. Solicitar que encontre ajuda para o problema "Estou sem internet" e visualize/oculte o guia.
8. Ativar texto ampliado e repetir uma navegação curta.
9. Pedir que utilize leitura em voz alta ou comando de voz, incluindo um cenário sem permissão de microfone.
10. Fechar e reabrir o aplicativo para verificar persistência de nome, favoritos, progresso e itens salvos.

---

## 6. Resultados

| ID | Caso | Resultado | Status |
|----|------|-----------|--------|
| CT-ACE-01 | Onboarding completo | — | Pendente |
| CT-ACE-02 | Treino resposta segura | — | Pendente |
| CT-ACE-03 | Resposta errada + retry | — | Pendente |
| CT-ACE-04 | Ajuda por marca | — | Pendente |
| CT-ACE-05 | FAQ expande/recolhe | — | Pendente |
| CT-ACE-06 | Persistência | — | Pendente |

---

## 7. Conclusão

O documento de teste de aceitação cobre as principais funcionalidades do app Lia Simplis do ponto de vista do usuário. A execução com participantes reais fornecerá evidências concretas sobre a qualidade e usabilidade do aplicativo.

**Status Geral:** Pendente de execução.
