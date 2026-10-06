import 'package:flutter/material.dart';

import '../../core/l10n/app_localizations.dart';
import 'home_screen.dart';

/// Barra inferior: Hoje · Proteína · Sintomas · Treinos · Perfil.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends State<HomeShell> {
  int _tab = 0;

  /// Permite que a Home troque de aba (ex.: "Registrar sintoma").
  void goTo(int tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _tab, children: const [
          HomeScreen(),
          SizedBox(),
          SizedBox(),
          SizedBox(),
          SizedBox(),
        ]),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: goTo,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.calendar_today_outlined), label: l.tabToday),
          NavigationDestination(icon: const Icon(Icons.egg_outlined), label: l.tabProtein),
          NavigationDestination(icon: const Icon(Icons.monitor_heart_outlined), label: l.tabSymptoms),
          NavigationDestination(icon: const Icon(Icons.fitness_center), label: l.tabWorkouts),
          NavigationDestination(icon: const Icon(Icons.person_outline), label: l.tabProfile),
        ],
      ),
    );
  }
}
