import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../doses/doses_repository.dart';
import '../doses/doses_screen.dart';
import '../onboarding/onboarding_repository.dart';
import '../protein/protein_repository.dart';
import '../protein/protein_screen.dart';
import 'home_shell.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final name = ref.watch(profileProvider).value?.name ?? '';
    final treatment = ref.watch(treatmentProvider).value;
    final goal = ref.watch(profileProvider).value?.proteinGoalG ?? 0;
    final now = DateTime.now();
    final totals = dailyTotals(ref.watch(proteinLogsProvider).value ?? const [], now);
    final shell = context.findAncestorStateOfType<HomeShellState>();
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(treatmentProvider);
        ref.invalidate(proteinLogsProvider);
      },
      child: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: [
        Text(l.appName.toUpperCase(), style: t.labelSmall?.copyWith(color: c.primary, letterSpacing: 1)),
        const SizedBox(height: 8),
        Text(l.homeGreeting(name.split(' ').first), style: t.headlineLarge),
        Text(l.homeHowAreYou, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
        const SizedBox(height: 16),
        if (treatment != null) ...[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.push('/doses'),
            child: NextDoseCard(
              treatment: treatment,
              action: FilledButton.tonalIcon(
                onPressed: () => showDoseLogSheet(context, treatment),
                icon: const Icon(Icons.check_circle_outline),
                label: Text(l.doseRegister),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        SectionCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            CardHeader(
              icon: Icons.egg_outlined,
              title: l.homeProteinTitle,
              trailing: Pill(l.homeProteinPct(goal <= 0 ? 0 : (totals.last / goal * 100).round())),
            ),
            const SizedBox(height: 16),
            Row(children: [
              ProteinRing(consumed: totals.last, goal: goal),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.proteinOfGoal(fmtNum(totals.last), fmtNum(goal)), style: t.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    totals.last >= goal ? l.proteinGoalReached : l.proteinRemaining(fmtNum(goal - totals.last)),
                    style: t.labelMedium?.copyWith(color: c.secondary),
                  ),
                ]),
              ),
            ]),
            const SizedBox(height: 16),
            SizedBox(height: 90, child: WeeklyBars(totals: totals, goal: goal, today: now)),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => shell?.goTo(1),
              icon: const Icon(Icons.add),
              label: Text(l.homeProteinLog),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        Row(children: [
          for (final (icon, label, onTap) in [
            (Icons.sick_outlined, l.homeLogSymptom, () => shell?.goTo(2)),
            (Icons.scale_outlined, l.homeLogWeight, () => context.push('/weight')),
            (Icons.fitness_center, l.homeLogWorkout, () => shell?.goTo(3)),
          ])
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    backgroundColor: c.surfaceContainerLowest,
                    textStyle: t.labelMedium,
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(icon, size: 20),
                    Text(label, textAlign: TextAlign.center),
                  ]),
                ),
              ),
            ),
        ]),
        const SizedBox(height: 16),
        Text(l.disclaimer, textAlign: TextAlign.center, style: t.labelSmall?.copyWith(color: c.outline)),
      ]),
    );
  }
}
