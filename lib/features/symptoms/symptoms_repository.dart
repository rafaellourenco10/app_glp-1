import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/format.dart';
import '../../core/supabase/supabase.dart';

const symptoms = [
  'nausea', 'vomito', 'constipacao', 'diarreia', 'refluxo', 'fadiga', 'falta_apetite', 'dor_cabeca', 'tontura', //
];

class SymptomLog {
  SymptomLog({required this.loggedAt, required this.symptom, required this.severity, this.note});
  final DateTime loggedAt;
  final String symptom;
  final int severity; // 0..3
  final String? note;

  factory SymptomLog.fromJson(Map<String, dynamic> j) => SymptomLog(
        loggedAt: DateTime.parse(j['logged_at'] as String).toLocal(),
        symptom: j['symptom'] as String,
        severity: j['severity'] as int,
        note: j['note'] as String?,
      );
}

/// Dias (de calendário) entre a última aplicação anterior a [at] e [at]. Null se não houver aplicação antes.
int? daysSinceDose(DateTime at, Iterable<DateTime> doses) {
  DateTime? last;
  for (final d in doses) {
    if (!d.isAfter(at) && (last == null || d.isAfter(last))) last = d;
  }
  return last == null ? null : dayOnly(at).difference(dayOnly(last)).inDays;
}

/// Intensidade média por dia desde a dose: índices 0..6 = D0..D6, 7 = D7 ou mais. Null = sem registros.
List<double?> severityByDoseDay(Iterable<SymptomLog> logs, Iterable<DateTime> doses) {
  final sum = List<double>.filled(8, 0);
  final count = List<int>.filled(8, 0);
  for (final s in logs) {
    final d = daysSinceDose(s.loggedAt, doses);
    if (d == null) continue;
    final i = d > 7 ? 7 : d;
    sum[i] += s.severity;
    count[i]++;
  }
  return [for (var i = 0; i < 8; i++) count[i] == 0 ? null : sum[i] / count[i]];
}

class SymptomsRepository {
  Future<List<SymptomLog>> fetchLogs() async {
    final rows = await db.from('symptom_logs').select().order('logged_at', ascending: false).limit(300);
    return rows.map(SymptomLog.fromJson).toList();
  }

  Future<void> add({required String symptom, required int severity, String? note}) =>
      db.from('symptom_logs').insert({'symptom': symptom, 'severity': severity, 'note': note});
}

final symptomsRepositoryProvider = Provider((ref) => SymptomsRepository());

final symptomLogsProvider = FutureProvider<List<SymptomLog>>((ref) {
  ref.watch(userIdProvider);
  return ref.watch(symptomsRepositoryProvider).fetchLogs();
});
