import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../doses/doses_repository.dart';
import '../doses/doses_screen.dart';
import '../onboarding/onboarding_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final name = ref.watch(profileProvider).value?.name ?? '';
    final treatment = ref.watch(treatmentProvider).value;
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(treatmentProvider);
      },
      child: ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 32), children: [
        Text(l.appName.toUpperCase(), style: t.labelSmall?.copyWith(color: c.primary, letterSpacing: 1)),
        const SizedBox(height: 8),
        Text(l.homeGreeting(name.split(' ').first), style: t.headlineLarge),
        Text(l.homeHowAreYou, style: t.bodyMedium?.copyWith(color: c.onSurfaceVariant)),
        const SizedBox(height: 16),
        if (treatment != null) ...[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.push('/doses'),
            child: NextDoseCard(
              treatment: treatment,
              action: FilledButton.tonalIcon(
                onPressed: () => showDoseLogSheet(context, treatment),
                icon: const Icon(Icons.check_circle_outline),
                label: Text(l.doseRegister),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(l.disclaimer, textAlign: TextAlign.center, style: t.labelSmall?.copyWith(color: c.outline)),
      ]),
    );
  }
}
