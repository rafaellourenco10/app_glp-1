import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

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
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final templates = ref.watch(workoutTemplatesProvider);
    final sessions = ref.watch(workoutSessionsProvider).value ?? const <WorkoutSession>[];
    final week = sessions.where((s) => !s.doneAt.isBefore(weekStart(DateTime.now()))).toList().reversed.toList();
    final suggested = suggestedTemplate(templates.value ?? const [], sessions);

    return ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 32), children: [
      StatusChip(l.workoutsTag.toUpperCase(), icon: Symbols.shield_with_heart, background: c.secondaryFixed.withValues(alpha: 0.5)),
      const SizedBox(height: 8),
      PageTitle(l.workoutsTitle, l.workoutsSubtitle),
      const SizedBox(height: 20),
      // Meta semanal
      SectionCard(
        shadow: shadowSm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            IconBadge(Symbols.fitness_center, iconSize: 20, bg: c.secondaryFixed.withValues(alpha: 0.4), fill: true),
            const SizedBox(width: 8),
            Expanded(child: Text(l.workoutsWeeklyGoal, style: t.titleSmall)),
            Text(l.workoutsThisWeek, style: t.labelMedium!.copyWith(color: c.primary, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 16),
          Text.rich(TextSpan(children: [
            TextSpan(text: '${week.length}', style: t.displayMedium!.copyWith(color: c.primary, height: 1)),
            TextSpan(text: ' / $weeklyGoal', style: t.headlineSmall!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w500)),
            TextSpan(text: '  ${l.workoutsSessionsDone}', style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
          ])),
          const SizedBox(height: 16),
          Row(children: [
            for (var i = 0; i < weeklyGoal; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(child: _SessionSlot(n: i + 1, done: i < week.length ? week[i] : null)),
            ],
          ]),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: c.surfaceContainerLow.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Icon(Symbols.spa, size: 18, color: c.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  week.length >= weeklyGoal
                      ? l.workoutsGoalFull
                      : week.length >= 2
                          ? l.workoutsGoalOk
                          : l.workoutsGoalMissing(2 - week.length),
                  style: t.labelMedium!.copyWith(color: c.onSurfaceVariant),
                ),
              ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      // Por que treinar
      Box(
        color: c.surfaceContainerLow,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconBadge(Symbols.lightbulb, size: 40, iconSize: 22, bg: c.secondaryFixed, fg: c.onSecondaryFixed),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.workoutsWhyTitle, style: t.titleMedium),
              const SizedBox(height: 4),
              Text(l.workoutsWhy, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant, height: 1.6)),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(child: Text(l.workoutsTemplates, style: t.headlineSmall)),
        Text(l.workoutsTemplatesTag.toUpperCase(), style: t.labelSmall!.copyWith(color: c.primary, letterSpacing: 0.55)),
      ]),
      const SizedBox(height: 12),
      ...templates.when(
        loading: () => [const Center(child: CircularProgressIndicator())],
        error: (_, _) => [ErrorRetry(onRetry: () => ref.invalidate(workoutTemplatesProvider))],
        data: (list) => [
          if (suggested != null) _FeaturedCard(suggested),
          for (final w in list)
            if (w.id != suggested?.id) _TemplateCard(w),
        ],
      ),
      const SizedBox(height: 8),
      Row(children: [Expanded(child: Text(l.workoutsHistory, style: t.headlineSmall))]),
      const SizedBox(height: 10),
      SectionCard(
        shadow: shadowSm,
        padding: const EdgeInsets.all(16),
        child: sessions.isEmpty
            ? Text(l.workoutsHistoryEmpty, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant))
            : Column(children: [
                for (final (i, s) in sessions.take(6).indexed) ...[
                  if (i > 0) const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      IconBadge(Symbols.check_circle, size: 40, iconSize: 20, fg: c.onPrimaryFixed, fill: true),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_templateName(l, templates.value, s.templateId),
                              overflow: TextOverflow.ellipsis, style: t.titleMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.3)),
                          Text('${weekdayName(s.doneAt.weekday)} • ${_templateLevel(l, templates.value, s.templateId)}${l.workoutsExercisesDone(s.doneCount)}',
                              style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
                        ]),
                      ),
                      Icon(Symbols.chevron_right, size: 20, color: c.outlineVariant),
                    ]),
                  ),
                ],
              ]),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: c.surfaceContainerLow.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Icon(Symbols.water_drop, size: 22, color: c.secondary),
          const SizedBox(width: 12),
          Expanded(child: Text(l.workoutsSafety, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant))),
        ]),
      ),
    ]);
  }

  String _templateName(AppLocalizations l, List<WorkoutTemplate>? all, int? id) {
    final w = all?.where((t) => t.id == id).firstOrNull;
    return w?.name ?? l.tabWorkouts;
  }

  String _templateLevel(AppLocalizations l, List<WorkoutTemplate>? all, int? id) {
    final w = all?.where((t) => t.id == id).firstOrNull;
    return w == null ? '' : '${levelLabel(l, w.level)} • ';
  }
}

