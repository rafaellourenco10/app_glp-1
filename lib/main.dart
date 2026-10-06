import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/notifications/notifications.dart';
import 'core/supabase/supabase.dart';
import 'demo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Sem .env: modo demonstração (sem login, dados em memória). Ver lib/demo.dart.
  final demo = supabaseUrl.isEmpty || supabaseAnonKey.isEmpty;
  if (!demo) await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);
  await initializeDateFormatting('pt_BR');
  Intl.defaultLocale = 'pt_BR';
  await Notifications.init();
  runApp(ProviderScope(overrides: demo ? demoOverrides : const [], child: const App()));
}
