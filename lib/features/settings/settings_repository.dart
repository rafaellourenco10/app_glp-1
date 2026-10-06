import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/notifications/notifications.dart';
import '../../core/supabase/supabase.dart';

class SettingsRepository {
  Future<void> updateProfile({
    required String name,
    required int? birthYear,
    required double? heightCm,
    required double proteinGoalG,
  }) =>
      db.from('profiles').update({
        'name': name,
        'birth_year': birthYear,
        'height_cm': heightCm,
        'protein_goal_g': proteinGoalG,
      }).eq('id', db.auth.currentUser!.id);

  /// Todos os dados do usuário (RPC export_my_data, sujeita à RLS), formatados.
  Future<String> exportJson() async {
    final data = await db.rpc('export_my_data');
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Apaga o usuário no Auth; o cascade no banco remove todas as linhas dele.
  Future<void> deleteAccount() async {
    await db.rpc('delete_my_account');
    await Notifications.cancelDose();
    await db.auth.signOut(scope: SignOutScope.local);
  }

  Future<void> signOut() async {
    await Notifications.cancelDose();
    await db.auth.signOut();
  }
}

final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

/// Tema salvo no user_metadata do Supabase (acompanha a conta, sem armazenamento local extra).
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    ref.watch(userIdProvider);
    final saved = db.auth.currentUser?.userMetadata?['theme'];
    return ThemeMode.values.firstWhere((m) => m.name == saved, orElse: () => ThemeMode.system);
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await db.auth.updateUser(UserAttributes(data: {'theme': mode.name}));
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
