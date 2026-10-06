import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../onboarding/onboarding_repository.dart';
import 'protein_repository.dart';

/// Ícone por palavra-chave do nome do alimento (como nos cards do mockup).
IconData foodIcon(String name) {
  final n = normalize(name);
  if (n.contains('ovo') || n.contains('omelete') || n.contains('clara')) return Symbols.egg;
  if (n.contains('whey') || n.contains('shake')) return Symbols.water_bottle;
  if (n.contains('iogurte') || n.contains('leite') || n.contains('coalhada') || n.contains('vitamina')) return Symbols.local_cafe;
  if (n.contains('queijo') || n.contains('ricota') || n.contains('requeijao') || n.contains('cottage')) return Symbols.breakfast_dining;
  if (n.contains('feij') || n.contains('lentilha') || n.contains('grao') || n.contains('ervilha') || n.contains('soja') || n.contains('sopa')) {
    return Symbols.soup_kitchen;
  }
  if (n.contains('peixe') || n.contains('tilapia') || n.contains('salmao') || n.contains('atum') || n.contains('sardinha') ||
      n.contains('camarao') || n.contains('bacalhau') || n.contains('merluza') || n.contains('moqueca')) {
    return Symbols.set_meal;
  }
  if (n.contains('pao') || n.contains('arroz') || n.contains('macarrao') || n.contains('aveia') || n.contains('granola') ||
      n.contains('cuscuz') || n.contains('tapioca')) {
    return Symbols.bakery_dining;
  }
  if (n.contains('amendoim') || n.contains('castanha') || n.contains('amendoa') || n.contains('noz') || n.contains('semente') ||
      n.contains('chia')) {
    return Symbols.grain;
  }
  return Symbols.skillet;
}

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
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final goal = ref.watch(profileProvider).value?.proteinGoalG ?? 0;

    return ref.watch(proteinLogsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: ErrorRetry(onRetry: () => ref.invalidate(proteinLogsProvider))),
          data: (logs) {
            final now = DateTime.now();
            final totals = dailyTotals(logs, now);
            final today = logs.where((x) => dayOnly(x.loggedAt) == dayOnly(now)).toList().reversed.toList();
            final hit = totals.where((v) => goal > 0 && v >= goal).length;
            final pct = goal <= 0 ? 0 : (totals.last / goal * 100).round();
            return ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 24), children: [
              PageTitle(
                l.tabProtein,
                l.proteinSubtitle,
                trailing: IconBadge(Symbols.nutrition, size: 40, iconSize: 24, bg: c.secondaryContainer.withValues(alpha: 0.4)),
              ),
              const SizedBox(height: 20),
              // Anel + meta
              Box(
                radius: 16,
                shadow: shadowSm,
                child: Column(children: [
                  Row(children: [
                    ProteinRing(
                      consumed: totals.last,
                      goal: goal,
                      size: 112,
                      center: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(text: fmtNum(totals.last), style: t.titleMedium!.copyWith(fontWeight: FontWeight.w700)),
                          TextSpan(text: 'g', style: t.labelSmall!.copyWith(fontWeight: FontWeight.w400, color: c.onSurfaceVariant)),
                        ])),
                        Text('$pct%', style: t.labelSmall!.copyWith(color: c.primary)),
                      ]),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Wrap(spacing: 6, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                          Text(l.proteinGoal(fmtNum(goal)), style: t.titleMedium!.copyWith(fontWeight: FontWeight.w700)),
                          Pill(
                            totals.last >= goal ? l.proteinGoalReached : l.proteinRemaining(fmtNum(goal - totals.last)),
                            background: c.secondaryContainer.withValues(alpha: 0.6),
                            foreground: c.onSecondaryContainer,
                          ),
                        ]),
                        const SizedBox(height: 6),
                        Text(l.proteinReference, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant, height: 1.25)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
                    child: Row(children: [
                      Icon(Symbols.spa, size: 18, color: c.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(text: '${l.proteinTipTitle}: ', style: TextStyle(fontWeight: FontWeight.w600, color: c.onSurface)),
                            TextSpan(text: l.proteinTipBody),
                          ]),
                          style: t.labelMedium!.copyWith(color: c.onSurfaceVariant),
                        ),
                      ),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              // Consistência semanal
              Box(
                radius: 16,
                shadow: shadowSm,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(l.proteinWeekly, style: t.titleMedium),
                        Text(l.proteinWeeklyAvg(fmtNum((totals.reduce((a, b) => a + b) / 7).roundToDouble()), fmtNum(goal)),
                            style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
                      ]),
                    ),
                    Pill(l.proteinDaysHit(hit)),
                  ]),
                  const SizedBox(height: 16),
                  SizedBox(height: 140, child: WeeklyBars(totals: totals, goal: goal, today: now)),
                ]),
              ),
              const SizedBox(height: 20),
              // Abas
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: c.surfaceContainer, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  for (final (manual, icon, label) in [
                    (false, Symbols.restaurant, l.proteinFoods),
                    (true, Symbols.edit_note, l.proteinManual),
                  ])
                    Expanded(
                      child: Semantics(
                        selected: _manual == manual,
                        child: Box(
                          radius: 8,
                          padding: EdgeInsets.zero,
                          color: _manual == manual ? c.primary : Colors.transparent,
                          shadow: _manual == manual ? shadowSm : const [],
                          onTap: () => setState(() => _manual = manual),
                          child: SizedBox(
                            height: 40,
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(icon, size: 18, color: _manual == manual ? c.onPrimary : c.onSurfaceVariant),
                              const SizedBox(width: 6),
                              Text(label,
                                  style: t.labelMedium!.copyWith(
                                    color: _manual == manual ? c.onPrimary : c.onSurfaceVariant,
                                    fontWeight: _manual == manual ? FontWeight.w600 : FontWeight.w500,
                                  )),
                            ]),
                          ),
                        ),
                      ),
                    ),
                ]),
              ),
              const SizedBox(height: 20),
              if (_manual) ..._manualForm() else ..._foodList(logs),
              const SizedBox(height: 28),
              // Registrados hoje
              Row(children: [
                Text(l.proteinToday, style: t.titleMedium),
                const SizedBox(width: 8),
                Pill(l.proteinTodayCount(today.length, fmtNum(totals.last)),
                    key: const ValueKey('protein_today_total'), foreground: c.onSurfaceVariant),
                const Spacer(),
                if (today.isNotEmpty) Text(l.proteinSwipe, style: t.labelSmall!.copyWith(color: c.outline)),
              ]),
              const SizedBox(height: 12),
              if (today.isEmpty)
                Text(l.proteinTodayEmpty, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant))
              else
                for (final x in today) _LogTile(x),
              const SizedBox(height: 16),
              Tip(l.proteinHydrationBody, title: l.proteinHydrationTitle, icon: Symbols.water_drop, iconBadge: true),
            ]);
          },
        );
  }

  List<Widget> _foodList(List<ProteinLog> logs) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final foods = ref.watch(foodsProvider);
    final q = normalize(_query.text.trim());
    // "Frequentes": mais registrados nos últimos 7 dias primeiro.
    final freq = <String, int>{};
    for (final x in logs) {
      freq[x.label] = (freq[x.label] ?? 0) + 1;
    }
    return [
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: shadowSm),
        child: TextField(
          controller: _query,
          onChanged: (_) => setState(() {}),
          style: t.bodyMedium,
          decoration: InputDecoration(
            fillColor: c.surfaceContainerLowest,
            prefixIcon: Icon(Symbols.search, size: 20, color: c.outline),
            hintText: l.proteinSearch,
            hintStyle: t.bodyMedium!.copyWith(color: c.outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.primary, width: 2)),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Text(q.isEmpty ? l.proteinFrequent : l.proteinResults, style: t.titleMedium),
      const SizedBox(height: 12),
      ...foods.when(
        loading: () => [const Center(child: CircularProgressIndicator())],
        error: (_, _) => [ErrorRetry(onRetry: () => ref.invalidate(foodsProvider))],
        data: (all) {
          final list = all.where((f) => normalize(f.name).contains(q)).toList();
          if (q.isEmpty) list.sort((a, b) => (freq[b.name] ?? 0).compareTo(freq[a.name] ?? 0));
          return [
            for (final f in list.take(q.isEmpty ? 8 : 30))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Box(
                  radius: 16,
                  padding: const EdgeInsets.all(14),
                  shadow: shadowSm,
                  child: Row(children: [
                    IconBadge(foodIcon(f.name), size: 48, iconSize: 24, radius: 12, bg: c.surfaceContainerLow),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(f.name, overflow: TextOverflow.ellipsis, style: t.titleMedium),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(text: '${f.portionLabel}  •  '),
                            TextSpan(text: l.proteinPerPortion(fmtNum(f.proteinG)), style: TextStyle(color: c.primary, fontWeight: FontWeight.w600)),
                          ]),
                          style: t.labelSmall!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w500),
                        ),
                      ]),
                    ),
                    const SizedBox(width: 12),
                    Tooltip(
                      message: l.proteinAddFood(f.name),
                      child: Box(
                        radius: 12,
                        padding: EdgeInsets.zero,
                        color: c.secondaryContainer.withValues(alpha: 0.5),
                        onTap: () => _addFood(f),
                        child: SizedBox(width: 48, height: 48, child: Icon(Symbols.add, size: 24, color: c.primary)),
                      ),
                    ),
                  ]),
                ),
              ),
          ];
        },
      ),
    ];
  }

  List<Widget> _manualForm() {
    final l = context.l;
    final c = context.c;
    InputDecoration deco(String label, {String? suffix}) => InputDecoration(
          labelText: label,
          suffixText: suffix,
          fillColor: c.surfaceContainerLowest,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        );
    Widget shadowed(Widget child) =>
        Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), boxShadow: shadowSm), child: child);
    return [
      shadowed(TextField(key: const ValueKey('protein_manual_label'), controller: _label, decoration: deco(l.proteinManualName))),
      const SizedBox(height: 12),
      shadowed(TextField(
        key: const ValueKey('protein_manual_grams'),
        controller: _grams,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: deco(l.proteinManualGrams, suffix: 'g'),
      )),
      const SizedBox(height: 16),
      PrimaryButton(
        key: const ValueKey('protein_manual_add'),
        label: l.proteinAdd,
        icon: Symbols.add,
        height: 48,
        shadow: shadowSm,
        onPressed: _addManual,
      ),
    ];
  }
}

