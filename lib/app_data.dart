import 'models.dart';

const deviceBrands = ['Detectado', 'Samsung', 'Motorola', 'Xiaomi', 'iPhone'];

const trainings = <Training>[
  Training(
    name: 'Mensagem suspeita',
    subtitle: 'Golpes por SMS ou aplicativo',
    minutes: '5 min',
    tag: 'Recomendado',
    scenarios: [
      Scenario(
        id: 'msg-1',
        sender: 'SMS desconhecido',
        title: 'Conta bloqueada',
        message:
            'Seu acesso bancário foi bloqueado. Clique para resolver agora.',
        link: 'bit.ly/ajuda-banco',
        clue: 'Pressa + link encurtado',
        safeAction: 'Não clicar no link.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Abrir app oficial'),
          ScenarioAnswer(AnswerType.help, 'Perguntar antes'),
          ScenarioAnswer(AnswerType.risky, 'Tocar no link'),
        ],
      ),
      Scenario(
        id: 'msg-2',
        sender: 'Número estranho',
        title: 'Prêmio falso',
        message: 'Você ganhou um prêmio. Envie seus dados para receber hoje.',
        link: 'premio-agora.info',
        clue: 'Promessa boa demais',
        safeAction: 'Não enviar dados.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Apagar mensagem'),
          ScenarioAnswer(AnswerType.help, 'Mostrar para alguém'),
          ScenarioAnswer(AnswerType.risky, 'Enviar CPF'),
        ],
      ),
      Scenario(
        id: 'msg-3',
        sender: 'Entrega urgente',
        title: 'Taxa de entrega',
        message:
            'Sua entrega está parada. Pague uma pequena taxa para liberar.',
        link: 'taxa-entrega.net',
        clue: 'Cobrança inesperada',
        safeAction: 'Conferir no app oficial.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Ver app da entrega'),
          ScenarioAnswer(AnswerType.help, 'Pedir ajuda'),
          ScenarioAnswer(AnswerType.risky, 'Pagar a taxa'),
        ],
      ),
      Scenario(
        id: 'msg-4',
        sender: 'Suporte falso',
        title: 'Código de verificação',
        message:
            'Informe o código que chegou por SMS para confirmar sua conta.',
        link: 'Sem link',
        clue: 'Pedido de código pessoal',
        safeAction: 'Nunca passar código.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Guardar o código'),
          ScenarioAnswer(AnswerType.help, 'Ligar para suporte real'),
          ScenarioAnswer(AnswerType.risky, 'Mandar o código'),
        ],
      ),
      Scenario(
        id: 'msg-5',
        sender: 'Contato novo',
        title: 'Pedido de dinheiro',
        message: 'Oi, troquei de número. Preciso de uma transferência urgente.',
        link: 'Sem link',
        clue: 'Urgência + número novo',
        safeAction: 'Ligar para confirmar.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Ligar para a pessoa'),
          ScenarioAnswer(AnswerType.help, 'Chamar familiar'),
          ScenarioAnswer(AnswerType.risky, 'Transferir agora'),
        ],
      ),
      Scenario(
        id: 'msg-6',
        sender: 'Promoção',
        title: 'Cadastro suspeito',
        message: 'Atualize seus dados para não perder o benefício.',
        link: 'beneficio-seguro.online',
        clue: 'Ameaça de perder benefício',
        safeAction: 'Procurar canal oficial.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Buscar site oficial'),
          ScenarioAnswer(AnswerType.help, 'Pedir confirmação'),
          ScenarioAnswer(AnswerType.risky, 'Atualizar no link'),
        ],
      ),
      Scenario(
        id: 'msg-7',
        sender: 'Loja desconhecida',
        title: 'Cupom exagerado',
        message:
            'Cupom de 90% só hoje. Preencha cadastro e cartão para reservar.',
        link: 'oferta-relampago.shop',
        clue: 'Desconto alto + pedido de cartão',
        safeAction: 'Conferir a loja fora do link recebido.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Pesquisar a loja'),
          ScenarioAnswer(AnswerType.help, 'Perguntar antes'),
          ScenarioAnswer(AnswerType.risky, 'Cadastrar cartão'),
        ],
      ),
      Scenario(
        id: 'msg-8',
        sender: 'Contato com áudio',
        title: 'Voz suspeita',
        message: 'Recebi um áudio curto pedindo segredo e dinheiro urgente.',
        link: 'Sem link',
        clue: 'Pedido de segredo + urgência',
        safeAction: 'Confirmar por ligação ou vídeo antes de agir.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Fazer chamada de vídeo'),
          ScenarioAnswer(AnswerType.help, 'Avisar a família'),
          ScenarioAnswer(AnswerType.risky, 'Mandar dinheiro'),
        ],
      ),
      Scenario(
        id: 'msg-9',
        sender: 'QR Code recebido',
        title: 'QR Code falso',
        message:
            'Escaneie este QR Code para evitar o cancelamento da sua conta.',
        link: 'Imagem com QR Code',
        clue: 'Ameaça + código desconhecido',
        safeAction: 'Não escanear código enviado por desconhecido.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Ignorar o QR Code'),
          ScenarioAnswer(AnswerType.help, 'Conferir com suporte'),
          ScenarioAnswer(AnswerType.risky, 'Escanear código'),
        ],
      ),
    ],
  ),
  Training(
    name: 'Transferência instantânea',
    subtitle: 'Treino sem dinheiro real',
    minutes: '3 min',
    tag: 'Importante',
    scenarios: [
      Scenario(
        id: 'pix-1',
        sender: 'Tela de treino',
        title: 'Chave desconhecida',
        message: 'A chave de pagamento não parece ser da pessoa combinada.',
        link: 'treino sem dinheiro real',
        clue: 'Nome diferente do combinado',
        safeAction: 'Conferir antes de confirmar.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Revisar nome'),
          ScenarioAnswer(AnswerType.help, 'Confirmar por ligação'),
          ScenarioAnswer(AnswerType.risky, 'Confirmar mesmo assim'),
        ],
      ),
      Scenario(
        id: 'pix-2',
        sender: 'Tela de treino',
        title: 'Valor alterado',
        message: 'O valor ficou maior do que o combinado na conversa.',
        link: 'treino sem dinheiro real',
        clue: 'Valor divergente',
        safeAction: 'Parar e revisar.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Corrigir valor'),
          ScenarioAnswer(AnswerType.help, 'Perguntar de novo'),
          ScenarioAnswer(AnswerType.risky, 'Pagar valor maior'),
        ],
      ),
      Scenario(
        id: 'pix-3',
        sender: 'Tela de treino',
        title: 'Pedido com pressa',
        message: 'A pessoa insiste para pagar agora sem conferir os dados.',
        link: 'treino sem dinheiro real',
        clue: 'Pressão para agir rápido',
        safeAction: 'Pedir ajuda ou confirmar.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Parar a operação'),
          ScenarioAnswer(AnswerType.help, 'Pedir ajuda'),
          ScenarioAnswer(AnswerType.risky, 'Pagar com pressa'),
        ],
      ),
      Scenario(
        id: 'pix-4',
        sender: 'Tela de treino',
        title: 'Comprovante falso',
        message:
            'A pessoa mandou um comprovante por imagem e pediu devolução de valor.',
        link: 'treino sem dinheiro real',
        clue: 'Comprovante fora do app',
        safeAction: 'Conferir o saldo no aplicativo antes de devolver.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Ver saldo no app'),
          ScenarioAnswer(AnswerType.help, 'Chamar banco'),
          ScenarioAnswer(AnswerType.risky, 'Devolver rápido'),
        ],
      ),
      Scenario(
        id: 'pix-5',
        sender: 'Tela de treino',
        title: 'QR Code de cobrança',
        message: 'O QR Code mostra um recebedor diferente da loja combinada.',
        link: 'treino sem dinheiro real',
        clue: 'Recebedor diferente',
        safeAction: 'Cancelar e pedir outro meio oficial de pagamento.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Cancelar pagamento'),
          ScenarioAnswer(AnswerType.help, 'Falar com a loja'),
          ScenarioAnswer(AnswerType.risky, 'Pagar o QR Code'),
        ],
      ),
      Scenario(
        id: 'pix-6',
        sender: 'Tela de treino',
        title: 'Agendamento estranho',
        message:
            'O pagamento aparece agendado para outra data, mas a pessoa diz que já caiu.',
        link: 'treino sem dinheiro real',
        clue: 'Data diferente + pressão',
        safeAction: 'Conferir status no app e não enviar novo valor.',
        answers: [
          ScenarioAnswer(AnswerType.safe, 'Ver status no app'),
          ScenarioAnswer(AnswerType.help, 'Pedir orientação'),
          ScenarioAnswer(AnswerType.risky, 'Enviar de novo'),
        ],
      ),
    ],
  ),
];

