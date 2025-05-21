import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client;

  AuthService(this.client);

  Future<void> signIn({required String email, required String password}) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // No need to check for error, exceptions will be thrown automatically
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<void> register(
      {required String email, required String password}) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      // No need to check for error, exceptions will be thrown automatically
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<void> recoverPassword({required String email}) async {
    try {
      await client.auth.resetPasswordForEmail(email);

      // No need to check for error, exceptions will be thrown automatically
    } catch (e) {
      throw Exception('Failed to send password recovery email: $e');
    }
  }
}
