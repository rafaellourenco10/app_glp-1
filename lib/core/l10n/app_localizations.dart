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
  /// **'Seus dados de saúde são estritamente privados e apenas você tem acesso a cada medição e nota registrada.'**
  String get obPrivacyBody;

  /// No description provided for @obPrivacy1.
  ///
  /// In pt, this message translates to:
  /// **'Criptografia segura em repouso e em trânsito'**
  String get obPrivacy1;

  /// No description provided for @obPrivacy2.
  ///
  /// In pt, this message translates to:
  /// **'Seus registros nunca são compartilhados ou vendidos'**
  String get obPrivacy2;

  /// No description provided for @obPrivacy3.
  ///
  /// In pt, this message translates to:
  /// **'Exclusão simplificada da sua conta a qualquer momento'**
  String get obPrivacy3;

  /// No description provided for @obConsent.
  ///
  /// In pt, this message translates to:
  /// **'Autorizo o tratamento dos meus dados de saúde (peso, doses, sintomas e alimentação) exclusivamente para o funcionamento deste diário, conforme a LGPD, e reconheço o aviso de saúde acima.'**
  String get obConsent;

  /// No description provided for @obConsentRequired.
  ///
  /// In pt, this message translates to:
  /// **'Obrigatório para iniciar o diário protegido'**
  String get obConsentRequired;

  /// No description provided for @obAboutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Conte um pouco sobre você'**
  String get obAboutTitle;

  /// No description provided for @obAboutSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Essas informações nos ajudam a personalizar seus lembretes e metas diárias.'**
  String get obAboutSubtitle;

  /// No description provided for @obName.
  ///
  /// In pt, this message translates to:
  /// **'Nome ou como quer ser chamado(a)'**
  String get obName;

  /// No description provided for @obNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Marina Silva'**
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
  /// **'Seus dados de saúde são privados e criptografados. Você poderá atualizar ou excluir essas informações a qualquer momento no seu Perfil.'**
  String get obPrivacyNote;

  /// No description provided for @obMedTitle.
  ///
  /// In pt, this message translates to:
  /// **'Qual é a sua medicação?'**
  String get obMedTitle;

  /// No description provided for @obMedSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Configuramos os lembretes no dia e na hora exatos da sua aplicação semanal.'**
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
  /// **'Ex: 0,5 mg ou 2,5 mg'**
  String get obDoseHint;

  /// No description provided for @obDoseHelper.
  ///
  /// In pt, this message translates to:
  /// **'Verifique na caneta ou prescrição médica.'**
  String get obDoseHelper;

  /// No description provided for @obWeekdayLabel.
  ///
  /// In pt, this message translates to:
  /// **'Dia da aplicação semanal'**
  String get obWeekdayLabel;

  /// No description provided for @obTimeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Horário preferido para o lembrete'**
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
  /// **'A ingestão adequada de proteína protege sua massa muscular magra e taxa metabólica durante o tratamento.'**
  String get obProteinSubtitle;

  /// No description provided for @obProteinTarget.
  ///
  /// In pt, this message translates to:
  /// **'Alvo diário sugerido'**
  String get obProteinTarget;

  /// No description provided for @obProteinRatio.
  ///
  /// In pt, this message translates to:
  /// **'Aprox. {ratio} g por kg de peso corporal'**
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
  /// **'Rotina de Aplicação'**
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
  /// **'Configuração do Lembrete'**
  String get reminderConfig;

  /// No description provided for @reminderExact.
  ///
  /// In pt, this message translates to:
  /// **'Notificaremos exatamente no dia e horário da aplicação programada.'**
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
  /// **'Histórico de Aplicações'**
  String get doseHistory;

  /// No description provided for @doseHistoryEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma aplicação registrada ainda.'**
  String get doseHistoryEmpty;

  /// No description provided for @doseSheetTitle.
  ///
  /// In pt, this message translates to:
  /// **'Registrar Aplicação'**
  String get doseSheetTitle;

  /// No description provided for @doseSheetNow.
  ///
  /// In pt, this message translates to:
  /// **'Registrada agora: {when}'**
  String doseSheetNow(String when);

  /// No description provided for @doseField.
  ///
  /// In pt, this message translates to:
  /// **'Dose aplicada'**
  String get doseField;

  /// No description provided for @doseSite.
  ///
  /// In pt, this message translates to:
  /// **'Local de injeção (opcional)'**
  String get doseSite;

  /// No description provided for @doseNoteHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: sem desconforto, agulha 4mm, sensação normal...'**
  String get doseNoteHint;

  /// No description provided for @doseConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar registro da dose'**
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
  /// **'Média de {avg} g/dia • Alvo {goal} g'**
  String proteinWeeklyAvg(String avg, String goal);

  /// No description provided for @proteinFoods.
  ///
  /// In pt, this message translates to:
  /// **'Alimentos'**
  String get proteinFoods;

  /// No description provided for @proteinManual.
  ///
  /// In pt, this message translates to:
  /// **'Registro Manual'**
  String get proteinManual;

  /// No description provided for @proteinSearch.
  ///
  /// In pt, this message translates to:
  /// **'Buscar alimento (ex: frango, iogurte)...'**
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
  /// **'Meta de Proteína'**
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
  /// **'Sem apetite'**
  String get symAppetite;

  /// No description provided for @symHeadache.
  ///
  /// In pt, this message translates to:
  /// **'Cefaleia'**
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
  /// **'Sintomas e Bem-estar'**
  String get symTitle;

  /// No description provided for @symSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Identifique padrões e acompanhe a adaptação ao longo do seu ciclo semanal.'**
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
  /// **'Ex: Começou após almoço mais gorduroso...'**
  String get symNoteHint;

  /// No description provided for @symSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar registro'**
  String get symSave;

  /// No description provided for @symCycleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Padrão no ciclo semanal'**
  String get symCycleTitle;

  /// No description provided for @symCycleSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Intensidade média que você registrou em cada dia após a aplicação; o destaque mostra o seu pico.'**
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
  /// **'Sua jornada é única. Em caso de vômito persistente, dor abdominal intensa ou sintomas que causem preocupação, entre em contato imediatamente com sua equipe de saúde.'**
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
  /// **'Evolução do Peso'**
  String get weightTitle;

  /// No description provided for @weightCurrent.
  ///
  /// In pt, this message translates to:
  /// **'Peso atual aferido'**
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
  /// **'Evolução recente'**
  String get weightEvolution;

  /// No description provided for @weightFluctuation.
  ///
  /// In pt, this message translates to:
  /// **'Oscilações de 500 g a 1 kg entre dias consecutivos costumam vir de água corporal e trânsito intestinal, não de gordura.'**
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
  /// **'Treinos focados em força protegem sua taxa metabólica e sustentam o emagrecimento saudável com GLP-1.'**
  String get workoutsSubtitle;

  /// No description provided for @workoutsWeeklyGoal.
  ///
  /// In pt, this message translates to:
  /// **'Meta semanal de força'**
  String get workoutsWeeklyGoal;

  /// No description provided for @workoutsSessionsDone.
  ///
  /// In pt, this message translates to:
  /// **'sessões concluídas'**
  String get workoutsSessionsDone;

  /// No description provided for @workoutsGoalOk.
  ///
  /// In pt, this message translates to:
  /// **'Excelente consistência. Mais 1 treino para bater sua meta da semana.'**
  String get workoutsGoalOk;

  /// No description provided for @workoutsGoalHint.
  ///
  /// In pt, this message translates to:
  /// **'Meta: 2 a 3 sessões por semana.'**
  String get workoutsGoalHint;

  /// No description provided for @workoutsWhy.
  ///
  /// In pt, this message translates to:
  /// **'A perda de peso rápida pode reduzir massa magra. Exercícios resistidos sinalizam ao corpo para preservar os músculos.'**
  String get workoutsWhy;

  /// No description provided for @workoutsTemplates.
  ///
  /// In pt, this message translates to:
  /// **'Treinos para você'**
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
  /// **'Respeite seus limites de energia e hidrate-se com frequência durante a atividade.'**
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
  /// **'Pare, sente-se e respire com calma. Pausas entre as séries ajudam. Se não melhorar, procure sua equipe de saúde.'**
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
  /// **'Treino de hoje'**
  String get homeWorkoutTitle;

  /// No description provided for @homeWorkoutStart.
  ///
  /// In pt, this message translates to:
  /// **'Começar'**
  String get homeWorkoutStart;

  /// No description provided for @settingsProfile.
  ///
  /// In pt, this message translates to:
  /// **'Seu perfil'**
  String get settingsProfile;

  /// No description provided for @settingsGoal.
  ///
  /// In pt, this message translates to:
  /// **'Meta diária de proteína'**
  String get settingsGoal;

  /// No description provided for @settingsReminder.
  ///
  /// In pt, this message translates to:
  /// **'Lembrete da aplicação'**
  String get settingsReminder;

  /// No description provided for @settingsReminderSub.
  ///
  /// In pt, this message translates to:
  /// **'Dia, horário e dose'**
  String get settingsReminderSub;

  /// No description provided for @settingsTheme.
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In pt, this message translates to:
  /// **'Sistema'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In pt, this message translates to:
  /// **'Claro'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In pt, this message translates to:
  /// **'Escuro'**
  String get themeDark;

  /// No description provided for @exportTitle.
  ///
  /// In pt, this message translates to:
  /// **'Exportar meus dados (JSON)'**
  String get exportTitle;

  /// No description provided for @exportSub.
  ///
  /// In pt, this message translates to:
  /// **'Copia todos os seus registros para a área de transferência'**
  String get exportSub;

  /// No description provided for @exportDone.
  ///
  /// In pt, this message translates to:
  /// **'Dados copiados para a área de transferência.'**
  String get exportDone;

  /// No description provided for @signOut.
  ///
  /// In pt, this message translates to:
  /// **'Sair'**
  String get signOut;

  /// No description provided for @deleteTitle.
  ///
  /// In pt, this message translates to:
  /// **'Excluir minha conta e todos os meus dados'**
  String get deleteTitle;

  /// No description provided for @deleteBody.
  ///
  /// In pt, this message translates to:
  /// **'Isso apaga permanentemente seu perfil, doses, sintomas, peso, proteína e treinos, além da sua conta. Não é possível desfazer.'**
  String get deleteBody;

  /// No description provided for @deleteConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Excluir definitivamente'**
  String get deleteConfirm;

  /// No description provided for @yesterday.
  ///
  /// In pt, this message translates to:
  /// **'Ontem'**
  String get yesterday;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get delete;

  /// No description provided for @note.
  ///
  /// In pt, this message translates to:
  /// **'Nota'**
  String get note;

  /// No description provided for @tip.
  ///
  /// In pt, this message translates to:
  /// **'Dica'**
  String get tip;

  /// No description provided for @done.
  ///
  /// In pt, this message translates to:
  /// **'Concluído'**
  String get done;

  /// No description provided for @pending.
  ///
  /// In pt, this message translates to:
  /// **'Pendente'**
  String get pending;

  /// No description provided for @showLess.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar menos'**
  String get showLess;

  /// No description provided for @periodDawn.
  ///
  /// In pt, this message translates to:
  /// **'Madrugada'**
  String get periodDawn;

  /// No description provided for @periodMorning.
  ///
  /// In pt, this message translates to:
  /// **'Manhã'**
  String get periodMorning;

  /// No description provided for @periodAfternoon.
  ///
  /// In pt, this message translates to:
  /// **'Tarde'**
  String get periodAfternoon;

  /// No description provided for @periodNight.
  ///
  /// In pt, this message translates to:
  /// **'Noite'**
  String get periodNight;

  /// No description provided for @clinicalNoticeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Aviso clínico importante'**
  String get clinicalNoticeTitle;

  /// No description provided for @disclaimerA.
  ///
  /// In pt, this message translates to:
  /// **'Este app é um diário de acompanhamento e '**
  String get disclaimerA;

  /// No description provided for @disclaimerB.
  ///
  /// In pt, this message translates to:
  /// **'não substitui'**
  String get disclaimerB;

  /// No description provided for @disclaimerC.
  ///
  /// In pt, this message translates to:
  /// **' orientação de médico ou nutricionista.'**
  String get disclaimerC;

  /// No description provided for @obWelcomeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Boas-vindas'**
  String get obWelcomeLabel;

  /// No description provided for @obLgpdBadge.
  ///
  /// In pt, this message translates to:
  /// **'Seus dados protegidos conforme a LGPD'**
  String get obLgpdBadge;

  /// No description provided for @obStepByStep.
  ///
  /// In pt, this message translates to:
  /// **'Passo a passo'**
  String get obStepByStep;

  /// No description provided for @obPersonalCare.
  ///
  /// In pt, this message translates to:
  /// **'Cuidado personalizado'**
  String get obPersonalCare;

  /// No description provided for @obNameCaption.
  ///
  /// In pt, this message translates to:
  /// **'Para saudarmos você carinhosamente todos os dias'**
  String get obNameCaption;

  /// No description provided for @obYearHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: 1990'**
  String get obYearHint;

  /// No description provided for @obYearInfo.
  ///
  /// In pt, this message translates to:
  /// **'Ajuda a contextualizar seus registros e metas diárias.'**
  String get obYearInfo;

  /// No description provided for @obCentimeters.
  ///
  /// In pt, this message translates to:
  /// **'Centímetros'**
  String get obCentimeters;

  /// No description provided for @obKilograms.
  ///
  /// In pt, this message translates to:
  /// **'Quilogramas'**
  String get obKilograms;

  /// No description provided for @obAlmostThere.
  ///
  /// In pt, this message translates to:
  /// **'Quase lá'**
  String get obAlmostThere;

  /// No description provided for @obMedHeroTag.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhamento seguro'**
  String get obMedHeroTag;

  /// No description provided for @obMedHeroTitle.
  ///
  /// In pt, this message translates to:
  /// **'Lembrete no seu ritmo'**
  String get obMedHeroTitle;

  /// No description provided for @obMedHeroBody.
  ///
  /// In pt, this message translates to:
  /// **'Você escolhe o dia e o horário; o app apenas lembra.'**
  String get obMedHeroBody;

  /// No description provided for @obOncePerWeek.
  ///
  /// In pt, this message translates to:
  /// **'1x por semana'**
  String get obOncePerWeek;

  /// No description provided for @obTimeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Lembrete semanal'**
  String get obTimeSubtitle;

  /// No description provided for @obReminderTipTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tudo ajustável depois'**
  String get obReminderTipTitle;

  /// No description provided for @mealBreakfast.
  ///
  /// In pt, this message translates to:
  /// **'Café da manhã'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In pt, this message translates to:
  /// **'Almoço'**
  String get mealLunch;

  /// No description provided for @mealSnack.
  ///
  /// In pt, this message translates to:
  /// **'Lanche'**
  String get mealSnack;

  /// No description provided for @mealDinner.
  ///
  /// In pt, this message translates to:
  /// **'Jantar'**
  String get mealDinner;

  /// No description provided for @obFinalPhase.
  ///
  /// In pt, this message translates to:
  /// **'Fase final'**
  String get obFinalPhase;

  /// No description provided for @obProteinPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Nutrição aliada ao seu ritmo metabólico'**
  String get obProteinPhoto;

  /// No description provided for @obProteinAdjust.
  ///
  /// In pt, this message translates to:
  /// **'Ajustar gramas'**
  String get obProteinAdjust;

  /// No description provided for @obComfortTitle.
  ///
  /// In pt, this message translates to:
  /// **'Conforto gástrico'**
  String get obComfortTitle;

  /// No description provided for @obComfortBody.
  ///
  /// In pt, this message translates to:
  /// **'Dica: fracionar em 3 ou 4 pequenas refeições diárias ajuda a evitar sensação de estômago pesado e náuseas.'**
  String get obComfortBody;

  /// No description provided for @goodMorning.
  ///
  /// In pt, this message translates to:
  /// **'Bom dia'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In pt, this message translates to:
  /// **'Boa tarde'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In pt, this message translates to:
  /// **'Boa noite'**
  String get goodEvening;

  /// No description provided for @homeCycleDay.
  ///
  /// In pt, this message translates to:
  /// **'Dia {n} do ciclo semanal'**
  String homeCycleDay(int n);

  /// No description provided for @routineReminder.
  ///
  /// In pt, this message translates to:
  /// **'Lembrete de rotina'**
  String get routineReminder;

  /// No description provided for @homeProteinSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Preservação muscular ativa'**
  String get homeProteinSubtitle;

  /// No description provided for @ofGoal.
  ///
  /// In pt, this message translates to:
  /// **'de {goal} g'**
  String ofGoal(String goal);

  /// No description provided for @homeProteinLeft.
  ///
  /// In pt, this message translates to:
  /// **'Restam {g} g'**
  String homeProteinLeft(String g);

  /// No description provided for @homeProteinTip.
  ///
  /// In pt, this message translates to:
  /// **'Ideal: fracionar em refeições leves para evitar sensação de peso.'**
  String get homeProteinTip;

  /// No description provided for @homeLast7.
  ///
  /// In pt, this message translates to:
  /// **'Consistência últimos 7 dias'**
  String get homeLast7;

  /// No description provided for @homeAvg.
  ///
  /// In pt, this message translates to:
  /// **'Média: {g} g/dia'**
  String homeAvg(String g);

  /// No description provided for @homeChipSymptom.
  ///
  /// In pt, this message translates to:
  /// **'+ Sintoma'**
  String get homeChipSymptom;

  /// No description provided for @homeChipWeight.
  ///
  /// In pt, this message translates to:
  /// **'+ Peso'**
  String get homeChipWeight;

  /// No description provided for @homeChipWorkout.
  ///
  /// In pt, this message translates to:
  /// **'+ Treino'**
  String get homeChipWorkout;

  /// No description provided for @homeWorkoutSub.
  ///
  /// In pt, this message translates to:
  /// **'Força • {level} • {place}'**
  String homeWorkoutSub(String level, String place);

  /// No description provided for @homeWorkoutFocus.
  ///
  /// In pt, this message translates to:
  /// **'Foco em sustentação muscular'**
  String get homeWorkoutFocus;

  /// No description provided for @homeWorkoutFocusSub.
  ///
  /// In pt, this message translates to:
  /// **'Treinos de força ajudam a preservar a massa magra durante o emagrecimento'**
  String get homeWorkoutFocusSub;

  /// No description provided for @homeFooter.
  ///
  /// In pt, this message translates to:
  /// **'Diário de acompanhamento. Não substitui orientação de médico ou nutricionista. Em caso de desconforto persistente, contate seu profissional de saúde.'**
  String get homeFooter;

  /// No description provided for @nextDoseShort.
  ///
  /// In pt, this message translates to:
  /// **'Próxima dose'**
  String get nextDoseShort;

  /// No description provided for @dosesStatusActive.
  ///
  /// In pt, this message translates to:
  /// **'Ciclo semanal • Lembrete ativo'**
  String get dosesStatusActive;

  /// No description provided for @dosesStatusOff.
  ///
  /// In pt, this message translates to:
  /// **'Ciclo semanal • Lembrete desligado'**
  String get dosesStatusOff;

  /// No description provided for @dosesPreferredDay.
  ///
  /// In pt, this message translates to:
  /// **'Dia da semana preferido'**
  String get dosesPreferredDay;

  /// No description provided for @daySelected.
  ///
  /// In pt, this message translates to:
  /// **'{day} selecionado'**
  String daySelected(String day);

  /// No description provided for @dosesAlarmTime.
  ///
  /// In pt, this message translates to:
  /// **'Horário do alarme'**
  String get dosesAlarmTime;

  /// No description provided for @dosesPrescribed.
  ///
  /// In pt, this message translates to:
  /// **'Dose na receita'**
  String get dosesPrescribed;

  /// No description provided for @doseCount.
  ///
  /// In pt, this message translates to:
  /// **'{n, plural, =0{Nenhuma aplicação registrada} =1{1 aplicação registrada} other{{n} aplicações registradas}}'**
  String doseCount(int n);

  /// No description provided for @daysAgo.
  ///
  /// In pt, this message translates to:
  /// **'Há {n} dias'**
  String daysAgo(int n);

  /// No description provided for @doseSheetSub.
  ///
  /// In pt, this message translates to:
  /// **'Dose prescrita: {dose} • Hoje'**
  String doseSheetSub(String dose);

  /// No description provided for @siteAbdomenFull.
  ///
  /// In pt, this message translates to:
  /// **'Abdômen (Esq / Dir)'**
  String get siteAbdomenFull;

  /// No description provided for @siteThighFull.
  ///
  /// In pt, this message translates to:
  /// **'Coxa (Esq / Dir)'**
  String get siteThighFull;

  /// No description provided for @siteArmFull.
  ///
  /// In pt, this message translates to:
  /// **'Braço (Posterior)'**
  String get siteArmFull;

  /// No description provided for @siteLastUsed.
  ///
  /// In pt, this message translates to:
  /// **'Usado na última'**
  String get siteLastUsed;

  /// No description provided for @doseWord.
  ///
  /// In pt, this message translates to:
  /// **'Dose'**
  String get doseWord;

  /// No description provided for @proteinTipTitle.
  ///
  /// In pt, this message translates to:
  /// **'Dica GLP-1'**
  String get proteinTipTitle;

  /// No description provided for @proteinTipBody.
  ///
  /// In pt, this message translates to:
  /// **'Distribuir a proteína ao longo das refeições do dia costuma deixar a alimentação mais confortável.'**
  String get proteinTipBody;

  /// No description provided for @proteinDaysHit.
  ///
  /// In pt, this message translates to:
  /// **'{n}/7 dias atingidos'**
  String proteinDaysHit(int n);

  /// No description provided for @proteinFrequent.
  ///
  /// In pt, this message translates to:
  /// **'Frequentes na sua rotina'**
  String get proteinFrequent;

  /// No description provided for @proteinResults.
  ///
  /// In pt, this message translates to:
  /// **'Resultados da busca'**
  String get proteinResults;

  /// No description provided for @proteinPerPortion.
  ///
  /// In pt, this message translates to:
  /// **'{g} g proteína'**
  String proteinPerPortion(String g);

  /// No description provided for @proteinSwipe.
  ///
  /// In pt, this message translates to:
  /// **'Deslize para excluir'**
  String get proteinSwipe;

  /// No description provided for @proteinHydrationTitle.
  ///
  /// In pt, this message translates to:
  /// **'Hidratação e digestão'**
  String get proteinHydrationTitle;

  /// No description provided for @proteinHydrationBody.
  ///
  /// In pt, this message translates to:
  /// **'Lembre-se de beber água em pequenos goles ao longo do dia para apoiar a digestão e evitar constipação.'**
  String get proteinHydrationBody;

  /// No description provided for @daysAfterDoseWith.
  ///
  /// In pt, this message translates to:
  /// **'Dia {n} pós-dose ({dose})'**
  String daysAfterDoseWith(int n, String dose);

  /// No description provided for @symNoteLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nota ou possível gatilho (opcional)'**
  String get symNoteLabel;

  /// No description provided for @symWeekN.
  ///
  /// In pt, this message translates to:
  /// **'Semana {n}'**
  String symWeekN(int n);

  /// No description provided for @symCurveLegend.
  ///
  /// In pt, this message translates to:
  /// **'Intensidade média por dia'**
  String get symCurveLegend;

  /// No description provided for @todayDayN.
  ///
  /// In pt, this message translates to:
  /// **'Hoje: Dia {n}'**
  String todayDayN(int n);

  /// No description provided for @symTipTitle.
  ///
  /// In pt, this message translates to:
  /// **'Leve para sua consulta'**
  String get symTipTitle;

  /// No description provided for @symTipBody.
  ///
  /// In pt, this message translates to:
  /// **'Este padrão é feito só com os seus registros e pode ajudar seu profissional de saúde a entender sua adaptação.'**
  String get symTipBody;

  /// No description provided for @symDoseLogged.
  ///
  /// In pt, this message translates to:
  /// **'Aplicação registrada'**
  String get symDoseLogged;

  /// No description provided for @weightTag.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhamento metabólico'**
  String get weightTag;

  /// No description provided for @weightSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Registre seu peso e acompanhe a evolução com calma, sem julgamentos.'**
  String get weightSubtitle;

  /// No description provided for @weightThisWeek.
  ///
  /// In pt, this message translates to:
  /// **'Esta semana'**
  String get weightThisWeek;

  /// No description provided for @weightLowest.
  ///
  /// In pt, this message translates to:
  /// **'Menor registro'**
  String get weightLowest;

  /// No description provided for @weightPaceTitle.
  ///
  /// In pt, this message translates to:
  /// **'Seu ritmo'**
  String get weightPaceTitle;

  /// No description provided for @weightPaceBody.
  ///
  /// In pt, this message translates to:
  /// **'média de {kg} kg/semana desde o primeiro registro.'**
  String weightPaceBody(String kg);

  /// No description provided for @weightNewLog.
  ///
  /// In pt, this message translates to:
  /// **'Novo registro'**
  String get weightNewLog;

  /// No description provided for @weightLess.
  ///
  /// In pt, this message translates to:
  /// **'Menos 100 g'**
  String get weightLess;

  /// No description provided for @weightMore.
  ///
  /// In pt, this message translates to:
  /// **'Mais 100 g'**
  String get weightMore;

  /// No description provided for @weightConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Confirmar aferição'**
  String get weightConfirm;

  /// No description provided for @weightLogsCount.
  ///
  /// In pt, this message translates to:
  /// **'{n} registros'**
  String weightLogsCount(int n);

  /// No description provided for @weightLatest.
  ///
  /// In pt, this message translates to:
  /// **'Últimos registros'**
  String get weightLatest;

  /// No description provided for @weightSeeAll.
  ///
  /// In pt, this message translates to:
  /// **'Ver histórico completo ({n})'**
  String weightSeeAll(int n);

  /// No description provided for @leanTitle.
  ///
  /// In pt, this message translates to:
  /// **'Proteção de massa magra'**
  String get leanTitle;

  /// No description provided for @leanSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Proteína e treino de força'**
  String get leanSubtitle;

  /// No description provided for @leanBody.
  ///
  /// In pt, this message translates to:
  /// **'Durante a perda de peso, proteína suficiente e treinos de força ajudam a preservar os músculos:'**
  String get leanBody;

  /// No description provided for @leanProtein.
  ///
  /// In pt, this message translates to:
  /// **'Ingestão de proteína hoje'**
  String get leanProtein;

  /// No description provided for @leanWorkouts.
  ///
  /// In pt, this message translates to:
  /// **'Treinos de força semanais'**
  String get leanWorkouts;

  /// No description provided for @leanWorkoutsValue.
  ///
  /// In pt, this message translates to:
  /// **'{n} de {goal} concluídos'**
  String leanWorkoutsValue(int n, int goal);

  /// No description provided for @leanTip.
  ///
  /// In pt, this message translates to:
  /// **'Ingerir proteína fracionada em cada refeição ajuda na saciedade e na preservação dos músculos.'**
  String get leanTip;

  /// No description provided for @workoutsTag.
  ///
  /// In pt, this message translates to:
  /// **'Metabolismo ativo'**
  String get workoutsTag;

  /// No description provided for @workoutsThisWeek.
  ///
  /// In pt, this message translates to:
  /// **'Esta semana'**
  String get workoutsThisWeek;

  /// No description provided for @workoutsGoalFull.
  ///
  /// In pt, this message translates to:
  /// **'Excelente! Meta da semana (3 sessões) concluída.'**
  String get workoutsGoalFull;

  /// No description provided for @workoutsGoalMissing.
  ///
  /// In pt, this message translates to:
  /// **'{n, plural, =1{Mais 1 treino para a meta mínima da semana.} other{Mais {n} treinos para a meta mínima da semana.}}'**
  String workoutsGoalMissing(int n);

  /// No description provided for @workoutsWhyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Por que treinar força com GLP-1?'**
  String get workoutsWhyTitle;

  /// No description provided for @workoutsTemplatesTag.
  ///
  /// In pt, this message translates to:
  /// **'4 modelos'**
  String get workoutsTemplatesTag;

  /// No description provided for @workoutsSuggested.
  ///
  /// In pt, this message translates to:
  /// **'Sugerido para hoje'**
  String get workoutsSuggested;

  /// No description provided for @workoutsNoEquipment.
  ///
  /// In pt, this message translates to:
  /// **'Sem aparelhos'**
  String get workoutsNoEquipment;

  /// No description provided for @sessionN.
  ///
  /// In pt, this message translates to:
  /// **'Sessão {n}'**
  String sessionN(int n);

  /// No description provided for @sessionActiveTime.
  ///
  /// In pt, this message translates to:
  /// **'tempo ativo'**
  String get sessionActiveTime;

  /// No description provided for @sessionPause.
  ///
  /// In pt, this message translates to:
  /// **'Pausar cronômetro'**
  String get sessionPause;

  /// No description provided for @sessionResume.
  ///
  /// In pt, this message translates to:
  /// **'Retomar'**
  String get sessionResume;

  /// No description provided for @sessionPauseSession.
  ///
  /// In pt, this message translates to:
  /// **'Pausar sessão'**
  String get sessionPauseSession;

  /// No description provided for @sessionWater.
  ///
  /// In pt, this message translates to:
  /// **'Beba pequenos goles de água entre os movimentos.'**
  String get sessionWater;

  /// No description provided for @sessionSafetyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sentiu tontura ou náusea súbita?'**
  String get sessionSafetyTitle;

  /// No description provided for @setOf.
  ///
  /// In pt, this message translates to:
  /// **'Série {n} de {total}'**
  String setOf(int n, int total);

  /// No description provided for @upNext.
  ///
  /// In pt, this message translates to:
  /// **'A seguir'**
  String get upNext;

  /// No description provided for @repsN.
  ///
  /// In pt, this message translates to:
  /// **'{reps} repetições'**
  String repsN(String reps);

  /// No description provided for @current.
  ///
  /// In pt, this message translates to:
  /// **'(atual)'**
  String get current;

  /// No description provided for @setN.
  ///
  /// In pt, this message translates to:
  /// **'Série {n}'**
  String setN(int n);

  /// No description provided for @restLabel.
  ///
  /// In pt, this message translates to:
  /// **'Descanso entre séries'**
  String get restLabel;

  /// No description provided for @restButton.
  ///
  /// In pt, this message translates to:
  /// **'Descansar 45s'**
  String get restButton;

  /// No description provided for @settingsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Seu perfil, lembretes e privacidade'**
  String get settingsSubtitle;

  /// No description provided for @deleteSub.
  ///
  /// In pt, this message translates to:
  /// **'Apaga permanentemente tudo, inclusive a conta'**
  String get deleteSub;
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
