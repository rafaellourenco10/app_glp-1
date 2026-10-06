import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../doses/doses_repository.dart';
import 'symptoms_repository.dart';

String symptomLabel(AppLocalizations l, String s) => switch (s) {
      'nausea' => l.symNausea,
      'vomito' => l.symVomit,
      'constipacao' => l.symConstipation,
      'diarreia' => l.symDiarrhea,
      'refluxo' => l.symReflux,
      'fadiga' => l.symFatigue,
      'falta_apetite' => l.symAppetite,
      'dor_cabeca' => l.symHeadache,
      'tontura' => l.symDizziness,
      _ => s,
    };

const _icons = {
  'nausea': Icons.sick_outlined,
  'vomito': Icons.sentiment_very_dissatisfied_outlined,
  'constipacao': Icons.do_not_disturb_on_outlined,
  'diarreia': Icons.water_drop_outlined,
  'refluxo': Icons.local_fire_department_outlined,
  'fadiga': Icons.battery_2_bar,
  'falta_apetite': Icons.no_meals_outlined,
  'dor_cabeca': Icons.psychology_alt_outlined,
  'tontura': Icons.sync,
};

List<String> severityLabels(AppLocalizations l) => [l.sev0, l.sev1, l.sev2, l.sev3];

class SymptomsScreen extends ConsumerStatefulWidget {
  const SymptomsScreen({super.key});

  @override
  ConsumerState<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends ConsumerState<SymptomsScreen> {
  String? _symptom;
  int _severity = 1;
  final _note = TextEditingController();
  bool _saving = false;

  Future<void> _save() async {
    if (_symptom == null) return;
    setState(() => _saving = true);
    try {
      await ref.read(symptomsRepositoryProvider).add(
            symptom: _symptom!,
            severity: _severity,
            note: _note.text.trim().isEmpty ? null : _note.text.trim(),
          );
      ref.invalidate(symptomLogsProvider);
      _note.clear();
      setState(() => _symptom = null);
    } catch (_) {
      if (mounted) showError(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final doses = (ref.watch(doseLogsProvider).value ?? const <DoseLog>[]).map((d) => d.takenAt).toList();
    final logsAsync = ref.watch(symptomLogsProvider);
    final today = daysSinceDose(DateTime.now(), doses);
    final sev = severityLabels(l);

    return ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: [
      if (today != null) Align(alignment: Alignment.centerLeft, child: Pill(l.daysAfterDose(today))),
      const SizedBox(height: 8),
      Text(l.symTitle, style: t.headlineLarge),
      Text(l.symSubtitle, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
      const SizedBox(height: 16),
      SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.symHowNow, style: t.titleMedium),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final s in symptoms)
              ChoiceChip(
                avatar: Icon(_icons[s], size: 18, color: _symptom == s ? c.onPrimary : c.primary),
                label: Text(symptomLabel(l, s)),
                selected: _symptom == s,
                onSelected: (sel) => setState(() => _symptom = sel ? s : null),
              ),
          ]),
          if (_symptom != null) ...[
            const SizedBox(height: 16),
            Text(l.symIntensity(symptomLabel(l, _symptom!)), style: t.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [for (var i = 0; i < 4; i++) ButtonSegment(value: i, label: Text('$i\n${sev[i]}', textAlign: TextAlign.center))],
              selected: {_severity},
              onSelectionChanged: (s) => setState(() => _severity = s.first),
            ),
            const SizedBox(height: 12),
            TextField(controller: _note, decoration: InputDecoration(labelText: l.noteOptional, hintText: l.symNoteHint)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(l.symSave),
            ),
          ],
        ]),
      ),
      const SizedBox(height: 16),
      ...logsAsync.when(
        loading: () => [const Center(child: CircularProgressIndicator())],
        error: (_, _) => [ErrorRetry(onRetry: () => ref.invalidate(symptomLogsProvider))],
        data: (logs) => [
          SectionCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.symCycleTitle, style: t.titleMedium),
              Text(l.symCycleSubtitle, style: t.labelMedium?.copyWith(color: c.onSurfaceVariant)),
              const SizedBox(height: 16),
              SizedBox(height: 160, child: _DoseDayChart(severityByDoseDay(logs, doses))),
            ]),
          ),
          const SizedBox(height: 24),
          Text(l.symHistory, style: t.headlineSmall),
          const SizedBox(height: 8),
          if (logs.isEmpty) Text(l.symHistoryEmpty, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
          for (final s in logs.take(30))
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(_icons[s.symptom], color: c.tertiary),
                title: Text(symptomLabel(l, s.symptom)),
                subtitle: Text([
                  fmtDateTime(s.loggedAt),
                  if (daysSinceDose(s.loggedAt, doses) case final d?) l.dayN(d),
                  if (s.note?.isNotEmpty ?? false) '"${s.note}"',
                ].join(' • ')),
                trailing: Pill('${sev[s.severity]} (${s.severity})',
                    background: s.severity >= 2 ? c.tertiaryFixed : c.secondaryContainer.withValues(alpha: 0.5),
                    foreground: s.severity >= 2 ? c.onTertiaryFixedVariant : c.onSecondaryContainer),
              ),
            ),
        ],
      ),
      const SizedBox(height: 8),
      InfoBox(l.symSafety, icon: Icons.health_and_safety_outlined),
    ]);
  }
}

/// Intensidade média (0–3) por dia desde a última aplicação.
class _DoseDayChart extends StatelessWidget {
  const _DoseDayChart(this.avg);
  final List<double?> avg;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);
    if (avg.every((v) => v == null)) {
      return Center(child: Text(l.symCycleEmpty, textAlign: TextAlign.center));
    }
    return BarChart(BarChartData(
      minY: 0,
      maxY: 3,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(drawVerticalLine: false, horizontalInterval: 1, getDrawingHorizontalLine: (_) => FlLine(color: c.outlineVariant, strokeWidth: 0.5)),
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true, interval: 1, reservedSize: 20, getTitlesWidget: (v, _) => Text('${v.toInt()}')),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            getTitlesWidget: (v, _) => Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(v.toInt() == 7 ? 'D7+' : 'D${v.toInt()}', style: Theme.of(context).textTheme.labelSmall),
            ),
          ),
        ),
      ),
      barGroups: [
        for (var i = 0; i < 8; i++)
          BarChartGroupData(x: i, barRods: [
            BarChartRodData(
              toY: avg[i] ?? 0,
              width: 18,
              color: c.tertiaryContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ]),
      ],
    ));
  }
}
