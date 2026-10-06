import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../onboarding/onboarding_repository.dart';
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

/// Separa "0,5 mg" em ("0,5", "mg") para o número grande do card.
(String, String) splitDose(String label) {
  final m = RegExp(r'^\s*([\d.,]+)\s*(.*)$').firstMatch(label);
  return m == null ? (label, '') : (m.group(1)!, m.group(2)!);
}

class DosesScreen extends ConsumerWidget {
  const DosesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final treatment = ref.watch(treatmentProvider);
    final logs = ref.watch(doseLogsProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          AppTopBar(
            title: l.dosesTitle,
            name: ref.watch(profileProvider).value?.name ?? '',
            onBack: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: treatment.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: ErrorRetry(onRetry: () => ref.invalidate(treatmentProvider))),
              data: (tr) {
                final now = DateTime.now();
                return ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: [
                  StatusChip(
                    (tr?.active ?? false ? l.dosesStatusActive : l.dosesStatusOff).toUpperCase(),
                    background: c.secondaryContainer.withValues(alpha: 0.5),
                    foreground: c.onSecondaryContainer,
                  ),
                  const SizedBox(height: 10),
                  PageTitle(l.dosesTitle, l.dosesSubtitle),
                  const SizedBox(height: 10),
                  if (tr != null) ...[
                    Box(
                      padding: const EdgeInsets.all(16),
                      shadow: const [BoxShadow(color: Color(0x0F0F766E), blurRadius: 12, offset: Offset(0, 2))],
                      child: Row(children: [
                        IconBadge(Symbols.notifications_active, size: 44, iconSize: 24, radius: 16, bg: c.tertiaryFixed, fg: c.tertiary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(l.nextDoseShort.toUpperCase(),
                                style: t.labelSmall!.copyWith(color: c.tertiary, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                            Text.rich(TextSpan(children: [
                              TextSpan(
                                text: tr.active ? inDaysLabel(l, nextOccurrence(tr.weekday, tr.time, now), now) : l.reminderOff,
                                style: t.titleMedium,
                              ),
                              TextSpan(
                                text: ' (${weekdayName(tr.weekday).split('-').first}, ${fmtTime(tr.time)})',
                                style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant),
                              ),
                            ])),
                          ]),
                        ),
                        Icon(Symbols.calendar_clock, size: 20, color: c.outline),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    _ReminderCard(key: ValueKey(tr.id), treatment: tr),
                    const SizedBox(height: 20),
                  ],
                  PrimaryButton(
                    key: const ValueKey('dose_register'),
                    label: l.doseRegister,
                    icon: Symbols.check_circle,
                    height: 54,
                    onPressed: () => showDoseLogSheet(context, tr),
                  ),
                  const SizedBox(height: 28),
                  ...logs.when(
                    loading: () => [const Center(child: CircularProgressIndicator())],
                    error: (_, _) => [ErrorRetry(onRetry: () => ref.invalidate(doseLogsProvider))],
                    data: (list) => [
                      SectionHeader(l.doseHistory, subtitle: l.doseCount(list.length)),
                      const SizedBox(height: 14),
                      if (list.isEmpty)
                        Text(l.doseHistoryEmpty, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant))
                      else
                        for (final (i, d) in list.indexed) _DoseTile(d, latest: i == 0),
                    ],
                  ),
                ]);
              },
            ),
          ),
        ]),
      ),
    );
  }
}

