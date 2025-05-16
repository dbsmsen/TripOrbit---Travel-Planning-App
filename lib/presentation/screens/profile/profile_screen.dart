import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_orbit/core/routes/app_routes.dart';
import 'package:trip_orbit/core/services/navigation_service.dart';
import 'package:trip_orbit/domain/models/user_model.dart';
import 'package:trip_orbit/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final isGuest = user == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: isGuest
                ? null
                : () {
                    Navigator.pushNamed(context, AppRoutes.editProfile);
                  },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.blue[100],
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.blue[700],
                  ),
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  isGuest ? 'Guest User' : user!.fullName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                // Email
                Text(
                  isGuest ? 'Not signed in' : user!.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                // Phone
                if (!isGuest &&
                    user!.phoneNumber != null &&
                    user.phoneNumber!.isNotEmpty)
                  Text(
                    user.phoneNumber!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 24),
                // Edit Profile Button
                if (!isGuest)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.editProfile);
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                if (isGuest)
                  Text(
                    'Sign in to access full profile features.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                if (!isGuest)
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        await ref.read(authStateProvider.notifier).signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutes.login, (route) => false);
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
