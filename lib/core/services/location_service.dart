import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.subLocality}, ${place.locality}';
      }
      return '';
    } catch (e) {
      debugPrint('Error getting address: $e');
      return '';
    }
  }

  static Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    // TODO: Implement Google Places API search
    // This is a mock implementation for now
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'name': 'Seoul Station',
        'address': '109 Cheongpa-ro, Jung-gu, Seoul',
        'latLng': const LatLng(37.5559, 126.9723),
      },
      {
        'name': 'Gangnam Station',
        'address': '396 Gangnam-daero, Gangnam-gu, Seoul',
        'latLng': const LatLng(37.4982, 127.0276),
      },
      {
        'name': 'Hongdae Station',
        'address': '184 Yanghwa-ro, Mapo-gu, Seoul',
        'latLng': const LatLng(37.5571, 126.9252),
      },
    ];
  }

  static Future<List<Map<String, dynamic>>> getSavedPlaces() async {
    // TODO: Implement saved places from local storage or backend
    return [
      {
        'name': 'Home',
        'address': '123 Home Street, Seoul',
        'latLng': const LatLng(37.5665, 126.9780),
        'type': 'home',
      },
      {
        'name': 'Work',
        'address': '456 Office Road, Seoul',
        'latLng': const LatLng(37.5665, 126.9780),
        'type': 'work',
      },
    ];
  }
}
