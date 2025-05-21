import 'package:flutter/material.dart';
import 'package:trip_orbit/presentation/screens/auth/forgot_password_screen.dart';
import 'package:trip_orbit/presentation/screens/auth/sign_in_screen.dart';
import 'package:trip_orbit/presentation/screens/auth/otp_verification_screen.dart';
import 'package:trip_orbit/presentation/screens/auth/register_screen.dart';
import 'package:trip_orbit/presentation/screens/budget/budget_planner_screen.dart';
import 'package:trip_orbit/presentation/screens/flights/flight_search_screen.dart';
import 'package:trip_orbit/presentation/screens/group/group_chat_screen.dart';
import 'package:trip_orbit/presentation/screens/group/group_list_screen.dart';
import 'package:trip_orbit/presentation/screens/home/home_screen.dart';
import 'package:trip_orbit/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:trip_orbit/presentation/screens/profile/change_password_screen.dart';
import 'package:trip_orbit/presentation/screens/profile/edit_profile_screen.dart';
import 'package:trip_orbit/presentation/screens/profile/profile_screen.dart';
import 'package:trip_orbit/presentation/screens/recommendations/ai_recommendations_screen.dart';
import 'package:trip_orbit/presentation/screens/schedule/daily_schedule_screen.dart';
import 'package:trip_orbit/presentation/screens/translator/language_translator_screen.dart';
import 'package:trip_orbit/presentation/screens/trips/trip_list_screen.dart';
import 'package:trip_orbit/presentation/screens/services/taxi_service_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
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
  static const String taxiService = '/taxi-service';
  static const String groupList = '/group-list';
  static const String groupChat = '/group-chat';
  static const String flightSearch = '/flight-search';
  static const String budgetPlanner = '/budget-planner';
  static const String dailySchedule = '/daily-schedule';
  static const String aiRecommendations = '/ai-recommendations';
  static const String languageTranslator = '/language-translator';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      onboarding: (context) => OnboardingScreen(
        onComplete: () => Navigator.pushReplacementNamed(context, login),
      ),
      login: (context) => const SignInScreen(),
      otpVerification: (context) {
        final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return OtpVerificationScreen(
          phoneNumber: args?['phoneNumber'] as String? ?? '',
          email: args?['email'] as String? ?? '',
          isPhoneVerification: args?['isPhoneVerification'] as bool? ?? true,
        );
      },
      register: (context) => const RegisterScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      home: (context) => const HomeScreen(),
      profile: (context) => const ProfileScreen(),
      editProfile: (context) => const EditProfileScreen(),
      changePassword: (context) => const ChangePasswordScreen(),
      tripList: (context) => const TripListScreen(),
      taxiService: (context) => const TaxiServiceScreen(),
      groupList: (context) => const GroupListScreen(),
      groupChat: (context) => const GroupChatScreen(),
      flightSearch: (context) => const FlightSearchScreen(),
      budgetPlanner: (context) => const BudgetPlannerScreen(),
      dailySchedule: (context) => const DailyScheduleScreen(),
      aiRecommendations: (context) => const AiRecommendationsScreen(),
      languageTranslator: (context) => const LanguageTranslatorScreen(),
    };
  }
}
