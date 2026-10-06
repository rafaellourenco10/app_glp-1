import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/notifications/notifications.dart';
import 'core/supabase/supabase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    // Erro de configuração de quem está rodando o projeto (não aparece para o usuário final).
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Configuração ausente: crie o arquivo .env (copie de .env.example) com SUPABASE_URL e '
              'SUPABASE_ANON_KEY e rode com --dart-define-from-file=.env (o F5 do VS Code já faz isso).',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ));
    return;
  }
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);
  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR';
  await Notifications.init();
  runApp(const ProviderScope(child: App()));
}