class _LogTile extends ConsumerWidget {
  const _LogTile(this.x);
  final ProteinLog x;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final time = fmtTime(TimeOfDay.fromDateTime(x.loggedAt));
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: ValueKey(x.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(color: c.error, borderRadius: BorderRadius.circular(16)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Symbols.delete, size: 22, color: c.onError),
            Text(l.delete, style: t.labelSmall!.copyWith(color: c.onError)),
          ]),
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
        child: Box(
          radius: 16,
          padding: const EdgeInsets.all(14),
          shadow: shadowSm,
          child: Row(children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(x.label, overflow: TextOverflow.ellipsis, style: t.titleMedium!.copyWith(fontWeight: FontWeight.w500)),
                Text(x.qty == 1 ? time : '$time • ${l.portions(fmtNum(x.qty))}',
                    style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
              ]),
            ),
            Text('+${fmtNum(x.proteinG)} g', style: t.titleMedium!.copyWith(color: c.primary, fontWeight: FontWeight.w700)),
          ]),
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
    final l = context.l;
    final c = context.c;
    final t = context.t;
    final f = widget.food;
    Widget step(IconData icon, String tip, VoidCallback? onTap) => Tooltip(
          message: tip,
          child: Box(
            radius: 12,
            padding: EdgeInsets.zero,
            shadow: shadowSm,
            onTap: onTap,
            child: SizedBox(width: 48, height: 48, child: Icon(icon, color: c.primary)),
          ),
        );
    return AlertDialog(
      title: Text(f.name, style: t.headlineSmall),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(f.portionLabel, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            step(Symbols.remove, l.lessPortion, _qty > 0.5 ? () => setState(() => _qty -= 0.5) : null),
            Expanded(child: Text(l.portions(fmtNum(_qty)), textAlign: TextAlign.center, style: t.titleMedium)),
            step(Symbols.add, l.morePortion, () => setState(() => _qty += 0.5)),
          ]),
        ),
        const SizedBox(height: 16),
        Text('${fmtNum(f.proteinG * _qty)} g', style: t.displayMedium!.copyWith(color: c.primary)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(context, _qty), child: Text(l.proteinAdd)),
      ],
    );
  }
}

