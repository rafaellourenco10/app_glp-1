import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../doses/doses_repository.dart';
import '../doses/doses_screen.dart';
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
  'nausea': Symbols.sick,
  'vomito': Symbols.sentiment_extremely_dissatisfied,
  'constipacao': Symbols.motion_photos_off,
  'diarreia': Symbols.water_drop,
  'refluxo': Symbols.local_fire_department,
  'fadiga': Symbols.battery_low,
  'falta_apetite': Symbols.no_meals,
  'dor_cabeca': Symbols.psychology_alt,
  'tontura': Symbols.sync,
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
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final doseLogs = ref.watch(doseLogsProvider).value ?? const <DoseLog>[];
    final doses = doseLogs.map((d) => d.takenAt).toList();
    final logsAsync = ref.watch(symptomLogsProvider);
    final now = DateTime.now();
    final today = daysSinceDose(now, doses);
    final sev = severityLabels(l);
    final lastDose = doseLogs.firstOrNull;

    return ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 32), children: [
      if (today != null && lastDose != null) ...[
        StatusChip(l.daysAfterDoseWith(today, lastDose.doseLabel), icon: Symbols.medical_services, foreground: c.primary),
        const SizedBox(height: 8),
      ],
      PageTitle(l.symTitle, l.symSubtitle),
      const SizedBox(height: 16),
      // Registro rápido
      SectionCard(
        shadow: const [BoxShadow(color: Color(0x0D0F766E), blurRadius: 24, offset: Offset(0, 4))],
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(child: Text(l.symHowNow, style: t.titleMedium)),
            Text(fmtRelative(now, today: l.today, yesterday: l.yesterday),
                style: t.labelSmall!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w500)),
          ]),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.2,
            children: [
              for (final s in symptoms)
                Semantics(
                  selected: _symptom == s,
                  button: true,
                  child: Box(
                    radius: 99,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: _symptom == s ? c.primary : c.surfaceContainerLow,
                    shadow: _symptom == s ? shadowSm : const [],
                    onTap: () => setState(() => _symptom = _symptom == s ? null : s),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(_icons[s], size: 18, color: _symptom == s ? c.onPrimary : c.onSurfaceVariant.withValues(alpha: 0.75)),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(symptomLabel(l, s),
                            overflow: TextOverflow.ellipsis,
                            style: t.labelMedium!.copyWith(color: _symptom == s ? c.onPrimary : c.onSurfaceVariant)),
                      ),
                      if (_symptom == s) ...[const SizedBox(width: 3), Icon(Symbols.check, size: 15, color: c.onPrimary)],
                    ]),
                  ),
                ),
            ],
          ),
          if (_symptom != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(18)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Icon(Symbols.speed, size: 18, color: c.primary),
                  const SizedBox(width: 6),
                  Expanded(child: Text(l.symIntensity(symptomLabel(l, _symptom!)), style: t.titleMedium)),
                  Pill(sev[_severity], background: c.surfaceContainerHigh, foreground: c.onSurfaceVariant),
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  for (var i = 0; i < 4; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(child: _SeverityButton(level: i, label: sev[i], selected: _severity == i, onTap: () => setState(() => _severity = i))),
                  ],
                ]),
                const SizedBox(height: 16),
                Row(children: [
                  Icon(Symbols.edit_note, size: 16, color: c.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(l.symNoteLabel, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant)),
                ]),
                const SizedBox(height: 6),
                TextField(
                  controller: _note,
                  style: t.bodyMedium,
                  decoration: InputDecoration(
                    hintText: l.symNoteHint,
                    hintStyle: t.bodyMedium!.copyWith(color: c.outline),
                    fillColor: c.surfaceContainerLowest,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: l.symSave,
                  icon: Symbols.check_circle,
                  height: 48,
                  shadow: const [BoxShadow(color: Color(0x380F766E), blurRadius: 16, offset: Offset(0, 4))],
                  onPressed: _saving ? null : _save,
                ),
              ]),
            ),
          ],
        ]),
      ),
      const SizedBox(height: 20),
      ...logsAsync.when(
        loading: () => [const Center(child: CircularProgressIndicator())],
        error: (_, _) => [ErrorRetry(onRetry: () => ref.invalidate(symptomLogsProvider))],
        data: (logs) {
          final avg = severityByDoseDay(logs, doses);
          // Linha do tempo: sintomas e aplicações juntos, mais recentes primeiro.
          final timeline = <(DateTime, Object)>[
            for (final s in logs.take(30)) (s.loggedAt, s),
            for (final d in doseLogs.take(10)) (d.takenAt, d),
          ]..sort((a, b) => b.$1.compareTo(a.$1));
          return [
            SectionCard(
              shadow: const [BoxShadow(color: Color(0x0D0F766E), blurRadius: 24, offset: Offset(0, 4))],
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Expanded(child: Text(l.symCycleTitle, style: t.titleMedium)),
                  if (doses.isNotEmpty)
                    Pill(l.symWeekN(doses.length), background: c.secondaryContainer, foreground: c.onSecondaryContainer),
                ]),
                const SizedBox(height: 4),
                Text(l.symCycleSubtitle, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                  child: Column(children: [
                    Row(children: [
                      Container(width: 10, height: 10, decoration: BoxDecoration(color: c.secondary, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(l.symCurveLegend, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w500)),
                      ),
                      if (today != null)
                        Text(l.todayDayN(today), style: t.labelSmall!.copyWith(color: c.primary)),
                    ]),
                    const SizedBox(height: 8),
                    SizedBox(height: 144, child: _DoseDayChart(avg, today: today)),
                    const SizedBox(height: 8),
                    Row(children: [
                      for (var i = 0; i < 8; i++)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: (today == null ? -1 : today > 7 ? 7 : today) == i ? c.primary.withValues(alpha: 0.1) : null,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              i == 7 ? 'D7+' : 'D$i',
                              textAlign: TextAlign.center,
                              style: t.labelSmall!.copyWith(
                                color: (today == null ? -1 : today > 7 ? 7 : today) == i ? c.primary : c.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ]),
                  ]),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: c.secondaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    IconBadge(Symbols.lightbulb, bg: c.secondaryContainer, fg: c.onSecondaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(l.symTipTitle, style: t.labelMedium!.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(l.symTipBody, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
                      ]),
                    ),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: SectionHeader(l.symHistory)),
            const SizedBox(height: 8),
            if (timeline.isEmpty) Text(l.symHistoryEmpty, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
            for (final (_, item) in timeline)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: item is SymptomLog ? _SymptomTile(item, doses: doses) : _DoseRow(item as DoseLog),
              ),
          ];
        },
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: c.surfaceContainer, borderRadius: BorderRadius.circular(16)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Symbols.verified_user, size: 20, color: c.outline),
          const SizedBox(width: 12),
          Expanded(child: Text(l.symSafety, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant, height: 1.6))),
        ]),
      ),
    ]);
  }
}

