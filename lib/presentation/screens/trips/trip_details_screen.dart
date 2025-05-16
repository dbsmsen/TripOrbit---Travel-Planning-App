import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_orbit/domain/models/trip_model.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripModel trip;
  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(title: const Text('Trip Details')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              trip.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              trip.destination,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (trip.description != null && trip.description!.isNotEmpty)
              Text(
                trip.description!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(label: Text(trip.status)),
              ],
            ),
            // TODO: Add itinerary, group, edit, and delete actions
          ],
        ),
      ),
    );
  }
}
