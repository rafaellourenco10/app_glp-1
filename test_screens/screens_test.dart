// Gera PNGs das telas para comparar com telas/*/screen.png. Não faz parte da suíte.
// Uso: flutter test test_screens/screens_test.dart  (saída em build/screens/)
import 'dart:io';
import 'dart:ui' as ui;

import 'package:companheiro_glp1/core/l10n/app_localizations.dart';
import 'package:companheiro_glp1/core/supabase/supabase.dart';
import 'package:companheiro_glp1/core/theme/theme.dart';
import 'package:companheiro_glp1/features/auth/login_screen.dart';
import 'package:companheiro_glp1/features/doses/doses_repository.dart';
import 'package:companheiro_glp1/features/doses/doses_screen.dart';
import 'package:companheiro_glp1/features/home/home_shell.dart';
import 'package:companheiro_glp1/features/onboarding/onboarding_repository.dart';
import 'package:companheiro_glp1/features/onboarding/onboarding_screen.dart';
import 'package:companheiro_glp1/features/protein/protein_repository.dart';
import 'package:companheiro_glp1/features/settings/settings_repository.dart';
import 'package:companheiro_glp1/features/symptoms/symptoms_repository.dart';
import 'package:companheiro_glp1/features/weight/weight_repository.dart';
import 'package:companheiro_glp1/features/weight/weight_screen.dart';
import 'package:companheiro_glp1/features/workouts/workout_session_screen.dart';
import 'package:companheiro_glp1/features/workouts/workouts_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

final now = DateTime.now();
DateTime ago(int days, int h, [int m = 0]) => DateTime(now.year, now.month, now.day - days, h, m);
final lastSunday = now.weekday % 7; // dias desde o último domingo

class FDoses extends DosesRepository {
  @override
  Future<Treatment?> fetchTreatment() async =>
      Treatment(id: 't', medication: 'Ozempic', doseLabel: '0,5 mg', weekday: 7, time: const TimeOfDay(hour: 20, minute: 0), active: true);
  @override
  Future<List<DoseLog>> fetchLogs() async => [
        DoseLog(takenAt: ago(lastSunday, 20), doseLabel: '0,5 mg', site: 'abdomen', note: 'Aplicação tranquila, sem dor'),
        DoseLog(takenAt: ago(lastSunday + 7, 20), doseLabel: '0,5 mg', site: 'coxa', note: 'Leve formigamento temporário'),
        DoseLog(takenAt: ago(lastSunday + 14, 20), doseLabel: '0,25 mg', site: 'abdomen'),
      ];
  @override
  Future<void> syncReminder(Treatment? t, {bool askPermission = false}) async {}
}

class FProtein extends ProteinRepository {
  @override
  Future<List<Food>> fetchFoods() async => [
        Food(id: 1, name: 'Ovo cozido', portionLabel: '1 unidade (50 g)', proteinG: 6),
        Food(id: 2, name: 'Peito de frango grelhado', portionLabel: '1 filé médio (100 g)', proteinG: 31),
        Food(id: 3, name: 'Iogurte grego natural', portionLabel: '1 pote (100 g)', proteinG: 10),
        Food(id: 4, name: 'Whey protein concentrado', portionLabel: '1 scoop (30 g)', proteinG: 24),
        Food(id: 5, name: 'Feijão carioca cozido', portionLabel: '1 concha (140 g)', proteinG: 6),
      ];
  @override
  Future<List<ProteinLog>> fetchLast7Days() async => [
        for (final (i, g) in [120.0, 110.0, 130.0, 125.0, 115.0, 95.0].indexed)
          ProteinLog(id: 'p$i', loggedAt: ago(6 - i, 12), label: 'x', qty: 1, proteinG: g),
        ProteinLog(id: 'a', loggedAt: ago(0, 8, 30), label: 'Whey batido com água', qty: 1, proteinG: 24),
        ProteinLog(id: 'b', loggedAt: ago(0, 12, 45), label: 'Omelete (2 ovos)', qty: 2, proteinG: 12),
        ProteinLog(id: 'c', loggedAt: ago(0, 13, 10), label: 'Peito de frango grelhado', qty: 1.8, proteinG: 56),
      ];
}

