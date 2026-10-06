import 'package:companheiro_glp1/app.dart';
import 'package:companheiro_glp1/demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  testWidgets('modo demo: entra sem login, faz onboarding e navega por todas as abas', (tester) async {
    await initializeDateFormatting('pt_BR');
    tester.view.physicalSize = const Size(1000, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(ProviderScope(overrides: demoOverrides, child: const App()));
    await tester.pumpAndSettle();

    Future<void> next() async {
      await tester.tap(find.byKey(const ValueKey('ob_continue')));
      await tester.pumpAndSettle();
    }

    await tester.tap(find.byKey(const ValueKey('ob_consent')));
    await tester.pump();
    await next();
    await tester.enterText(find.byKey(const ValueKey('ob_name')), 'Ana');
    await tester.enterText(find.byKey(const ValueKey('ob_year')), '1990');
    await tester.enterText(find.byKey(const ValueKey('ob_height')), '165');
    await tester.enterText(find.byKey(const ValueKey('ob_weight')), '70');
    await tester.pump();
    await next();
    await tester.enterText(find.byKey(const ValueKey('ob_dose')), '0,5 mg');
    await tester.pump();
    await next();
    await next();

    expect(find.textContaining(', Ana'), findsOneWidget);
    expect(find.text('Próxima aplicação'), findsOneWidget);

    for (final tab in ['Proteína', 'Sintomas', 'Treinos', 'Perfil', 'Hoje']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
  });
}