class _SessionSlot extends StatelessWidget {
  const _SessionSlot({required this.n, this.done});
  final int n;
  final WorkoutSession? done;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final t = context.t;
    final l = context.l;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: done != null ? c.surfaceContainerLow : c.surfaceContainer, borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        IconBadge(done != null ? Symbols.check : Symbols.schedule,
            size: 28, iconSize: 18, bg: done != null ? c.primaryContainer : c.surfaceContainerHighest, fg: done != null ? c.onPrimary : c.primary),
        const SizedBox(height: 6),
        Text(l.sessionN(n), style: t.labelSmall!.copyWith(color: done != null ? c.onSurface : c.primary)),
        Text(done != null ? weekdayName(done!.doneAt.weekday).split('-').first : l.pending,
            textAlign: TextAlign.center, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

Widget _tag(BuildContext context, String text, {IconData? icon, bool accent = false}) {
  final c = context.c;
  return Pill(text,
      icon: icon,
      background: accent ? c.secondaryFixed.withValues(alpha: 0.5) : c.surfaceContainerHigh,
      foreground: accent ? c.secondary : c.onSurfaceVariant,
      style: context.t.labelSmall!.copyWith(fontWeight: accent ? FontWeight.w600 : FontWeight.w500));
}

/// Card do treino sugerido do dia: foto + selo "Recomendado para hoje".
class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard(this.w);
  final WorkoutTemplate w;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SectionCard(
        shadow: shadowSm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 128,
              child: Stack(fit: StackFit.expand, children: [
                Image.asset('assets/images/workout_home.jpg', fit: BoxFit.cover),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [c.surfaceContainerLowest, c.surfaceContainerLowest.withValues(alpha: 0.3), Colors.transparent],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 10,
                  child: Pill(l.workoutsSuggested, icon: Symbols.star, background: c.primaryContainer, foreground: c.onPrimary),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          Text(w.name, style: t.titleMedium),
          const SizedBox(height: 2),
          Text(w.exercises.map((e) => e.name).join(', '), style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
          const SizedBox(height: 14),
          Wrap(spacing: 6, runSpacing: 6, children: [
            _tag(context, locationLabel(l, w.location), icon: w.location == 'casa' ? Symbols.home : Symbols.domain),
            _tag(context, levelLabel(l, w.level), icon: Symbols.energy_savings_leaf),
            _tag(context, l.workoutsExerciseCount(w.exercises.length), icon: Symbols.timer),
            if (w.location == 'casa') _tag(context, l.workoutsNoEquipment, icon: Symbols.verified, accent: true),
          ]),
          const SizedBox(height: 14),
          PrimaryButton(
            label: l.workoutsStart,
            trailing: Symbols.arrow_forward,
            color: c.primaryContainer,
            shadow: shadowSm,
            onPressed: () => context.push('/workout/${w.id}'),
          ),
        ]),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard(this.w);
  final WorkoutTemplate w;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SectionCard(
        shadow: shadowSm,
        onTap: () => context.push('/workout/${w.id}'),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(w.name, style: t.titleMedium),
                const SizedBox(height: 2),
                Text(w.exercises.map((e) => e.name).join(', '),
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
              ]),
            ),
            const SizedBox(width: 8),
            IconBadge(w.location == 'casa' ? Symbols.home : Symbols.domain, size: 36, iconSize: 20, bg: c.surfaceContainer, fg: c.onSurfaceVariant),
          ]),
          const SizedBox(height: 12),
          Wrap(spacing: 6, runSpacing: 6, children: [
            _tag(context, locationLabel(l, w.location)),
            _tag(context, levelLabel(l, w.level)),
            _tag(context, l.workoutsExerciseCount(w.exercises.length)),
          ]),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: c.surfaceContainer, borderRadius: BorderRadius.circular(99)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(l.workoutsStart, style: t.labelMedium!.copyWith(color: c.primary, fontWeight: FontWeight.w600)),
                Icon(Symbols.chevron_right, size: 16, color: c.primary),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
