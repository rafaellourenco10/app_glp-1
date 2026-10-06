import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../l10n/app_localizations.dart';
import '../l10n/format.dart';

// Componentes que espelham as classes Tailwind das telas do Stitch (telas/*/code.html).

/// shadow-[0px_4px_20px_rgba(15,118,110,0.05)] — cards principais.
const shadowCard = [BoxShadow(color: Color(0x0D0F766E), blurRadius: 20, offset: Offset(0, 4))];

/// shadow-sm do Tailwind.
const shadowSm = [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))];

/// shadow-md do Tailwind.
const shadowMd = [
  BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -1),
  BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2), spreadRadius: -2),
];

/// shadow-[0_8px_20px_rgba(0,92,85,0.22)] — botão principal de ação.
const shadowPrimary = [BoxShadow(color: Color(0x38005C55), blurRadius: 20, offset: Offset(0, 8))];

/// Atalhos de tema.
extension Ctx on BuildContext {
  ColorScheme get c => Theme.of(this).colorScheme;
  TextTheme get t => Theme.of(this).textTheme;
  AppLocalizations get l => AppLocalizations.of(this);
}

/// Caixa genérica: cor, raio, padding e sombra (um `div` com classes).
class Box extends StatelessWidget {
  const Box({
    super.key,
    required this.child,
    this.color,
    this.radius = 20,
    this.padding = const EdgeInsets.all(20),
    this.shadow = const [],
    this.onTap,
    this.border,
  });
  final Widget child;
  final Color? color;
  final double radius;
  final EdgeInsets padding;
  final List<BoxShadow> shadow;
  final VoidCallback? onTap;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    return Container(
      decoration: BoxDecoration(color: color ?? context.c.surfaceContainerLowest, borderRadius: r, boxShadow: shadow, border: border),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: r,
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: Padding(padding: padding, child: child)),
      ),
    );
  }
}

/// bg-surface-container-lowest rounded-[20px] p-space-lg + sombra de card.
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.shadow = shadowCard, this.onTap});
  final Widget child;
  final EdgeInsets padding;
  final List<BoxShadow> shadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Box(padding: padding, shadow: shadow, onTap: onTap, child: child);
}

/// Ícone dentro de círculo/quadrado colorido (w-8 h-8 rounded-full bg-... text-...).
class IconBadge extends StatelessWidget {
  const IconBadge(this.icon, {super.key, this.size = 32, this.iconSize = 18, this.bg, this.fg, this.radius, this.fill = false});
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? bg;
  final Color? fg;
  final double? radius; // null = círculo
  final bool fill;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg ?? context.c.primaryFixed,
          borderRadius: BorderRadius.circular(radius ?? size / 2),
        ),
        child: Icon(icon, size: iconSize, color: fg ?? context.c.primary, fill: fill ? 1 : 0),
      );
}

/// Pílula: px-2.5 py-1 rounded-full font-label-sm.
class Pill extends StatelessWidget {
  const Pill(this.text, {super.key, this.background, this.foreground, this.icon, this.dot = false, this.style});
  final String text;
  final Color? background;
  final Color? foreground;
  final IconData? icon;
  final bool dot;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final fg = foreground ?? context.c.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: background ?? context.c.surfaceContainer, borderRadius: BorderRadius.circular(99)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (dot) ...[
          Container(width: 6, height: 6, decoration: BoxDecoration(color: context.c.primary, shape: BoxShape.circle)),
          const SizedBox(width: 6),
        ],
        if (icon != null) ...[Icon(icon, size: 14, color: fg, fill: 1), const SizedBox(width: 4)],
        Flexible(child: Text(text, style: (style ?? context.t.labelSmall)!.copyWith(color: fg))),
      ]),
    );
  }
}

/// Caixa de dica: ícone + (título) + texto. Variações de cor via [color].
class Tip extends StatelessWidget {
  const Tip(this.text, {super.key, this.title, this.icon = Symbols.info, this.color, this.iconBadge = false, this.iconColor, this.titleColor});
  final String text;
  final String? title;
  final IconData icon;
  final Color? color;
  final bool iconBadge;
  final Color? iconColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color ?? c.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (iconBadge)
          IconBadge(icon, size: 36, iconSize: 20, bg: c.secondaryContainer.withValues(alpha: 0.5), fg: iconColor ?? c.primary)
        else
          Padding(padding: const EdgeInsets.only(top: 2), child: Icon(icon, size: 20, color: iconColor ?? c.primary)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (title != null)
              Text(title!, style: context.t.labelMedium!.copyWith(fontWeight: FontWeight.w600, color: titleColor ?? c.onSurface)),
            Text(text, style: context.t.bodyMedium!.copyWith(color: c.onSurfaceVariant)),
          ]),
        ),
      ]),
    );
  }
}

