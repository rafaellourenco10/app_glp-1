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
}
