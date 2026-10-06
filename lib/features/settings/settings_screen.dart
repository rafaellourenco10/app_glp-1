import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../onboarding/onboarding_repository.dart';
import 'settings_repository.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
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
    final l = AppLocalizations.of(context);
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
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final profile = ref.watch(profileProvider).value;
    final theme = ref.watch(themeModeProvider);
    return ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: [
      Text(l.tabProfile, style: t.headlineLarge),
      const SizedBox(height: 16),
      if (profile != null) _ProfileCard(key: ValueKey(profile), profile: profile),
      const SizedBox(height: 16),
      Card(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l.settingsReminder),
            subtitle: Text(l.settingsReminderSub),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/doses'),
          ),
          ListTile(
            leading: const Icon(Icons.scale_outlined),
            title: Text(l.weightTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/weight'),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(l.settingsTheme, style: t.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(value: ThemeMode.system, label: Text(l.themeSystem)),
              ButtonSegment(value: ThemeMode.light, label: Text(l.themeLight)),
              ButtonSegment(value: ThemeMode.dark, label: Text(l.themeDark)),
            ],
            selected: {theme},
            onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).set(s.first).catchError((_) {}),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      InfoBox(l.disclaimer),
      const SizedBox(height: 16),
      Card(
        child: Column(children: [
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(l.exportTitle),
            subtitle: Text(l.exportSub),
            onTap: () => _export(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l.signOut),
            onTap: () => ref.read(settingsRepositoryProvider).signOut().catchError((_) {}),
          ),
        ]),
      ),
      const SizedBox(height: 24),
      OutlinedButton.icon(
        style: OutlinedButton.styleFrom(foregroundColor: c.error, side: BorderSide(color: c.error)),
        onPressed: () => _delete(context, ref),
        icon: const Icon(Icons.delete_forever_outlined),
        label: Text(l.deleteTitle, textAlign: TextAlign.center),
      ),
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
    final l = AppLocalizations.of(context);
    const gap = SizedBox(height: 12);
    const number = TextInputType.numberWithOptions(decimal: true);
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l.settingsProfile, style: Theme.of(context).textTheme.titleMedium),
        gap,
        TextField(controller: _name, decoration: InputDecoration(labelText: l.obName)),
        gap,
        Row(children: [
          Expanded(child: TextField(controller: _year, keyboardType: number, decoration: InputDecoration(labelText: l.obBirthYear))),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(controller: _height, keyboardType: number, decoration: InputDecoration(labelText: l.obHeight, suffixText: 'cm')),
          ),
        ]),
        gap,
        TextField(
          controller: _goal,
          keyboardType: number,
          decoration: InputDecoration(labelText: l.settingsGoal, suffixText: 'g/dia', helperText: l.proteinReference, helperMaxLines: 2),
        ),
        gap,
        OutlinedButton(onPressed: _saving ? null : _save, child: Text(l.save)),
      ]),
    );
  }
}
