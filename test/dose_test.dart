import 'package:companheiro_glp1/features/doses/doses_repository.dart';
import 'package:companheiro_glp1/features/doses/doses_screen.dart';
import 'package:companheiro_glp1/features/onboarding/onboarding_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

class FakeDosesRepository extends DosesRepository {
  final logs = <DoseLog>[];
  String? lastTreatmentId;

  @override
  Future<Treatment?> fetchTreatment() async => Treatment(
        id: 't1',
        medication: 'Ozempic',
        doseLabel: '0,5 mg',
        weekday: 7,
        time: const TimeOfDay(hour: 20, minute: 0),
        active: true,
      );

  @override
  Future<List<DoseLog>> fetchLogs() async => logs.reversed.toList();

  @override
  Future<void> addLog({String? treatmentId, required String doseLabel, String? site, String? note}) async {
    lastTreatmentId = treatmentId;
    logs.add(DoseLog(takenAt: DateTime.now(), doseLabel: doseLabel, site: site, note: note));
  }
}

void main() {
  testWidgets('registrar aplicação cria dose_log e aparece no histórico', (tester) async {
    final repo = FakeDosesRepository();
    await pumpScreen(tester, const DosesScreen(), overrides: [
      dosesRepositoryProvider.overrideWithValue(repo),
      profileProvider.overrideWith((ref) async => Profile(name: 'Marina', proteinGoalG: 100)),
    ]);

    expect(find.text('Nenhuma aplicação registrada ainda.'), findsOneWidget);
    expect(find.textContaining('(Domingo, 20:00)'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('dose_register')));
    await tester.pumpAndSettle();

    // Dose vem preenchida do agendamento (texto livre, editável).
    expect(tester.widget<TextField>(find.byKey(const ValueKey('dose_label'))).controller!.text, '0,5 mg');
    await tester.tap(find.text('Coxa (Esq / Dir)'));
    await tester.enterText(find.byKey(const ValueKey('dose_note')), 'sem desconforto');
    await tester.tap(find.byKey(const ValueKey('dose_confirm')));
    await tester.pumpAndSettle();

    expect(repo.logs, hasLength(1));
    expect(repo.logs.single.doseLabel, '0,5 mg');
    expect(repo.logs.single.site, 'coxa');
    expect(repo.logs.single.note, 'sem desconforto');
    expect(repo.lastTreatmentId, 't1');

    // Histórico atualizado.
    expect(find.text('Nenhuma aplicação registrada ainda.'), findsNothing);
    expect(find.text('“sem desconforto”'), findsOneWidget);
  });
}
