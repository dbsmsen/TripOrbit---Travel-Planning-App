import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trip_orbit/data/repositories/trip_repository_impl.dart';
import 'package:trip_orbit/domain/models/trip_model.dart';
import 'package:trip_orbit/domain/repositories/trip_repository.dart';

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepositoryImpl(Supabase.instance.client);
});

final tripListProvider =
    FutureProvider.family<List<TripModel>, String?>((ref, userId) async {
  final repo = ref.watch(tripRepositoryProvider);
  return repo.fetchTrips(userId: userId);
});

class TripNotifier extends StateNotifier<AsyncValue<List<TripModel>>> {
  final TripRepository _repo;
  final String? userId;
  TripNotifier(this._repo, this.userId) : super(const AsyncValue.loading()) {
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    try {
      state = const AsyncValue.loading();
      final trips = await _repo.fetchTrips(userId: userId);
      state = AsyncValue.data(trips);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createTrip(TripModel trip) async {
    try {
      await _repo.createTrip(trip);
      await fetchTrips();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final tripNotifierProvider = StateNotifierProvider.family<TripNotifier,
    AsyncValue<List<TripModel>>, String?>((ref, userId) {
  return TripNotifier(ref.watch(tripRepositoryProvider), userId);
});