/// Card "Próxima aplicação" da Home (borda esquerda coral). Só informa o agendamento do usuário.
class NextDoseCard extends StatelessWidget {
  const NextDoseCard({super.key, required this.treatment, this.action, this.onTap});
  final Treatment treatment;
  final Widget? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final now = DateTime.now();
    final next = nextOccurrence(treatment.weekday, treatment.time, now);
    final (amount, unit) = splitDose(treatment.doseLabel);
    return Box(
      padding: EdgeInsets.zero,
      shadow: shadowCard,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(border: Border(left: BorderSide(color: c.tertiaryContainer, width: 4))),
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconBadge(Symbols.vaccines, bg: c.tertiaryFixed, fg: c.tertiary),
            const SizedBox(width: 6),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.routineReminder.toUpperCase(), style: t.labelSmall!.copyWith(color: c.tertiary, letterSpacing: 0.55)),
                Text(l.nextDose, style: t.titleMedium),
              ]),
            ),
            Pill(
              treatment.active ? inDaysLabel(l, next, now) : l.reminderOff,
              background: c.tertiaryFixed,
              foreground: c.onTertiaryFixedVariant,
            ),
          ]),
          const SizedBox(height: 12),
          Text.rich(TextSpan(children: [
            TextSpan(text: amount, style: t.displayMedium!.copyWith(height: 1)),
            if (unit.isNotEmpty) TextSpan(text: ' $unit', style: t.titleMedium!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w500)),
          ])),
          const SizedBox(height: 6),
          Row(children: [
            Icon(Symbols.event, size: 16, color: c.tertiary),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${l.atTime(weekdayName(treatment.weekday).split('-').first, fmtTime(treatment.time))} • ${treatment.medication == 'Outro' ? l.medOther : treatment.medication}',
                style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant),
              ),
            ),
          ]),
          if (action != null) ...[const SizedBox(height: 20), action!],
        ]),
      ),
    );
  }
}

/// Configuração do lembrete: salva automaticamente a cada alteração (como no mockup, sem botão salvar).
class _ReminderCard extends ConsumerStatefulWidget {
  const _ReminderCard({super.key, required this.treatment});
  final Treatment treatment;

  @override
  ConsumerState<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends ConsumerState<_ReminderCard> {
  late String _dose = widget.treatment.doseLabel;
  late int _weekday = widget.treatment.weekday;
  late TimeOfDay _time = widget.treatment.time;
  late bool _active = widget.treatment.active;

  Future<void> _save() async {
    try {
      await ref.read(dosesRepositoryProvider).saveTreatment(
            id: widget.treatment.id,
            doseLabel: _dose,
            weekday: _weekday,
            time: _time,
            active: _active,
          );
      ref.invalidate(treatmentProvider);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l.reminderSaved)));
    } catch (_) {
      if (mounted) showError(context);
    }
  }

  Future<void> _editDose() async {
    final ctrl = TextEditingController(text: _dose);
    final v = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(context.l.obDoseLabel),
        content: TextField(controller: ctrl, autofocus: true, decoration: InputDecoration(hintText: context.l.obDoseHint)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: Text(context.l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(c, ctrl.text.trim()), child: Text(context.l.save)),
        ],
      ),
    );
    if (v == null || v.isEmpty) return;
    setState(() => _dose = v);
    _save();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    Widget field(String label, Widget value, IconData icon, Color iconColor, VoidCallback onTap) => Expanded(
          child: Box(
            color: c.surfaceContainerLow,
            radius: 16,
            padding: const EdgeInsets.all(12),
            onTap: onTap,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
              SizedBox(
                height: 44,
                child: Row(children: [Expanded(child: value), Icon(icon, size: 18, color: iconColor)]),
              ),
            ]),
          ),
        );
    return Box(
      shadow: const [BoxShadow(color: Color(0x0A1F2937), blurRadius: 20, offset: Offset(0, 4))],
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          IconBadge(Symbols.event_repeat, size: 36, iconSize: 22, radius: 12, bg: c.primaryContainer.withValues(alpha: 0.1)),
          const SizedBox(width: 10),
          Expanded(child: Text(l.reminderConfig, style: t.titleMedium)),
          Switch(
            value: _active,
            onChanged: (v) {
              setState(() => _active = v);
              _save();
            },
          ),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: Text(l.dosesPreferredDay, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant))),
          Text(l.daySelected(weekdayName(_weekday).split('-').first),
              style: t.labelSmall!.copyWith(color: c.primary)),
        ]),
        const SizedBox(height: 8),
        WeekdayPicker(
          square: true,
          value: _weekday,
          onChanged: (d) {
            setState(() => _weekday = d);
            _save();
          },
        ),
        const SizedBox(height: 16),
        Row(children: [
          field(
            l.dosesAlarmTime,
            Text.rich(TextSpan(children: [
              TextSpan(text: fmtTime(_time), style: t.titleMedium),
              TextSpan(text: ' (${periodOfDay(l, _time)})', style: t.labelMedium!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w400)),
            ])),
            Symbols.schedule,
            c.primary,
            () => pickTime(context, _time, (v) {
              setState(() => _time = v);
              _save();
            }),
          ),
          const SizedBox(width: 12),
          field(
            l.dosesPrescribed,
            Text(_dose, overflow: TextOverflow.ellipsis, style: t.titleMedium!.copyWith(color: c.primary, fontWeight: FontWeight.w700)),
            Symbols.edit,
            c.outline,
            _editDose,
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          Icon(Symbols.info, size: 18, color: c.secondary),
          const SizedBox(width: 10),
          Expanded(child: Text(l.reminderExact, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant))),
        ]),
      ]),
    );
  }
}

