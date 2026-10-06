import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/format.dart';
import '../../core/supabase/supabase.dart';

class Profile {
  Profile({required this.name, this.birthYear, this.heightCm, required this.proteinGoalG});
  final String name;
  final int? birthYear;
  final double? heightCm;
  final double proteinGoalG;

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
        name: j['name'] as String,
        birthYear: j['birth_year'] as int?,
        heightCm: (j['height_cm'] as num?)?.toDouble(),
        proteinGoalG: (j['protein_goal_g'] as num).toDouble(),
      );
}

class OnboardingData {
  OnboardingData({
    required this.name,
    required this.birthYear,
    required this.heightCm,
    required this.weightKg,
    required this.medication,
    required this.doseLabel,
    required this.weekday,
    required this.time,
    required this.proteinGoalG,
  });
  final String name;
  final int birthYear;
  final double heightCm;
  final double weightKg;
  final String medication;
  final String doseLabel;
  final int weekday;
  final TimeOfDay time;
  final double proteinGoalG;
}

const medications = ['Ozempic', 'Wegovy', 'Mounjaro', 'Zepbound', 'Saxenda', 'Outro'];

/// Ponto de partida editável: 1,2 g de proteína por kg.
double suggestedProteinGoal(double weightKg) => (weightKg * 1.2).roundToDouble();

class OnboardingRepository {
  Future<Profile?> fetchProfile() async {
    final row = await db.from('profiles').select().maybeSingle();
    return row == null ? null : Profile.fromJson(row);
  }

  /// O perfil é gravado por último: ele marca o onboarding como concluído.
  Future<void> complete(OnboardingData d) async {
    await db.from('treatments').insert({
      'medication': d.medication,
      'dose_label': d.doseLabel,
      'weekday': d.weekday,
      'time_of_day': '${fmtTime(d.time)}:00',
    });
    await db.from('weight_logs').insert({'kg': d.weightKg});
    await db.from('profiles').insert({
      'id': db.auth.currentUser!.id,
      'name': d.name,
      'birth_year': d.birthYear,
      'height_cm': d.heightCm,
      'protein_goal_g': d.proteinGoalG,
      'consented_at': DateTime.now().toUtc().toIso8601String(),
    });
  }
}

final onboardingRepositoryProvider = Provider((ref) => OnboardingRepository());

final profileProvider = FutureProvider<Profile?>((ref) {
  ref.watch(userIdProvider); // refaz ao trocar de usuário
  return ref.watch(onboardingRepositoryProvider).fetchProfile();
});
