import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/widgets.dart';
import 'auth_repository.dart';

/// Sem mockup próprio: segue o padrão visual do Onboarding 1 (banner + cards brancos).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  bool _busy = false;

  Future<void> _run(Future<void> Function() action, {String? success}) async {
    setState(() => _busy = true);
    try {
      await action();
      if (mounted && success != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(success)));
      }
    } catch (_) {
      if (mounted) showError(context);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final t = context.t;
    final c = context.c;
    final repo = ref.read(authRepositoryProvider);
    Widget social(IconData icon, String label, Future<void> Function() action) => Box(
          radius: 99,
          padding: EdgeInsets.zero,
          shadow: shadowSm,
          onTap: _busy ? null : () => _run(action),
          child: SizedBox(
            height: 52,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 22, color: c.onSurface),
              const SizedBox(width: 8),
              Text(label, style: t.titleMedium),
            ]),
          ),
        );
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: [
          WelcomeBanner(title: l.appName, subtitle: l.loginSubtitle),
          const SizedBox(height: 20),
          SectionCard(
            shadow: shadowSm,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                IconBadge(Symbols.mail, size: 40, iconSize: 22, radius: 12, bg: c.secondaryContainer.withValues(alpha: 0.4), fill: true),
                const SizedBox(width: 8),
                Expanded(child: Text(l.loginEmailLabel, style: t.titleMedium)),
              ]),
              const SizedBox(height: 16),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                style: t.bodyLarge,
                decoration: InputDecoration(hintText: l.loginEmailHint, prefixIcon: Icon(Symbols.alternate_email, color: c.outline)),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: l.loginSendLink,
                trailing: Symbols.arrow_forward,
                color: c.primaryContainer,
                radius: 16,
                shadow: shadowMd,
                onPressed: _busy
                    ? null
                    : () {
                        if (!_email.text.contains('@')) return;
                        _run(() => repo.sendMagicLink(_email.text), success: l.loginLinkSent);
                      },
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: Divider(color: c.outlineVariant)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(l.loginOr, style: t.labelMedium!.copyWith(color: c.onSurfaceVariant)),
            ),
            Expanded(child: Divider(color: c.outlineVariant)),
          ]),
          const SizedBox(height: 20),
          social(Icons.apple, l.loginApple, repo.signInWithApple),
          const SizedBox(height: 12),
          social(Icons.g_mobiledata, l.loginGoogle, repo.signInWithGoogle),
          const SizedBox(height: 24),
          const ClinicalNotice(),
        ]),
      ),
    );
  }
}

/// Banner do Onboarding 1: foto suave ao fundo + pílula "Seu espaço seguro" + título. Usado no login e no Onboarding 1.
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      constraints: const BoxConstraints(minHeight: 148),
      decoration: BoxDecoration(color: c.surfaceContainerLow, borderRadius: BorderRadius.circular(16), boxShadow: shadowSm),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        Positioned.fill(
          child: Opacity(
            opacity: 0.35,
            child: Image.asset('assets/images/ob1_tea.jpg', fit: BoxFit.cover, colorBlendMode: BlendMode.multiply, color: c.surfaceContainerLow),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Pill(context.l.loginBadge,
                icon: Symbols.spa,
                background: c.secondaryContainer.withValues(alpha: 0.6),
                foreground: c.onSecondaryContainer,
                style: context.t.labelSmall!.copyWith(fontSize: 13)),
            const SizedBox(height: 4),
            Text(title, style: context.t.headlineLarge!.copyWith(letterSpacing: -0.65)),
            const SizedBox(height: 4),
            Text(subtitle, style: context.t.bodyMedium!.copyWith(color: c.onSurfaceVariant, height: 1.6)),
          ]),
        ),
      ]),
    );
  }
}

/// Card "AVISO CLÍNICO IMPORTANTE" do Onboarding 1 (disclaimer obrigatório).
class ClinicalNotice extends StatelessWidget {
  const ClinicalNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final l = context.l;
    return Box(
      color: c.surfaceContainer,
      radius: 16,
      padding: const EdgeInsets.all(16),
      shadow: shadowSm,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        IconBadge(Symbols.info, size: 32, iconSize: 18, radius: 8, bg: c.surfaceContainerHighest, fg: c.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.clinicalNoticeTitle.toUpperCase(),
                style: context.t.labelSmall!.copyWith(color: c.onSurfaceVariant, fontWeight: FontWeight.w700, letterSpacing: 0.55)),
            const SizedBox(height: 2),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: l.disclaimerA),
                TextSpan(text: l.disclaimerB, style: TextStyle(fontWeight: FontWeight.w600, color: c.onSurface)),
                TextSpan(text: l.disclaimerC),
              ]),
              style: context.t.bodyMedium!.copyWith(color: c.onSurfaceVariant, height: 1.6),
            ),
          ]),
        ),
      ]),
    );
  }
}
