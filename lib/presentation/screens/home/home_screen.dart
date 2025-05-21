import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_orbit/core/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  final List<Map<String, dynamic>> _services = [
    {'icon': Icons.local_taxi, 'label': 'Taxi', 'color': Colors.amber},
    {'icon': Icons.flight, 'label': 'Flights', 'color': Colors.blue},
    {'icon': Icons.calendar_today, 'label': 'Schedule', 'color': Colors.green},
    {'icon': Icons.lightbulb, 'label': 'AI Recommends', 'color': Colors.orange},
    {'icon': Icons.translate, 'label': 'Translator', 'color': Colors.purple},
    {'icon': Icons.group, 'label': 'Groups', 'color': Colors.indigo},
    {'icon': Icons.card_travel, 'label': 'Trips', 'color': Colors.brown},
    {'icon': Icons.attach_money, 'label': 'Budget', 'color': Colors.green},
    {'icon': Icons.motorcycle, 'label': 'Bike', 'color': Colors.orange},
    {'icon': Icons.local_parking, 'label': 'Parking', 'color': Colors.blue},
    {'icon': Icons.drive_eta, 'label': 'Driver', 'color': Colors.blue},
    {'icon': Icons.local_shipping, 'label': 'Delivery', 'color': Colors.indigo},
    {'icon': Icons.directions_car, 'label': 'Car Rental', 'color': Colors.red},
    {'icon': Icons.bolt, 'label': 'EV Charging', 'color': Colors.green},
    {'icon': Icons.more_horiz, 'label': 'More', 'color': Colors.grey},
  ];

  void _onServiceTapped(String label) {
    switch (label) {
      case 'Taxi':
        Navigator.pushNamed(context, AppRoutes.taxiService);
        break;
      case 'Flights':
        Navigator.pushNamed(context, AppRoutes.flightSearch);
        break;
      case 'Schedule':
        Navigator.pushNamed(context, AppRoutes.dailySchedule);
        break;
      case 'AI Recommends':
        Navigator.pushNamed(context, AppRoutes.aiRecommendations);
        break;
      case 'Translator':
        Navigator.pushNamed(context, AppRoutes.languageTranslator);
        break;
      case 'Groups':
        Navigator.pushNamed(context, AppRoutes.groupList);
        break;
      case 'Trips':
        Navigator.pushNamed(context, AppRoutes.tripList);
        break;
      case 'Budget':
        Navigator.pushNamed(context, AppRoutes.budgetPlanner);
        break;
      case 'Car Rental':
        // TODO: Implement car rental screen
        break;
      case 'EV Charging':
        // TODO: Implement EV charging station screen
        break;
      case 'Delivery':
        // TODO: Implement delivery service screen
        break;
      case 'Driver':
        // TODO: Implement driver service screen
        break;
      case 'Parking':
        // TODO: Implement parking service screen
        break;
      case 'Bike':
        // TODO: Implement bike rental screen
        break;
      case 'More':
        // TODO: Implement more services screen
        break;
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0: // Home
        setState(() => _selectedIndex = index);
        break;
      case 1: // Business
        Navigator.pushNamed(context, AppRoutes.budgetPlanner);
        break;
      case 2: // Notifications
        // TODO: Implement notifications screen
        setState(() => _selectedIndex = index);
        break;
      case 3: // Profile
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'TripOrbit',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Where would you like to go?',
                            prefixIcon: const Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Start Now',
                            style: TextStyle(color: Colors.black54)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: _services.length,
                itemBuilder: (context, index) {
                  final service = _services[index];
                  return GestureDetector(
                    onTap: () => _onServiceTapped(service['label']),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: service['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            service['icon'],
                            color: service['color'],
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          service['label'],
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(37.5665, 126.9780), // Seoul coordinates
                    zoom: 14,
                  ),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createTrip);
        },
        child: const Icon(Icons.add),
        tooltip: 'Create Trip',
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _HorizontalPlaceholderList extends StatelessWidget {
  final int itemCount;
  final String label;
  const _HorizontalPlaceholderList(
      {required this.itemCount, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
            ),
            child: Center(
              child: Text('$label ${index + 1}',
                  style: const TextStyle(fontSize: 16)),
            ),
          );
        },
      ),
    );
  }
}
