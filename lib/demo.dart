// Modo demonstração: roda sem Supabase (sem .env), sem login, com dados só em memória.
// Usado apenas para ver o app; tudo some ao fechar. Cada repositório real ganha um gêmeo em memória.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/format.dart';
import 'core/notifications/notifications.dart';
import 'core/supabase/supabase.dart';
import 'features/doses/doses_repository.dart';
import 'features/onboarding/onboarding_repository.dart';
import 'features/protein/protein_repository.dart';
import 'features/settings/settings_repository.dart';
import 'features/symptoms/symptoms_repository.dart';
import 'features/weight/weight_repository.dart';
import 'features/workouts/workouts_repository.dart';

class _Store {
  Profile? profile;
  Treatment? treatment;
  final doses = <DoseLog>[];
  final protein = <ProteinLog>[];
  final symptoms = <SymptomLog>[];
  final weights = <WeightLog>[];
  final sessions = <WorkoutSession>[];
  int _id = 0;
  String nextId() => '${++_id}';

  void reset() {
    profile = null;
    treatment = null;
    doses.clear();
    protein.clear();
    symptoms.clear();
    weights.clear();
    sessions.clear();
  }
}

final _store = _Store();

/// "Sair"/"Excluir conta" trocam o usuário de mentira, e todos os providers recarregam.
class _Session extends Notifier<int> {
  @override
  int build() => 0;
  void restart() => state++;
}

final _sessionProvider = NotifierProvider<_Session, int>(_Session.new);

class _Onboarding extends OnboardingRepository {
  @override
  Future<Profile?> fetchProfile() async => _store.profile;

  @override
  Future<void> complete(OnboardingData d) async {
    _store.treatment = Treatment(
      id: _store.nextId(),
      medication: d.medication,
      doseLabel: d.doseLabel,
      weekday: d.weekday,
      time: d.time,
      active: true,
    );
    _store.weights.add(WeightLog(loggedAt: DateTime.now(), kg: d.weightKg));
    _store.profile = Profile(name: d.name, birthYear: d.birthYear, heightCm: d.heightCm, proteinGoalG: d.proteinGoalG);
    try {
      await Notifications.scheduleWeeklyDose(
        first: nextOccurrence(d.weekday, d.time, DateTime.now()),
        medication: d.medication,
        dose: d.doseLabel,
        askPermission: true,
      );
    } catch (_) {}
  }
}

class _Doses extends DosesRepository {
  @override
  Future<Treatment?> fetchTreatment() async => _store.treatment;

  @override
  Future<void> saveTreatment({
    required String id,
    required String doseLabel,
    required int weekday,
    required TimeOfDay time,
    required bool active,
  }) async {
    final t = Treatment(
      id: id,
      medication: _store.treatment!.medication,
      doseLabel: doseLabel,
      weekday: weekday,
      time: time,
      active: active,
    );
    _store.treatment = t;
    await syncReminder(t, askPermission: true); // o lembrete local funciona de verdade no modo demo
  }

  @override
  Future<List<DoseLog>> fetchLogs() async => _store.doses.reversed.toList();

  @override
  Future<void> addLog({String? treatmentId, required String doseLabel, String? site, String? note}) async =>
      _store.doses.add(DoseLog(takenAt: DateTime.now(), doseLabel: doseLabel, site: site, note: note));
}

class _Protein extends ProteinRepository {
  @override
  Future<List<Food>> fetchFoods() async => [
        for (final (i, (name, portion, g)) in _foods.indexed)
          Food(id: i + 1, name: name, portionLabel: portion, proteinG: g),
      ];

  @override
  Future<List<ProteinLog>> fetchLast7Days() async {
    final since = dayOnly(DateTime.now()).subtract(const Duration(days: 6));
    return _store.protein.where((p) => !p.loggedAt.isBefore(since)).toList();
  }

  @override
  Future<void> add({required String label, required double qty, required double proteinG, int? foodId}) async =>
      _store.protein.add(
          ProteinLog(id: _store.nextId(), loggedAt: DateTime.now(), label: label, qty: qty, proteinG: proteinG));

  @override
  Future<void> delete(String id) async => _store.protein.removeWhere((p) => p.id == id);
}

class _Symptoms extends SymptomsRepository {
  @override
  Future<List<SymptomLog>> fetchLogs() async => _store.symptoms.reversed.toList();

  @override
  Future<void> add({required String symptom, required int severity, String? note}) async =>
      _store.symptoms.add(SymptomLog(loggedAt: DateTime.now(), symptom: symptom, severity: severity, note: note));
}

class _Weight extends WeightRepository {
  @override
  Future<List<WeightLog>> fetchLogs() async => List.of(_store.weights);

  @override
  Future<void> add(double kg) async => _store.weights.add(WeightLog(loggedAt: DateTime.now(), kg: kg));
}

class _Workouts extends WorkoutsRepository {
  @override
  Future<List<WorkoutTemplate>> fetchTemplates() async => [
        for (final (i, (name, level, location, exercises)) in _templates.indexed)
          WorkoutTemplate(
            id: i + 1,
            name: name,
            level: level,
            location: location,
            exercises: [for (final (n, reps, note) in exercises) Exercise(name: n, sets: 3, reps: reps, note: note)],
          ),
      ];

  @override
  Future<List<WorkoutSession>> fetchSessions() async => _store.sessions.reversed.toList();

