import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/format.dart';
import '../../core/notifications/notifications.dart';
import '../../core/supabase/supabase.dart';

class Treatment {
  Treatment({
    required this.id,
    required this.medication,
    required this.doseLabel,
    required this.weekday,
    required this.time,
    required this.active,
  });
  final String id;
  final String medication;
  final String doseLabel;
  final int weekday; // ISO 1=seg..7=dom
  final TimeOfDay time;
  final bool active;

  factory Treatment.fromJson(Map<String, dynamic> j) => Treatment(
        id: j['id'] as String,
        medication: j['medication'] as String,
        doseLabel: j['dose_label'] as String,
        weekday: j['weekday'] as int,
        time: parseTime(j['time_of_day'] as String),
        active: j['active'] as bool,
      );
}

class DoseLog {
  DoseLog({required this.takenAt, required this.doseLabel, this.site, this.note});
  final DateTime takenAt;
  final String doseLabel;
  final String? site; // abdomen | coxa | braco
  final String? note;

  factory DoseLog.fromJson(Map<String, dynamic> j) => DoseLog(
        takenAt: DateTime.parse(j['taken_at'] as String).toLocal(),
        doseLabel: j['dose_label'] as String,
        site: j['site'] as String?,
        note: j['note'] as String?,
      );
}

const doseSites = ['abdomen', 'coxa', 'braco'];

/// Próxima ocorrência (estritamente depois de [now]) do dia da semana + horário escolhidos.
DateTime nextOccurrence(int weekday, TimeOfDay t, DateTime now) {
  var d = DateTime(now.year, now.month, now.day, t.hour, t.minute);
  while (d.weekday != weekday || !d.isAfter(now)) {
    d = DateTime(d.year, d.month, d.day + 1, t.hour, t.minute);
  }
  return d;
}

class DosesRepository {
  Future<Treatment?> fetchTreatment() async {
    final row = await db.from('treatments').select().order('started_on', ascending: false).limit(1).maybeSingle();
    return row == null ? null : Treatment.fromJson(row);
  }

  Future<void> saveTreatment({
    required String id,
    required String doseLabel,
    required int weekday,
    required TimeOfDay time,
    required bool active,
  }) async {
    final row = await db
        .from('treatments')
        .update({'dose_label': doseLabel, 'weekday': weekday, 'time_of_day': '${fmtTime(time)}:00', 'active': active})
        .eq('id', id)
        .select()
        .single();
    await syncReminder(Treatment.fromJson(row), askPermission: true);
  }

  /// Reagenda (ou cancela) o lembrete local a partir do tratamento salvo.
  Future<void> syncReminder(Treatment? t, {bool askPermission = false}) async {
    if (t == null || !t.active) return Notifications.cancelDose();
    await Notifications.scheduleWeeklyDose(
      first: nextOccurrence(t.weekday, t.time, DateTime.now()),
      medication: t.medication,
      dose: t.doseLabel,
      askPermission: askPermission,
    );
  }

  Future<List<DoseLog>> fetchLogs() async {
    final rows = await db.from('dose_logs').select().order('taken_at', ascending: false).limit(200);
    return rows.map(DoseLog.fromJson).toList();
  }

  Future<void> addLog({String? treatmentId, required String doseLabel, String? site, String? note}) =>
      db.from('dose_logs').insert({
        'treatment_id': treatmentId,
        'dose_label': doseLabel,
        'site': site,
        'note': note,
      });
}

final dosesRepositoryProvider = Provider((ref) => DosesRepository());

final treatmentProvider = FutureProvider<Treatment?>((ref) {
  ref.watch(userIdProvider);
  return ref.watch(dosesRepositoryProvider).fetchTreatment();
});

final doseLogsProvider = FutureProvider<List<DoseLog>>((ref) {
  ref.watch(userIdProvider);
  return ref.watch(dosesRepositoryProvider).fetchLogs();
});
