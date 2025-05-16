import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trip_orbit/core/constants/supabase_constants.dart';
import 'package:trip_orbit/domain/models/trip_model.dart';
import 'package:trip_orbit/domain/repositories/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final SupabaseClient _client;
  TripRepositoryImpl(this._client);

  @override
  Future<void> createTrip(TripModel trip) async {
    await _client.from(SupabaseConstants.tripsTable).insert(trip.toJson());
  }

  @override
  Future<List<TripModel>> fetchTrips({String? userId}) async {
    final query = _client.from(SupabaseConstants.tripsTable).select();
    if (userId != null) {
      query.eq('user_id', userId);
    }
    final data = await query;
    return (data as List).map((e) => TripModel.fromJson(e)).toList();
  }

  @override
  Future<TripModel?> getTripById(String id) async {
    final data = await _client
        .from(SupabaseConstants.tripsTable)
        .select()
        .eq('id', id)
        .maybeSingle();
    if (data == null) return null;
    return TripModel.fromJson(data);
  }

  @override
  Future<void> updateTrip(TripModel trip) async {
    await _client
        .from(SupabaseConstants.tripsTable)
        .update(trip.toJson())
        .eq('id', trip.id);
  }

  @override
  Future<void> deleteTrip(String id) async {
    await _client.from(SupabaseConstants.tripsTable).delete().eq('id', id);
  }
}
