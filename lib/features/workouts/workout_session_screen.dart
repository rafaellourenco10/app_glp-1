import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/widgets.dart';
import 'workouts_repository.dart';
import 'workouts_screen.dart';

class WorkoutSessionScreen extends ConsumerStatefulWidget {
  const WorkoutSessionScreen({super.key, required this.templateId});
  final int templateId;

  @override
  ConsumerState<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends ConsumerState<WorkoutSessionScreen> {
  /// Séries feitas por exercício (índice do exercício -> quantidade de séries marcadas).
  final _sets = <int, int>{};
  bool _saving = false;
  final _watch = Stopwatch()..start();
  Timer? _tick;
  int _rest = 0; // segundos restantes de descanso

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _rest = _rest > 0 ? _rest - 1 : 0);
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  bool _done(WorkoutTemplate w, int i) => (_sets[i] ?? 0) >= w.exercises[i].sets;

  Future<void> _finish(WorkoutTemplate w) async {
    setState(() => _saving = true);
    try {
      await ref.read(workoutsRepositoryProvider).finishSession(w.id, {
        for (final (i, e) in w.exercises.indexed) e.name: _done(w, i),
      });
      ref.invalidate(workoutSessionsProvider);
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
    final w = ref.watch(workoutTemplatesProvider).value?.where((x) => x.id == widget.templateId).firstOrNull;
    if (w == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final n = w.exercises.length;
    final doneCount = [for (var i = 0; i < n; i++) _done(w, i)].where((d) => d).length;
    final current = [for (var i = 0; i < n; i++) i].where((i) => !_done(w, i)).firstOrNull;
    final secs = _watch.elapsed.inSeconds;
    final clock = '${(secs ~/ 60).toString().padLeft(2, '0')}:${(secs % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          StepHeader(
            step: n == 0 ? 0 : (doneCount * 4 / n).ceil().clamp(1, 4) - 1,
            onBack: () => Navigator.maybePop(context),
            semanticsLabel: l.sessionProgress(doneCount, n),
          ),
          Expanded(
            child: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 24), children: [
              // Cabeçalho da sessão
              SectionCard(
                shadow: shadowSm,
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(l.sessionTitle.toUpperCase(), style: t.labelSmall!.copyWith(color: c.primary, letterSpacing: 0.55)),
                        Text('${w.name} • ${locationLabel(l, w.location)}', overflow: TextOverflow.ellipsis, style: t.titleMedium),
                      ]),
                    ),
                    Pill(levelLabel(l, w.level), dot: true, background: c.surfaceContainerLow, foreground: c.onSurfaceVariant),
                  ]),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                    child: Row(children: [
                      Text(clock, style: t.displayMedium),
                      const SizedBox(width: 8),
                      Text(l.sessionActiveTime, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant)),
                      const Spacer(),
                      Tooltip(
                        message: _watch.isRunning ? l.sessionPause : l.sessionResume,
                        child: Box(
                          radius: 99,
                          padding: EdgeInsets.zero,
                          shadow: shadowSm,
                          onTap: () => setState(() => _watch.isRunning ? _watch.stop() : _watch.start()),
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(_watch.isRunning ? Symbols.pause : Symbols.play_arrow, size: 26, color: c.primary),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: Text(l.sessionProgress(doneCount, n), style: t.labelMedium!.copyWith(color: c.onSurfaceVariant))),
                    Text('${n == 0 ? 0 : (doneCount * 100 / n).round()}%', style: t.titleMedium!.copyWith(color: c.primary)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(value: n == 0 ? 0 : doneCount / n, minHeight: 8),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Icon(Symbols.water_drop, size: 18, color: c.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(l.sessionWater, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant))),
                  ]),
                ]),
              ),
              const SizedBox(height: 20),
              for (final (i, e) in w.exercises.indexed) ...[
                _ExerciseCard(
                  exercise: e,
                  done: _sets[i] ?? 0,
                  state: _done(w, i) ? _State.done : i == current ? _State.current : _State.next,
                  rest: i == current ? _rest : null,
                  onRest: () => setState(() => _rest = 45),
                  onSet: (k) => setState(() => _sets[i] = (_sets[i] ?? 0) == k + 1 ? k : k + 1),
                ),
                const SizedBox(height: 16),
              ],
              Box(
                color: c.surfaceContainerLow,
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  IconBadge(Symbols.health_and_safety, size: 36, iconSize: 20, fg: c.onPrimaryFixed),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.sessionSafetyTitle, style: t.titleMedium),
                      const SizedBox(height: 4),
                      Text(l.sessionSafety, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
                    ]),
                  ),
                ]),
              ),
            ]),
          ),
          // Rodapé fixo
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            decoration: BoxDecoration(
              color: c.surface.withValues(alpha: 0.9),
              boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 24, offset: Offset(0, -8))],
            ),
            child: Column(children: [
              PrimaryButton(
                label: l.sessionFinish,
                icon: Symbols.check_circle,
                color: c.primaryContainer,
                shadow: shadowMd,
                onPressed: _saving ? null : () => _finish(w),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                  onPressed: () => setState(() => _watch.isRunning ? _watch.stop() : _watch.start()),
                  style: TextButton.styleFrom(foregroundColor: c.onSurfaceVariant),
                  child: Text(_watch.isRunning ? l.sessionPauseSession : l.sessionResume),
                ),
                Container(width: 4, height: 4, decoration: BoxDecoration(color: c.outlineVariant, shape: BoxShape.circle)),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: c.error),
                  child: Text(l.sessionDiscard),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}

