import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/l10n/app_localizations.dart';
import 'core/supabase/supabase.dart';
import 'core/theme/theme.dart';
import 'features/auth/login_screen.dart';

final _router = GoRouter(routes: [
  GoRoute(path: '/', builder: (_, _) => const Gate()),
]);

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      onGenerateTitle: (c) => AppLocalizations.of(c).appName,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: const Locale('pt'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
    );
  }
}

/// Decide entre login, onboarding e o app.
class Gate extends ConsumerWidget {
  const Gate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(userIdProvider) == null) return const LoginScreen();
    return const Scaffold(body: Center(child: Text('OK')));
  }
}