class _DoseTile extends StatelessWidget {
  const _DoseTile(this.d, {required this.latest});
  final DoseLog d;
  final bool latest;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final days = dayOnly(DateTime.now()).difference(dayOnly(d.takenAt)).inDays;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Box(
        radius: 16,
        padding: const EdgeInsets.all(16),
        shadow: shadowSm,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: IconBadge(Symbols.done,
                bg: latest ? c.primaryContainer : c.surfaceContainerHighest, fg: latest ? c.onPrimaryContainer : c.onSurfaceVariant),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text(fmtDayMonth(d.takenAt).replaceAll('-feira', ''), style: t.titleMedium),
                Pill(d.doseLabel, foreground: c.onSurface),
              ]),
              if (d.site != null) ...[
                const SizedBox(height: 2),
                Text(siteLabel(l, d.site), style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
              ],
              if (d.note?.isNotEmpty ?? false) ...[
                const SizedBox(height: 4),
                Text('“${d.note}”', style: t.labelSmall!.copyWith(color: latest ? c.secondary : c.onSurfaceVariant, fontWeight: FontWeight.w500)),
              ],
            ]),
          ),
          Text(days == 0 ? l.today : days < 7 ? l.daysAgo(days) : fmtDayMonth(d.takenAt).split(', ').last,
              style: t.labelSmall!.copyWith(color: c.outline)),
        ]),
      ),
    );
  }
}

/// Bottom sheet "Registrar Aplicação". Usado pela tela de Doses e pela Home.
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
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final lastSite = ref.watch(doseLogsProvider).value?.firstOrNull?.site;
    final siteNames = {'abdomen': l.siteAbdomenFull, 'coxa': l.siteThighFull, 'braco': l.siteArmFull};
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.doseSheetTitle, style: t.headlineSmall),
                Text(l.doseSheetSub(widget.treatment?.doseLabel ?? '—'),
                    style: t.labelMedium!.copyWith(color: c.primary)),
              ]),
            ),
            IconBadge(Symbols.vaccines, size: 40, iconSize: 20, bg: c.surfaceContainerLow, fg: c.onSurfaceVariant),
          ]),
          const SizedBox(height: 16),
          Text(l.doseSite, style: t.labelMedium!.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          for (final s in doseSites) ...[
            Semantics(
              selected: _site == s,
              button: true,
              child: Box(
                radius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: _site == s ? c.primary : c.surfaceContainerLow,
                shadow: _site == s ? shadowSm : const [],
                onTap: () => setState(() => _site = _site == s ? null : s),
                child: SizedBox(
                  height: 48,
                  child: Row(children: [
                    Icon(_site == s ? Symbols.radio_button_checked : Symbols.radio_button_unchecked,
                        size: 20, color: _site == s ? c.onPrimary : c.outline),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(siteNames[s]!,
                          style: t.titleMedium!.copyWith(fontWeight: FontWeight.w500, color: _site == s ? c.onPrimary : c.onSurface)),
                    ),
                    if (s == lastSite)
                      Pill(l.siteLastUsed,
                          background: _site == s ? c.onPrimary.withValues(alpha: 0.2) : Colors.transparent,
                          foreground: _site == s ? c.onPrimary : c.onSurfaceVariant),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          Text(l.doseField, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant)),
          const SizedBox(height: 6),
          TextField(key: const ValueKey('dose_label'), controller: _dose, style: t.bodyMedium),
          const SizedBox(height: 16),
          Text(l.noteOptional, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant)),
          const SizedBox(height: 6),
          TextField(
            key: const ValueKey('dose_note'),
            controller: _note,
            style: t.bodyMedium,
            decoration: InputDecoration(hintText: l.doseNoteHint, hintStyle: t.bodyMedium!.copyWith(color: c.outline)),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            key: const ValueKey('dose_confirm'),
            label: l.doseConfirm,
            icon: Symbols.task_alt,
            onPressed: _saving ? null : _confirm,
          ),
        ]),
      ),
    );
  }
}
