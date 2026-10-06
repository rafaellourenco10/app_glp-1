import 'package:companheiro_glp1/features/symptoms/symptoms_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final doses = [DateTime(2026, 10, 4, 20), DateTime(2026, 10, 11, 21)];

  test('daysSinceDose usa a última aplicação anterior', () {
    expect(daysSinceDose(DateTime(2026, 10, 4, 19), doses), isNull); // antes da 1ª dose
    expect(daysSinceDose(DateTime(2026, 10, 4, 22), doses), 0);
    expect(daysSinceDose(DateTime(2026, 10, 7, 8), doses), 3);
    expect(daysSinceDose(DateTime(2026, 10, 11, 20), doses), 7); // ainda antes da 2ª
    expect(daysSinceDose(DateTime(2026, 10, 12, 9), doses), 1);
  });

  test('severityByDoseDay calcula média por dia e agrupa D7+', () {
    SymptomLog s(DateTime at, int sev) => SymptomLog(loggedAt: at, symptom: 'nausea', severity: sev);
    final avg = severityByDoseDay([
      s(DateTime(2026, 10, 5, 8), 2),
      s(DateTime(2026, 10, 12, 8), 3), // também D1
      s(DateTime(2026, 10, 11, 8), 1), // D7
      s(DateTime(2026, 10, 1), 3), // sem dose antes: ignorado
    ], doses);
    expect(avg[1], 2.5);
    expect(avg[7], 1);
    expect(avg[0], isNull);
  });
}
