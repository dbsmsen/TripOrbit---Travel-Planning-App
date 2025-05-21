import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_orbit/core/services/location_service.dart';
import 'package:trip_orbit/core/services/navigation_service.dart';
import 'package:trip_orbit/presentation/widgets/location_search_widget.dart';

class TaxiServiceScreen extends StatefulWidget {
  const TaxiServiceScreen({super.key});

  @override
  State<TaxiServiceScreen> createState() => _TaxiServiceScreenState();
}

class _TaxiServiceScreenState extends State<TaxiServiceScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;
  List<Map<String, dynamic>> _savedPlaces = [];
  
  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
    _loadSavedPlaces();
  }
  
  Future<void> _loadCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentLocation();
      final latLng = LatLng(position.latitude, position.longitude);
      final address = await LocationService.getAddressFromLatLng(latLng);
      
      setState(() {
        _pickupLocation = latLng;
        _pickupController.text = address;
        _updateMarkers();
      });
      
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, 15),
      );
    } catch (e) {
      debugPrint('Error loading current location: $e');
    }
  }
  
  Future<void> _loadSavedPlaces() async {
    try {
      final places = await LocationService.getSavedPlaces();
      setState(() => _savedPlaces = places);
    } catch (e) {
      debugPrint('Error loading saved places: $e');
    }
  }
  
  void _updateMarkers() {
    final markers = <Marker>{};
    
    if (_pickupLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    
    if (_destinationLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _destinationLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    
    setState(() => _markers = markers);
    
    if (_pickupLocation != null && _destinationLocation != null) {
      _fitMapBounds();
    }
  }
  
  void _fitMapBounds() {
    if (_pickupLocation == null || _destinationLocation == null || _mapController == null) {
      return;
    }
    
    final bounds = LatLngBounds(
      southwest: LatLng(
        _pickupLocation!.latitude < _destinationLocation!.latitude
            ? _pickupLocation!.latitude
            : _destinationLocation!.latitude,
        _pickupLocation!.longitude < _destinationLocation!.longitude
            ? _pickupLocation!.longitude
            : _destinationLocation!.longitude,
      ),
      northeast: LatLng(
        _pickupLocation!.latitude > _destinationLocation!.latitude
            ? _pickupLocation!.latitude
            : _destinationLocation!.latitude,
        _pickupLocation!.longitude > _destinationLocation!.longitude
            ? _pickupLocation!.longitude
            : _destinationLocation!.longitude,
      ),
    );
    
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Layer
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.5665, 126.9780), // Seoul coordinates
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Search and Options Layer
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => NavigationService.goBack(),
                          ),
                          const Text(
                            'Taxi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Location Input Fields
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            LocationSearchWidget(
                              controller: _pickupController,
                              hintText: 'Enter pickup location',
                              prefixIcon: Icons.my_location,
                              iconColor: Colors.blue,
                              onPlaceSelected: (place) {
                                setState(() {
                                  _pickupLocation = place['latLng'];
                                  _updateMarkers();
                                });
                              },
                            ),
                            const Divider(),
                            LocationSearchWidget(
                              controller: _destinationController,
                              hintText: 'Enter destination',
                              prefixIcon: Icons.location_on,
                              iconColor: Colors.red,
                              onPlaceSelected: (place) {
                                setState(() {
                                  _destinationLocation = place['latLng'];
                                  _updateMarkers();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Quick Options
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ..._savedPlaces.map((place) => _buildQuickOption(
                                  place['name'],
                                  place['type'] == 'home' ? Icons.home : Icons.work,
                                  onTap: () {
                                    _destinationController.text = place['name'];
                                    setState(() {
                                      _destinationLocation = place['latLng'];
                                      _updateMarkers();
                                    });
                                  },
                                )),
                            _buildQuickOption('Favorites', Icons.star),
                            _buildQuickOption('Recent', Icons.history),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Bottom Sheet
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildServiceOption(
                              'Regular Taxi',
                              'assets/images/taxi_regular.png',
                              '5-10 min',
                              'Est. ₩15,000',
                              isSelected: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildServiceOption(
                              'Premium Taxi',
                              'assets/images/taxi_premium.png',
                              '7-12 min',
                              'Est. ₩20,000',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implement taxi booking
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Call Taxi'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickOption(String label, IconData icon, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 4),
              Text(label),
            ],
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceOption(
    String title,
    String imagePath,
    String waitTime,
    String price, {
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_taxi),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            waitTime,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
