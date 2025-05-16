import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trip_orbit/core/constants/supabase_constants.dart';
import 'package:trip_orbit/domain/models/user_model.dart';
import 'package:trip_orbit/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  AuthRepositoryImpl(this._client);

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response =
        await _client.from('users').select().eq('id', user.id).single();

    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: SupabaseConstants.authRedirectUri,
    );

    if (response.user == null) {
      throw Exception('Failed to create user');
    }

    // Do not insert into users table here due to RLS
    // Profile will be created on first login
    return UserModel(
      id: response.user!.id,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
      avatarUrl: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Failed to sign in');
    }

    // Check if user profile exists
    final userId = response.user!.id;
    final userProfile =
        await _client.from('users').select().eq('id', userId).maybeSingle();

    if (userProfile == null) {
      // Insert profile if not exists
      final userMetadata = response.user!.userMetadata ?? {};
      print('User metadata: $userMetadata');
      final userData = {
        'id': userId,
        'email': email,
        'full_name': userMetadata['full_name']?.toString() ?? '',
        'phone_number': userMetadata['phone_number']?.toString(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
      await _client.from('users').insert(userData);
      return UserModel.fromJson(userData);
    }

    return UserModel.fromJson(userProfile);
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<UserModel> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final userData = {
      'full_name': fullName,
      'phone_number': phoneNumber,
      'updated_at': DateTime.now().toIso8601String(),
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };

    await _client.from('users').update(userData).eq('id', user.id);

    final response =
        await _client.from('users').select().eq('id', user.id).single();

    return UserModel.fromJson(response);
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await _client.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  }
}
