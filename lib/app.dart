import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/l10n/app_localizations.dart';
import 'core/supabase/supabase.dart';
import 'core/theme/theme.dart';
import 'core/theme/widgets.dart';
import 'features/auth/login_screen.dart';
import 'features/home/home_shell.dart';
import 'features/onboarding/onboarding_repository.dart';
import 'features/onboarding/onboarding_screen.dart';

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
    return ref.watch(profileProvider).when(
          data: (p) => p == null ? const OnboardingScreen() : const HomeShell(),
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (_, _) => Scaffold(body: Center(child: ErrorRetry(onRetry: () => ref.invalidate(profileProvider)))),
        );
  }
}