/// Anel de progresso consumido/meta (Home e Proteína): stroke 9 sobre 100, ponta arredondada.
class ProteinRing extends StatelessWidget {
  const ProteinRing({super.key, required this.consumed, required this.goal, this.size = 112, this.center});
  final double consumed;
  final double goal;
  final double size;
  final Widget? center;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final pct = goal <= 0 ? 0.0 : consumed / goal;
    return Semantics(
      label: context.l.proteinOfGoal(fmtNum(consumed), fmtNum(goal)),
      child: SizedBox.square(
        dimension: size,
        child: Stack(alignment: Alignment.center, children: [
          SizedBox.square(
            dimension: size * 0.84,
            child: CircularProgressIndicator(
              value: min(pct, 1),
              strokeWidth: size * 0.09,
              strokeCap: StrokeCap.round,
              backgroundColor: c.surfaceContainer,
              color: c.primaryContainer,
            ),
          ),
          if (center != null) ExcludeSemantics(child: center!),
        ]),
      ),
    );
  }
}

/// Barras dos últimos 7 dias com valor em cima e linha tracejada da meta (tela de Proteína).
class WeeklyBars extends StatelessWidget {
  const WeeklyBars({super.key, required this.totals, required this.goal, required this.today});
  final List<double> totals;
  final double goal;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final t = context.t;
    final l = context.l;
    final names = l.weekdaysShort.split(',');
    const goalH = 80.0; // a meta fica a 80 px da base, como no mockup
    final scale = goal > 0 ? goalH / goal : (totals.reduce(max) > 0 ? goalH / totals.reduce(max) : 0.0);
    return LayoutBuilder(builder: (context, box) {
      return Stack(children: [
        if (goal > 0)
          Positioned(
            left: 0,
            right: 0,
            bottom: 22 + goalH,
            child: Opacity(opacity: 0.4, child: CustomPaint(size: const Size(double.infinity, 1), painter: _Dash(c.primary))),
          ),
        Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          for (var i = 0; i < 7; i++)
            Builder(builder: (context) {
              final v = totals[i];
              final isToday = i == 6;
              final best = goal > 0 && v >= goal;
              final color = isToday
                  ? c.secondaryFixedDim
                  : best
                      ? c.primary
                      : goal > 0 && v >= goal * 0.85
                          ? c.primaryFixedDim
                          : c.surfaceContainerHigh;
              final label = isToday ? l.today : names[today.subtract(Duration(days: 6 - i)).weekday - 1];
              final strong = isToday || best;
              final fg = isToday ? c.secondary : best ? c.primary : c.onSurfaceVariant;
              return Column(mainAxisSize: MainAxisSize.min, children: [
                Text(fmtNum(v.roundToDouble()), style: t.labelSmall!.copyWith(color: fg, fontWeight: strong ? FontWeight.w700 : FontWeight.w600)),
                const SizedBox(height: 6),
                Container(
                  width: 20,
                  height: min(max(v * scale, 4), box.maxHeight - 50),
                  decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
                ),
                const SizedBox(height: 6),
                Text(label, style: t.labelSmall!.copyWith(color: fg, fontWeight: strong ? FontWeight.w700 : FontWeight.w500)),
              ]);
            }),
        ]),
      ]);
    });
  }
}

/// Mini barras da Home (grid-cols-7 h-16, hoje em secondary).
class MiniBars extends StatelessWidget {
  const MiniBars({super.key, required this.totals, required this.goal, required this.today});
  final List<double> totals;
  final double goal;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l = context.l;
    final names = l.weekdaysShort.split(',');
    final top = [goal, ...totals].reduce(max);
    return LayoutBuilder(builder: (context, box) {
      final maxH = box.maxHeight - 18;
      return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        for (var i = 0; i < 7; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                height: top <= 0 ? 2 : max(2, totals[i] / top * maxH),
                decoration: BoxDecoration(
                  color: i == 6 ? c.secondary : c.primaryContainer,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                i == 6 ? l.today : names[today.subtract(Duration(days: 6 - i)).weekday - 1],
                style: context.t.labelSmall!.copyWith(
                  fontSize: 10,
                  color: i == 6 ? c.primary : c.onSurfaceVariant,
                  fontWeight: i == 6 ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ]),
          ),
        ],
      ]);
    });
  }
}

class _Dash extends CustomPainter {
  _Dash(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, 0), Offset(x + 4, 0), p);
    }
  }

  @override
  bool shouldRepaint(_Dash old) => old.color != color;
}
