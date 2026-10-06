import 'package:companheiro_glp1/features/onboarding/onboarding_repository.dart';
import 'package:companheiro_glp1/features/protein/protein_repository.dart';
import 'package:companheiro_glp1/features/protein/protein_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

class FakeProteinRepository extends ProteinRepository {
  final now = DateTime.now();
  late final logs = <ProteinLog>[
    ProteinLog(id: '1', loggedAt: now.subtract(const Duration(days: 1)), label: 'Ontem', qty: 1, proteinG: 50),
    ProteinLog(id: '2', loggedAt: now, label: 'Whey', qty: 1, proteinG: 24),
    ProteinLog(id: '3', loggedAt: now, label: 'Omelete', qty: 1, proteinG: 12.5),
  ];

  @override
  Future<List<Food>> fetchFoods() async => [
        Food(id: 1, name: 'Ovo cozido', portionLabel: '1 unidade (50 g)', proteinG: 6),
        Food(id: 2, name: 'Feijão carioca cozido', portionLabel: '1 concha (140 g)', proteinG: 7),
      ];

  @override
  Future<List<ProteinLog>> fetchLast7Days() async => List.of(logs);

  @override
  Future<void> add({required String label, required double qty, required double proteinG, int? foodId}) async =>
      logs.add(ProteinLog(id: '${logs.length + 1}', loggedAt: DateTime.now(), label: label, qty: qty, proteinG: proteinG));
}

void main() {
  test('dailyTotals soma por dia e ignora fora da janela', () {
    final today = DateTime(2026, 10, 6, 12);
    ProteinLog p(DateTime at, double g) => ProteinLog(id: '', loggedAt: at, label: '', qty: 1, proteinG: g);
    final totals = dailyTotals([
      p(DateTime(2026, 10, 6, 0, 5), 10),
      p(DateTime(2026, 10, 6, 23, 59), 20.5),
      p(DateTime(2026, 10, 5, 23, 59), 7),
      p(DateTime(2026, 9, 29, 23), 99), // 7 dias atrás: fora
    ], today);
    expect(totals.last, 30.5);
    expect(totals[5], 7);
    expect(totals.reduce((a, b) => a + b), 37.5);
  });

  testWidgets('registrar proteína atualiza a soma do dia', (tester) async {
    final repo = FakeProteinRepository();
    await pumpScreen(tester, const ProteinScreen(), overrides: [
      proteinRepositoryProvider.overrideWithValue(repo),
      profileProvider.overrideWith((ref) async => Profile(name: 'Marina', proteinGoalG: 100)),
    ]);

    Finder total(String s) => find.descendant(of: find.byKey(const ValueKey('protein_today_total')), matching: find.text(s));

    // Só os de hoje: 24 + 12,5 (o de ontem não entra).
    expect(total('2 itens • 36,5 g'), findsOneWidget);

    // Alimento da tabela, 1,5 porção de feijão (7 g) = 10,5 g. Busca sem acento.
    await tester.enterText(find.byType(TextField).first, 'feijao');
    await tester.pump();
    expect(find.text('Ovo cozido'), findsNothing);
    await tester.tap(find.byTooltip('Adicionar Feijão carioca cozido'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Mais meia porção'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Adicionar'));
    await tester.pumpAndSettle();
    expect(total('3 itens • 47 g'), findsOneWidget);

    // Lançamento manual: 30 g.
    await tester.tap(find.text('Registro Manual'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('protein_manual_label')), 'Frango');
    await tester.enterText(find.byKey(const ValueKey('protein_manual_grams')), '30');
    await tester.tap(find.byKey(const ValueKey('protein_manual_add')));
    await tester.pumpAndSettle();

    expect(total('4 itens • 77 g'), findsOneWidget);
    expect(find.text('Faltam 23 g'), findsOneWidget);
    expect(repo.logs.last.proteinG, 30);
  });
}
