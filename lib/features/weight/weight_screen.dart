import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../onboarding/onboarding_repository.dart';
import '../protein/protein_repository.dart';
import '../workouts/workouts_repository.dart';
import '../workouts/workouts_screen.dart';
import 'weight_repository.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key});

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  double? _draft; // registro rápido aberto
  bool _all = false;

  Future<void> _save() async {
    final kg = _draft!;
    try {
      await ref.read(weightRepositoryProvider).add(double.parse(kg.toStringAsFixed(1)));
      ref.invalidate(weightLogsProvider);
      setState(() => _draft = null);
    } catch (_) {
      if (mounted) showError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.c;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          AppTopBar(
            title: l.weightTitle,
            name: ref.watch(profileProvider).value?.name ?? '',
            onBack: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: ref.watch(weightLogsProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, _) => Center(child: ErrorRetry(onRetry: () => ref.invalidate(weightLogsProvider))),
                  data: (logs) => ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: [
                    _hero(),
                    const SizedBox(height: 20),
                    _current(logs),
                    const SizedBox(height: 20),
                    if (_draft == null)
                      PrimaryButton(
                        label: l.weightLogToday,
                        icon: Symbols.add,
                        color: c.primaryContainer,
                        shadow: shadowMd,
                        onPressed: () => setState(() => _draft = logs.isEmpty ? 70 : logs.last.kg),
                      )
                    else
                      _quickLog(),
                    if (logs.length > 1) ...[const SizedBox(height: 20), _chart(logs)],
                    const SizedBox(height: 20),
                    _leanMass(),
                    if (logs.isNotEmpty) ...[const SizedBox(height: 20), _history(logs)],
                  ]),
                ),
          ),
        ]),
      ),
    );
  }

  Widget _hero() {
    final c = context.c;
    final t = context.t;
    final l = context.l;
    return Box(
      color: c.surfaceContainerLow,
      radius: 16,
      padding: const EdgeInsets.all(16),
      shadow: shadowSm,
      child: Row(children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: shadowSm),
          clipBehavior: Clip.antiAlias,
          child: Image.asset('assets/images/weight_tea.jpg', width: 64, height: 64, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Pill(l.weightTag.toUpperCase(),
                background: c.secondaryContainer.withValues(alpha: 0.4),
                foreground: c.onSecondaryContainer,
                style: t.labelSmall!.copyWith(letterSpacing: 0.3)),
            const SizedBox(height: 2),
            Text(l.weightTitle, overflow: TextOverflow.ellipsis, style: t.headlineSmall),
            Text(l.weightSubtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
          ]),
        ),
      ]),
    );
  }

  Widget _current(List<WeightLog> logs) {
    final c = context.c;
    final t = context.t;
    final l = context.l;
    final last = logs.lastOrNull;
    final total = logs.length < 2 ? null : logs.last.kg - logs.first.kg;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    final older = logs.where((w) => w.loggedAt.isBefore(weekAgo));
    final week = last == null || older.isEmpty ? null : last.kg - older.last.kg;
    final lowest = logs.isEmpty ? null : logs.map((w) => w.kg).reduce(min);
    final weeks = logs.length < 2 ? 0.0 : logs.last.loggedAt.difference(logs.first.loggedAt).inHours / (24 * 7);
    String signed(double v) => '${v > 0 ? '+' : ''}${fmtNum(v)} kg';
    Widget mini(String label, Widget value) => Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
              const SizedBox(height: 2),
              value,
            ]),
          ),
        );
    return Box(
      shadow: const [BoxShadow(color: Color(0x0F0F766E), blurRadius: 24, offset: Offset(0, 8))],
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Symbols.scale, size: 18, color: c.primary),
                const SizedBox(width: 6),
                Text(l.weightCurrent, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant)),
              ]),
              const SizedBox(height: 4),
              Text.rich(TextSpan(children: [
                TextSpan(text: last == null ? '—' : fmtNum(last.kg), style: t.displayMedium!.copyWith(color: c.primary)),
                TextSpan(text: '  kg', style: t.titleMedium!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w500)),
              ])),
            ]),
          ),
          if (total != null)
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: c.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(99)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(total <= 0 ? Symbols.trending_down : Symbols.trending_up, size: 16, color: c.primary),
                  const SizedBox(width: 4),
                  Text(l.weightTotal('${total > 0 ? '+' : ''}${fmtNum(total)}'), style: t.labelMedium!.copyWith(color: c.primary, fontWeight: FontWeight.w600)),
                ]),
              ),
              const SizedBox(height: 6),
              Text(l.weightStart(fmtNum(logs.first.kg)), style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
            ]),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          mini(l.weightThisWeek, Text(week == null ? '—' : signed(week), style: t.titleMedium!.copyWith(color: c.primary, fontWeight: FontWeight.w700))),
          const SizedBox(width: 8),
          mini(l.weightLowest, Text(lowest == null ? '—' : '${fmtNum(lowest)} kg', style: t.titleMedium!.copyWith(fontWeight: FontWeight.w700))),
        ]),
        if (weeks >= 1) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: c.secondaryContainer.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(Symbols.verified, size: 20, color: c.secondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(text: '${l.weightPaceTitle}: ', style: TextStyle(fontWeight: FontWeight.w600, color: c.secondary)),
                    TextSpan(text: l.weightPaceBody(fmtNum(((logs.last.kg - logs.first.kg) / weeks * 100).round() / 100))),
                  ]),
                  style: t.bodyMedium!.copyWith(color: c.onSecondaryContainer),
                ),
              ),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _quickLog() {
    final c = context.c;
    final t = context.t;
    final l = context.l;
    Widget round(String s, String tip, VoidCallback onTap) => Tooltip(
          message: tip,
          child: Box(
            radius: 99,
            padding: EdgeInsets.zero,
            color: c.surfaceContainer,
            onTap: onTap,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(child: Text(s, style: t.headlineSmall!.copyWith(color: c.primary, fontWeight: FontWeight.w700))),
            ),
          ),
        );
    return Box(
      shadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3)],
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: Text(l.weightNewLog, style: t.titleMedium)),
          Tooltip(
            message: l.cancel,
            child: Box(
              radius: 99,
              padding: EdgeInsets.zero,
              color: c.surfaceContainerHigh,
              onTap: () => setState(() => _draft = null),
              child: SizedBox(width: 32, height: 32, child: Icon(Symbols.close, size: 18, color: c.onSurfaceVariant)),
            ),
          ),
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          round('−', l.weightLess, () => setState(() => _draft = max(20, _draft! - 0.1))),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _typeWeight,
            child: Container(
              constraints: const BoxConstraints(minWidth: 130),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
              child: Text.rich(
                TextSpan(children: [
                  TextSpan(text: fmtNum(double.parse(_draft!.toStringAsFixed(1))), style: t.displayMedium!.copyWith(color: c.primary)),
                  TextSpan(text: ' kg', style: t.titleMedium!.copyWith(color: c.onSurfaceVariant)),
                ]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 12),
          round('+', l.weightMore, () => setState(() => _draft = min(400, _draft! + 0.1))),
        ]),
        const SizedBox(height: 16),
        PrimaryButton(label: l.weightConfirm, height: 48, radius: 12, shadow: const [], onPressed: _save),
      ]),
    );
  }

  /// Toque no número: digitar o peso direto.
  Future<void> _typeWeight() async {
    final ctrl = TextEditingController(text: fmtNum(double.parse(_draft!.toStringAsFixed(1))));
    final kg = await showDialog<double>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.l.weightLogToday),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(suffixText: 'kg'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(context.l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, parseNum(ctrl.text)), child: Text(context.l.save)),
        ],
      ),
    );
    if (kg != null && kg >= 20 && kg <= 400) setState(() => _draft = kg);
  }

  Widget _chart(List<WeightLog> logs) {
    final c = context.c;
    final t = context.t;
    final l = context.l;
    final shown = logs.length > 12 ? logs.sublist(logs.length - 12) : logs;
    final t0 = shown.first.loggedAt;
    final spots = [for (final w in shown) FlSpot(w.loggedAt.difference(t0).inHours / 24, w.kg)];
    final ys = shown.map((w) => w.kg);
    final minY = (ys.reduce(min) - 1).floorToDouble();
    final maxY = (ys.reduce(max) + 1).ceilToDouble();
    final lastSpot = spots.last;
    final bar = LineChartBarData(
      spots: spots,
      color: c.primaryContainer,
      barWidth: 3,
      isCurved: true,
      preventCurveOverShooting: true,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [c.primaryContainer.withValues(alpha: 0.32), c.secondaryFixedDim.withValues(alpha: 0.08), c.surface.withValues(alpha: 0)],
          stops: const [0, 0.7, 1],
        ),
      ),
      dotData: FlDotData(
        getDotPainter: (s, _, _, _) => s == lastSpot
            ? FlDotCirclePainter(radius: 5, color: c.primaryContainer, strokeWidth: 6, strokeColor: c.secondaryFixedDim.withValues(alpha: 0.35))
            : FlDotCirclePainter(radius: 3.5, color: Colors.white, strokeWidth: 2, strokeColor: c.primaryContainer),
      ),
    );
    return Box(
      shadow: const [BoxShadow(color: Color(0x0F0F766E), blurRadius: 24, offset: Offset(0, 8))],
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.weightEvolution, style: t.titleMedium),
              Row(children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: c.secondary, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text(l.weightLogsCount(shown.length), style: t.labelSmall!.copyWith(color: c.secondary, fontWeight: FontWeight.w500)),
              ]),
            ]),
          ),
          Pill('${DateFormat('dd/MM').format(t0)} – ${DateFormat('dd/MM').format(shown.last.loggedAt)}',
              background: c.surfaceContainerHigh, foreground: c.onSurfaceVariant),
        ]),
        const SizedBox(height: 16),
        SizedBox(
          height: 176,
          child: LineChart(LineChartData(
            minY: minY,
            maxY: maxY,
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              drawVerticalLine: false,
              horizontalInterval: max(1, ((maxY - minY) / 3).roundToDouble()),
              getDrawingHorizontalLine: (_) => FlLine(color: c.outlineVariant.withValues(alpha: 0.4), strokeWidth: 1, dashArray: [3, 3]),
            ),
            lineTouchData: LineTouchData(
              enabled: false,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => c.onPrimaryFixed,
                tooltipBorderRadius: BorderRadius.circular(6),
                getTooltipItems: (spots) => [
                  for (final s in spots)
                    LineTooltipItem('${fmtNum(s.y)} kg', t.labelMedium!.copyWith(color: c.onPrimaryContainer, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            showingTooltipIndicators: [
              ShowingTooltipIndicators([LineBarSpot(bar, 0, lastSpot)]),
            ],
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              leftTitles: const AxisTitles(),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34,
                  interval: max(1, ((maxY - minY) / 3).roundToDouble()),
                  // O fl_chart sempre desenha mín/máx; mostramos só os da grade.
                  getTitlesWidget: (v, m) => v == m.min || v == m.max ? const SizedBox() : Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('${fmtNum(v)}kg', style: t.labelSmall!.copyWith(fontSize: 9, color: c.outline, fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  interval: max(1, spots.last.x / 4),
                  getTitlesWidget: (v, m) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateFormat('dd/MM').format(t0.add(Duration(hours: (v * 24).round()))),
                      style: t.labelSmall!.copyWith(
                        color: v == m.max ? c.primary : c.onSurfaceVariant,
                        fontWeight: v == m.max ? FontWeight.w700 : FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            lineBarsData: [bar],
          )),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Symbols.info, size: 18, color: c.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(child: Text(l.weightFluctuation, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant, height: 1.6))),
          ]),
        ),
      ]),
    );
  }

  Widget _leanMass() {
    final c = context.c;
    final t = context.t;
    final l = context.l;
    final goal = ref.watch(profileProvider).value?.proteinGoalG ?? 0;
    final today = dailyTotals(ref.watch(proteinLogsProvider).value ?? const [], DateTime.now()).last;
    final sessions = (ref.watch(workoutSessionsProvider).value ?? const <WorkoutSession>[])
        .where((s) => !s.doneAt.isBefore(weekStart(DateTime.now())))
        .length;
    final pPct = goal <= 0 ? 0.0 : min(1.0, today / goal);
    Widget bar(IconData icon, Color iconColor, String label, Widget value, double pct, Color color) => Column(children: [
          Row(children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 6),
            Expanded(child: Text(label, style: t.labelMedium)),
            value,
          ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(value: pct, minHeight: 10, color: color, backgroundColor: c.surfaceContainer),
          ),
        ]);
    return Box(
      shadow: const [BoxShadow(color: Color(0x0F0F766E), blurRadius: 24, offset: Offset(0, 8))],
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          IconBadge(Symbols.shield_with_heart, size: 36, iconSize: 20, radius: 12, bg: c.secondaryContainer.withValues(alpha: 0.4)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.leanTitle, style: t.titleMedium),
              Text(l.leanSubtitle, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
            ]),
          ),
          Icon(Symbols.fitness_center, size: 22, color: c.secondary),
        ]),
        const SizedBox(height: 16),
        Text(l.leanBody, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
        const SizedBox(height: 16),
        bar(
          Symbols.egg_alt,
          c.tertiary,
          l.leanProtein,
          Text.rich(TextSpan(children: [
            TextSpan(text: '${fmtNum(today)}g / ${fmtNum(goal)}g ', style: TextStyle(color: c.primary, fontWeight: FontWeight.w600)),
            TextSpan(text: '(${(pPct * 100).round()}%)', style: TextStyle(color: c.onSurfaceVariant)),
          ]), style: t.labelMedium),
          pPct,
          c.primaryContainer,
        ),
        const SizedBox(height: 12),
        bar(
          Symbols.exercise,
          c.secondary,
          l.leanWorkouts,
          Text(l.leanWorkoutsValue(sessions, weeklyGoal), style: t.labelMedium!.copyWith(color: c.secondary, fontWeight: FontWeight.w600)),
          min(1, sessions / weeklyGoal),
          c.secondaryFixedDim,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/images/weight_meal.jpg', width: 48, height: 48, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(l.leanTip, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant))),
          ]),
        ),
      ]),
    );
  }

  Widget _history(List<WeightLog> logs) {
    final c = context.c;
    final t = context.t;
    final l = context.l;
    final rev = logs.reversed.toList();
    final shown = _all ? rev : rev.take(4).toList();
    return Box(
      shadow: const [BoxShadow(color: Color(0x0F0F766E), blurRadius: 24, offset: Offset(0, 8))],
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Icon(Symbols.history, size: 20, color: c.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(l.weightHistory, style: t.titleMedium)),
          Text(l.weightLatest, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
        ]),
        const SizedBox(height: 12),
        for (final (i, w) in shown.indexed) ...[
          Builder(builder: (_) {
            final prev = i + 1 < rev.length ? rev[i + 1] : null;
            final diff = prev == null ? null : w.kg - prev.kg;
            final isToday = dayOnly(w.loggedAt) == dayOnly(DateTime.now());
            final first = i == 0;
            return Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(color: first ? c.surfaceContainerLow : c.surfaceBright, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                      Text(isToday ? l.today : weekdayName(w.loggedAt.weekday),
                          style: t.titleMedium!.copyWith(fontWeight: first ? FontWeight.w600 : FontWeight.w500)),
                      if (isToday)
                        Pill(weekdayName(w.loggedAt.weekday), background: c.secondaryContainer.withValues(alpha: 0.3), foreground: c.secondary)
                      else
                        Text(DateFormat("d 'de' MMMM", 'pt_BR').format(w.loggedAt), style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
                    ]),
                    Text(fmtTime(TimeOfDay.fromDateTime(w.loggedAt)), style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
                  ]),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('${fmtNum(w.kg)} kg',
                      style: t.titleMedium!.copyWith(color: first ? c.primary : c.onSurface, fontWeight: first ? FontWeight.w700 : FontWeight.w600)),
                  if (diff != null)
                    Text('${diff > 0 ? '+' : ''}${fmtNum(diff)} kg', style: t.labelSmall!.copyWith(color: c.primary)),
                ]),
              ]),
            );
          }),
        ],
        if (rev.length > 4)
          TextButton(
            onPressed: () => setState(() => _all = !_all),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(_all ? l.showLess : l.weightSeeAll(rev.length), style: t.titleMedium!.copyWith(color: c.primary)),
              Icon(_all ? Symbols.expand_less : Symbols.chevron_right, size: 18, color: c.primary),
            ]),
          ),
      ]),
    );
  }
}