/// Botão principal (h-[52px] rounded-full) com ícone à esquerda ou seta à direita.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailing,
    this.color,
    this.foreground,
    this.radius,
    this.shadow = shadowPrimary,
    this.height = 52,
    this.expand = true,
  });
  final bool expand;
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailing;
  final Color? color;
  final Color? foreground;
  final double? radius; // null = pílula
  final List<BoxShadow> shadow;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? context.c.primary;
    final fg = foreground ?? context.c.onPrimary;
    final shape = radius == null ? const StadiumBorder() : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius!));
    return Container(
      decoration: ShapeDecoration(shape: shape, shadows: onPressed == null ? const [] : shadow),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withValues(alpha: 0.4),
          disabledForegroundColor: fg.withValues(alpha: 0.9),
          minimumSize: Size(expand ? double.infinity : 0, height),
          padding: expand ? null : const EdgeInsets.symmetric(horizontal: 24),
          shape: shape,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 22), const SizedBox(width: 8)],
          Flexible(child: Text(label, textAlign: TextAlign.center)),
          if (trailing != null) ...[const SizedBox(width: 8), Icon(trailing, size: 20)],
        ]),
      ),
    );
  }
}

/// Avatar com a inicial do nome (no lugar da foto dos mockups).
class Avatar extends StatelessWidget {
  const Avatar(this.name, {super.key, this.size = 32});
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: context.c.primaryContainer, shape: BoxShape.circle),
        child: Text(
          name.trim().isEmpty ? '' : name.trim()[0].toUpperCase(),
          style: TextStyle(color: context.c.onPrimary, fontWeight: FontWeight.w700, fontSize: size * 0.42),
        ),
      );
}

/// Barra superior das abas: logo + "COMPANHEIRO GLP-1" + título; sino + avatar.
class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key, required this.title, required this.name, this.onBell, this.onAvatar, this.onBack});
  final String title;
  final VoidCallback? onBack;
  final String name;
  final VoidCallback? onBell;
  final VoidCallback? onAvatar;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: 0.85),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 1))],
      ),
      child: Row(children: [
        if (onBack != null)
          IconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: onBack,
            icon: Icon(Symbols.arrow_back, color: c.onSurface),
          )
        else
          ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.asset('assets/images/logo_mark.png', height: 32)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(context.l.appName.toUpperCase(),
                overflow: TextOverflow.ellipsis, style: context.t.labelSmall!.copyWith(color: c.primary, letterSpacing: 0.55)),
            Text(title, overflow: TextOverflow.ellipsis, style: context.t.titleMedium),
          ]),
        ),
        IconButton(
          tooltip: context.l.settingsReminder,
          onPressed: onBell,
          icon: Icon(Symbols.notifications, size: 24, color: c.onSurfaceVariant),
        ),
        IconButton(tooltip: context.l.tabProfile, onPressed: onAvatar, icon: Avatar(name)),
      ]),
    );
  }
}

/// Cabeçalho do onboarding/sessão: voltar + 4 barras de progresso + ícone de pessoa.
class StepHeader extends StatelessWidget {
  const StepHeader({super.key, required this.step, this.onBack, this.semanticsLabel});
  final int step; // 0..3
  final VoidCallback? onBack;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    const alphas = [1.0, 0.25, 0.15, 0.10];
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: 0.8),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0, 1))],
      ),
      child: Row(children: [
        SizedBox(
          width: 44,
          child: onBack == null
              ? null
              : IconButton(
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: onBack,
                  icon: Icon(Symbols.arrow_back, color: c.onSurface),
                ),
        ),
        Expanded(
          child: Center(
            child: Semantics(
              label: semanticsLabel,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Row(children: [
                  for (var i = 0; i < 4; i++)
                    Expanded(
                      child: Container(
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: c.primary.withValues(alpha: i <= step ? 1 : alphas[i]),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                ]),
              ),
            ),
          ),
        ),
        IconBadge(Symbols.person, size: 32, iconSize: 18, bg: c.primary, fg: c.onPrimary),
        const SizedBox(width: 8),
      ]),
    );
  }
}

/// Erro amigável com botão de tentar de novo.
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Symbols.cloud_off, size: 40, color: context.c.outline),
          const SizedBox(height: 12),
          Text(context.l.errorLoad, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: Text(context.l.retry)),
        ]),
      );
}

/// SnackBar de erro amigável para falhas de escrita.
void showError(BuildContext context) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).errorSave)));

