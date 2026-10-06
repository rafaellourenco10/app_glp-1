import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../onboarding/onboarding_repository.dart';
import 'protein_repository.dart';

class ProteinScreen extends ConsumerStatefulWidget {
  const ProteinScreen({super.key});

  @override
  ConsumerState<ProteinScreen> createState() => _ProteinScreenState();
}

class _ProteinScreenState extends ConsumerState<ProteinScreen> {
  bool _manual = false;
  final _query = TextEditingController();
  final _label = TextEditingController();
  final _grams = TextEditingController();

  Future<void> _add({required String label, required double qty, required double proteinG, int? foodId}) async {
    try {
      await ref.read(proteinRepositoryProvider).add(label: label, qty: qty, proteinG: proteinG, foodId: foodId);
      ref.invalidate(proteinLogsProvider);
    } catch (_) {
      if (mounted) showError(context);
    }
  }

  Future<void> _addFood(Food f) async {
    final qty = await showDialog<double>(context: context, builder: (_) => _QtyDialog(food: f));
    if (qty != null) await _add(label: f.name, qty: qty, proteinG: f.proteinG * qty, foodId: f.id);
  }

  Future<void> _addManual() async {
    final g = parseNum(_grams.text);
    if (_label.text.trim().isEmpty || g == null || g < 0) return;
    await _add(label: _label.text.trim(), qty: 1, proteinG: g);
    _label.clear();
    _grams.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final goal = ref.watch(profileProvider).value?.proteinGoalG ?? 0;
    final logsAsync = ref.watch(proteinLogsProvider);

    return logsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => Center(child: ErrorRetry(onRetry: () => ref.invalidate(proteinLogsProvider))),
      data: (logs) {
        final now = DateTime.now();
        final totals = dailyTotals(logs, now);
        final today = logs.where((x) => dayOnly(x.loggedAt) == dayOnly(now)).toList().reversed.toList();
        return ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: [
          Text(l.tabProtein, style: t.headlineLarge),
          Text(l.proteinSubtitle, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
          const SizedBox(height: 16),
          SectionCard(
            child: Row(children: [
              ProteinRing(consumed: totals.last, goal: goal, size: 120),
              const SizedBox(width: 20),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.proteinGoal(fmtNum(goal)), style: t.titleMedium),
                  const SizedBox(height: 6),
                  Pill(
                    totals.last >= goal ? l.proteinGoalReached : l.proteinRemaining(fmtNum(goal - totals.last)),
                    background: c.secondaryContainer.withValues(alpha: 0.5),
                    foreground: c.onSecondaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(l.proteinReference, style: t.labelSmall?.copyWith(color: c.onSurfaceVariant)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.proteinWeekly, style: t.titleMedium),
              Text(l.proteinWeeklyAvg(fmtNum((totals.reduce((a, b) => a + b) / 7).roundToDouble()), fmtNum(goal)),
                  style: t.labelMedium?.copyWith(color: c.onSurfaceVariant)),
              const SizedBox(height: 16),
              SizedBox(height: 140, child: WeeklyBars(totals: totals, goal: goal, today: now)),
            ]),
          ),
          const SizedBox(height: 16),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l.proteinFoods), icon: const Icon(Icons.restaurant)),
              ButtonSegment(value: true, label: Text(l.proteinManual), icon: const Icon(Icons.edit_note)),
            ],
            selected: {_manual},
            onSelectionChanged: (s) => setState(() => _manual = s.first),
          ),
          const SizedBox(height: 16),
          if (_manual) ..._manualForm(l) else ..._foodList(l),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: Text(l.proteinToday, style: t.headlineSmall)),
            Pill(l.proteinTodayCount(today.length, fmtNum(totals.last)), key: const ValueKey('protein_today_total')),
          ]),
          const SizedBox(height: 8),
          if (today.isEmpty)
            Text(l.proteinTodayEmpty, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant))
          else
            for (final x in today) _LogTile(x),
        ]);
      },
    );
  }

  List<Widget> _foodList(AppLocalizations l) {
    final foods = ref.watch(foodsProvider);
    final q = normalize(_query.text.trim());
    return [
      TextField(
        controller: _query,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l.proteinSearch),
      ),
      const SizedBox(height: 8),
      ...foods.when(
        loading: () => [const Center(child: CircularProgressIndicator())],
        error: (_, _) => [ErrorRetry(onRetry: () => ref.invalidate(foodsProvider))],
        data: (all) => [
          for (final f in all.where((f) => normalize(f.name).contains(q)).take(30))
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(f.name),
                subtitle: Text(l.foodPortion(f.portionLabel, fmtNum(f.proteinG))),
                trailing: IconButton.filledTonal(
                  tooltip: l.proteinAddFood(f.name),
                  onPressed: () => _addFood(f),
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
        ],
      ),
    ];
  }

  List<Widget> _manualForm(AppLocalizations l) => [
        TextField(
          key: const ValueKey('protein_manual_label'),
          controller: _label,
          decoration: InputDecoration(labelText: l.proteinManualName),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey('protein_manual_grams'),
          controller: _grams,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l.proteinManualGrams, suffixText: 'g'),
        ),
        const SizedBox(height: 12),
        FilledButton(key: const ValueKey('protein_manual_add'), onPressed: _addManual, child: Text(l.proteinAdd)),
      ];
}

