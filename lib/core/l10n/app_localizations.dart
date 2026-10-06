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
