import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/l10n/format.dart';
import '../../core/theme/widgets.dart';
import '../auth/login_screen.dart';
import 'onboarding_repository.dart';

/// Nome genérico mostrado ao lado do nome comercial na lista.
const _generic = {
  'Ozempic': 'Semaglutida',
  'Wegovy': 'Semaglutida',
  'Mounjaro': 'Tirzepatida',
  'Zepbound': 'Tirzepatida',
  'Saxenda': 'Liraglutida',
};

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
    final l = context.l;
    final c = context.c;
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step--);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            if (_step > 0) StepHeader(step: _step, onBack: () => setState(() => _step--), semanticsLabel: l.obStepOf(_step + 1)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  ...switch (_step) {
                    0 => _welcome(l),
                    1 => _aboutYou(l),
                    2 => _medicationStep(l),
                    _ => _protein(l),
                  },
                  const SizedBox(height: 20),
                  PrimaryButton(
                    key: const ValueKey('ob_continue'),
                    label: _step == 3 ? l.obStart : l.obContinue,
                    trailing: Symbols.arrow_forward,
                    color: _step == 0 || _step == 2 ? c.primaryContainer : c.primary,
                    radius: 16,
                    height: _step == 3 ? 54 : 52,
                    shadow: shadowMd,
                    onPressed: _canContinue ? _next : null,
                  ),
                  if (_step == 1) ...[
                    const SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Symbols.verified, size: 16, color: c.primary),
                      const SizedBox(width: 6),
                      Text(l.obLgpdBadge, style: context.t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
                    ]),
                  ],
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _heading(String title, String subtitle) => Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 20),
        child: PageTitle(title, subtitle),
      );

  /// Card branco com título do campo (padrão do Onboarding 2).
  Widget _fieldCard({required Widget child}) => SectionCard(shadow: shadowSm, child: child);

  // ---------------- Etapa 1: boas-vindas, privacidade, aviso e consentimento ----------------
  List<Widget> _welcome(AppLocalizations l) {
    final c = context.c;
    final t = context.t;
    Widget check(String s) => Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(children: [
            IconBadge(Symbols.check, size: 20, iconSize: 14, bg: c.primary.withValues(alpha: 0.1)),
            const SizedBox(width: 8),
            Expanded(child: Text(s, style: t.labelMedium)),
          ]),
        );
    return [
      Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(
              child: Text(l.obWelcomeLabel.toUpperCase(),
                  style: t.labelSmall!.copyWith(color: c.onSurfaceVariant, letterSpacing: 0.55)),
            ),
            Text(l.obStepOf(1), style: t.labelSmall!.copyWith(color: c.primary, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            for (var i = 0; i < 4; i++) ...[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == 0 ? c.primaryContainer : c.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ],
          ]),
        ]),
      ),
      WelcomeBanner(title: l.obWelcomeTitle, subtitle: l.loginSubtitle),
      const SizedBox(height: 20),
      SectionCard(
        shadow: shadowSm,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            IconBadge(Symbols.verified_user, size: 40, iconSize: 22, radius: 12, bg: c.secondaryContainer.withValues(alpha: 0.4), fill: true),
            const SizedBox(width: 8),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.obPrivacyTitle, style: t.titleMedium),
                Text(l.obPrivacySubtitle, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Text(l.obPrivacyBody, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant, height: 1.6)),
          const SizedBox(height: 4),
          check(l.obPrivacy1),
          check(l.obPrivacy2),
          check(l.obPrivacy3),
        ]),
      ),
      const SizedBox(height: 16),
      const ClinicalNotice(),
      const SizedBox(height: 20),
      Semantics(
        checked: _consent,
        child: Box(
          key: const ValueKey('ob_consent'),
          radius: 16,
          padding: const EdgeInsets.all(16),
          shadow: shadowSm,
          onTap: () => setState(() => _consent = !_consent),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: _consent ? c.primaryContainer : c.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _consent ? Icon(Symbols.check, size: 16, color: c.onPrimary, weight: 700) : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.obConsent, style: t.bodyMedium),
                const SizedBox(height: 4),
                Text(l.obConsentRequired, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
              ]),
            ),
          ]),
        ),
      ),
    ];
  }

  // ---------------- Etapa 2: dados básicos ----------------
  List<Widget> _aboutYou(AppLocalizations l) {
    final c = context.c;
    final t = context.t;
    InputDecoration soft({String? hint, IconData? icon}) => InputDecoration(
          hintText: hint,
          prefixIcon: icon == null ? null : Icon(icon, size: 20, color: c.onSurfaceVariant.withValues(alpha: 0.6)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusColor: c.surfaceContainer,
        );
    Widget metric(String label, IconData icon, TextEditingController ctrl, Key key, String hint, String caption) =>
        Expanded(
          child: SectionCard(
            shadow: shadowSm,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(children: [
                Expanded(child: Text(label, style: t.labelMedium!.copyWith(fontWeight: FontWeight.w600))),
                Icon(icon, size: 18, color: c.secondary),
              ]),
              const SizedBox(height: 8),
              TextField(
                key: key,
                controller: ctrl,
                onChanged: (_) => setState(() {}),
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: t.titleMedium!.copyWith(letterSpacing: 0.4),
                decoration: soft(hint: hint),
              ),
              const SizedBox(height: 6),
              Text(caption, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
            ]),
          ),
        );
    return [
      Row(children: [
        Expanded(
          child: Text(l.obStepByStep.toUpperCase(), style: t.labelSmall!.copyWith(color: c.primary, letterSpacing: 0.55)),
        ),
        Pill(l.obStepOf(2), foreground: c.onSurfaceVariant),
      ]),
      const SizedBox(height: 12),
      _PhotoHeader(image: 'assets/images/ob2_interior.jpg', label: l.obPersonalCare),
      const SizedBox(height: 16),
      _heading(l.obAboutTitle, l.obAboutSubtitle),
      _fieldCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.obName, style: t.titleMedium),
          const SizedBox(height: 4),
          Text(l.obNameCaption, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
          const SizedBox(height: 8),
          TextField(
            key: const ValueKey('ob_name'),
            controller: _name,
            onChanged: (_) => setState(() {}),
            textCapitalization: TextCapitalization.words,
            style: t.bodyLarge,
            decoration: soft(hint: l.obNameHint, icon: Symbols.person),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      _fieldCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(l.obBirthYear, style: t.titleMedium)),
            Icon(Symbols.cake, size: 20, color: c.primary),
          ]),
          const SizedBox(height: 4),
          TextField(
            key: const ValueKey('ob_year'),
            controller: _year,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.number,
            style: t.bodyLarge,
            decoration: soft(hint: l.obYearHint),
          ),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Symbols.info, size: 16, color: c.primary),
            const SizedBox(width: 6),
            Expanded(child: Text(l.obYearInfo, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant))),
          ]),
        ]),
      ),
      const SizedBox(height: 16),
      Row(children: [
        metric(l.obHeight, Symbols.straighten, _height, const ValueKey('ob_height'), '168', l.obCentimeters),
        const SizedBox(width: 8),
        metric(l.obWeight, Symbols.scale, _weight, const ValueKey('ob_weight'), '78,5', l.obKilograms),
      ]),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: c.surfaceContainerLow.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(16)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconBadge(Symbols.lock, size: 32, iconSize: 18, bg: c.secondaryContainer, fg: c.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(child: Text(l.obPrivacyNote, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant))),
        ]),
      ),
    ];
  }

  // ---------------- Etapa 3: medicação e rotina ----------------
  List<Widget> _medicationStep(AppLocalizations l) {
    final c = context.c;
    final t = context.t;
    Widget label(String s, [Widget? trailing]) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(children: [Expanded(child: Text(s, style: t.labelMedium)), ?trailing]),
        );
    return [
      Row(children: [
        Pill(l.obStepOf(3).toUpperCase(), dot: true, foreground: c.onSurfaceVariant, style: t.labelSmall!.copyWith(letterSpacing: 0.55)),
        const Spacer(),
        Text(l.obAlmostThere, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant.withValues(alpha: 0.8))),
      ]),
      const SizedBox(height: 12),
      _heading(l.obMedTitle, l.obMedSubtitle),
      Box(
        color: c.surfaceContainerLow,
        radius: 16,
        padding: const EdgeInsets.all(16),
        shadow: shadowSm,
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/images/ob3_pens.jpg', width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Icon(Symbols.shield_with_heart, size: 16, color: c.primary, fill: 1),
                const SizedBox(width: 4),
                Text(l.obMedHeroTag, style: t.labelSmall!.copyWith(color: c.primary)),
              ]),
              Text(l.obMedHeroTitle, style: t.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
              Text(l.obMedHeroBody, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      label(l.obMedLabel),
      Box(
        key: const ValueKey('ob_med'),
        radius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shadow: shadowSm,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _medication,
            isExpanded: true,
            itemHeight: 52,
            borderRadius: BorderRadius.circular(16),
            dropdownColor: c.surfaceContainerLowest,
            icon: Icon(Symbols.expand_more, color: c.outline),
            onChanged: (v) => setState(() => _medication = v!),
            selectedItemBuilder: (_) => [
              for (final m in medications)
                Row(children: [
                  IconBadge(Symbols.vaccines, bg: c.secondaryContainer.withValues(alpha: 0.4)),
                  const SizedBox(width: 8),
                  Text(m == 'Outro' ? l.medOther : m, style: t.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
                ]),
            ],
            items: [
              for (final m in medications)
                DropdownMenuItem(
                  value: m,
                  child: Text(_generic[m] == null ? l.medOther : '$m (${_generic[m]})', style: t.bodyMedium),
                ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
      label(l.obDoseLabel),
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: shadowSm),
        child: TextField(
          key: const ValueKey('ob_dose'),
          controller: _dose,
          onChanged: (_) => setState(() {}),
          style: t.bodyLarge,
          decoration: InputDecoration(
            hintText: l.obDoseHint,
            fillColor: c.surfaceContainerLowest,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(10),
              child: IconBadge(Symbols.edit_note, bg: c.surfaceContainer, fg: c.outline),
            ),
          ),
        ),
      ),
      const SizedBox(height: 6),
      Row(children: [
        const SizedBox(width: 4),
        Icon(Symbols.info, size: 14, color: c.primary),
        const SizedBox(width: 4),
        Text(l.obDoseHelper, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
      ]),
      const SizedBox(height: 20),
      label(l.obWeekdayLabel, Text(l.obOncePerWeek, style: t.labelSmall!.copyWith(color: c.primary))),
      const SizedBox(height: 2),
      WeekdayPicker(value: _weekday, onChanged: (d) => setState(() => _weekday = d)),
      const SizedBox(height: 20),
      label(l.obTimeLabel),
      TimeTile(value: _time, onChanged: (v) => setState(() => _time = v), subtitle: l.obTimeSubtitle),
      const SizedBox(height: 20),
      Box(
        color: c.surfaceContainerLow,
        radius: 16,
        padding: const EdgeInsets.all(16),
        shadow: shadowSm,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Symbols.spa, size: 20, color: c.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.obReminderTipTitle, style: t.labelMedium!.copyWith(fontWeight: FontWeight.w600)),
              Text(l.obReminderNote, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
            ]),
          ),
        ]),
      ),
    ];
  }

  // ---------------- Etapa 4: meta de proteína ----------------
  List<Widget> _protein(AppLocalizations l) {
    final c = context.c;
    final t = context.t;
    final goal = _goal!;
    // Divisão ilustrativa da meta em 4 refeições, arredondada de 5 em 5 g.
    final meals = [
      (l.mealBreakfast, 0.23),
      (l.mealLunch, 0.31),
      (l.mealSnack, 0.19),
      (l.mealDinner, 0.27),
    ];
    Widget stepBtn(IconData icon, String tip, VoidCallback? onTap) => Tooltip(
          message: tip,
          child: Box(
            radius: 12,
            padding: EdgeInsets.zero,
            shadow: shadowSm,
            onTap: onTap,
            child: SizedBox(width: 48, height: 48, child: Icon(icon, size: 24, color: c.primary)),
          ),
        );
    return [
      Row(children: [
        Pill(l.obStepOf(4).toUpperCase(),
            background: c.secondaryContainer.withValues(alpha: 0.3),
            style: t.labelMedium!.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.3)),
        const Spacer(),
        Icon(Symbols.verified, size: 18, color: c.secondary, fill: 1),
        const SizedBox(width: 6),
        Text(l.obFinalPhase, style: t.labelSmall!.copyWith(color: c.secondary)),
      ]),
      const SizedBox(height: 20),
      _heading(l.obProteinTitle, l.obProteinSubtitle),
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 128,
          child: Stack(fit: StackFit.expand, children: [
            Image.asset('assets/images/ob4_meal.jpg', fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    c.onSurface.withValues(alpha: 0.7),
                    c.onSurface.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Row(children: [
                const Icon(Symbols.restaurant_menu, size: 20, color: Color(0xFFFBF9F6), fill: 1),
                const SizedBox(width: 8),
                Expanded(child: Text(l.obProteinPhoto, style: t.labelMedium!.copyWith(color: const Color(0xFFFBF9F6)))),
              ]),
            ),
          ]),
        ),
      ),
      const SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(color: c.surfaceContainerLowest, borderRadius: BorderRadius.circular(16), boxShadow: shadowMd),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          Container(
            height: 6,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [c.primaryFixedDim, c.primary, c.secondary])),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            child: Column(children: [
              Row(children: [
                Expanded(
                  child: Text(l.obProteinTarget.toUpperCase(), style: t.titleSmall!.copyWith(color: c.onSurfaceVariant, letterSpacing: 0.65)),
                ),
                Icon(Symbols.fitness_center, size: 22, color: c.primary, fill: 1),
              ]),
              const SizedBox(height: 16),
              Text.rich(
                key: const ValueKey('ob_goal'),
                TextSpan(children: [
                  TextSpan(text: fmtNum(goal), style: t.displayMedium!.copyWith(color: c.primary)),
                  TextSpan(text: '  g / dia', style: t.titleMedium!.copyWith(color: c.onSurfaceVariant)),
                ]),
              ),
              const SizedBox(height: 16),
              Pill(l.obProteinRatio(fmtNum(goal / _weightKg!)), icon: Symbols.calculate, background: c.surfaceContainerLow),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                child: Row(children: [
                  stepBtn(Symbols.remove, l.obProteinLess, goal > 10 ? () => setState(() => _goal = goal - 5) : null),
                  Expanded(
                    child: Column(children: [
                      Text(l.obProteinAdjust, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
                      Text(l.obProteinStep, style: t.labelMedium!.copyWith(color: c.primary, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                  stepBtn(Symbols.add, l.obProteinMore, () => setState(() => _goal = goal + 5)),
                ]),
              ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                for (final (i, (name, share)) in meals.indexed) ...[
                  if (i > 0)
                    Container(width: 6, height: 6, decoration: BoxDecoration(color: c.surfaceContainerHighest, shape: BoxShape.circle)),
                  Column(children: [
                    Text(name, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
                    Text('${fmtNum((goal * share / 5).round() * 5)}g', style: t.titleMedium),
                  ]),
                ],
              ]),
            ]),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: c.secondaryContainer.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(Symbols.info, size: 22, color: c.primary, fill: 1),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: '${l.note}: ', style: TextStyle(fontWeight: FontWeight.w600, color: c.onSurface)),
                TextSpan(text: l.proteinReference),
              ]),
              style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 20),
      Box(
        color: c.surfaceContainer,
        radius: 16,
        padding: const EdgeInsets.all(16),
        shadow: shadowSm,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconBadge(Symbols.lightbulb, size: 36, iconSize: 20, bg: c.primaryFixedDim.withValues(alpha: 0.4), fill: true),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(l.obComfortTitle, style: t.labelMedium!.copyWith(color: c.primary, fontWeight: FontWeight.w600)),
              Text(l.obComfortBody, style: t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
            ]),
          ),
        ]),
      ),
    ];
  }
}

/// Foto h-36 com degradê para o fundo e selo (Onboarding 2).
class _PhotoHeader extends StatelessWidget {
  const _PhotoHeader({required this.image, required this.label});
  final String image;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      height: 144,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: shadowSm),
      clipBehavior: Clip.antiAlias,
      child: Stack(fit: StackFit.expand, children: [
        Image.asset(image, fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [c.surface, c.surface.withValues(alpha: 0.4), Colors.transparent],
            ),
          ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: c.surfaceContainerLowest.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(99),
              boxShadow: shadowSm,
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Symbols.spa, size: 18, color: c.primary, fill: 1),
              const SizedBox(width: 8),
              Text(label, style: context.t.labelSmall!.copyWith(color: c.primary)),
            ]),
          ),
        ),
      ]),
    );
  }
}
