import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../doses/doses_repository.dart';
import '../doses/doses_screen.dart';
import '../onboarding/onboarding_repository.dart';
import '../protein/protein_repository.dart';
import '../protein/protein_screen.dart';
import '../symptoms/symptoms_repository.dart';
import '../workouts/workouts_repository.dart';
import '../workouts/workouts_screen.dart';
import 'home_shell.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final name = ref.watch(profileProvider).value?.name ?? '';
    final treatment = ref.watch(treatmentProvider).value;
    final doses = ref.watch(doseLogsProvider).value ?? const <DoseLog>[];
    final goal = ref.watch(profileProvider).value?.proteinGoalG ?? 0;
    final now = DateTime.now();
    final totals = dailyTotals(ref.watch(proteinLogsProvider).value ?? const [], now);
    final shell = context.findAncestorStateOfType<HomeShellState>();
    final workout = suggestedTemplate(
      ref.watch(workoutTemplatesProvider).value ?? const [],
      ref.watch(workoutSessionsProvider).value ?? const [],
    );
    final cycleDay = daysSinceDose(now, doses.map((d) => d.takenAt));
    final greeting = now.hour < 12 ? l.goodMorning : now.hour < 18 ? l.goodAfternoon : l.goodEvening;
    final pct = goal <= 0 ? 0 : (totals.last / goal * 100).round();
    final avg = totals.reduce((a, b) => a + b) / 7;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(treatmentProvider);
        ref.invalidate(doseLogsProvider);
        ref.invalidate(proteinLogsProvider);
      },
      child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: [
        // 1. Saudação
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (cycleDay != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(children: [
                      Container(width: 8, height: 8, decoration: BoxDecoration(color: c.secondaryFixedDim, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(l.homeCycleDay(cycleDay).toUpperCase(),
                          style: t.labelSmall!.copyWith(color: c.secondary, letterSpacing: 0.3)),
                    ]),
                  ),
                Text('$greeting, ${name.split(' ').first}', style: t.headlineLarge!.copyWith(letterSpacing: -0.65)),
                const SizedBox(height: 2),
                Text(l.homeHowAreYou, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
              ]),
            ),
            Stack(children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: c.surfaceContainerHigh, shape: BoxShape.circle, boxShadow: shadowSm),
                child: Avatar(name, size: 48),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle, border: Border.all(color: c.surface, width: 2)),
                  child: Icon(Symbols.check, size: 10, color: c.onPrimary, fill: 1),
                ),
              ),
            ]),
          ]),
        ),
        // 2. Próxima aplicação
        if (treatment != null) ...[
          NextDoseCard(
            treatment: treatment,
            onTap: () => context.push('/doses'),
            action: Box(
              radius: 99,
              padding: EdgeInsets.zero,
              color: c.surfaceContainerHigh,
              onTap: () => showDoseLogSheet(context, treatment),
              child: SizedBox(
                height: 52,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Symbols.check_circle, size: 20, color: c.primary),
                  const SizedBox(width: 8),
                  Text(l.doseRegister, style: t.titleMedium!.copyWith(color: c.primary)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        // 3. Meta de proteína
        SectionCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              const IconBadge(Symbols.nutrition),
              const SizedBox(width: 8),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.homeProteinTitle, style: t.titleMedium),
                  Text(l.homeProteinSubtitle, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
                ]),
              ),
              Pill(l.homeProteinPct(pct)),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              ProteinRing(
                consumed: totals.last,
                goal: goal,
                size: 112,
                center: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Symbols.fitness_center, size: 20, color: c.primary),
                  Text('${fmtNum(totals.last)}g', style: t.labelSmall!.copyWith(color: c.primary, fontWeight: FontWeight.w700)),
                ]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: '${fmtNum(totals.last)} g ', style: t.headlineSmall!.copyWith(fontWeight: FontWeight.w700)),
                    TextSpan(text: l.ofGoal(fmtNum(goal)), style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
                  ])),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: c.secondary, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text(
                      totals.last >= goal ? l.proteinGoalReached : l.homeProteinLeft(fmtNum(goal - totals.last)),
                      style: t.labelMedium!.copyWith(color: c.secondary, fontWeight: FontWeight.w600),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  Text(l.homeProteinTip, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w500)),
                ]),
              ),
            ]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: c.surfaceContainerLow.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                Row(children: [
                  Expanded(child: Text(l.homeLast7, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w500))),
                  Text(l.homeAvg(fmtNum(avg.roundToDouble())), style: t.labelSmall!.copyWith(color: c.primary, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 8),
                SizedBox(height: 64, child: MiniBars(totals: totals, goal: goal, today: now)),
              ]),
            ),
            const SizedBox(height: 16),
            Box(
              radius: 99,
              padding: EdgeInsets.zero,
              color: c.secondaryFixed.withValues(alpha: 0.5),
              onTap: () => shell?.goTo(1),
              child: SizedBox(
                height: 48,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Symbols.add, size: 20, color: c.onSecondaryFixed),
                  const SizedBox(width: 8),
                  Text(l.homeProteinLog, style: t.titleMedium!.copyWith(color: c.onSecondaryFixed)),
                ]),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        // 4. Atalhos
        Row(children: [
          for (final (i, (icon, label, semantics, onTap)) in [
            (Symbols.sentiment_satisfied, l.homeChipSymptom, l.homeLogSymptom, () => shell?.goTo(2)),
            (Symbols.scale, l.homeChipWeight, l.homeLogWeight, () => context.push('/weight')),
            (Symbols.fitness_center, l.homeChipWorkout, l.homeLogWorkout, () => shell?.goTo(3)),
          ].indexed) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Semantics(
                label: semantics,
                button: true,
                excludeSemantics: true,
                child: Box(
                  radius: 99,
                  padding: EdgeInsets.zero,
                  shadow: shadowSm,
                  onTap: onTap,
                  child: SizedBox(
                    height: 48,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(icon, size: 18, color: c.primary),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(label, overflow: TextOverflow.ellipsis, style: t.labelMedium!.copyWith(fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ]),
        const SizedBox(height: 16),
        // 5. Treino de hoje
        if (workout != null) ...[
          SectionCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                IconBadge(Symbols.exercise, bg: c.secondaryContainer.withValues(alpha: 0.6)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l.homeWorkoutTitle, style: t.titleMedium),
                    Text(l.homeWorkoutSub(levelLabel(l, workout.level), locationLabel(l, workout.location)),
                        style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
                  ]),
                ),
              ]),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Icon(Symbols.shield_with_heart, size: 20, color: c.secondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.homeWorkoutFocus, style: t.labelSmall!.copyWith(color: c.secondary, fontWeight: FontWeight.w700)),
                      Text(l.homeWorkoutFocusSub, style: t.labelSmall!.copyWith(fontSize: 10, color: c.onSurfaceVariant)),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              Row(children: [
                Icon(Symbols.timer, size: 16, color: c.secondary),
                const SizedBox(width: 4),
                Text(l.workoutsExerciseCount(workout.exercises.length), style: t.labelMedium!.copyWith(color: c.onSurfaceVariant)),
                const Spacer(),
                PrimaryButton(
                  label: l.homeWorkoutStart,
                  trailing: Symbols.play_arrow,
                  height: 48,
                  expand: false,
                  shadow: shadowSm,
                  onPressed: () => context.push('/workout/${workout.id}'),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 20),
        ],
        // 6. Rodapé
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l.homeFooter, textAlign: TextAlign.center, style: t.labelSmall!.copyWith(color: c.outline, height: 1.6)),
        ),
      ]),
    );
  }
}
