import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient client;

  AuthService(this.client);

  Future<void> signIn({required String email, required String password}) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  Future<void> register({required String email, required String password}) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  Future<void> recoverPassword({required String email}) async {
    final response = await client.auth.resetPasswordForEmail(email);

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }
}
