import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/theme/widgets.dart';
import '../doses/doses_repository.dart';
import '../onboarding/onboarding_repository.dart';
import '../protein/protein_screen.dart';
import '../settings/settings_screen.dart';
import '../symptoms/symptoms_screen.dart';
import '../workouts/workouts_screen.dart';
import 'home_screen.dart';

/// Barra inferior: Hoje · Proteína · Sintomas · Treinos · Perfil.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends ConsumerState<HomeShell> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    // Garante o lembrete agendado no SO a cada abertura (ex.: após reinstalar ou trocar de aparelho).
    final repo = ref.read(dosesRepositoryProvider);
    ref.read(treatmentProvider.future).then(repo.syncReminder).ignore();
  }

  /// Permite que a Home troque de aba (ex.: "Registrar sintoma").
  void goTo(int tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    final c = context.c;
    final tabs = [
      (Symbols.calendar_today, l.tabToday),
      (Symbols.nutrition, l.tabProtein),
      (Symbols.vital_signs, l.tabSymptoms),
      (Symbols.fitness_center, l.tabWorkouts),
      (Symbols.person, l.tabProfile),
    ];
    final titles = [l.tabToday, l.tabProtein, l.symTitle, l.tabWorkouts, l.tabProfile];
    return Scaffold(
      body: Column(children: [
        ColoredBox(
          color: c.surface,
          child: SafeArea(
            bottom: false,
            child: AppTopBar(
              title: titles[_tab],
              name: ref.watch(profileProvider).value?.name ?? '',
              onBell: () => context.push('/doses'),
              onAvatar: () => goTo(4),
            ),
          ),
        ),
        Expanded(
          child: IndexedStack(index: _tab, children: const [
            HomeScreen(),
            ProteinScreen(),
            SymptomsScreen(),
            WorkoutsScreen(),
            SettingsScreen(),
          ]),
        ),
      ]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: c.surface.withValues(alpha: 0.9),
          boxShadow: const [BoxShadow(color: Color(0x0F0F766E), blurRadius: 20, offset: Offset(0, -4))],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(children: [
              for (final (i, (icon, label)) in tabs.indexed)
                Expanded(
                  child: Semantics(
                    selected: i == _tab,
                    button: true,
                    child: InkWell(
                      onTap: () => goTo(i),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(icon, size: 24, color: i == _tab ? c.primary : c.onSurfaceVariant),
                        const SizedBox(height: 2),
                        Text(
                          label,
                          style: context.t.labelSmall!.copyWith(
                            color: i == _tab ? c.primary : c.onSurfaceVariant,
                            fontWeight: i == _tab ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
