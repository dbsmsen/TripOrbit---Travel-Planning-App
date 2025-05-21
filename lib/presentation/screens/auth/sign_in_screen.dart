import 'package:flutter/material.dart';
import 'package:trip_orbit/core/routes/app_routes.dart';
import 'package:trip_orbit/core/services/navigation_service.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => NavigationService.goBack(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const Text(
                'Sign in or create\nan account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Unlock a world of travel with one account across the world',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  // TODO: Implement Google sign in
                  await NavigationService.navigateToAndClearStack(AppRoutes.home);
                },
                icon: Image.asset(
                  'assets/images/google_icon.png',
                  height: 34,
                ),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'or',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  NavigationService.navigateTo(AppRoutes.register);
                },
                child: const Text('Create an account'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  NavigationService.navigateTo(AppRoutes.forgotPassword);
                },
                child: const Text('Forgot password?'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // TODO: Implement email sign in
                  await NavigationService.navigateToAndClearStack(AppRoutes.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Continue'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Other ways to sign in',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  // TODO: Implement Apple sign in
                  await NavigationService.navigateToAndClearStack(AppRoutes.home);
                },
                icon: const Icon(Icons.apple),
                label: const Text('Apple'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  // TODO: Implement Facebook sign in
                  await NavigationService.navigateToAndClearStack(AppRoutes.home);
                },
                icon: const Icon(Icons.facebook),
                label: const Text('Facebook'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                  children: [
                    const TextSpan(
                      text: 'By continuing, you have read and agree to our ',
                    ),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: TextStyle(
                        color: Colors.blue[700],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ', '),
                    TextSpan(
                      text: 'Privacy Statement',
                      style: TextStyle(
                        color: Colors.blue[700],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: ', and '),
                    TextSpan(
                      text: 'One Key Rewards Terms & Conditions',
                      style: TextStyle(
                        color: Colors.blue[700],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/images/app_label.png',
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
