import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Card branco, raio 20, padding 20 (padrão das telas).
class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.color, this.padding = const EdgeInsets.all(20)});
  final Widget child;
  final Color? color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) =>
      Card(color: color, child: Padding(padding: padding, child: child));
}

/// Ícone em círculo colorido + título/subtítulo (cabeçalho dos cards).
class CardHeader extends StatelessWidget {
  const CardHeader({super.key, required this.icon, required this.title, this.subtitle, this.trailing, this.tint});
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Row(children: [
      CircleAvatar(
        radius: 18,
        backgroundColor: tint ?? c.primaryFixed,
        child: Icon(icon, size: 20, color: c.onPrimaryFixed),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: t.titleMedium),
          if (subtitle != null) Text(subtitle!, style: t.labelMedium?.copyWith(color: c.onSurfaceVariant)),
        ]),
      ),
      ?trailing,
    ]);
  }
}

/// Etiqueta em pílula ("Em 3 dias", "71% hoje").
class Pill extends StatelessWidget {
  const Pill(this.text, {super.key, this.background, this.foreground});
  final String text;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: background ?? c.surfaceContainer, borderRadius: BorderRadius.circular(99)),
      child: Text(text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: foreground ?? c.primary, fontSize: 12)),
    );
  }
}

/// Caixa de aviso suave (info / disclaimer).
class InfoBox extends StatelessWidget {
  const InfoBox(this.text, {super.key, this.icon = Icons.info_outline, this.color});
  final String text;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color ?? c.surfaceContainer, borderRadius: BorderRadius.circular(16)),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 20, color: c.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.onSurfaceVariant))),
      ]),
    );
  }
}

/// Erro amigável com botão de tentar de novo.
class ErrorRetry extends StatelessWidget {
  const ErrorRetry({super.key, required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.cloud_off_outlined, size: 40, color: Theme.of(context).colorScheme.outline),
        const SizedBox(height: 12),
        Text(l.errorLoad, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: onRetry, child: Text(l.retry)),
      ]),
    );
  }
}

/// Atalho: SnackBar de erro amigável para falhas de escrita.
void showError(BuildContext context) => ScaffoldMessenger.of(context)
    .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).errorSave)));
