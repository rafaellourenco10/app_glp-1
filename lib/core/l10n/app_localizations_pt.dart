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
}