class FSymptoms extends SymptomsRepository {
  @override
  Future<List<SymptomLog>> fetchLogs() async => [
        SymptomLog(loggedAt: ago(0, 14, 20), symptom: 'nausea', severity: 2,
            note: 'Após almoço, durou cerca de 40 min. Aliviou após caminhar um pouco e tomar água gelada.'),
        SymptomLog(loggedAt: ago(1, 19, 15), symptom: 'refluxo', severity: 1, note: 'Ao deitar após o jantar. Melhora imediata elevando o travesseiro.'),
        SymptomLog(loggedAt: ago(9, 10), symptom: 'fadiga', severity: 1, note: 'Manhã mais lenta com sonolência leve.'),
        SymptomLog(loggedAt: ago(lastSunday + 6, 10), symptom: 'nausea', severity: 2),
        SymptomLog(loggedAt: ago(lastSunday + 5, 10), symptom: 'nausea', severity: 3),
        SymptomLog(loggedAt: ago(lastSunday + 3, 10), symptom: 'nausea', severity: 1),
        SymptomLog(loggedAt: ago(lastSunday + 1, 10), symptom: 'nausea', severity: 0),
      ];
}

class FWeight extends WeightRepository {
  @override
  Future<List<WeightLog>> fetchLogs() async => [
        for (final (i, kg) in [83.7, 82.9, 82.1, 81.3, 80.6, 79.9, 79.1, 78.5].indexed) WeightLog(loggedAt: ago((7 - i) * 7, 7), kg: kg),
      ];
}

class FWorkouts extends WorkoutsRepository {
  @override
  Future<List<WorkoutTemplate>> fetchTemplates() async => [
        WorkoutTemplate(id: 1, name: 'Corpo todo em casa', level: 'iniciante', location: 'casa', exercises: [
          Exercise(name: 'Agachamento livre', sets: 3, reps: '12', note: 'Pés na largura dos ombros, desça com controle.'),
          Exercise(name: 'Remada com elástico', sets: 3, reps: '12', note: 'Cotovelos próximos ao tronco.'),
          Exercise(name: 'Flexão inclinada', sets: 3, reps: '10', note: 'Apoio em sofá ou banco firme.'),
          Exercise(name: 'Ponte de glúteos', sets: 3, reps: '15'),
        ]),
        WorkoutTemplate(id: 3, name: 'Corpo todo na academia', level: 'intermediario', location: 'academia', exercises: [
          Exercise(name: 'Leg press', sets: 3, reps: '12'),
          Exercise(name: 'Puxada alta', sets: 3, reps: '12'),
          Exercise(name: 'Supino com halteres', sets: 3, reps: '10'),
        ]),
      ];
  @override
  Future<List<WorkoutSession>> fetchSessions() async => [
        WorkoutSession(templateId: 3, doneAt: ago(0, 7), doneCount: 3),
        WorkoutSession(templateId: 1, doneAt: ago(now.weekday - 1, 7), doneCount: 4),
      ];
}

class FTheme extends ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.light;
}

final overrides = [
  userIdProvider.overrideWithValue('u'),
  profileProvider.overrideWith((ref) async => Profile(name: 'Marina Silva', birthYear: 1992, heightCm: 168, proteinGoalG: 130)),
  dosesRepositoryProvider.overrideWithValue(FDoses()),
  proteinRepositoryProvider.overrideWithValue(FProtein()),
  symptomsRepositoryProvider.overrideWithValue(FSymptoms()),
  weightRepositoryProvider.overrideWithValue(FWeight()),
  workoutsRepositoryProvider.overrideWithValue(FWorkouts()),
  themeModeProvider.overrideWith(FTheme.new),
];

const _key = ValueKey('shot');
const images = ['ob1_tea', 'ob2_interior', 'ob3_pens', 'ob4_meal', 'weight_tea', 'weight_meal', 'workout_home'];