class _LogTile extends ConsumerWidget {
  const _LogTile(this.x);
  final ProteinLog x;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final time = fmtTime(TimeOfDay.fromDateTime(x.loggedAt));
    return Dismissible(
      key: ValueKey(x.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: c.error, borderRadius: BorderRadius.circular(20)),
        child: Icon(Icons.delete_outline, color: c.onError),
      ),
      // Apaga e espera a lista recarregar; o item some com os dados novos.
      confirmDismiss: (_) async {
        try {
          await ref.read(proteinRepositoryProvider).delete(x.id);
          ref.invalidate(proteinLogsProvider);
          await ref.read(proteinLogsProvider.future);
        } catch (_) {
          if (context.mounted) showError(context);
        }
        return false;
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(x.label),
          subtitle: Text(x.qty == 1 ? time : '$time • ${l.portions(fmtNum(x.qty))}'),
          trailing: Text('+${fmtNum(x.proteinG)} g', style: t.titleMedium?.copyWith(color: c.primary)),
        ),
      ),
    );
  }
}

class _QtyDialog extends StatefulWidget {
  const _QtyDialog({required this.food});
  final Food food;

  @override
  State<_QtyDialog> createState() => _QtyDialogState();
}

class _QtyDialogState extends State<_QtyDialog> {
  double _qty = 1;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final f = widget.food;
    return AlertDialog(
      title: Text(f.name),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(f.portionLabel),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton.filledTonal(
            tooltip: l.lessPortion,
            onPressed: _qty > 0.5 ? () => setState(() => _qty -= 0.5) : null,
            icon: const Icon(Icons.remove),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(l.portions(fmtNum(_qty)), style: Theme.of(context).textTheme.titleMedium),
          ),
          IconButton.filledTonal(
            tooltip: l.morePortion,
            onPressed: () => setState(() => _qty += 0.5),
            icon: const Icon(Icons.add),
          ),
        ]),
        const SizedBox(height: 12),
        Text('${fmtNum(f.proteinG * _qty)} g', style: Theme.of(context).textTheme.headlineSmall),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(context, _qty), child: Text(l.proteinAdd)),
      ],
    );
  }
}

/// Anel de progresso consumido/meta (Home e Proteína).
class ProteinRing extends StatelessWidget {
  const ProteinRing({super.key, required this.consumed, required this.goal, this.size = 112});
  final double consumed;
  final double goal;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final pct = goal <= 0 ? 0.0 : consumed / goal;
    return Semantics(
      label: AppLocalizations.of(context).proteinOfGoal(fmtNum(consumed), fmtNum(goal)),
      child: SizedBox.square(
        dimension: size,
        child: Stack(alignment: Alignment.center, children: [
          SizedBox.square(
            dimension: size,
            child: CircularProgressIndicator(
              value: min(pct, 1),
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              backgroundColor: c.surfaceContainer,
              color: c.primaryContainer,
            ),
          ),
          ExcludeSemantics(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('${fmtNum(consumed)} g', style: t.titleMedium),
              Text('${(pct * 100).round()}%', style: t.labelSmall?.copyWith(color: c.primary)),
            ]),
          ),
        ]),
      ),
    );
  }
}

/// Barras dos últimos 7 dias com linha tracejada da meta.
class WeeklyBars extends StatelessWidget {
  const WeeklyBars({super.key, required this.totals, required this.goal, required this.today});
  final List<double> totals;
  final double goal;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    final names = l.weekdaysShort.split(',');
    final maxY = [...totals, goal].reduce(max) * 1.15 + 1;
    return BarChart(BarChartData(
      maxY: maxY,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barTouchData: BarTouchData(enabled: false),
      extraLinesData: ExtraLinesData(horizontalLines: [
        if (goal > 0) HorizontalLine(y: goal, color: c.outline, strokeWidth: 1, dashArray: [4, 4]),
      ]),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            getTitlesWidget: (v, _) {
              final i = v.toInt();
              final d = today.subtract(Duration(days: 6 - i));
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(i == 6 ? l.today : names[d.weekday - 1],
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c.onSurfaceVariant)),
              );
            },
          ),
        ),
      ),
      barGroups: [
        for (var i = 0; i < 7; i++)
          BarChartGroupData(x: i, barRods: [
            BarChartRodData(
              toY: totals[i],
              width: 22,
              color: i == 6 ? c.secondary : c.primaryContainer.withValues(alpha: goal > 0 && totals[i] >= goal ? 1 : 0.55),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ]),
      ],
    ));
  }
}