const dictionaryTerms = <DictionaryTerm>[
  DictionaryTerm(
    key: 'link',
    title: 'Link',
    description: 'Um caminho que abre uma página, foto, vídeo ou aplicativo.',
    example: 'Geralmente aparece azul, sublinhado ou dentro de um botão.',
    alert: 'Cuidado com links enviados por desconhecidos.',
  ),
  DictionaryTerm(
    key: 'golpe',
    title: 'Golpe',
    description:
        'Uma tentativa de enganar alguém para roubar dados ou dinheiro.',
    example: 'Pode aparecer como mensagem urgente, prêmio ou falsa cobrança.',
    alert: 'Desconfie de pressa, ameaça e pedido de senha.',
  ),
  DictionaryTerm(
    key: 'senha',
    title: 'Senha',
    description: 'Uma chave pessoal usada para entrar em contas e aplicativos.',
    example: 'Ela deve ser guardada como segredo.',
    alert: 'Nunca envie senha por mensagem.',
  ),
  DictionaryTerm(
    key: 'wifi',
    title: 'Wi-Fi',
    description:
        'Internet sem fio usada pelo celular dentro de casa ou lugares públicos.',
    example: 'O símbolo costuma aparecer no topo da tela.',
    alert: 'Evite redes desconhecidas para acessar banco.',
  ),
  DictionaryTerm(
    key: 'codigo',
    title: 'Código',
    description: 'Números enviados para confirmar que é você usando a conta.',
    example: 'Pode chegar por SMS ou aplicativo.',
    alert: 'Não passe esse código para outras pessoas.',
  ),
];

