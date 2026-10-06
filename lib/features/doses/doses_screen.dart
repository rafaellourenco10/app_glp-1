import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import 'doses_repository.dart';

String siteLabel(AppLocalizations l, String? site) => switch (site) {
      'abdomen' => l.siteAbdomen,
      'coxa' => l.siteThigh,
      'braco' => l.siteArm,
      _ => '',
    };

/// "Hoje", "Amanhã" ou "Em N dias".
String inDaysLabel(AppLocalizations l, DateTime when, DateTime now) {
  final days = dayOnly(when).difference(dayOnly(now)).inDays;
  return days == 0 ? l.today : days == 1 ? l.tomorrow : l.inDays(days);
}

class DosesScreen extends ConsumerWidget {
  const DosesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final treatment = ref.watch(treatmentProvider);
    final logs = ref.watch(doseLogsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.dosesTitle)),
      body: treatment.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: ErrorRetry(onRetry: () => ref.invalidate(treatmentProvider))),
        data: (tr) => ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: [
          Text(l.dosesSubtitle, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
          const SizedBox(height: 16),
          if (tr != null) ...[
            NextDoseCard(treatment: tr),
            const SizedBox(height: 16),
            _ReminderCard(key: ValueKey(tr.id), treatment: tr),
            const SizedBox(height: 16),
          ],
          FilledButton.icon(
            key: const ValueKey('dose_register'),
            onPressed: () => showDoseLogSheet(context, tr),
            icon: const Icon(Icons.check_circle_outline),
            label: Text(l.doseRegister),
          ),
          const SizedBox(height: 24),
          Text(l.doseHistory, style: t.headlineSmall),
          const SizedBox(height: 8),
          ...logs.when(
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (_, _) => [ErrorRetry(onRetry: () => ref.invalidate(doseLogsProvider))],
            data: (list) => list.isEmpty
                ? [Text(l.doseHistoryEmpty, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant))]
                : [for (final d in list) _DoseTile(d)],
          ),
        ]),
      ),
    );
  }
}

/// Card "Próxima aplicação" (também usado na Home). Só informa o agendamento do usuário.
class NextDoseCard extends StatelessWidget {
  const NextDoseCard({super.key, required this.treatment, this.action});
  final Treatment treatment;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final next = nextOccurrence(treatment.weekday, treatment.time, now);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(border: Border(left: BorderSide(color: c.tertiaryContainer, width: 4))),
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CardHeader(
            icon: Icons.vaccines_outlined,
            tint: c.tertiaryFixed,
            title: l.nextDose,
            subtitle: treatment.medication == 'Outro' ? l.medOther : treatment.medication,
            trailing: treatment.active
                ? Pill(inDaysLabel(l, next, now), background: c.tertiaryFixed, foreground: c.onTertiaryFixedVariant)
                : Pill(l.reminderOff),
          ),
          const SizedBox(height: 12),
          Text(treatment.doseLabel, style: t.displayMedium),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.event, size: 16, color: c.tertiary),
            const SizedBox(width: 4),
            Text(l.atTime(weekdayName(treatment.weekday), fmtTime(treatment.time)),
                style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
          ]),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ]),
      ),
    );
  }
}

class _ReminderCard extends ConsumerStatefulWidget {
  const _ReminderCard({super.key, required this.treatment});
  final Treatment treatment;

