import 'package:trip_orbit/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  });
  Future<UserModel> signIn({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<UserModel> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? avatarUrl,
  });
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  });
}
