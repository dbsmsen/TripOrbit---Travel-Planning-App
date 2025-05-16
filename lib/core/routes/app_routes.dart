import 'package:flutter/material.dart';
import 'package:trip_orbit/presentation/screens/auth/forgot_password_screen.dart';
import 'package:trip_orbit/presentation/screens/auth/login_screen.dart';
import 'package:trip_orbit/presentation/screens/auth/register_screen.dart';
import 'package:trip_orbit/presentation/screens/home/home_screen.dart';
import 'package:trip_orbit/presentation/screens/profile/change_password_screen.dart';
import 'package:trip_orbit/presentation/screens/profile/edit_profile_screen.dart';
import 'package:trip_orbit/presentation/screens/profile/profile_screen.dart';
import 'package:trip_orbit/presentation/screens/trips/trip_list_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String notifications = '/notifications';
  static const String language = '/language';
  static const String help = '/help';
  static const String about = '/about';
  static const String createTrip = '/create-trip';
  static const String savedPlaces = '/saved-places';
  static const String expenses = '/expenses';
  static const String tripList = '/trip-list';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      home: (context) => const HomeScreen(),
      profile: (context) => const ProfileScreen(),
      editProfile: (context) => const EditProfileScreen(),
      changePassword: (context) => const ChangePasswordScreen(),
      tripList: (context) => const TripListScreen(),
      // TODO: Add other route builders as screens are implemented
    };
  }
}