  @override
  ConsumerState<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends ConsumerState<_ReminderCard> {
  late final _dose = TextEditingController(text: widget.treatment.doseLabel);
  late int _weekday = widget.treatment.weekday;
  late TimeOfDay _time = widget.treatment.time;
  late bool _active = widget.treatment.active;
  bool _saving = false;

  Future<void> _save() async {
    if (_dose.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(dosesRepositoryProvider).saveTreatment(
            id: widget.treatment.id,
            doseLabel: _dose.text.trim(),
            weekday: _weekday,
            time: _time,
            active: _active,
          );
      ref.invalidate(treatmentProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).reminderSaved)));
      }
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
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CardHeader(
          icon: Icons.event_repeat,
          title: l.reminderConfig,
          trailing: Switch(value: _active, onChanged: (v) => setState(() => _active = v)),
        ),
        const SizedBox(height: 16),
        Text(l.obWeekdayLabel, style: t.labelMedium),
        const SizedBox(height: 8),
        WeekdayPicker(value: _weekday, onChanged: (d) => setState(() => _weekday = d)),
        const SizedBox(height: 16),
        Text(l.obTimeLabel, style: t.labelMedium),
        const SizedBox(height: 8),
        TimeTile(value: _time, onChanged: (v) => setState(() => _time = v)),
        const SizedBox(height: 16),
        Text(l.obDoseLabel, style: t.labelMedium),
        const SizedBox(height: 8),
        TextField(controller: _dose, decoration: InputDecoration(hintText: l.obDoseHint)),
        const SizedBox(height: 12),
        InfoBox(l.reminderExact),
        const SizedBox(height: 16),
        OutlinedButton(onPressed: _saving ? null : _save, child: Text(l.save)),
      ]),
    );
  }
}

class _DoseTile extends StatelessWidget {
  const _DoseTile(this.d);
  final DoseLog d;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final details = [siteLabel(l, d.site), if (d.note?.isNotEmpty ?? false) '"${d.note}"'].where((s) => s.isNotEmpty);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SectionCard(
        padding: const EdgeInsets.all(16),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CircleAvatar(radius: 16, backgroundColor: c.primaryContainer, child: Icon(Icons.done, size: 18, color: c.onPrimary)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text(fmtDayDate(d.takenAt), style: t.titleMedium),
                Pill(d.doseLabel),
              ]),
              for (final s in details) Text(s, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
            ]),
          ),
          Text(fmtTime(TimeOfDay.fromDateTime(d.takenAt)), style: t.labelSmall),
        ]),
      ),
    );
  }
}

/// Bottom sheet "Registrar aplicação". Usado pela tela de Doses e pela Home.
Future<void> showDoseLogSheet(BuildContext context, Treatment? tr) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _DoseLogSheet(treatment: tr),
  );
}

class _DoseLogSheet extends ConsumerStatefulWidget {
  const _DoseLogSheet({required this.treatment});
  final Treatment? treatment;

  @override
  ConsumerState<_DoseLogSheet> createState() => _DoseLogSheetState();
}

class _DoseLogSheetState extends ConsumerState<_DoseLogSheet> {
  late final _dose = TextEditingController(text: widget.treatment?.doseLabel ?? '');
  final _note = TextEditingController();
  String? _site;
  bool _saving = false;

  Future<void> _confirm() async {
    if (_dose.text.trim().isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(dosesRepositoryProvider).addLog(
            treatmentId: widget.treatment?.id,
            doseLabel: _dose.text.trim(),
            site: _site,
            note: _note.text.trim().isEmpty ? null : _note.text.trim(),
          );
      ref.invalidate(doseLogsProvider);
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
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.doseSheetTitle, style: t.headlineSmall),
          Text(l.doseSheetNow(fmtDateTime(DateTime.now())), style: t.labelMedium),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('dose_label'),
            controller: _dose,
            decoration: InputDecoration(labelText: l.doseField),
          ),
          const SizedBox(height: 16),
          Text(l.doseSite, style: t.labelMedium),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            for (final s in doseSites)
              ChoiceChip(
                label: Text(siteLabel(l, s)),
                selected: _site == s,
                onSelected: (sel) => setState(() => _site = sel ? s : null),
              ),
          ]),
          const SizedBox(height: 16),
          TextField(
            key: const ValueKey('dose_note'),
            controller: _note,
            decoration: InputDecoration(labelText: l.noteOptional, hintText: l.doseNoteHint),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            key: const ValueKey('dose_confirm'),
            onPressed: _saving ? null : _confirm,
            icon: const Icon(Icons.task_alt),
            label: Text(l.doseConfirm),
          ),
        ]),
      ),
    );
  }
}
