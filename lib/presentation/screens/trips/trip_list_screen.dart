import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:trip_orbit/domain/models/trip_model.dart';
import 'package:trip_orbit/presentation/providers/auth_provider.dart';
import 'package:trip_orbit/presentation/providers/trip_provider.dart';
import 'package:trip_orbit/presentation/screens/trips/trip_details_screen.dart';

class TripListScreen extends ConsumerWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final userId = user?.id ?? 'guest';
    final tripsAsync = ref.watch(tripNotifierProvider(userId));
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (trips) => trips.isEmpty
            ? const Center(child: Text('No trips found.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: trips.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return Card(
                    child: ListTile(
                      title: Text(trip.title),
                      subtitle: Text(
                        '${trip.destination}\n${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}',
                      ),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TripDetailsScreen(trip: trip),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