/// Seletor Dom..Sáb em grade de 7 (ISO weekday: 1=seg..7=dom).
/// [square]: estilo da tela de Doses (h-12 rounded-xl); senão, estilo do onboarding (h-11 rounded-full).
class WeekdayPicker extends StatelessWidget {
  const WeekdayPicker({super.key, required this.value, required this.onChanged, this.square = false});
  final int value;
  final ValueChanged<int> onChanged;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final names = context.l.weekdaysShort.split(',');
    return Row(children: [
      for (final (i, d) in const [7, 1, 2, 3, 4, 5, 6].indexed) ...[
        if (i > 0) const SizedBox(width: 6),
        Expanded(
          child: Semantics(
            selected: d == value,
            button: true,
            child: Box(
              radius: square ? 12 : 99,
              padding: EdgeInsets.zero,
              color: d == value ? (square ? c.primary : c.primaryContainer) : (square ? c.surfaceContainerLow : c.surfaceContainerLowest),
              shadow: square && d != value ? const [] : shadowSm,
              onTap: () => onChanged(d),
              child: SizedBox(
                height: square ? 48 : 44,
                child: Center(
                  child: Text(
                    names[d - 1],
                    style: context.t.labelMedium!.copyWith(
                      color: d == value ? c.onPrimary : c.onSurfaceVariant,
                      fontWeight: d == value && square ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ]);
  }
}

String periodOfDay(AppLocalizations l, TimeOfDay t) =>
    t.hour < 6 ? l.periodDawn : t.hour < 12 ? l.periodMorning : t.hour < 18 ? l.periodAfternoon : l.periodNight;

Future<void> pickTime(BuildContext context, TimeOfDay value, ValueChanged<TimeOfDay> onChanged) async {
  final picked = await showTimePicker(context: context, initialTime: value);
  if (picked != null) onChanged(picked);
}

/// Card de horário do onboarding: relógio + 20:00 + período + "Ajustar".
class TimeTile extends StatelessWidget {
  const TimeTile({super.key, required this.value, required this.onChanged, this.subtitle});
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChanged;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final t = context.t;
    return Box(
      radius: 16,
      padding: const EdgeInsets.all(16),
      shadow: shadowSm,
      onTap: () => pickTime(context, value, onChanged),
      child: Row(children: [
        IconBadge(Symbols.schedule, size: 44, iconSize: 24, radius: 12, bg: c.primary.withValues(alpha: 0.1)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(fmtTime(value), style: t.headlineSmall),
              const SizedBox(width: 8),
              Pill(periodOfDay(context.l, value), foreground: c.onSurfaceVariant),
            ]),
            if (subtitle != null)
              Text(subtitle!, overflow: TextOverflow.ellipsis, style: t.labelSmall!.copyWith(color: c.onSurfaceVariant)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(color: c.surfaceContainer, borderRadius: BorderRadius.circular(99)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(context.l.adjust, style: t.labelSmall!.copyWith(color: c.primary)),
            const SizedBox(width: 4),
            Icon(Symbols.tune, size: 14, color: c.primary),
          ]),
        ),
      ]),
    );
  }
}

/// Título de seção ("Histórico recente" + ação à direita).
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.subtitle, this.trailing, this.big = false});
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool big;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: big ? context.t.headlineSmall : context.t.titleMedium),
            if (subtitle != null) Text(subtitle!, style: context.t.labelSmall!.copyWith(color: context.c.onSurfaceVariant)),
          ]),
        ),
        ?trailing,
      ]);
}

/// Faixa de status do topo das telas ("CICLO SEMANAL • DOSE ATIVA").
class StatusChip extends StatelessWidget {
  const StatusChip(this.text, {super.key, this.icon, this.background, this.foreground});
  final String text;
  final IconData? icon;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final fg = foreground ?? c.secondary;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: background ?? c.secondaryContainer.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(99)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null)
            Icon(icon, size: 15, color: fg, fill: 1)
          else
            Container(width: 8, height: 8, decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(text, style: context.t.labelSmall!.copyWith(color: fg, letterSpacing: 0.55)),
        ]),
      ),
    );
  }
}

/// Título grande de página + subtítulo.
class PageTitle extends StatelessWidget {
  const PageTitle(this.title, this.subtitle, {super.key, this.trailing});
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: context.t.headlineLarge!.copyWith(letterSpacing: -0.65)),
            const SizedBox(height: 4),
            Text(subtitle, style: context.t.bodyMedium!.copyWith(color: context.c.onSurfaceVariant, height: 1.6)),
          ]),
        ),
        ?trailing,
      ]);
}
