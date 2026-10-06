import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('pt')];

  /// No description provided for @appName.
  ///
  /// In pt, this message translates to:
  /// **'Companheiro GLP-1'**
  String get appName;

  /// No description provided for @disclaimer.
  ///
  /// In pt, this message translates to:
  /// **'Este app é um diário de acompanhamento e não substitui orientação de médico ou nutricionista.'**
  String get disclaimer;

  /// No description provided for @errorLoad.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível carregar seus dados. Verifique sua conexão e tente novamente.'**
  String get errorLoad;

  /// No description provided for @errorSave.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível salvar. Verifique sua conexão e tente novamente.'**
  String get errorSave;

  /// No description provided for @retry.
  ///
  /// In pt, this message translates to:
  /// **'Tentar novamente'**
  String get retry;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @loginBadge.
  ///
  /// In pt, this message translates to:
  /// **'Seu espaço seguro'**
  String get loginBadge;

  /// No description provided for @loginSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Um apoio diário, acolhedor e sem julgamentos na sua jornada com a medicação.'**
  String get loginSubtitle;

  /// No description provided for @loginEmailLabel.
  ///
  /// In pt, this message translates to:
  /// **'Entrar com e-mail'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In pt, this message translates to:
  /// **'seu@email.com'**
  String get loginEmailHint;

  /// No description provided for @loginSendLink.
  ///
  /// In pt, this message translates to:
  /// **'Enviar link de acesso'**
  String get loginSendLink;

  /// No description provided for @loginLinkSent.
  ///
  /// In pt, this message translates to:
  /// **'Enviamos um link de acesso para o seu e-mail.'**
  String get loginLinkSent;

  /// No description provided for @loginOr.
  ///
  /// In pt, this message translates to:
  /// **'ou'**
  String get loginOr;

  /// No description provided for @loginApple.
  ///
  /// In pt, this message translates to:
  /// **'Continuar com Apple'**
  String get loginApple;

  /// No description provided for @loginGoogle.
  ///
  /// In pt, this message translates to:
  /// **'Continuar com Google'**
  String get loginGoogle;

  /// No description provided for @adjust.
  ///
  /// In pt, this message translates to:
  /// **'Ajustar'**
  String get adjust;

  /// No description provided for @weekdaysShort.
  ///
  /// In pt, this message translates to:
  /// **'Seg,Ter,Qua,Qui,Sex,Sáb,Dom'**
  String get weekdaysShort;

  /// No description provided for @medOther.
  ///
  /// In pt, this message translates to:
  /// **'Outro'**
  String get medOther;

  /// No description provided for @proteinReference.
  ///
  /// In pt, this message translates to:
  /// **'Valor de referência, converse com seu profissional de saúde.'**
  String get proteinReference;

  /// No description provided for @obStepOf.
  ///
  /// In pt, this message translates to:
  /// **'Etapa {n} de 4'**
  String obStepOf(int n);

  /// No description provided for @obContinue.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get obContinue;

  /// No description provided for @obStart.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get obStart;

  /// No description provided for @obWelcomeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo ao Companheiro GLP-1'**
  String get obWelcomeTitle;

  /// No description provided for @obPrivacyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Privacidade em primeiro lugar'**
  String get obPrivacyTitle;

  /// No description provided for @obPrivacySubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Controle total dos seus registros'**
  String get obPrivacySubtitle;

  /// No description provided for @obPrivacyBody.
  ///
  /// In pt, this message translates to:
  /// **'Seus dados de saúde são privados e apenas você tem acesso a cada medição e nota registrada.'**
  String get obPrivacyBody;

  /// No description provided for @obPrivacy1.
  ///
  /// In pt, this message translates to:
  /// **'Criptografia em repouso e em trânsito'**
  String get obPrivacy1;

  /// No description provided for @obPrivacy2.
  ///
  /// In pt, this message translates to:
  /// **'Seus registros nunca são compartilhados ou vendidos'**
  String get obPrivacy2;

  /// No description provided for @obPrivacy3.
  ///
  /// In pt, this message translates to:
  /// **'Exclusão da sua conta e de todos os dados a qualquer momento'**
  String get obPrivacy3;

  /// No description provided for @obConsent.
  ///
  /// In pt, this message translates to:
  /// **'Autorizo o tratamento dos meus dados de saúde (peso, doses, sintomas e alimentação) exclusivamente para o funcionamento deste diário, conforme a LGPD, e reconheço o aviso de saúde acima.'**
  String get obConsent;

  /// No description provided for @obConsentRequired.
  ///
  /// In pt, this message translates to:
  /// **'Obrigatório para iniciar o diário'**
  String get obConsentRequired;

  /// No description provided for @obAboutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Conte um pouco sobre você'**
  String get obAboutTitle;

  /// No description provided for @obAboutSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Essas informações aparecem no seu diário e servem de base para sua meta de proteína.'**
  String get obAboutSubtitle;

  /// No description provided for @obName.
  ///
  /// In pt, this message translates to:
  /// **'Nome ou como quer ser chamado(a)'**
  String get obName;

  /// No description provided for @obNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Marina'**
  String get obNameHint;

  /// No description provided for @obBirthYear.
  ///
  /// In pt, this message translates to:
  /// **'Ano de nascimento'**
  String get obBirthYear;

  /// No description provided for @obHeight.
  ///
  /// In pt, this message translates to:
  /// **'Altura'**
  String get obHeight;

  /// No description provided for @obWeight.
  ///
  /// In pt, this message translates to:
  /// **'Peso atual'**
  String get obWeight;

  /// No description provided for @obPrivacyNote.
  ///
  /// In pt, this message translates to:
  /// **'Seus dados de saúde são privados. Você pode editá-los ou excluí-los a qualquer momento no Perfil.'**
  String get obPrivacyNote;

  /// No description provided for @obMedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Qual é a sua medicação?'**
  String get obMedTitle;

  /// No description provided for @obMedSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'O lembrete semanal segue exatamente o dia e o horário que você escolher.'**
  String get obMedSubtitle;

  /// No description provided for @obMedLabel.
  ///
  /// In pt, this message translates to:
  /// **'Medicação prescrita'**
  String get obMedLabel;

  /// No description provided for @obDoseLabel.
  ///
  /// In pt, this message translates to:
  /// **'Dose (como está na sua receita)'**
  String get obDoseLabel;

  /// No description provided for @obDoseHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: 0,5 mg'**
  String get obDoseHint;

  /// No description provided for @obDoseHelper.
  ///
  /// In pt, this message translates to:
  /// **'Copie da caneta ou da prescrição médica.'**
  String get obDoseHelper;

  /// No description provided for @obWeekdayLabel.
  ///
  /// In pt, this message translates to:
  /// **'Dia da aplicação semanal'**
  String get obWeekdayLabel;

  /// No description provided for @obTimeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Horário do lembrete'**
  String get obTimeLabel;

  /// No description provided for @obReminderNote.
  ///
  /// In pt, this message translates to:
  /// **'Você poderá mudar o dia, o horário e a dose depois, em Doses.'**
  String get obReminderNote;

  /// No description provided for @obProteinTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua meta de proteína'**
  String get obProteinTitle;

  /// No description provided for @obProteinSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Sugerimos como ponto de partida 1,2 g por kg de peso. Ajuste como preferir.'**
  String get obProteinSubtitle;

  /// No description provided for @obProteinTarget.
  ///
  /// In pt, this message translates to:
  /// **'Meta diária'**
  String get obProteinTarget;

  /// No description provided for @obProteinRatio.
  ///
  /// In pt, this message translates to:
  /// **'Aprox. {ratio} g por kg de peso'**
  String obProteinRatio(String ratio);

  /// No description provided for @obProteinStep.
  ///
  /// In pt, this message translates to:
  /// **'Passo de 5 g'**
  String get obProteinStep;

  /// No description provided for @obProteinLess.
  ///
  /// In pt, this message translates to:
  /// **'Diminuir 5 g'**
  String get obProteinLess;

  /// No description provided for @obProteinMore.
  ///
  /// In pt, this message translates to:
  /// **'Aumentar 5 g'**
  String get obProteinMore;

  /// No description provided for @tabToday.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get tabToday;

  /// No description provided for @tabProtein.
  ///
  /// In pt, this message translates to:
  /// **'Proteína'**
  String get tabProtein;

  /// No description provided for @tabSymptoms.
  ///
  /// In pt, this message translates to:
  /// **'Sintomas'**
  String get tabSymptoms;

  /// No description provided for @tabWorkouts.
  ///
  /// In pt, this message translates to:
  /// **'Treinos'**
  String get tabWorkouts;

  /// No description provided for @tabProfile.
  ///
  /// In pt, this message translates to:
  /// **'Perfil'**
  String get tabProfile;

  /// No description provided for @homeGreeting.
  ///
  /// In pt, this message translates to:
  /// **'Olá, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeHowAreYou.
  ///
  /// In pt, this message translates to:
  /// **'Como você está se sentindo hoje?'**
  String get homeHowAreYou;

  /// No description provided for @today.
  ///
  /// In pt, this message translates to:
  /// **'Hoje'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In pt, this message translates to:
  /// **'Amanhã'**
  String get tomorrow;

  /// No description provided for @inDays.
  ///
  /// In pt, this message translates to:
  /// **'Em {n} dias'**
  String inDays(int n);

  /// No description provided for @atTime.
  ///
  /// In pt, this message translates to:
  /// **'{day}, às {time}'**
  String atTime(String day, String time);

  /// No description provided for @noteOptional.
  ///
  /// In pt, this message translates to:
  /// **'Observação (opcional)'**
  String get noteOptional;

  /// No description provided for @notifTitle.
  ///
  /// In pt, this message translates to:
  /// **'Lembrete da sua aplicação'**
  String get notifTitle;

  /// No description provided for @notifBody.
  ///
  /// In pt, this message translates to:
  /// **'{medication} · {dose} — no dia e horário que você definiu.'**
  String notifBody(String medication, String dose);

  /// No description provided for @notifChannel.
  ///
  /// In pt, this message translates to:
  /// **'Lembrete de aplicação'**
  String get notifChannel;

  /// No description provided for @dosesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rotina de aplicação'**
  String get dosesTitle;

  /// No description provided for @dosesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhe seus dias de aplicação e registre cada uma.'**
  String get dosesSubtitle;

  /// No description provided for @nextDose.
  ///
  /// In pt, this message translates to:
  /// **'Próxima aplicação'**
  String get nextDose;

  /// No description provided for @reminderOff.
  ///
  /// In pt, this message translates to:
  /// **'Lembrete desligado'**
  String get reminderOff;

  /// No description provided for @reminderConfig.
  ///
  /// In pt, this message translates to:
  /// **'Configuração do lembrete'**
  String get reminderConfig;

  /// No description provided for @reminderExact.
  ///
  /// In pt, this message translates to:
  /// **'O lembrete toca exatamente no dia e horário escolhidos, toda semana.'**
  String get reminderExact;

  /// No description provided for @reminderSaved.
  ///
  /// In pt, this message translates to:
  /// **'Lembrete atualizado.'**
  String get reminderSaved;

  /// No description provided for @doseRegister.
  ///
  /// In pt, this message translates to:
  /// **'Registrei a aplicação'**
  String get doseRegister;

  /// No description provided for @doseHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico de aplicações'**
  String get doseHistory;

  /// No description provided for @doseHistoryEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma aplicação registrada ainda.'**
  String get doseHistoryEmpty;

  /// No description provided for @doseSheetTitle.
  ///
  /// In pt, this message translates to:
  /// **'Registrar aplicação'**
  String get doseSheetTitle;

  /// No description provided for @doseSheetNow.
  ///
  /// In pt, this message translates to:
  /// **'Registrada agora: {when}'**
  String doseSheetNow(String when);

  /// No description provided for @doseField.
  ///
  /// In pt, this message translates to:
  /// **'Dose (como está na sua receita)'**
  String get doseField;

  /// No description provided for @doseSite.
  ///
  /// In pt, this message translates to:
  /// **'Local da aplicação (opcional)'**
  String get doseSite;

  /// No description provided for @doseNoteHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: sem desconforto'**
  String get doseNoteHint;

  /// No description provided for @doseConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar registro'**
  String get doseConfirm;

  /// No description provided for @siteAbdomen.
  ///
  /// In pt, this message translates to:
  /// **'Abdômen'**
  String get siteAbdomen;

  /// No description provided for @siteThigh.
  ///
  /// In pt, this message translates to:
  /// **'Coxa'**
  String get siteThigh;

  /// No description provided for @siteArm.
  ///
  /// In pt, this message translates to:
  /// **'Braço'**
  String get siteArm;

  /// No description provided for @proteinSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Preservação de massa magra e saciedade'**
  String get proteinSubtitle;

  /// No description provided for @proteinGoal.
  ///
  /// In pt, this message translates to:
  /// **'Meta {g} g'**
  String proteinGoal(String g);

  /// No description provided for @proteinRemaining.
  ///
  /// In pt, this message translates to:
  /// **'Faltam {g} g'**
  String proteinRemaining(String g);

  /// No description provided for @proteinGoalReached.
  ///
  /// In pt, this message translates to:
  /// **'Meta do dia atingida'**
  String get proteinGoalReached;

  /// No description provided for @proteinOfGoal.
  ///
  /// In pt, this message translates to:
  /// **'{consumed} g de {goal} g'**
  String proteinOfGoal(String consumed, String goal);

  /// No description provided for @proteinWeekly.
  ///
  /// In pt, this message translates to:
  /// **'Consistência semanal'**
  String get proteinWeekly;

  /// No description provided for @proteinWeeklyAvg.
  ///
  /// In pt, this message translates to:
  /// **'Média de {avg} g/dia • Meta {goal} g'**
  String proteinWeeklyAvg(String avg, String goal);

  /// No description provided for @proteinFoods.
  ///
  /// In pt, this message translates to:
  /// **'Alimentos'**
  String get proteinFoods;

  /// No description provided for @proteinManual.
  ///
  /// In pt, this message translates to:
  /// **'Registro manual'**
  String get proteinManual;

  /// No description provided for @proteinSearch.
  ///
  /// In pt, this message translates to:
  /// **'Buscar alimento (ex: frango, iogurte)'**
  String get proteinSearch;

  /// No description provided for @foodPortion.
  ///
  /// In pt, this message translates to:
  /// **'{portion} • {g} g proteína'**
  String foodPortion(String portion, String g);

  /// No description provided for @proteinAddFood.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar {name}'**
  String proteinAddFood(String name);

  /// No description provided for @proteinManualName.
  ///
  /// In pt, this message translates to:
  /// **'Nome do alimento'**
  String get proteinManualName;

  /// No description provided for @proteinManualGrams.
  ///
  /// In pt, this message translates to:
  /// **'Proteína (gramas)'**
  String get proteinManualGrams;

  /// No description provided for @proteinAdd.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get proteinAdd;

  /// No description provided for @proteinToday.
  ///
  /// In pt, this message translates to:
  /// **'Registrados hoje'**
  String get proteinToday;

  /// No description provided for @proteinTodayCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} itens}} • {g} g'**
  String proteinTodayCount(int count, String g);

  /// No description provided for @proteinTodayEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nada registrado hoje.'**
  String get proteinTodayEmpty;

  /// No description provided for @portions.
  ///
  /// In pt, this message translates to:
  /// **'{n} porção(ões)'**
  String portions(String n);

  /// No description provided for @lessPortion.
  ///
  /// In pt, this message translates to:
  /// **'Menos meia porção'**
  String get lessPortion;

  /// No description provided for @morePortion.
  ///
  /// In pt, this message translates to:
  /// **'Mais meia porção'**
  String get morePortion;

  /// No description provided for @homeProteinTitle.
  ///
  /// In pt, this message translates to:
  /// **'Meta de proteína'**
  String get homeProteinTitle;

  /// No description provided for @homeProteinPct.
  ///
  /// In pt, this message translates to:
  /// **'{pct}% hoje'**
  String homeProteinPct(int pct);

  /// No description provided for @homeProteinLog.
  ///
  /// In pt, this message translates to:
  /// **'Registrar proteína'**
  String get homeProteinLog;

  /// No description provided for @homeLogSymptom.
  ///
  /// In pt, this message translates to:
  /// **'Registrar sintoma'**
  String get homeLogSymptom;

  /// No description provided for @homeLogWeight.
  ///
  /// In pt, this message translates to:
  /// **'Registrar peso'**
  String get homeLogWeight;

  /// No description provided for @homeLogWorkout.
  ///
  /// In pt, this message translates to:
  /// **'Treinar'**
  String get homeLogWorkout;

  /// No description provided for @symNausea.
  ///
  /// In pt, this message translates to:
  /// **'Náusea'**
  String get symNausea;

  /// No description provided for @symVomit.
  ///
  /// In pt, this message translates to:
  /// **'Vômito'**
  String get symVomit;

  /// No description provided for @symConstipation.
  ///
  /// In pt, this message translates to:
  /// **'Constipação'**
  String get symConstipation;

  /// No description provided for @symDiarrhea.
  ///
  /// In pt, this message translates to:
  /// **'Diarreia'**
  String get symDiarrhea;

  /// No description provided for @symReflux.
  ///
  /// In pt, this message translates to:
  /// **'Refluxo'**
  String get symReflux;

  /// No description provided for @symFatigue.
  ///
  /// In pt, this message translates to:
  /// **'Fadiga'**
  String get symFatigue;

  /// No description provided for @symAppetite.
  ///
  /// In pt, this message translates to:
  /// **'Falta de apetite'**
  String get symAppetite;

  /// No description provided for @symHeadache.
  ///
  /// In pt, this message translates to:
  /// **'Dor de cabeça'**
  String get symHeadache;

  /// No description provided for @symDizziness.
  ///
  /// In pt, this message translates to:
  /// **'Tontura'**
  String get symDizziness;

  /// No description provided for @sev0.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum'**
  String get sev0;

  /// No description provided for @sev1.
  ///
  /// In pt, this message translates to:
  /// **'Leve'**
  String get sev1;

  /// No description provided for @sev2.
  ///
  /// In pt, this message translates to:
  /// **'Moderado'**
  String get sev2;

  /// No description provided for @sev3.
  ///
  /// In pt, this message translates to:
  /// **'Forte'**
  String get sev3;

  /// No description provided for @symTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sintomas e bem-estar'**
  String get symTitle;

  /// No description provided for @symSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Registre como você se sente e veja padrões ao longo da semana.'**
  String get symSubtitle;

  /// No description provided for @symHowNow.
  ///
  /// In pt, this message translates to:
  /// **'Como você se sente agora?'**
  String get symHowNow;

  /// No description provided for @symIntensity.
  ///
  /// In pt, this message translates to:
  /// **'Intensidade: {symptom}'**
  String symIntensity(String symptom);

  /// No description provided for @symNoteHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: começou após o almoço'**
  String get symNoteHint;

  /// No description provided for @symSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar registro'**
  String get symSave;

  /// No description provided for @symCycleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sintomas × dias desde a aplicação'**
  String get symCycleTitle;

  /// No description provided for @symCycleSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Intensidade média (0 a 3) registrada em cada dia após a última aplicação.'**
  String get symCycleSubtitle;

  /// No description provided for @symCycleEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Registre aplicações e sintomas para ver o gráfico.'**
  String get symCycleEmpty;

  /// No description provided for @symHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico recente'**
  String get symHistory;

  /// No description provided for @symHistoryEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum sintoma registrado.'**
  String get symHistoryEmpty;

  /// No description provided for @symSafety.
  ///
  /// In pt, this message translates to:
  /// **'Em caso de vômito persistente, dor abdominal intensa ou sintomas que preocupem, procure sua equipe de saúde.'**
  String get symSafety;

  /// No description provided for @daysAfterDose.
  ///
  /// In pt, this message translates to:
  /// **'Dia {n} após a aplicação'**
  String daysAfterDose(int n);

  /// No description provided for @dayN.
  ///
  /// In pt, this message translates to:
  /// **'Dia {n}'**
  String dayN(int n);

  /// No description provided for @weightTitle.
  ///
  /// In pt, this message translates to:
  /// **'Evolução do peso'**
  String get weightTitle;

  /// No description provided for @weightCurrent.
  ///
  /// In pt, this message translates to:
  /// **'Peso atual'**
  String get weightCurrent;

  /// No description provided for @weightTotal.
  ///
  /// In pt, this message translates to:
  /// **'{diff} kg total'**
  String weightTotal(String diff);

  /// No description provided for @weightStart.
  ///
  /// In pt, this message translates to:
  /// **'Início: {kg} kg'**
  String weightStart(String kg);

  /// No description provided for @weightLogToday.
  ///
  /// In pt, this message translates to:
  /// **'Registrar peso de hoje'**
  String get weightLogToday;

  /// No description provided for @weightEvolution.
  ///
  /// In pt, this message translates to:
  /// **'Evolução'**
  String get weightEvolution;

  /// No description provided for @weightFluctuation.
  ///
  /// In pt, this message translates to:
  /// **'Oscilações de 0,5 a 1 kg entre dias são comuns e costumam refletir água e intestino.'**
  String get weightFluctuation;

  /// No description provided for @weightHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico de pesagens'**
  String get weightHistory;

  /// No description provided for @levelBeginner.
  ///
  /// In pt, this message translates to:
  /// **'Iniciante'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In pt, this message translates to:
  /// **'Intermediário'**
  String get levelIntermediate;

  /// No description provided for @locHome.
  ///
  /// In pt, this message translates to:
  /// **'Em casa'**
  String get locHome;

  /// No description provided for @locGym.
  ///
  /// In pt, this message translates to:
  /// **'Academia'**
  String get locGym;

  /// No description provided for @workoutsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Preserve sua massa muscular'**
  String get workoutsTitle;

  /// No description provided for @workoutsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Treinos de força simples, em casa ou na academia.'**
  String get workoutsSubtitle;

  /// No description provided for @workoutsWeeklyGoal.
  ///
  /// In pt, this message translates to:
  /// **'Meta semanal de força'**
  String get workoutsWeeklyGoal;

  /// No description provided for @workoutsSessionsDone.
  ///
  /// In pt, this message translates to:
  /// **'sessões nesta semana'**
  String get workoutsSessionsDone;

  /// No description provided for @workoutsGoalOk.
  ///
  /// In pt, this message translates to:
  /// **'Meta da semana (2 a 3 sessões) alcançada.'**
  String get workoutsGoalOk;

  /// No description provided for @workoutsGoalHint.
  ///
  /// In pt, this message translates to:
  /// **'Meta: 2 a 3 sessões por semana.'**
  String get workoutsGoalHint;

  /// No description provided for @workoutsWhy.
  ///
  /// In pt, this message translates to:
  /// **'A perda de peso pode incluir massa muscular. Exercícios de força ajudam a preservá-la. Respeite seus limites e, em caso de dúvida, fale com seu profissional de saúde.'**
  String get workoutsWhy;

  /// No description provided for @workoutsTemplates.
  ///
  /// In pt, this message translates to:
  /// **'Modelos de treino'**
  String get workoutsTemplates;

  /// No description provided for @workoutsExerciseCount.
  ///
  /// In pt, this message translates to:
  /// **'{n} exercícios'**
  String workoutsExerciseCount(int n);

  /// No description provided for @workoutsStart.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar treino'**
  String get workoutsStart;

  /// No description provided for @workoutsHistory.
  ///
  /// In pt, this message translates to:
  /// **'Histórico recente'**
  String get workoutsHistory;

  /// No description provided for @workoutsHistoryEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma sessão registrada ainda.'**
  String get workoutsHistoryEmpty;

  /// No description provided for @workoutsExercisesDone.
  ///
  /// In pt, this message translates to:
  /// **'{n, plural, =1{1 exercício feito} other{{n} exercícios feitos}}'**
  String workoutsExercisesDone(int n);

  /// No description provided for @workoutsSafety.
  ///
  /// In pt, this message translates to:
  /// **'Hidrate-se e respeite seus limites de energia durante a atividade.'**
  String get workoutsSafety;

  /// No description provided for @sessionTitle.
  ///
  /// In pt, this message translates to:
  /// **'Treino em andamento'**
  String get sessionTitle;

  /// No description provided for @sessionProgress.
  ///
  /// In pt, this message translates to:
  /// **'{done} de {total} exercícios concluídos'**
  String sessionProgress(int done, int total);

  /// No description provided for @setsReps.
  ///
  /// In pt, this message translates to:
  /// **'{sets} séries × {reps}'**
  String setsReps(int sets, String reps);

  /// No description provided for @sessionSafety.
  ///
  /// In pt, this message translates to:
  /// **'Sentiu tontura, náusea ou mal-estar? Pare e descanse. Se persistir, procure sua equipe de saúde.'**
  String get sessionSafety;

  /// No description provided for @sessionFinish.
  ///
  /// In pt, this message translates to:
  /// **'Finalizar treino'**
  String get sessionFinish;

  /// No description provided for @sessionDiscard.
  ///
  /// In pt, this message translates to:
  /// **'Descartar treino'**
  String get sessionDiscard;

  /// No description provided for @homeWorkoutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Treino sugerido de hoje'**
  String get homeWorkoutTitle;

  /// No description provided for @homeWorkoutStart.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get homeWorkoutStart;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
