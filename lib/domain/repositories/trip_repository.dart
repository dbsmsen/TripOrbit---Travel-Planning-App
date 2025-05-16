import 'package:trip_orbit/domain/models/trip_model.dart';

abstract class TripRepository {
  Future<void> createTrip(TripModel trip);
  Future<List<TripModel>> fetchTrips({String? userId});
  Future<TripModel?> getTripById(String id);
  Future<void> updateTrip(TripModel trip);
  Future<void> deleteTrip(String id);
}
