import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Lido de `--dart-define-from-file=.env`.
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

/// Deep link de retorno do magic link / OAuth (configurado no Supabase e nas plataformas).
const authRedirect = 'companheiroglp1://login-callback';

SupabaseClient get db => Supabase.instance.client;

final authStateProvider = StreamProvider<Session?>((ref) async* {
  yield db.auth.currentSession;
  yield* db.auth.onAuthStateChange.map((e) => e.session);
});

/// Muda só quando troca o usuário (não a cada refresh de token).
final userIdProvider = Provider<String?>((ref) => ref.watch(authStateProvider.select((s) => s.value?.user.id)));

/// Converte para o formato `date` do Postgres (sem hora).
String isoDate(DateTime d) => d.toIso8601String().substring(0, 10);
