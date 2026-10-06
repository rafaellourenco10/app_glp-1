import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import 'onboarding_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = 0;
  bool _consent = false;
  bool _saving = false;
  final _name = TextEditingController();
  final _year = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _dose = TextEditingController();
  String _medication = medications.first;
  int _weekday = 7;
  TimeOfDay _time = const TimeOfDay(hour: 20, minute: 0);
  double? _goal;

  double? get _weightKg {
    final w = parseNum(_weight.text);
    return w != null && w >= 20 && w <= 400 ? w : null;
  }

  bool get _step2Valid {
    final y = int.tryParse(_year.text);
    final h = parseNum(_height.text);
    return _name.text.trim().isNotEmpty &&
        y != null && y >= 1900 && y <= DateTime.now().year &&
        h != null && h >= 50 && h <= 250 &&
        _weightKg != null;
  }

  bool get _canContinue => switch (_step) {
        0 => _consent,
        1 => _step2Valid,
        2 => _dose.text.trim().isNotEmpty,
        _ => !_saving,
      };

  Future<void> _next() async {
    if (_step < 3) {
      setState(() {
        _step++;
        if (_step == 3) _goal ??= suggestedProteinGoal(_weightKg!);
      });
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(onboardingRepositoryProvider).complete(OnboardingData(
            name: _name.text.trim(),
            birthYear: int.parse(_year.text),
            heightCm: parseNum(_height.text)!,
            weightKg: _weightKg!,
            medication: _medication,
            doseLabel: _dose.text.trim(),
            weekday: _weekday,
            time: _time,
            proteinGoalG: _goal!,
          ));
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
    final c = Theme.of(context).colorScheme;
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step--);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: _step == 0
              ? null
              : IconButton(
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => setState(() => _step--),
                ),
          title: Semantics(
            label: l.obStepOf(_step + 1),
            child: Row(children: [
              for (var i = 0; i < 4; i++)
                Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: i <= _step ? c.primary : c.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
            ]),
          ),
          actions: const [SizedBox(width: 56)],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Align(alignment: Alignment.centerLeft, child: Pill(l.obStepOf(_step + 1))),
              const SizedBox(height: 12),
              ...switch (_step) {
                0 => _welcome(l),
                1 => _aboutYou(l),
                2 => _medicationStep(l),
                _ => _protein(l),
              },
              const SizedBox(height: 24),
              FilledButton(
                key: const ValueKey('ob_continue'),
                onPressed: _canContinue ? _next : null,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(_step == 3 ? l.obStart : l.obContinue),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String title, String subtitle) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: t.headlineLarge),
        const SizedBox(height: 4),
        Text(subtitle, style: t.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ]),
    );
  }

  List<Widget> _welcome(AppLocalizations l) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    Widget check(String s) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.check_circle, size: 20, color: c.primary),
            const SizedBox(width: 8),
            Expanded(child: Text(s, style: t.labelMedium)),
          ]),
        );
    return [
      _title(l.obWelcomeTitle, l.loginSubtitle),
      SectionCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CardHeader(icon: Icons.verified_user_outlined, title: l.obPrivacyTitle, subtitle: l.obPrivacySubtitle,
              tint: c.secondaryContainer.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(l.obPrivacyBody, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
          check(l.obPrivacy1),
          check(l.obPrivacy2),
          check(l.obPrivacy3),
        ]),
      ),
      const SizedBox(height: 16),
      InfoBox(l.disclaimer),
      const SizedBox(height: 16),
      SectionCard(
        padding: const EdgeInsets.all(8),
        child: CheckboxListTile(
          key: const ValueKey('ob_consent'),
          value: _consent,
          onChanged: (v) => setState(() => _consent = v ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(l.obConsent, style: t.bodyMedium),
          subtitle: Text(l.obConsentRequired, style: t.labelSmall),
        ),
      ),
    ];
  }

  Widget _field(String label, TextEditingController ctrl, Key key,
      {String? hint, String? helper, String? suffix, IconData? icon, bool number = false}) {
    return SectionCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        TextField(
          key: key,
          controller: ctrl,
          onChanged: (_) => setState(() {}),
          keyboardType: number ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.name,
          textCapitalization: number ? TextCapitalization.none : TextCapitalization.words,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helper,
            helperMaxLines: 3,
            suffixText: suffix,
            prefixIcon: icon == null ? null : Icon(icon),
          ),
        ),
      ]),
    );
  }

  List<Widget> _aboutYou(AppLocalizations l) => [
        _title(l.obAboutTitle, l.obAboutSubtitle),
        _field(l.obName, _name, const ValueKey('ob_name'), hint: l.obNameHint, icon: Icons.person_outline),
        const SizedBox(height: 12),
        _field(l.obBirthYear, _year, const ValueKey('ob_year'), hint: '1990', number: true),
        const SizedBox(height: 12),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _field(l.obHeight, _height, const ValueKey('ob_height'), hint: '168', suffix: 'cm', number: true)),
          const SizedBox(width: 8),
          Expanded(child: _field(l.obWeight, _weight, const ValueKey('ob_weight'), hint: '78,5', suffix: 'kg', number: true)),
        ]),
        const SizedBox(height: 16),
        InfoBox(l.obPrivacyNote, icon: Icons.lock_outline),
      ];

  List<Widget> _medicationStep(AppLocalizations l) {
    final t = Theme.of(context).textTheme;
    return [
      _title(l.obMedTitle, l.obMedSubtitle),
      Text(l.obMedLabel, style: t.titleMedium),
      const SizedBox(height: 8),
      DropdownButtonFormField<String>(
        key: const ValueKey('ob_med'),
        initialValue: _medication,
        items: [for (final m in medications) DropdownMenuItem(value: m, child: Text(m == 'Outro' ? l.medOther : m))],
        onChanged: (v) => setState(() => _medication = v!),
        decoration: const InputDecoration(prefixIcon: Icon(Icons.vaccines_outlined)),
      ),
      const SizedBox(height: 20),
      Text(l.obDoseLabel, style: t.titleMedium),
      const SizedBox(height: 8),
      TextField(
        key: const ValueKey('ob_dose'),
        controller: _dose,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(hintText: l.obDoseHint, helperText: l.obDoseHelper),
      ),
      const SizedBox(height: 20),
      Text(l.obWeekdayLabel, style: t.titleMedium),
      const SizedBox(height: 8),
      WeekdayPicker(value: _weekday, onChanged: (d) => setState(() => _weekday = d)),
      const SizedBox(height: 20),
      Text(l.obTimeLabel, style: t.titleMedium),
      const SizedBox(height: 8),
      TimeTile(value: _time, onChanged: (v) => setState(() => _time = v)),
      const SizedBox(height: 16),
      InfoBox(l.obReminderNote, icon: Icons.notifications_outlined),
    ];
  }

  List<Widget> _protein(AppLocalizations l) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final goal = _goal!;
    return [
      _title(l.obProteinTitle, l.obProteinSubtitle),
      SectionCard(
        child: Column(children: [
          Text(l.obProteinTarget.toUpperCase(), style: t.labelMedium?.copyWith(letterSpacing: 1)),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: fmtNum(goal), style: t.displayMedium?.copyWith(color: c.primary)),
              TextSpan(text: ' g/dia', style: t.titleMedium),
            ]),
            key: const ValueKey('ob_goal'),
          ),
          const SizedBox(height: 8),
          Pill(l.obProteinRatio(fmtNum(goal / _weightKg!))),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton.filledTonal(
              tooltip: l.obProteinLess,
              onPressed: goal > 10 ? () => setState(() => _goal = goal - 5) : null,
              icon: const Icon(Icons.remove),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(l.obProteinStep, style: t.labelMedium),
            ),
            IconButton.filledTonal(
              tooltip: l.obProteinMore,
              onPressed: () => setState(() => _goal = goal + 5),
              icon: const Icon(Icons.add),
            ),
          ]),
        ]),
      ),
      const SizedBox(height: 16),
      InfoBox(l.proteinReference, color: c.secondaryContainer.withValues(alpha: 0.25)),
    ];
  }
}
