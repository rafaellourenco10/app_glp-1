import 'package:companheiro_glp1/features/onboarding/onboarding_repository.dart';
import 'package:companheiro_glp1/features/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

class FakeOnboardingRepository extends OnboardingRepository {
  OnboardingData? saved;

  @override
  Future<Profile?> fetchProfile() async => null;

  @override
  Future<void> complete(OnboardingData d) async => saved = d;
}

void main() {
  testWidgets('onboarding exige consentimento, sugere 1,2 g/kg e salva tudo', (tester) async {
    final repo = FakeOnboardingRepository();
    await pumpScreen(tester, const OnboardingScreen(),
        overrides: [onboardingRepositoryProvider.overrideWithValue(repo)]);

    FilledButton continueBtn() =>
        tester.widget<FilledButton>(find.descendant(of: find.byKey(const ValueKey('ob_continue')), matching: find.byType(FilledButton)));
    Future<void> next() async {
      await tester.tap(find.byKey(const ValueKey('ob_continue')));
      await tester.pumpAndSettle();
    }

    // Etapa 1: disclaimer visível e aceite obrigatório.
    expect(find.textContaining('não substitui orientação de médico ou nutricionista'), findsOneWidget);
    expect(continueBtn().onPressed, isNull);
    await tester.tap(find.byKey(const ValueKey('ob_consent')));
    await tester.pump();
    expect(continueBtn().onPressed, isNotNull);
    await next();

    // Etapa 2: dados básicos.
    expect(continueBtn().onPressed, isNull);
    await tester.enterText(find.byKey(const ValueKey('ob_name')), 'Marina Silva');
    await tester.enterText(find.byKey(const ValueKey('ob_year')), '1992');
    await tester.enterText(find.byKey(const ValueKey('ob_height')), '168');
    await tester.enterText(find.byKey(const ValueKey('ob_weight')), '80');
    await tester.pump();
    await next();

    // Etapa 3: medicação, dose em texto livre, dia e horário.
    await tester.tap(find.byKey(const ValueKey('ob_med')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mounjaro (Tirzepatida)').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('ob_dose')), '2,5 mg');
    await tester.tap(find.text('Qua'));
    await tester.pump();
    await next();

    // Etapa 4: 80 kg × 1,2 = 96 g, editável em passos de 5 g.
    expect(find.textContaining('Valor de referência, converse com seu profissional de saúde.'), findsOneWidget);
    expect(find.textContaining('96'), findsWidgets);
    await tester.tap(find.byTooltip('Aumentar 5 g'));
    await tester.pump();
    await next();

    final d = repo.saved!;
    expect(d.name, 'Marina Silva');
    expect(d.birthYear, 1992);
    expect(d.heightCm, 168);
    expect(d.weightKg, 80);
    expect(d.medication, 'Mounjaro');
    expect(d.doseLabel, '2,5 mg');
    expect(d.weekday, 3); // quarta (ISO)
    expect(d.time, const TimeOfDay(hour: 20, minute: 0));
    expect(d.proteinGoalG, 101);
  });
}
