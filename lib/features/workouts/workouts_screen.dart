import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import 'workouts_repository.dart';

/// Meta semanal: 2 a 3 sessões.
const weeklyGoal = 3;

String levelLabel(AppLocalizations l, String level) => level == 'iniciante' ? l.levelBeginner : l.levelIntermediate;
String locationLabel(AppLocalizations l, String loc) => loc == 'casa' ? l.locHome : l.locGym;

class WorkoutsScreen extends ConsumerWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final templates = ref.watch(workoutTemplatesProvider);
    final sessions = ref.watch(workoutSessionsProvider).value ?? const <WorkoutSession>[];
    final thisWeek = sessions.where((s) => !s.doneAt.isBefore(weekStart(DateTime.now()))).length;

    return ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: [
      Text(l.workoutsTitle, style: t.headlineLarge),
      Text(l.workoutsSubtitle, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
      const SizedBox(height: 16),
      SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CardHeader(icon: Icons.fitness_center, title: l.workoutsWeeklyGoal),
          const SizedBox(height: 12),
          Text.rich(TextSpan(children: [
            TextSpan(text: '$thisWeek', style: t.displayMedium?.copyWith(color: c.primary)),
            TextSpan(text: ' / $weeklyGoal  ', style: t.titleMedium),
            TextSpan(text: l.workoutsSessionsDone, style: t.bodyMedium),
          ])),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (thisWeek / weeklyGoal).clamp(0, 1),
            minHeight: 8,
            borderRadius: BorderRadius.circular(99),
          ),
          const SizedBox(height: 8),
          Text(thisWeek >= 2 ? l.workoutsGoalOk : l.workoutsGoalHint, style: t.labelMedium?.copyWith(color: c.onSurfaceVariant)),
        ]),
      ),
      const SizedBox(height: 16),
      InfoBox(l.workoutsWhy, icon: Icons.lightbulb_outline),
      const SizedBox(height: 24),
      Text(l.workoutsTemplates, style: t.headlineSmall),
      const SizedBox(height: 8),
      ...templates.when(
        loading: () => [const Center(child: CircularProgressIndicator())],
        error: (_, _) => [ErrorRetry(onRetry: () => ref.invalidate(workoutTemplatesProvider))],
        data: (list) => [for (final w in list) _TemplateCard(w)],
      ),
      const SizedBox(height: 24),
      Text(l.workoutsHistory, style: t.headlineSmall),
      const SizedBox(height: 8),
      if (sessions.isEmpty) Text(l.workoutsHistoryEmpty, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
      for (final s in sessions.take(10))
        Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.check_circle, color: c.secondary),
            title: Text(_templateName(l, templates.value, s.templateId)),
            subtitle: Text('${fmtDayDate(s.doneAt)} • ${l.workoutsExercisesDone(s.doneCount)}'),
          ),
        ),
      const SizedBox(height: 8),
      InfoBox(l.workoutsSafety, icon: Icons.water_drop_outlined),
    ]);
  }

  String _templateName(AppLocalizations l, List<WorkoutTemplate>? all, int? id) {
    final w = all?.where((t) => t.id == id).firstOrNull;
    return w == null ? l.tabWorkouts : '${w.name} · ${levelLabel(l, w.level)}';
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard(this.w);
  final WorkoutTemplate w;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(w.name, style: t.titleMedium),
          const SizedBox(height: 4),
          Text(w.exercises.map((e) => e.name).join(', '),
              maxLines: 2, overflow: TextOverflow.ellipsis, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 6, children: [
            Pill(locationLabel(l, w.location)),
            Pill(levelLabel(l, w.level)),
            Pill(l.workoutsExerciseCount(w.exercises.length)),
          ]),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => context.push('/workout/${w.id}'),
            icon: const Icon(Icons.play_arrow),
            label: Text(l.workoutsStart),
          ),
        ]),
      ),
    );
  }
}