  @override
  Future<void> finishSession(int templateId, Map<String, bool> exercises) async => _store.sessions.add(
      WorkoutSession(templateId: templateId, doneAt: DateTime.now(), doneCount: exercises.values.where((d) => d).length));
}

class _Settings extends SettingsRepository {
  _Settings(this.ref);
  final Ref ref;

  @override
  Future<void> updateProfile({
    required String name,
    required int? birthYear,
    required double? heightCm,
    required double proteinGoalG,
  }) async =>
      _store.profile = Profile(name: name, birthYear: birthYear, heightCm: heightCm, proteinGoalG: proteinGoalG);

  @override
  Future<String> exportJson() async => const JsonEncoder.withIndent('  ').convert({
        'profile': {'name': _store.profile?.name, 'protein_goal_g': _store.profile?.proteinGoalG},
        'dose_logs': [for (final d in _store.doses) {'taken_at': '${d.takenAt}', 'dose_label': d.doseLabel, 'site': d.site}],
        'protein_logs': [for (final p in _store.protein) {'logged_at': '${p.loggedAt}', 'label': p.label, 'protein_g': p.proteinG}],
        'weight_logs': [for (final w in _store.weights) {'logged_at': '${w.loggedAt}', 'kg': w.kg}],
      });

  @override
  Future<void> deleteAccount() => signOut();

  @override
  Future<void> signOut() async {
    await Notifications.cancelDose();
    _store.reset();
    ref.read(_sessionProvider.notifier).restart();
  }
}

class _Theme extends ThemeModeNotifier {
  @override
  ThemeMode build() => ThemeMode.system;

  @override
  Future<void> set(ThemeMode mode) async => state = mode;
}

final demoOverrides = [
  userIdProvider.overrideWith((ref) => 'demo-${ref.watch(_sessionProvider)}'),
  onboardingRepositoryProvider.overrideWithValue(_Onboarding()),
  dosesRepositoryProvider.overrideWithValue(_Doses()),
  proteinRepositoryProvider.overrideWithValue(_Protein()),
  symptomsRepositoryProvider.overrideWithValue(_Symptoms()),
  weightRepositoryProvider.overrideWithValue(_Weight()),
  workoutsRepositoryProvider.overrideWithValue(_Workouts()),
  settingsRepositoryProvider.overrideWith(_Settings.new),
  themeModeProvider.overrideWith(_Theme.new),
];

// Amostra do supabase/seed.sql.
const _foods = [
  ('Peito de frango grelhado', '1 filé médio (100 g)', 32.0),
  ('Carne moída refogada (patinho)', '3 col. sopa (75 g)', 26.0),
  ('Tilápia grelhada', '1 filé (100 g)', 26.0),
  ('Atum em lata (em água)', '1/2 lata (60 g)', 15.0),
  ('Ovo cozido', '1 unidade (50 g)', 6.0),
  ('Omelete simples', '2 ovos (110 g)', 12.0),
  ('Iogurte proteico', '1 pote (160 g)', 15.0),
  ('Queijo minas frescal', '1 fatia (30 g)', 5.0),
  ('Queijo cottage', '2 col. sopa (50 g)', 6.0),
  ('Whey protein concentrado', '1 scoop (30 g)', 24.0),
  ('Leite desnatado', '1 copo (200 ml)', 6.0),
  ('Feijão carioca cozido', '1 concha (140 g)', 7.0),
  ('Lentilha cozida', '1 concha (140 g)', 9.0),
  ('Tofu', '1 fatia (100 g)', 8.0),
  ('Arroz branco cozido', '4 col. sopa (100 g)', 3.0),
  ('Pão francês', '1 unidade (50 g)', 4.0),
  ('Amendoim torrado', '1 punhado (30 g)', 8.0),
];

const _templates = [
  ('Corpo todo em casa', 'iniciante', 'casa', [
    ('Agachamento livre (pode usar uma cadeira atrás)', '12', 'Pés na largura dos ombros, desça com controle.'),
    ('Flexão inclinada com apoio no sofá ou mesa', '10', 'Corpo alinhado, cotovelos perto do tronco.'),
    ('Remada com elástico ou mochila', '12', 'Puxe levando os cotovelos para trás.'),
    ('Ponte de glúteos', '15', 'Suba o quadril contraindo os glúteos.'),
  ]),
  ('Corpo todo em casa', 'intermediario', 'casa', [
    ('Agachamento búlgaro', '10 cada perna', 'Pé de trás apoiado em uma cadeira.'),
    ('Flexão de braço', '10', 'Se precisar, apoie os joelhos.'),
    ('Afundo alternado', '10 cada perna', 'Joelho da frente alinhado com o pé.'),
    ('Prancha', '40 s', 'Corpo em linha reta.'),
  ]),
  ('Corpo todo na academia', 'iniciante', 'academia', [
    ('Leg press', '12', 'Sem tirar a lombar do encosto.'),
    ('Puxada alta', '12', 'Puxe a barra até a altura do queixo.'),
    ('Supino na máquina', '12', 'Empurre sem travar os cotovelos.'),
    ('Remada baixa', '12', 'Peito aberto, ombros longe das orelhas.'),
  ]),
  ('Corpo todo na academia', 'intermediario', 'academia', [
    ('Agachamento goblet com halter', '10', 'Halter junto ao peito.'),
    ('Supino com halteres', '10', 'Desça até a linha do peito.'),
    ('Levantamento terra romeno', '10', 'Quadril vai para trás.'),
    ('Elevação pélvica com barra', '12', 'Pausa de 1 segundo no topo.'),
  ]),
];
