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
      'Seus dados de saúde são estritamente privados e apenas você tem acesso a cada medição e nota registrada.';

  @override
  String get obPrivacy1 => 'Criptografia segura em repouso e em trânsito';

  @override
  String get obPrivacy2 =>
      'Seus registros nunca são compartilhados ou vendidos';

  @override
  String get obPrivacy3 =>
      'Exclusão simplificada da sua conta a qualquer momento';

  @override
  String get obConsent =>
      'Autorizo o tratamento dos meus dados de saúde (peso, doses, sintomas e alimentação) exclusivamente para o funcionamento deste diário, conforme a LGPD, e reconheço o aviso de saúde acima.';

  @override
  String get obConsentRequired => 'Obrigatório para iniciar o diário protegido';

  @override
  String get obAboutTitle => 'Conte um pouco sobre você';

  @override
  String get obAboutSubtitle =>
      'Essas informações nos ajudam a personalizar seus lembretes e metas diárias.';

  @override
  String get obName => 'Nome ou como quer ser chamado(a)';

  @override
  String get obNameHint => 'Marina Silva';

  @override
  String get obBirthYear => 'Ano de nascimento';

  @override
  String get obHeight => 'Altura';

  @override
  String get obWeight => 'Peso atual';

  @override
  String get obPrivacyNote =>
      'Seus dados de saúde são privados e criptografados. Você poderá atualizar ou excluir essas informações a qualquer momento no seu Perfil.';

  @override
  String get obMedTitle => 'Qual é a sua medicação?';

  @override
  String get obMedSubtitle =>
      'Configuramos os lembretes no dia e na hora exatos da sua aplicação semanal.';

  @override
  String get obMedLabel => 'Medicação prescrita';

  @override
  String get obDoseLabel => 'Dose (como está na sua receita)';

  @override
  String get obDoseHint => 'Ex: 0,5 mg ou 2,5 mg';

  @override
  String get obDoseHelper => 'Verifique na caneta ou prescrição médica.';

  @override
  String get obWeekdayLabel => 'Dia da aplicação semanal';

  @override
  String get obTimeLabel => 'Horário preferido para o lembrete';

  @override
  String get obReminderNote =>
      'Você poderá mudar o dia, o horário e a dose depois, em Doses.';

  @override
  String get obProteinTitle => 'Sua meta de proteína';

  @override
  String get obProteinSubtitle =>
      'A ingestão adequada de proteína protege sua massa muscular magra e taxa metabólica durante o tratamento.';

  @override
  String get obProteinTarget => 'Alvo diário sugerido';

  @override
  String obProteinRatio(String ratio) {
    return 'Aprox. $ratio g por kg de peso corporal';
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
  String get dosesTitle => 'Rotina de Aplicação';

  @override
  String get dosesSubtitle =>
      'Acompanhe seus dias de aplicação e registre cada uma.';

  @override
  String get nextDose => 'Próxima aplicação';

  @override
  String get reminderOff => 'Lembrete desligado';

  @override
  String get reminderConfig => 'Configuração do Lembrete';

  @override
  String get reminderExact =>
      'Notificaremos exatamente no dia e horário da aplicação programada.';

  @override
  String get reminderSaved => 'Lembrete atualizado.';

  @override
  String get doseRegister => 'Registrei a aplicação';

  @override
  String get doseHistory => 'Histórico de Aplicações';

  @override
  String get doseHistoryEmpty => 'Nenhuma aplicação registrada ainda.';

  @override
  String get doseSheetTitle => 'Registrar Aplicação';

  @override
  String doseSheetNow(String when) {
    return 'Registrada agora: $when';
  }

  @override
  String get doseField => 'Dose aplicada';

  @override
  String get doseSite => 'Local de injeção (opcional)';

  @override
  String get doseNoteHint =>
      'Ex: sem desconforto, agulha 4mm, sensação normal...';

  @override
  String get doseConfirm => 'Confirmar registro da dose';

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
    return 'Média de $avg g/dia • Alvo $goal g';
  }

  @override
  String get proteinFoods => 'Alimentos';

  @override
  String get proteinManual => 'Registro Manual';

  @override
  String get proteinSearch => 'Buscar alimento (ex: frango, iogurte)...';

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
  String get homeProteinTitle => 'Meta de Proteína';

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
  String get symAppetite => 'Sem apetite';

  @override
  String get symHeadache => 'Cefaleia';

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
  String get symTitle => 'Sintomas e Bem-estar';

  @override
  String get symSubtitle =>
      'Identifique padrões e acompanhe a adaptação ao longo do seu ciclo semanal.';

  @override
  String get symHowNow => 'Como você se sente agora?';

  @override
  String symIntensity(String symptom) {
    return 'Intensidade: $symptom';
  }

  @override
  String get symNoteHint => 'Ex: Começou após almoço mais gorduroso...';

  @override
  String get symSave => 'Salvar registro';

  @override
  String get symCycleTitle => 'Padrão no ciclo semanal';

  @override
  String get symCycleSubtitle =>
      'Intensidade média que você registrou em cada dia após a aplicação; o destaque mostra o seu pico.';

  @override
  String get symCycleEmpty =>
      'Registre aplicações e sintomas para ver o gráfico.';

  @override
  String get symHistory => 'Histórico recente';

  @override
  String get symHistoryEmpty => 'Nenhum sintoma registrado.';

  @override
  String get symSafety =>
      'Sua jornada é única. Em caso de vômito persistente, dor abdominal intensa ou sintomas que causem preocupação, entre em contato imediatamente com sua equipe de saúde.';

  @override
  String daysAfterDose(int n) {
    return 'Dia $n após a aplicação';
  }

  @override
  String dayN(int n) {
    return 'Dia $n';
  }

  @override
  String get weightTitle => 'Evolução do Peso';

  @override
  String get weightCurrent => 'Peso atual aferido';

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
  String get weightEvolution => 'Evolução recente';

  @override
  String get weightFluctuation =>
      'Oscilações de 500 g a 1 kg entre dias consecutivos costumam vir de água corporal e trânsito intestinal, não de gordura.';

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
      'Treinos focados em força protegem sua taxa metabólica e sustentam o emagrecimento saudável com GLP-1.';

  @override
  String get workoutsWeeklyGoal => 'Meta semanal de força';

  @override
  String get workoutsSessionsDone => 'sessões concluídas';

  @override
  String get workoutsGoalOk =>
      'Excelente consistência. Mais 1 treino para bater sua meta da semana.';

  @override
  String get workoutsGoalHint => 'Meta: 2 a 3 sessões por semana.';

  @override
  String get workoutsWhy =>
      'A perda de peso rápida pode reduzir massa magra. Exercícios resistidos sinalizam ao corpo para preservar os músculos.';

  @override
  String get workoutsTemplates => 'Treinos para você';

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
      'Respeite seus limites de energia e hidrate-se com frequência durante a atividade.';

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
      'Pare, sente-se e respire com calma. Pausas entre as séries ajudam. Se não melhorar, procure sua equipe de saúde.';

  @override
  String get sessionFinish => 'Finalizar treino';

  @override
  String get sessionDiscard => 'Descartar treino';

  @override
  String get homeWorkoutTitle => 'Treino de hoje';

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

  @override
  String get yesterday => 'Ontem';

  @override
  String get delete => 'Excluir';

  @override
  String get note => 'Nota';

  @override
  String get tip => 'Dica';

  @override
  String get done => 'Concluído';

  @override
  String get pending => 'Pendente';

  @override
  String get showLess => 'Mostrar menos';

  @override
  String get periodDawn => 'Madrugada';

  @override
  String get periodMorning => 'Manhã';

  @override
  String get periodAfternoon => 'Tarde';

  @override
  String get periodNight => 'Noite';

  @override
  String get clinicalNoticeTitle => 'Aviso clínico importante';

  @override
  String get disclaimerA => 'Este app é um diário de acompanhamento e ';

  @override
  String get disclaimerB => 'não substitui';

  @override
  String get disclaimerC => ' orientação de médico ou nutricionista.';

  @override
  String get obWelcomeLabel => 'Boas-vindas';

  @override
  String get obLgpdBadge => 'Seus dados protegidos conforme a LGPD';

  @override
  String get obStepByStep => 'Passo a passo';

  @override
  String get obPersonalCare => 'Cuidado personalizado';

  @override
  String get obNameCaption =>
      'Para saudarmos você carinhosamente todos os dias';

  @override
  String get obYearHint => 'Ex: 1990';

  @override
  String get obYearInfo =>
      'Ajuda a contextualizar seus registros e metas diárias.';

  @override
  String get obCentimeters => 'Centímetros';

  @override
  String get obKilograms => 'Quilogramas';

  @override
  String get obAlmostThere => 'Quase lá';

  @override
  String get obMedHeroTag => 'Acompanhamento seguro';

  @override
  String get obMedHeroTitle => 'Lembrete no seu ritmo';

  @override
  String get obMedHeroBody =>
      'Você escolhe o dia e o horário; o app apenas lembra.';

  @override
  String get obOncePerWeek => '1x por semana';

  @override
  String get obTimeSubtitle => 'Lembrete semanal';

  @override
  String get obReminderTipTitle => 'Tudo ajustável depois';

  @override
  String get mealBreakfast => 'Café da manhã';

  @override
  String get mealLunch => 'Almoço';

  @override
  String get mealSnack => 'Lanche';

  @override
  String get mealDinner => 'Jantar';

  @override
  String get obFinalPhase => 'Fase final';

  @override
  String get obProteinPhoto => 'Nutrição aliada ao seu ritmo metabólico';

  @override
  String get obProteinAdjust => 'Ajustar gramas';

  @override
  String get obComfortTitle => 'Conforto gástrico';

  @override
  String get obComfortBody =>
      'Dica: fracionar em 3 ou 4 pequenas refeições diárias ajuda a evitar sensação de estômago pesado e náuseas.';

  @override
  String get goodMorning => 'Bom dia';

  @override
  String get goodAfternoon => 'Boa tarde';

  @override
  String get goodEvening => 'Boa noite';

  @override
  String homeCycleDay(int n) {
    return 'Dia $n do ciclo semanal';
  }

  @override
  String get routineReminder => 'Lembrete de rotina';

  @override
  String get homeProteinSubtitle => 'Preservação muscular ativa';

  @override
  String ofGoal(String goal) {
    return 'de $goal g';
  }

  @override
  String homeProteinLeft(String g) {
    return 'Restam $g g';
  }

  @override
  String get homeProteinTip =>
      'Ideal: fracionar em refeições leves para evitar sensação de peso.';

  @override
  String get homeLast7 => 'Consistência últimos 7 dias';

  @override
  String homeAvg(String g) {
    return 'Média: $g g/dia';
  }

  @override
  String get homeChipSymptom => '+ Sintoma';

  @override
  String get homeChipWeight => '+ Peso';

  @override
  String get homeChipWorkout => '+ Treino';

  @override
  String homeWorkoutSub(String level, String place) {
    return 'Força • $level • $place';
  }

  @override
  String get homeWorkoutFocus => 'Foco em sustentação muscular';

  @override
  String get homeWorkoutFocusSub =>
      'Treinos de força ajudam a preservar a massa magra durante o emagrecimento';

  @override
  String get homeFooter =>
      'Diário de acompanhamento. Não substitui orientação de médico ou nutricionista. Em caso de desconforto persistente, contate seu profissional de saúde.';

  @override
  String get nextDoseShort => 'Próxima dose';

  @override
  String get dosesStatusActive => 'Ciclo semanal • Lembrete ativo';

  @override
  String get dosesStatusOff => 'Ciclo semanal • Lembrete desligado';

  @override
  String get dosesPreferredDay => 'Dia da semana preferido';

  @override
  String daySelected(String day) {
    return '$day selecionado';
  }

  @override
  String get dosesAlarmTime => 'Horário do alarme';

  @override
  String get dosesPrescribed => 'Dose na receita';

  @override
  String doseCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n aplicações registradas',
      one: '1 aplicação registrada',
      zero: 'Nenhuma aplicação registrada',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    return 'Há $n dias';
  }

  @override
  String doseSheetSub(String dose) {
    return 'Dose prescrita: $dose • Hoje';
  }

  @override
  String get siteAbdomenFull => 'Abdômen (Esq / Dir)';

  @override
  String get siteThighFull => 'Coxa (Esq / Dir)';

  @override
  String get siteArmFull => 'Braço (Posterior)';

  @override
  String get siteLastUsed => 'Usado na última';

  @override
  String get doseWord => 'Dose';

  @override
  String get proteinTipTitle => 'Dica GLP-1';

  @override
  String get proteinTipBody =>
      'Distribuir a proteína ao longo das refeições do dia costuma deixar a alimentação mais confortável.';

  @override
  String proteinDaysHit(int n) {
    return '$n/7 dias atingidos';
  }

  @override
  String get proteinFrequent => 'Frequentes na sua rotina';

  @override
  String get proteinResults => 'Resultados da busca';

  @override
  String proteinPerPortion(String g) {
    return '$g g proteína';
  }

  @override
  String get proteinSwipe => 'Deslize para excluir';

  @override
  String get proteinHydrationTitle => 'Hidratação e digestão';

  @override
  String get proteinHydrationBody =>
      'Lembre-se de beber água em pequenos goles ao longo do dia para apoiar a digestão e evitar constipação.';

  @override
  String daysAfterDoseWith(int n, String dose) {
    return 'Dia $n pós-dose ($dose)';
  }

  @override
  String get symNoteLabel => 'Nota ou possível gatilho (opcional)';

  @override
  String symWeekN(int n) {
    return 'Semana $n';
  }

  @override
  String get symCurveLegend => 'Intensidade média por dia';

  @override
  String todayDayN(int n) {
    return 'Hoje: Dia $n';
  }

  @override
  String get symTipTitle => 'Leve para sua consulta';

  @override
  String get symTipBody =>
      'Este padrão é feito só com os seus registros e pode ajudar seu profissional de saúde a entender sua adaptação.';

  @override
  String get symDoseLogged => 'Aplicação registrada';

  @override
  String get weightTag => 'Acompanhamento metabólico';

  @override
  String get weightSubtitle =>
      'Registre seu peso e acompanhe a evolução com calma, sem julgamentos.';

  @override
  String get weightThisWeek => 'Esta semana';

  @override
  String get weightLowest => 'Menor registro';

  @override
  String get weightPaceTitle => 'Seu ritmo';

  @override
  String weightPaceBody(String kg) {
    return 'média de $kg kg/semana desde o primeiro registro.';
  }

  @override
  String get weightNewLog => 'Novo registro';

  @override
  String get weightLess => 'Menos 100 g';

  @override
  String get weightMore => 'Mais 100 g';

  @override
  String get weightConfirm => 'Confirmar aferição';

  @override
  String weightLogsCount(int n) {
    return '$n registros';
  }

  @override
  String get weightLatest => 'Últimos registros';

  @override
  String weightSeeAll(int n) {
    return 'Ver histórico completo ($n)';
  }

  @override
  String get leanTitle => 'Proteção de massa magra';

  @override
  String get leanSubtitle => 'Proteína e treino de força';

  @override
  String get leanBody =>
      'Durante a perda de peso, proteína suficiente e treinos de força ajudam a preservar os músculos:';

  @override
  String get leanProtein => 'Ingestão de proteína hoje';

  @override
  String get leanWorkouts => 'Treinos de força semanais';

  @override
  String leanWorkoutsValue(int n, int goal) {
    return '$n de $goal concluídos';
  }

  @override
  String get leanTip =>
      'Ingerir proteína fracionada em cada refeição ajuda na saciedade e na preservação dos músculos.';

  @override
  String get workoutsTag => 'Metabolismo ativo';

  @override
  String get workoutsThisWeek => 'Esta semana';

  @override
  String get workoutsGoalFull =>
      'Excelente! Meta da semana (3 sessões) concluída.';

  @override
  String workoutsGoalMissing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Mais $n treinos para a meta mínima da semana.',
      one: 'Mais 1 treino para a meta mínima da semana.',
    );
    return '$_temp0';
  }

  @override
  String get workoutsWhyTitle => 'Por que treinar força com GLP-1?';

  @override
  String get workoutsTemplatesTag => '4 modelos';

  @override
  String get workoutsSuggested => 'Sugerido para hoje';

  @override
  String get workoutsNoEquipment => 'Sem aparelhos';

  @override
  String sessionN(int n) {
    return 'Sessão $n';
  }

  @override
  String get sessionActiveTime => 'tempo ativo';

  @override
  String get sessionPause => 'Pausar cronômetro';

  @override
  String get sessionResume => 'Retomar';

  @override
  String get sessionPauseSession => 'Pausar sessão';

  @override
  String get sessionWater => 'Beba pequenos goles de água entre os movimentos.';

  @override
  String get sessionSafetyTitle => 'Sentiu tontura ou náusea súbita?';

  @override
  String setOf(int n, int total) {
    return 'Série $n de $total';
  }

  @override
  String get upNext => 'A seguir';

  @override
  String repsN(String reps) {
    return '$reps repetições';
  }

  @override
  String get current => '(atual)';

  @override
  String setN(int n) {
    return 'Série $n';
  }

  @override
  String get restLabel => 'Descanso entre séries';

  @override
  String get restButton => 'Descansar 45s';

  @override
  String get settingsSubtitle => 'Seu perfil, lembretes e privacidade';

  @override
  String get deleteSub => 'Apaga permanentemente tudo, inclusive a conta';
}
