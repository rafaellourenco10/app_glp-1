import 'package:companheiro_glp1/core/l10n/app_localizations.dart';
import 'package:companheiro_glp1/core/supabase/supabase.dart';
import 'package:companheiro_glp1/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Monta [child] com tema, l10n pt e repositórios falsos (sem Supabase).
Future<void> pumpScreen(WidgetTester tester, Widget child, {List overrides = const []}) async {
  await initializeDateFormatting('pt_BR');
  tester.view.physicalSize = const Size(1000, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(ProviderScope(
    overrides: [userIdProvider.overrideWithValue('user-a'), ...overrides.cast()],
    child: MaterialApp(
      theme: lightTheme,
      locale: const Locale('pt'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(body: child),
    ),
  ));
  await tester.pumpAndSettle();
}
