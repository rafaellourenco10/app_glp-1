import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../auth/login_screen.dart';
import '../onboarding/onboarding_repository.dart';
import 'settings_repository.dart';

/// Sem mockup próprio: segue o padrão dos cards das outras telas.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final l = context.l;
    try {
      final json = await ref.read(settingsRepositoryProvider).exportJson();
      // ponytail: área de transferência; trocar por share_plus/arquivo se precisarem enviar como anexo.
      await Clipboard.setData(ClipboardData(text: json));
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.exportDone)));
    } catch (_) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.errorLoad)));
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = context.l;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.deleteTitle),
        content: Text(l.deleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(c).colorScheme.error),
            onPressed: () => Navigator.pop(c, true),
            child: Text(l.deleteConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(settingsRepositoryProvider).deleteAccount();
    } catch (_) {
      if (context.mounted) showError(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final profile = ref.watch(profileProvider).value;
    final theme = ref.watch(themeModeProvider);
    Widget row(IconData icon, String title, String? sub, VoidCallback onTap, {Color? color}) => Box(
          radius: 16,
          padding: const EdgeInsets.all(14),
          shadow: shadowSm,
          onTap: onTap,
          child: Row(children: [
            IconBadge(icon, size: 40, iconSize: 20, radius: 12,
                bg: color == null ? c.secondaryContainer.withValues(alpha: 0.4) : c.errorContainer, fg: color ?? c.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: t.titleMedium!.copyWith(color: color)),
                if (sub != null) Text(sub, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
              ]),
            ),
            Icon(Symbols.chevron_right, size: 20, color: c.outlineVariant),
          ]),
        );
    return ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), children: [
      Row(children: [
        Avatar(profile?.name ?? '', size: 56),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(profile?.name ?? '', style: t.headlineLarge!.copyWith(letterSpacing: -0.65)),
            Text(l.settingsSubtitle, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
          ]),
        ),
      ]),
      const SizedBox(height: 20),
      if (profile != null) _ProfileCard(key: ValueKey(profile), profile: profile),
      const SizedBox(height: 16),
      row(Symbols.notifications_active, l.settingsReminder, l.settingsReminderSub, () => context.push('/doses')),
      const SizedBox(height: 10),
      row(Symbols.scale, l.weightTitle, null, () => context.push('/weight')),
      const SizedBox(height: 16),
      SectionCard(
        shadow: shadowSm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            const IconBadge(Symbols.contrast),
            const SizedBox(width: 8),
            Text(l.settingsTheme, style: t.titleMedium),
          ]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: c.surfaceContainer, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              for (final (mode, label) in [
                (ThemeMode.system, l.themeSystem),
                (ThemeMode.light, l.themeLight),
                (ThemeMode.dark, l.themeDark),
              ])
                Expanded(
                  child: Semantics(
                    selected: theme == mode,
                    child: Box(
                      radius: 8,
                      padding: EdgeInsets.zero,
                      color: theme == mode ? c.primary : Colors.transparent,
                      shadow: theme == mode ? shadowSm : const [],
                      onTap: () => ref.read(themeModeProvider.notifier).set(mode).catchError((_) {}),
                      child: SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(label,
                              style: t.labelMedium!.copyWith(
                                color: theme == mode ? c.onPrimary : c.onSurfaceVariant,
                                fontWeight: theme == mode ? FontWeight.w600 : FontWeight.w500,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      const ClinicalNotice(),
      const SizedBox(height: 16),
      row(Symbols.download, l.exportTitle, l.exportSub, () => _export(context, ref)),
      const SizedBox(height: 10),
      row(Symbols.logout, l.signOut, null, () => ref.read(settingsRepositoryProvider).signOut().catchError((_) {})),
      const SizedBox(height: 24),
      row(Symbols.delete_forever, l.deleteTitle, l.deleteSub, () => _delete(context, ref), color: c.error),
    ]);
  }
}

class _ProfileCard extends ConsumerStatefulWidget {
  const _ProfileCard({super.key, required this.profile});
  final Profile profile;

  @override
  ConsumerState<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends ConsumerState<_ProfileCard> {
  late final _name = TextEditingController(text: widget.profile.name);
  late final _year = TextEditingController(text: widget.profile.birthYear?.toString() ?? '');
  late final _height = TextEditingController(text: widget.profile.heightCm == null ? '' : fmtNum(widget.profile.heightCm!));
  late final _goal = TextEditingController(text: fmtNum(widget.profile.proteinGoalG));
  bool _saving = false;

  Future<void> _save() async {
    final goal = parseNum(_goal.text);
    if (_name.text.trim().isEmpty || goal == null || goal <= 0) return;
    setState(() => _saving = true);
    try {
      await ref.read(settingsRepositoryProvider).updateProfile(
            name: _name.text.trim(),
            birthYear: int.tryParse(_year.text),
            heightCm: parseNum(_height.text),
            proteinGoalG: goal,
          );
      ref.invalidate(profileProvider);
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
    const gap = SizedBox(height: 12);
    const number = TextInputType.numberWithOptions(decimal: true);
    Widget label(String s) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(s, style: t.labelMedium));
    return SectionCard(
      shadow: shadowSm,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          const IconBadge(Symbols.person),
          const SizedBox(width: 8),
          Text(l.settingsProfile, style: t.titleMedium),
        ]),
        const SizedBox(height: 16),
        label(l.obName),
        TextField(controller: _name, style: t.bodyLarge),
        gap,
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              label(l.obBirthYear),
              TextField(controller: _year, keyboardType: number, style: t.bodyLarge),
            ]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              label(l.obHeight),
              TextField(controller: _height, keyboardType: number, style: t.bodyLarge, decoration: const InputDecoration(suffixText: 'cm')),
            ]),
          ),
        ]),
        gap,
        label(l.settingsGoal),
        TextField(controller: _goal, keyboardType: number, style: t.bodyLarge, decoration: const InputDecoration(suffixText: 'g/dia')),
        const SizedBox(height: 6),
        Text(l.proteinReference, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
        const SizedBox(height: 16),
        PrimaryButton(label: l.save, height: 48, shadow: shadowSm, onPressed: _saving ? null : _save),
      ]),
    );
  }
}