/// Botão de intensidade 0..3 (cores do mockup: 0 outline, 1 secondary, 2 tertiary, 3 error).
class _SeverityButton extends StatelessWidget {
  const _SeverityButton({required this.level, required this.label, required this.selected, required this.onTap});
  final int level;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final t = context.t;
    final numColor = [c.outline, c.secondary, c.tertiary, c.error][level];
    final selBg = [c.surfaceContainerHigh, c.secondaryContainer.withValues(alpha: 0.5), c.tertiaryFixed, c.errorContainer][level];
    return Semantics(
      selected: selected,
      button: true,
      child: Box(
        radius: 16,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        color: selected ? selBg : c.surfaceContainerLowest,
        shadow: selected ? shadowSm : const [],
        onTap: onTap,
        child: Column(children: [
          Text('$level', style: t.headlineSmall!.copyWith(color: numColor, fontWeight: FontWeight.w700)),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label,
              style: t.labelSmall!.copyWith(
                color: selected ? c.onSurface : c.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              )),
          ),
        ]),
      ),
    );
  }
}

class _SymptomTile extends StatelessWidget {
  const _SymptomTile(this.s, {required this.doses});
  final SymptomLog s;
  final List<DateTime> doses;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final strong = s.severity >= 2;
    final day = daysSinceDose(s.loggedAt, doses);
    return Box(
      radius: 18,
      padding: const EdgeInsets.all(14),
      shadow: const [BoxShadow(color: Color(0x080F766E), blurRadius: 8, offset: Offset(0, 2))],
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          IconBadge(_icons[s.symptom] ?? Symbols.sick,
              size: 28,
              iconSize: 17,
              radius: 12,
              bg: strong ? c.tertiaryFixed : c.secondaryContainer.withValues(alpha: 0.5),
              fg: strong ? c.tertiary : c.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(symptomLabel(l, s.symptom), style: t.titleMedium!.copyWith(height: 1.2)),
              Text(
                [fmtRelative(s.loggedAt, today: l.today, yesterday: l.yesterday), if (day != null) l.dayN(day)].join(' • '),
                style: t.labelSmall!.copyWith(color: c.onSurfaceVariant),
              ),
            ]),
          ),
          Pill(
            '${severityLabels(l)[s.severity]} (${s.severity})',
            background: strong ? c.tertiaryFixed : c.secondaryContainer,
            foreground: strong ? c.onTertiaryFixedVariant : c.onSecondaryContainer,
          ),
        ]),
        if (s.note?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(left: 36, top: 6),
            child: Text('"${s.note}"', style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
          ),
      ]),
    );
  }
}

