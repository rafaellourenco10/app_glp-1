import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/widgets.dart';
import 'auth_repository.dart';

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
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final repo = ref.read(authRepositoryProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Pill(l.loginBadge, background: c.secondaryContainer.withValues(alpha: 0.6), foreground: c.onSecondaryContainer),
          ),
          const SizedBox(height: 12),
          Text(l.appName, style: t.headlineLarge),
          const SizedBox(height: 4),
          Text(l.loginSubtitle, style: t.bodyLarge?.copyWith(color: c.onSurfaceVariant)),
          const SizedBox(height: 32),
          SectionCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(l.loginEmailLabel, style: t.titleMedium),
              const SizedBox(height: 12),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: InputDecoration(hintText: l.loginEmailHint, prefixIcon: const Icon(Icons.mail_outline)),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy
                    ? null
                    : () {
                        if (!_email.text.contains('@')) return;
                        _run(() => repo.sendMagicLink(_email.text), success: l.loginLinkSent);
                      },
                child: Text(l.loginSendLink),
              ),
            ]),
          ),
          const SizedBox(height: 20),
          Text(l.loginOr, textAlign: TextAlign.center, style: t.labelMedium?.copyWith(color: c.onSurfaceVariant)),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: _busy ? null : () => _run(repo.signInWithApple),
            icon: const Icon(Icons.apple),
            label: Text(l.loginApple),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _busy ? null : () => _run(repo.signInWithGoogle),
            icon: const Icon(Icons.g_mobiledata, size: 32),
            label: Text(l.loginGoogle),
          ),
          const SizedBox(height: 32),
          InfoBox(l.disclaimer),
        ]),
      ),
    );
  }
}