enum _State { done, current, next }

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.done,
    required this.state,
    required this.onSet,
    required this.onRest,
    this.rest,
  });
  final Exercise exercise;
  final int done; // séries feitas
  final _State state;
  final ValueChanged<int> onSet;
  final VoidCallback onRest;
  final int? rest;

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final e = exercise;
    final (badgeBg, badgeFg) = switch (state) {
      _State.done => (c.secondaryContainer.withValues(alpha: 0.4), c.onSecondaryContainer),
      _State.current => (c.primaryContainer, c.onPrimary),
      _State.next => (c.surfaceContainer, c.onSurfaceVariant),
    };
    return Opacity(
      opacity: state == _State.done ? 0.95 : 1,
      child: SectionCard(
        shadow: shadowSm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconBadge(Symbols.fitness_center, size: 40, iconSize: 22, radius: 12, bg: badgeBg, fg: badgeFg),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(e.name, style: t.titleMedium),
                Text(l.setsReps(e.sets, e.reps), style: t.labelMedium!.copyWith(color: c.onSurfaceVariant)),
              ]),
            ),
            const SizedBox(width: 8),
            switch (state) {
              _State.done => Pill(l.done, icon: Symbols.check, background: c.primaryFixed.withValues(alpha: 0.5), foreground: c.onPrimaryFixed),
              _State.current => Pill(l.setOf(done + 1, e.sets), foreground: c.onSurfaceVariant),
              _State.next => Pill(l.upNext, foreground: c.onSurfaceVariant),
            },
          ]),
          if (e.note != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: c.surfaceContainerLow.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(12)),
              child: Text('${l.tip}: ${e.note}', style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
            ),
          ],
          if (e.url != null) ...[
            const SizedBox(height: 6),
            SelectableText(e.url!, style: t.labelSmall!.copyWith(color: c.primary)),
          ],
          const SizedBox(height: 12),
          for (var k = 0; k < e.sets; k++) ...[
            if (k > 0) const SizedBox(height: 8),
            Builder(builder: (_) {
              final checked = k < done;
              final isCurrent = state == _State.current && k == done;
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCurrent ? c.secondaryContainer.withValues(alpha: 0.2) : c.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: checked ? c.primary : isCurrent ? c.primaryContainer : c.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Text('${k + 1}',
                        style: t.labelSmall!.copyWith(color: checked || isCurrent ? c.onPrimary : c.onSurfaceVariant)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: l.repsN(e.reps),
                        style: (isCurrent ? t.titleMedium : t.bodyMedium)!.copyWith(
                          color: checked || isCurrent ? c.onSurface : c.onSurfaceVariant,
                        ),
                      ),
                      if (isCurrent) TextSpan(text: '  ${l.current}', style: t.labelSmall!.copyWith(color: c.primary, fontWeight: FontWeight.w500)),
                    ])),
                  ),
                  Semantics(
                    label: l.setN(k + 1),
                    checked: checked,
                    child: Box(
                      radius: 12,
                      padding: EdgeInsets.zero,
                      color: checked ? c.primary : isCurrent ? c.surfaceContainer : c.surfaceContainerHigh,
                      onTap: () => onSet(k),
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(
                          checked ? Symbols.done : Symbols.radio_button_unchecked,
                          size: checked ? 22 : 24,
                          color: checked ? c.onPrimary : isCurrent ? c.onSurfaceVariant : c.outline,
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            }),
          ],
          if (state == _State.current && done > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
              child: Row(children: [
                Icon(Symbols.timer, size: 20, color: c.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(l.restLabel, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant))),
                Box(
                  radius: 99,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: c.primaryContainer,
                  shadow: shadowSm,
                  onTap: rest == 0 ? onRest : null,
                  child: SizedBox(
                    height: 40,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Symbols.hourglass_top, size: 16, color: c.onPrimary),
                      const SizedBox(width: 6),
                      Text(rest! > 0 ? '${rest}s' : l.restButton, style: t.labelMedium!.copyWith(color: c.onPrimary)),
                    ]),
                  ),
                ),
              ]),
            ),
          ],
        ]),
      ),
    );
  }
}
