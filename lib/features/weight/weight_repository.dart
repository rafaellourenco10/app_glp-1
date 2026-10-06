import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/supabase/supabase.dart';

class WeightLog {
  WeightLog({required this.loggedAt, required this.kg});
  final DateTime loggedAt;
  final double kg;

  factory WeightLog.fromJson(Map<String, dynamic> j) => WeightLog(
        loggedAt: DateTime.parse(j['logged_at'] as String).toLocal(),
        kg: (j['kg'] as num).toDouble(),
      );
}

class WeightRepository {
  /// Do mais antigo ao mais recente.
  Future<List<WeightLog>> fetchLogs() async {
    final rows = await db.from('weight_logs').select().order('logged_at').limit(1000);
    return rows.map(WeightLog.fromJson).toList();
  }

  Future<void> add(double kg) => db.from('weight_logs').insert({'kg': kg});
}

final weightRepositoryProvider = Provider((ref) => WeightRepository());

final weightLogsProvider = FutureProvider<List<WeightLog>>((ref) {
  ref.watch(userIdProvider);
  return ref.watch(weightRepositoryProvider).fetchLogs();
});
