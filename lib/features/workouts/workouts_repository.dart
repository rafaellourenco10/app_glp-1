import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/format.dart';
import '../../core/supabase/supabase.dart';

class Exercise {
  Exercise({required this.name, required this.sets, required this.reps, this.note, this.url});
  final String name;
  final int sets;
  final String reps;
  final String? note;
  final String? url;
}

class WorkoutTemplate {
  WorkoutTemplate({required this.id, required this.name, required this.level, required this.location, required this.exercises});
  final int id;
  final String name;
  final String level; // iniciante | intermediario
  final String location; // casa | academia
  final List<Exercise> exercises;

  factory WorkoutTemplate.fromJson(Map<String, dynamic> j) {
    final ex = (j['workout_template_exercises'] as List).cast<Map<String, dynamic>>()
      ..sort((a, b) => (a['position'] as int).compareTo(b['position'] as int));
    return WorkoutTemplate(
      id: j['id'] as int,
      name: j['name'] as String,
      level: j['level'] as String,
      location: j['location'] as String,
      exercises: [
        for (final e in ex)
          Exercise(
            name: e['name'] as String,
            sets: e['sets'] as int,
            reps: e['reps'] as String,
            note: e['note'] as String?,
            url: e['url'] as String?,
          ),
      ],
    );
  }
}

class WorkoutSession {
  WorkoutSession({required this.templateId, required this.doneAt, required this.doneCount});
  final int? templateId;
  final DateTime doneAt;
  final int doneCount;

  factory WorkoutSession.fromJson(Map<String, dynamic> j) => WorkoutSession(
        templateId: j['template_id'] as int?,
        doneAt: DateTime.parse(j['done_at'] as String).toLocal(),
        doneCount: (j['workout_session_exercises'] as List).where((e) => e['done'] == true).length,
      );
}

/// Segunda-feira 00:00 da semana de [now].
DateTime weekStart(DateTime now) => dayOnly(now).subtract(Duration(days: now.weekday - 1));

/// Sugestão do dia: o modelo seguinte ao último treino feito (rodízio simples).
WorkoutTemplate? suggestedTemplate(List<WorkoutTemplate> templates, List<WorkoutSession> sessions) {
  if (templates.isEmpty) return null;
  final last = sessions.isEmpty ? null : sessions.first.templateId;
  final i = templates.indexWhere((t) => t.id == last);
  return templates[(i + 1) % templates.length];
}

class WorkoutsRepository {
  Future<List<WorkoutTemplate>> fetchTemplates() async {
    final rows = await db.from('workout_templates').select('*, workout_template_exercises(*)').order('id');
    return rows.map(WorkoutTemplate.fromJson).toList();
  }

  /// Mais recentes primeiro.
  Future<List<WorkoutSession>> fetchSessions() async {
    final rows = await db
        .from('workout_sessions')
        .select('template_id, done_at, workout_session_exercises(done)')
        .order('done_at', ascending: false)
        .limit(50);
    return rows.map(WorkoutSession.fromJson).toList();
  }

  Future<void> finishSession(int templateId, Map<String, bool> exercises) async {
    final session = await db.from('workout_sessions').insert({'template_id': templateId}).select('id').single();
    await db.from('workout_session_exercises').insert([
      for (final e in exercises.entries) {'session_id': session['id'], 'exercise_name': e.key, 'done': e.value},
    ]);
  }
}

final workoutsRepositoryProvider = Provider((ref) => WorkoutsRepository());

final workoutTemplatesProvider = FutureProvider((ref) => ref.watch(workoutsRepositoryProvider).fetchTemplates());

final workoutSessionsProvider = FutureProvider<List<WorkoutSession>>((ref) {
  ref.watch(userIdProvider);
  return ref.watch(workoutsRepositoryProvider).fetchSessions();
});