const deviceHelpItems = <DeviceHelp>[
  DeviceHelp(
    key: 'internet',
    title: 'Estou sem internet',
    visual: 'Painel rápido com o botão Wi-Fi destacado.',
    steps: {
      'Samsung': [
        'Abra o painel rápido.',
        'Toque em Wi-Fi.',
        'Escolha sua rede de casa.',
      ],
      'Motorola': [
        'Puxe a tela de cima para baixo.',
        'Segure Wi-Fi.',
        'Conecte na rede conhecida.',
      ],
      'Xiaomi': [
        'Abra a Central de controle.',
        'Ative Wi-Fi.',
        'Confira se os dados móveis estão ligados.',
      ],
      'iPhone': [
        'Abra a Central de Controle.',
        'Toque no ícone Wi-Fi.',
        'Confira se há sinal.',
      ],
      'Detectado': [
        'Abra os atalhos rápidos.',
        'Confira Wi-Fi e dados móveis.',
        'Tente abrir um site simples.',
      ],
    },
  ),
  DeviceHelp(
    key: 'sound',
    title: 'Celular sem som',
    visual: 'Controle de volume com barra de som visível.',
    steps: {
      'Samsung': [
        'Aperte volume para cima.',
        'Toque nos três pontos.',
        'Aumente mídia e toque.',
      ],
      'Motorola': [
        'Aperte o botão de volume.',
        'Desative o modo silencioso.',
        'Teste uma música.',
      ],
      'Xiaomi': [
        'Aperte volume para cima.',
        'Abra controles de som.',
        'Confira se não está no silencioso.',
      ],
      'iPhone': [
        'Confira a chave lateral.',
        'Aumente o volume.',
        'Teste um vídeo curto.',
      ],
      'Detectado': [
        'Aperte volume para cima.',
        'Confira modo silencioso.',
        'Teste o áudio.',
      ],
    },
  ),
  DeviceHelp(
    key: 'brightness',
    title: 'Tela muito escura',
    visual: 'Barra de brilho no centro da tela.',
    steps: {
      'Samsung': [
        'Abra o painel rápido.',
        'Arraste a barra de brilho.',
        'Desative brilho extra baixo.',
      ],
      'Motorola': [
        'Puxe os atalhos rápidos.',
        'Aumente a barra de brilho.',
        'Confira brilho adaptável.',
      ],
      'Xiaomi': [
        'Abra a Central de controle.',
        'Aumente o brilho.',
        'Desative modo escuro se precisar.',
      ],
      'iPhone': [
        'Abra a Central de Controle.',
        'Arraste o brilho para cima.',
        'Confira modo baixo consumo.',
      ],
      'Detectado': [
        'Abra os atalhos rápidos.',
        'Aumente o brilho.',
        'Procure modo economia.',
      ],
    },
  ),
  DeviceHelp(
    key: 'app',
    title: 'Aplicativo travou',
    visual: 'Lista de apps recentes com um app sendo fechado.',
    steps: {
      'Samsung': [
        'Abra apps recentes.',
        'Feche o app travado.',
        'Abra novamente.',
      ],
      'Motorola': [
        'Toque no botão de apps recentes.',
        'Arraste o app para cima.',
        'Abra de novo.',
      ],
      'Xiaomi': [
        'Abra apps recentes.',
        'Feche o app.',
        'Se continuar, reinicie o celular.',
      ],
      'iPhone': [
        'Abra a troca de apps.',
        'Deslize o app para cima.',
        'Abra novamente.',
      ],
      'Detectado': [
        'Feche o aplicativo.',
        'Abra novamente.',
        'Reinicie se continuar travado.',
      ],
    },
  ),
];

Training trainingByName(String name) => trainings.firstWhere(
  (item) => item.name == name,
  orElse: () => trainings.first,
);
DictionaryTerm termByKey(String key) => dictionaryTerms.firstWhere(
  (item) => item.key == key,
  orElse: () => dictionaryTerms.first,
);
DeviceHelp helpByKey(String key) => deviceHelpItems.firstWhere(
  (item) => item.key == key,
  orElse: () => deviceHelpItems.first,
);