Future<void> loadFonts() async {
  final m = FontLoader('Manrope');
  for (final w in [400, 500, 600, 700]) {
    m.addFont(rootBundle.load('assets/fonts/Manrope-$w.ttf'));
  }
  await m.load();
  await (FontLoader('packages/material_symbols_icons/MaterialSymbolsOutlined')
        ..addFont(rootBundle.load('packages/material_symbols_icons/lib/fonts/MaterialSymbolsOutlined.ttf')))
      .load();
  await (FontLoader('MaterialIcons')..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
}

Future<void> pumpApp(WidgetTester tester, Widget child, {double height = 2400}) async {
  tester.view.physicalSize = Size(390, height);
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(ProviderScope(
    overrides: overrides.cast(),
    child: RepaintBoundary(
      key: _key,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        locale: const Locale('pt'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
      ),
    ),
  ));
  final ctx = tester.element(find.byType(Scaffold).first);
  await tester.runAsync(() async {
    for (final i in images) {
      await precacheImage(AssetImage('assets/images/$i.jpg'), ctx);
    }
    await precacheImage(const AssetImage('assets/images/logo_mark.png'), ctx);
  });
  await tester.pumpAndSettle();
}

Future<void> shot(WidgetTester tester, String name) async {
  await tester.pump(const Duration(milliseconds: 300));
  final b = tester.renderObject<RenderRepaintBoundary>(find.byKey(_key));
  await tester.runAsync(() async {
    final img = await b.toImage(pixelRatio: 1.5);
    final png = await img.toByteData(format: ui.ImageByteFormat.png);
    Directory('build/screens').createSync(recursive: true);
    File('build/screens/$name.png').writeAsBytesSync(png!.buffer.asUint8List());
  });
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
    await loadFonts();
  });

  testWidgets('login', (t) async {
    await pumpApp(t, const LoginScreen(), height: 1000);
    await shot(t, 'login');
  });

  testWidgets('onboarding', (t) async {
    await pumpApp(t, const OnboardingScreen(), height: 1150);
    await t.tap(find.byKey(const ValueKey('ob_consent')));
    await shot(t, 'ob1');
    await t.tap(find.byKey(const ValueKey('ob_continue')));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const ValueKey('ob_name')), 'Marina Silva');
    await t.enterText(find.byKey(const ValueKey('ob_year')), '1992');
    await t.enterText(find.byKey(const ValueKey('ob_height')), '168');
    await t.enterText(find.byKey(const ValueKey('ob_weight')), '78,5');
    FocusManager.instance.primaryFocus?.unfocus();
    await shot(t, 'ob2');
    await t.tap(find.byKey(const ValueKey('ob_continue')));
    await t.pumpAndSettle();
    await t.enterText(find.byKey(const ValueKey('ob_dose')), '0,5 mg');
    FocusManager.instance.primaryFocus?.unfocus();
    await shot(t, 'ob3');
    await t.tap(find.byKey(const ValueKey('ob_continue')));
    await t.pumpAndSettle();
    await shot(t, 'ob4');
  });

  testWidgets('tabs', (t) async {
    await pumpApp(t, const HomeShell(), height: 1650);
    await shot(t, 'home');
    for (final (i, tab) in ['Proteína', 'Sintomas', 'Treinos', 'Perfil'].indexed) {
      t.view.physicalSize = Size(390, [2150.0, 2050.0, 1750.0, 1300.0][i]);
      await t.tap(find.text(tab).last);
      await t.pumpAndSettle();
      if (tab == 'Sintomas') {
        await t.tap(find.text('Náusea').first);
        await t.pumpAndSettle();
      }
      await shot(t, 'tab_$tab');
    }
  });

  testWidgets('doses', (t) async {
    await pumpApp(t, const DosesScreen(), height: 1400);
    await shot(t, 'doses');
    await t.tap(find.byKey(const ValueKey('dose_register')));
    await t.pumpAndSettle();
    await shot(t, 'doses_sheet');
  });

  testWidgets('weight', (t) async {
    await pumpApp(t, const WeightScreen(), height: 2200);
    await shot(t, 'weight');
  });

  testWidgets('session', (t) async {
    await pumpApp(t, const WorkoutSessionScreen(templateId: 1), height: 2300);
    await t.tap(find.bySemanticsLabel('Série 3').first);
    await t.tap(find.bySemanticsLabel('Série 1').at(1));
    await t.pumpAndSettle();
    await shot(t, 'session');
  });
}
