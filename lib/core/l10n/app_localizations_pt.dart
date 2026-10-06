// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Companheiro GLP-1';

  @override
  String get disclaimer =>
      'Este app é um diário de acompanhamento e não substitui orientação de médico ou nutricionista.';

  @override
  String get errorLoad =>
      'Não foi possível carregar seus dados. Verifique sua conexão e tente novamente.';

  @override
  String get errorSave =>
      'Não foi possível salvar. Verifique sua conexão e tente novamente.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get loginBadge => 'Seu espaço seguro';

  @override
  String get loginSubtitle =>
      'Um apoio diário, acolhedor e sem julgamentos na sua jornada com a medicação.';

  @override
  String get loginEmailLabel => 'Entrar com e-mail';

  @override
  String get loginEmailHint => 'seu@email.com';

  @override
  String get loginSendLink => 'Enviar link de acesso';

  @override
  String get loginLinkSent => 'Enviamos um link de acesso para o seu e-mail.';

  @override
  String get loginOr => 'ou';

  @override
  String get loginApple => 'Continuar com Apple';

  @override
  String get loginGoogle => 'Continuar com Google';

  @override
  String get adjust => 'Ajustar';

  @override
  String get weekdaysShort => 'Seg,Ter,Qua,Qui,Sex,Sáb,Dom';

  @override
  String get medOther => 'Outro';

  @override
  String get proteinReference =>
      'Valor de referência, converse com seu profissional de saúde.';

  @override
  String obStepOf(int n) {
    return 'Etapa $n de 4';
  }

  @override
  String get obContinue => 'Continuar';

  @override
  String get obStart => 'Começar';

  @override
  String get obWelcomeTitle => 'Bem-vindo ao Companheiro GLP-1';

  @override
  String get obPrivacyTitle => 'Privacidade em primeiro lugar';

  @override
  String get obPrivacySubtitle => 'Controle total dos seus registros';

  @override
  String get obPrivacyBody =>
      'Seus dados de saúde são privados e apenas você tem acesso a cada medição e nota registrada.';

  @override
  String get obPrivacy1 => 'Criptografia em repouso e em trânsito';

  @override
  String get obPrivacy2 =>
      'Seus registros nunca são compartilhados ou vendidos';

  @override
  String get obPrivacy3 =>
      'Exclusão da sua conta e de todos os dados a qualquer momento';

  @override
  String get obConsent =>
      'Autorizo o tratamento dos meus dados de saúde (peso, doses, sintomas e alimentação) exclusivamente para o funcionamento deste diário, conforme a LGPD, e reconheço o aviso de saúde acima.';

  @override
  String get obConsentRequired => 'Obrigatório para iniciar o diário';

  @override
  String get obAboutTitle => 'Conte um pouco sobre você';

  @override
  String get obAboutSubtitle =>
      'Essas informações aparecem no seu diário e servem de base para sua meta de proteína.';

  @override
  String get obName => 'Nome ou como quer ser chamado(a)';

  @override
  String get obNameHint => 'Marina';

  @override
  String get obBirthYear => 'Ano de nascimento';

  @override
  String get obHeight => 'Altura';

  @override
  String get obWeight => 'Peso atual';

  @override
  String get obPrivacyNote =>
      'Seus dados de saúde são privados. Você pode editá-los ou excluí-los a qualquer momento no Perfil.';

  @override
  String get obMedTitle => 'Qual é a sua medicação?';

  @override
  String get obMedSubtitle =>
      'O lembrete semanal segue exatamente o dia e o horário que você escolher.';

  @override
  String get obMedLabel => 'Medicação prescrita';

  @override
  String get obDoseLabel => 'Dose (como está na sua receita)';

  @override
  String get obDoseHint => 'Ex: 0,5 mg';

  @override
  String get obDoseHelper => 'Copie da caneta ou da prescrição médica.';

  @override
  String get obWeekdayLabel => 'Dia da aplicação semanal';

  @override
  String get obTimeLabel => 'Horário do lembrete';

  @override
  String get obReminderNote =>
      'Você poderá mudar o dia, o horário e a dose depois, em Doses.';

  @override
  String get obProteinTitle => 'Sua meta de proteína';

  @override
  String get obProteinSubtitle =>
      'Sugerimos como ponto de partida 1,2 g por kg de peso. Ajuste como preferir.';

  @override
  String get obProteinTarget => 'Meta diária';

  @override
  String obProteinRatio(String ratio) {
    return 'Aprox. $ratio g por kg de peso';
  }

  @override
  String get obProteinStep => 'Passo de 5 g';

  @override
  String get obProteinLess => 'Diminuir 5 g';

  @override
  String get obProteinMore => 'Aumentar 5 g';

  @override
  String get tabToday => 'Hoje';

  @override
  String get tabProtein => 'Proteína';

  @override
  String get tabSymptoms => 'Sintomas';

  @override
  String get tabWorkouts => 'Treinos';

  @override
  String get tabProfile => 'Perfil';

  @override
  String homeGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get homeHowAreYou => 'Como você está se sentindo hoje?';

  @override
  String get today => 'Hoje';

  @override
  String get tomorrow => 'Amanhã';

  @override
  String inDays(int n) {
    return 'Em $n dias';
  }

  @override
  String atTime(String day, String time) {
    return '$day, às $time';
  }

  @override
  String get noteOptional => 'Observação (opcional)';

  @override
  String get notifTitle => 'Lembrete da sua aplicação';

  @override
  String notifBody(String medication, String dose) {
    return '$medication · $dose — no dia e horário que você definiu.';
  }

  @override
  String get notifChannel => 'Lembrete de aplicação';

  @override
  String get dosesTitle => 'Rotina de aplicação';

  @override
  String get dosesSubtitle =>
      'Acompanhe seus dias de aplicação e registre cada uma.';

  @override
  String get nextDose => 'Próxima aplicação';

  @override
  String get reminderOff => 'Lembrete desligado';

  @override
  String get reminderConfig => 'Configuração do lembrete';

  @override
  String get reminderExact =>
      'O lembrete toca exatamente no dia e horário escolhidos, toda semana.';

  @override
  String get reminderSaved => 'Lembrete atualizado.';

  @override
  String get doseRegister => 'Registrei a aplicação';

  @override
  String get doseHistory => 'Histórico de aplicações';

  @override
  String get doseHistoryEmpty => 'Nenhuma aplicação registrada ainda.';

  @override
  String get doseSheetTitle => 'Registrar aplicação';

  @override
  String doseSheetNow(String when) {
    return 'Registrada agora: $when';
  }

  @override
  String get doseField => 'Dose (como está na sua receita)';

  @override
  String get doseSite => 'Local da aplicação (opcional)';

  @override
  String get doseNoteHint => 'Ex: sem desconforto';

  @override
  String get doseConfirm => 'Confirmar registro';

  @override
  String get siteAbdomen => 'Abdômen';

  @override
  String get siteThigh => 'Coxa';

  @override
  String get siteArm => 'Braço';

  @override
  String get proteinSubtitle => 'Preservação de massa magra e saciedade';

  @override
  String proteinGoal(String g) {
    return 'Meta $g g';
  }

  @override
  String proteinRemaining(String g) {
    return 'Faltam $g g';
  }

  @override
  String get proteinGoalReached => 'Meta do dia atingida';

  @override
  String proteinOfGoal(String consumed, String goal) {
    return '$consumed g de $goal g';
  }

  @override
  String get proteinWeekly => 'Consistência semanal';

  @override
  String proteinWeeklyAvg(String avg, String goal) {
    return 'Média de $avg g/dia • Meta $goal g';
  }

  @override
  String get proteinFoods => 'Alimentos';

  @override
  String get proteinManual => 'Registro manual';

  @override
  String get proteinSearch => 'Buscar alimento (ex: frango, iogurte)';

  @override
  String foodPortion(String portion, String g) {
    return '$portion • $g g proteína';
  }

  @override
  String proteinAddFood(String name) {
    return 'Adicionar $name';
  }

  @override
  String get proteinManualName => 'Nome do alimento';

  @override
  String get proteinManualGrams => 'Proteína (gramas)';

  @override
  String get proteinAdd => 'Adicionar';

  @override
  String get proteinToday => 'Registrados hoje';

  @override
  String proteinTodayCount(int count, String g) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
    );
    return '$_temp0 • $g g';
  }

  @override
  String get proteinTodayEmpty => 'Nada registrado hoje.';

  @override
  String portions(String n) {
    return '$n porção(ões)';
  }

  @override
  String get lessPortion => 'Menos meia porção';

  @override
  String get morePortion => 'Mais meia porção';

  @override
  String get homeProteinTitle => 'Meta de proteína';

  @override
  String homeProteinPct(int pct) {
    return '$pct% hoje';
  }

  @override
  String get homeProteinLog => 'Registrar proteína';

  @override
  String get homeLogSymptom => 'Registrar sintoma';

  @override
  String get homeLogWeight => 'Registrar peso';

  @override
  String get homeLogWorkout => 'Treinar';

  @override
  String get symNausea => 'Náusea';

  @override
  String get symVomit => 'Vômito';

  @override
  String get symConstipation => 'Constipação';

  @override
  String get symDiarrhea => 'Diarreia';

  @override
  String get symReflux => 'Refluxo';

  @override
  String get symFatigue => 'Fadiga';

  @override
  String get symAppetite => 'Falta de apetite';

  @override
  String get symHeadache => 'Dor de cabeça';

  @override
  String get symDizziness => 'Tontura';

  @override
  String get sev0 => 'Nenhum';

  @override
  String get sev1 => 'Leve';

  @override
  String get sev2 => 'Moderado';

  @override
  String get sev3 => 'Forte';

  @override
  String get symTitle => 'Sintomas e bem-estar';

  @override
  String get symSubtitle =>
      'Registre como você se sente e veja padrões ao longo da semana.';

  @override
  String get symHowNow => 'Como você se sente agora?';

  @override
  String symIntensity(String symptom) {
    return 'Intensidade: $symptom';
  }

  @override
  String get symNoteHint => 'Ex: começou após o almoço';

  @override
  String get symSave => 'Salvar registro';

  @override
  String get symCycleTitle => 'Sintomas × dias desde a aplicação';

  @override
  String get symCycleSubtitle =>
      'Intensidade média (0 a 3) registrada em cada dia após a última aplicação.';

  @override
  String get symCycleEmpty =>
      'Registre aplicações e sintomas para ver o gráfico.';

  @override
  String get symHistory => 'Histórico recente';

  @override
  String get symHistoryEmpty => 'Nenhum sintoma registrado.';

  @override
  String get symSafety =>
      'Em caso de vômito persistente, dor abdominal intensa ou sintomas que preocupem, procure sua equipe de saúde.';

  @override
  String daysAfterDose(int n) {
    return 'Dia $n após a aplicação';
  }

  @override
  String dayN(int n) {
    return 'Dia $n';
  }

  @override
  String get weightTitle => 'Evolução do peso';

  @override
  String get weightCurrent => 'Peso atual';

  @override
  String weightTotal(String diff) {
    return '$diff kg total';
  }

  @override
  String weightStart(String kg) {
    return 'Início: $kg kg';
  }

  @override
  String get weightLogToday => 'Registrar peso de hoje';

  @override
  String get weightEvolution => 'Evolução';

  @override
  String get weightFluctuation =>
      'Oscilações de 0,5 a 1 kg entre dias são comuns e costumam refletir água e intestino.';

  @override
  String get weightHistory => 'Histórico de pesagens';

  @override
  String get levelBeginner => 'Iniciante';

  @override
  String get levelIntermediate => 'Intermediário';

  @override
  String get locHome => 'Em casa';

  @override
  String get locGym => 'Academia';

  @override
  String get workoutsTitle => 'Preserve sua massa muscular';

  @override
  String get workoutsSubtitle =>
      'Treinos de força simples, em casa ou na academia.';

  @override
  String get workoutsWeeklyGoal => 'Meta semanal de força';

  @override
  String get workoutsSessionsDone => 'sessões nesta semana';

  @override
  String get workoutsGoalOk => 'Meta da semana (2 a 3 sessões) alcançada.';

  @override
  String get workoutsGoalHint => 'Meta: 2 a 3 sessões por semana.';

  @override
  String get workoutsWhy =>
      'A perda de peso pode incluir massa muscular. Exercícios de força ajudam a preservá-la. Respeite seus limites e, em caso de dúvida, fale com seu profissional de saúde.';

  @override
  String get workoutsTemplates => 'Modelos de treino';

  @override
  String workoutsExerciseCount(int n) {
    return '$n exercícios';
  }

  @override
  String get workoutsStart => 'Iniciar treino';

  @override
  String get workoutsHistory => 'Histórico recente';

  @override
  String get workoutsHistoryEmpty => 'Nenhuma sessão registrada ainda.';

  @override
  String workoutsExercisesDone(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n exercícios feitos',
      one: '1 exercício feito',
    );
    return '$_temp0';
  }

  @override
  String get workoutsSafety =>
      'Hidrate-se e respeite seus limites de energia durante a atividade.';

  @override
  String get sessionTitle => 'Treino em andamento';

  @override
  String sessionProgress(int done, int total) {
    return '$done de $total exercícios concluídos';
  }

  @override
  String setsReps(int sets, String reps) {
    return '$sets séries × $reps';
  }

  @override
  String get sessionSafety =>
      'Sentiu tontura, náusea ou mal-estar? Pare e descanse. Se persistir, procure sua equipe de saúde.';

  @override
  String get sessionFinish => 'Finalizar treino';

  @override
  String get sessionDiscard => 'Descartar treino';

  @override
  String get homeWorkoutTitle => 'Treino sugerido de hoje';

  @override
  String get homeWorkoutStart => 'Começar';

  @override
  String get settingsProfile => 'Seu perfil';

  @override
  String get settingsGoal => 'Meta diária de proteína';

  @override
  String get settingsReminder => 'Lembrete da aplicação';

  @override
  String get settingsReminderSub => 'Dia, horário e dose';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get exportTitle => 'Exportar meus dados (JSON)';

  @override
  String get exportSub =>
      'Copia todos os seus registros para a área de transferência';

  @override
  String get exportDone => 'Dados copiados para a área de transferência.';

  @override
  String get signOut => 'Sair';

  @override
  String get deleteTitle => 'Excluir minha conta e todos os meus dados';

  @override
  String get deleteBody =>
      'Isso apaga permanentemente seu perfil, doses, sintomas, peso, proteína e treinos, além da sua conta. Não é possível desfazer.';

  @override
  String get deleteConfirm => 'Excluir definitivamente';
}
