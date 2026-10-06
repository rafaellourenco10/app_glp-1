import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/widgets.dart';
import 'workouts_repository.dart';
import 'workouts_screen.dart';

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key, required this.templateId});
  final int templateId;

  @override
  ConsumerState<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  final _done = <String>{};
  bool _saving = false;

  Future<void> _finish(WorkoutTemplate w) async {
    setState(() => _saving = true);
    try {
      await ref.read(workoutsRepositoryProvider).finishSession(w.id, {
        for (final e in w.exercises) e.name: _done.contains(e.name),
      });
      ref.invalidate(workoutSessionsProvider);
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
        showError(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final w = ref.watch(workoutTemplatesProvider).value?.where((x) => x.id == widget.templateId).firstOrNull;
    if (w == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final n = w.exercises.length;
    return Scaffold(
      appBar: AppBar(title: Text(l.sessionTitle)),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: [
        SectionCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(w.name, style: t.headlineSmall),
            Text('${locationLabel(l, w.location)} · ${levelLabel(l, w.level)}', style: t.labelMedium),
            const SizedBox(height: 12),
            Text(l.sessionProgress(_done.length, n), style: t.labelMedium),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: _done.length / n, minHeight: 8, borderRadius: BorderRadius.circular(99)),
          ]),
        ),
        const SizedBox(height: 16),
        for (final e in w.exercises)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: CheckboxListTile(
              value: _done.contains(e.name),
              onChanged: (v) => setState(() => v! ? _done.add(e.name) : _done.remove(e.name)),
              title: Text(e.name, style: t.titleMedium),
              subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.setsReps(e.sets, e.reps), style: t.labelMedium?.copyWith(color: c.primary)),
                if (e.note != null) Text(e.note!),
                if (e.url != null) SelectableText(e.url!, style: TextStyle(color: c.primary)),
              ]),
              isThreeLine: e.note != null,
            ),
          ),
        const SizedBox(height: 8),
        InfoBox(l.sessionSafety, icon: Icons.health_and_safety_outlined),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _saving ? null : () => _finish(w),
          icon: const Icon(Icons.check_circle_outline),
          label: Text(l.sessionFinish),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: c.error),
          child: Text(l.sessionDiscard),
        ),
      ]),
    );
  }
}
