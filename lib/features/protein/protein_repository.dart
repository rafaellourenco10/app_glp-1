import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/format.dart';
import '../../core/supabase/supabase.dart';

class Food {
  Food({required this.id, required this.name, required this.portionLabel, required this.proteinG});
  final int id;
  final String name;
  final String portionLabel;
  final double proteinG; // por porção

  factory Food.fromJson(Map<String, dynamic> j) => Food(
        id: j['id'] as int,
        name: j['name'] as String,
        portionLabel: j['portion_label'] as String,
        proteinG: (j['protein_g'] as num).toDouble(),
      );
}

class ProteinLog {
  ProteinLog({required this.id, required this.loggedAt, required this.label, required this.qty, required this.proteinG});
  final String id;
  final DateTime loggedAt;
  final String label;
  final double qty;
  final double proteinG; // total (já multiplicado pela qty)

  factory ProteinLog.fromJson(Map<String, dynamic> j) => ProteinLog(
        id: j['id'] as String,
        loggedAt: DateTime.parse(j['logged_at'] as String).toLocal(),
        label: j['label'] as String,
        qty: (j['qty'] as num).toDouble(),
        proteinG: (j['protein_g'] as num).toDouble(),
      );
}

/// Totais por dia, do mais antigo ao [today] (7 posições).
List<double> dailyTotals(Iterable<ProteinLog> logs, DateTime today) {
  final start = dayOnly(today).subtract(const Duration(days: 6));
  final totals = List<double>.filled(7, 0);
  for (final l in logs) {
    final i = dayOnly(l.loggedAt).difference(start).inDays;
    if (i >= 0 && i < 7) totals[i] += l.proteinG;
  }
  return totals;
}

/// Minúsculas e sem acento, para a busca ("feijao" acha "Feijão").
String normalize(String s) {
  const from = 'áàâãäéèêëíìîïóòôõöúùûüç';
  const to = 'aaaaaeeeeiiiiooooouuuuc';
  final lower = s.toLowerCase();
  final b = StringBuffer();
  for (final ch in lower.split('')) {
    final i = from.indexOf(ch);
    b.write(i < 0 ? ch : to[i]);
  }
  return b.toString();
}

class ProteinRepository {
  Future<List<Food>> fetchFoods() async {
    final rows = await db.from('foods').select().order('name');
    return rows.map(Food.fromJson).toList();
  }

  /// Registros dos últimos 7 dias (inclui hoje).
  Future<List<ProteinLog>> fetchLast7Days() async {
    final since = dayOnly(DateTime.now()).subtract(const Duration(days: 6));
    final rows = await db
        .from('protein_logs')
        .select()
        .gte('logged_at', since.toUtc().toIso8601String())
        .order('logged_at');
    return rows.map(ProteinLog.fromJson).toList();
  }

  Future<void> add({required String label, required double qty, required double proteinG, int? foodId}) =>
      db.from('protein_logs').insert({'label': label, 'qty': qty, 'protein_g': proteinG, 'food_id': foodId});

  Future<void> delete(String id) => db.from('protein_logs').delete().eq('id', id);
}

final proteinRepositoryProvider = Provider((ref) => ProteinRepository());

/// Catálogo em memória (público, não depende do usuário).
final foodsProvider = FutureProvider((ref) => ref.watch(proteinRepositoryProvider).fetchFoods());

final proteinLogsProvider = FutureProvider<List<ProteinLog>>((ref) {
  ref.watch(userIdProvider);
  return ref.watch(proteinRepositoryProvider).fetchLast7Days();
});
