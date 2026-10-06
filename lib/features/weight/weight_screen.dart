import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import 'weight_repository.dart';

class WeightScreen extends ConsumerWidget {
  const WeightScreen({super.key});

  Future<void> _log(BuildContext context, WidgetRef ref, double? last) async {
    final kg = await showDialog<double>(context: context, builder: (_) => _WeightDialog(initial: last));
    if (kg == null) return;
    try {
      await ref.read(weightRepositoryProvider).add(kg);
      ref.invalidate(weightLogsProvider);
    } catch (_) {
      if (context.mounted) showError(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l.weightTitle)),
      body: ref.watch(weightLogsProvider).when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Center(child: ErrorRetry(onRetry: () => ref.invalidate(weightLogsProvider))),
            data: (logs) {
              final last = logs.isEmpty ? null : logs.last;
              final diff = logs.length < 2 ? null : logs.last.kg - logs.first.kg;
              return ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: [
                SectionCard(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    CardHeader(
                      icon: Icons.scale_outlined,
                      title: l.weightCurrent,
                      trailing: diff == null ? null : Pill(l.weightTotal('${diff > 0 ? '+' : ''}${fmtNum(diff)}')),
                    ),
                    const SizedBox(height: 12),
                    Text(last == null ? '—' : '${fmtNum(last.kg)} kg', style: t.displayMedium),
                    if (logs.length > 1)
                      Text(l.weightStart(fmtNum(logs.first.kg)), style: t.labelMedium?.copyWith(color: c.onSurfaceVariant)),
                  ]),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => _log(context, ref, last?.kg),
                  icon: const Icon(Icons.add),
                  label: Text(l.weightLogToday),
                ),
                const SizedBox(height: 16),
                if (logs.length > 1)
                  SectionCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.weightEvolution, style: t.titleMedium),
                      const SizedBox(height: 16),
                      SizedBox(height: 200, child: _WeightChart(logs)),
                      const SizedBox(height: 12),
                      InfoBox(l.weightFluctuation),
                    ]),
                  ),
                const SizedBox(height: 24),
                Text(l.weightHistory, style: t.headlineSmall),
                const SizedBox(height: 8),
                for (var i = logs.length - 1; i >= 0; i--)
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(fmtDayDate(logs[i].loggedAt)),
                      subtitle: i == 0 ? null : Text('${logs[i].kg - logs[i - 1].kg > 0 ? '+' : ''}${fmtNum(logs[i].kg - logs[i - 1].kg)} kg'),
                      trailing: Text('${fmtNum(logs[i].kg)} kg', style: t.titleMedium),
                    ),
                  ),
              ]);
            },
          ),
    );
  }
}

class _WeightChart extends StatelessWidget {
  const _WeightChart(this.logs);
  final List<WeightLog> logs;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t0 = logs.first.loggedAt;
    final spots = [for (final w in logs) FlSpot(w.loggedAt.difference(t0).inHours / 24, w.kg)];
    final ys = logs.map((w) => w.kg);
    final minY = (ys.reduce(min) - 1).floorToDouble();
    final maxY = (ys.reduce(max) + 1).ceilToDouble();
    return LineChart(LineChartData(
      minY: minY,
      maxY: maxY,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(drawVerticalLine: false, getDrawingHorizontalLine: (_) => FlLine(color: c.outlineVariant, strokeWidth: 0.5)),
      lineTouchData: const LineTouchData(enabled: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, reservedSize: 36, getTitlesWidget: (v, m) => Text(fmtNum(v), style: Theme.of(context).textTheme.labelSmall)),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: max(1, spots.last.x / 4),
            getTitlesWidget: (v, m) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(DateFormat('dd/MM').format(t0.add(Duration(hours: (v * 24).round()))),
                  style: Theme.of(context).textTheme.labelSmall),
            ),
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          color: c.primary,
          barWidth: 3,
          isCurved: true,
          preventCurveOverShooting: true,
          belowBarData: BarAreaData(show: true, color: c.primary.withValues(alpha: 0.1)),
        ),
      ],
    ));
  }
}

class _WeightDialog extends StatefulWidget {
  const _WeightDialog({this.initial});
  final double? initial;

  @override
  State<_WeightDialog> createState() => _WeightDialogState();
}

class _WeightDialogState extends State<_WeightDialog> {
  late final _ctrl = TextEditingController(text: widget.initial == null ? '' : fmtNum(widget.initial!));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final kg = parseNum(_ctrl.text);
    final valid = kg != null && kg >= 20 && kg <= 400;
    return AlertDialog(
      title: Text(l.weightLogToday),
      content: TextField(
        controller: _ctrl,
        autofocus: true,
        onChanged: (_) => setState(() {}),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(suffixText: 'kg'),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: valid ? () => Navigator.pop(context, kg) : null, child: Text(l.save)),
      ],
    );
  }
}