/// Aplicação registrada, intercalada no histórico (bg primary/5).
class _DoseRow extends StatelessWidget {
  const _DoseRow(this.d);
  final DoseLog d;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final site = siteLabel(l, d.site);
    return Box(
      radius: 18,
      padding: const EdgeInsets.all(14),
      color: c.primary.withValues(alpha: 0.05),
      child: Row(children: [
        IconBadge(Symbols.vaccines, bg: c.primary, fg: c.onPrimary, fill: true),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.symDoseLogged, style: t.labelMedium!.copyWith(fontWeight: FontWeight.w700)),
            Text(
              '${fmtRelative(d.takenAt, today: l.today, yesterday: l.yesterday)} • ${l.doseWord} ${d.doseLabel}${site.isEmpty ? '' : ' ($site)'}',
              style: t.labelSmall!.copyWith(color: c.onSurfaceVariant),
            ),
          ]),
        ),
        Icon(Symbols.check_circle, size: 20, color: c.primary),
      ]),
    );
  }
}

/// Curva da intensidade média (0–3) por dia desde a última aplicação; destaca o seu pico e o dia de hoje.
class _DoseDayChart extends StatelessWidget {
  const _DoseDayChart(this.avg, {this.today});
  final List<double?> avg;
  final int? today;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l = context.l;
    if (avg.every((v) => v == null)) {
      return Center(child: Text(l.symCycleEmpty, textAlign: TextAlign.center, style: context.t.bodyMedium));
    }
    final spots = [for (var i = 0; i < 8; i++) if (avg[i] != null) FlSpot(i.toDouble(), avg[i]!)];
    final peak = spots.reduce((a, b) => b.y > a.y ? b : a).x;
    final todayX = today == null ? null : (today! > 7 ? 7 : today!).toDouble();
    return LineChart(LineChartData(
      minX: -0.4,
      maxX: 7.4,
      minY: 0,
      maxY: 3.3,
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(show: false),
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (_) => FlLine(color: c.outlineVariant.withValues(alpha: 0.3), strokeWidth: 1, dashArray: [3, 3]),
      ),
      rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: [
        VerticalRangeAnnotation(
          x1: peak - 0.45,
          x2: peak + 0.45,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [c.tertiaryFixedDim.withValues(alpha: 0.25), c.tertiaryFixedDim.withValues(alpha: 0)],
          ),
        ),
      ]),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          color: c.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [c.primaryContainer.withValues(alpha: 0.32), c.secondaryFixed.withValues(alpha: 0.12), c.secondaryFixed.withValues(alpha: 0)],
            ),
          ),
          dotData: FlDotData(
            getDotPainter: (s, _, _, _) => s.x == todayX
                ? FlDotCirclePainter(radius: 4.5, color: c.primary, strokeWidth: 6, strokeColor: c.secondaryFixed.withValues(alpha: 0.4))
                : s.x == peak
                    ? FlDotCirclePainter(radius: 4.5, color: c.tertiaryFixedDim, strokeWidth: 2, strokeColor: c.tertiary)
                    : FlDotCirclePainter(radius: 3.5, color: Colors.white, strokeWidth: 2, strokeColor: c.primary),
          ),
        ),
      ],
    ));
  }
}
