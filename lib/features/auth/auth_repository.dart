import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase/supabase.dart';

class AuthRepository {
  Future<void> sendMagicLink(String email) =>
      db.auth.signInWithOtp(email: email.trim(), emailRedirectTo: authRedirect);

  // ponytail: OAuth via navegador; trocar por sign_in_with_apple/google_sign_in nativos se a UX pedir.
  Future<void> signInWithApple() => db.auth.signInWithOAuth(OAuthProvider.apple, redirectTo: authRedirect);

  Future<void> signInWithGoogle() => db.auth.signInWithOAuth(OAuthProvider.google, redirectTo: authRedirect);

  Future<void> signOut() => db.auth.signOut();
}

final authRepositoryProvider = Provider((ref) => AuthRepository());
