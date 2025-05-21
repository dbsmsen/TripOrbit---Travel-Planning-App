import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FlightSearchScreen extends ConsumerStatefulWidget {
  const FlightSearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends ConsumerState<FlightSearchScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime? _departureDate;
  DateTime? _returnDate;
  bool _isRoundTrip = true;
  String _selectedClass = 'Economy';

  final List<String> _flightClasses = [
    'Economy',
    'Premium Economy',
    'Business',
    'First',
  ];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Search'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTripTypeSelector(),
            const SizedBox(height: 16),
            _buildLocationFields(),
            const SizedBox(height: 16),
            _buildDateFields(),
            const SizedBox(height: 16),
            _buildClassSelector(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _searchFlights,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Search Flights'),
            ),
            const SizedBox(height: 24),
            _buildFlightResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeSelector() {
    return SegmentedButton<bool>(
      segments: const [
        ButtonSegment<bool>(
          value: true,
          label: Text('Round Trip'),
        ),
        ButtonSegment<bool>(
          value: false,
          label: Text('One Way'),
        ),
      ],
      selected: {_isRoundTrip},
      onSelectionChanged: (Set<bool> newSelection) {
        setState(() {
          _isRoundTrip = newSelection.first;
          if (!_isRoundTrip) {
            _returnDate = null;
          }
        });
      },
    );
  }

  Widget _buildLocationFields() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: 'From',
                prefixIcon: Icon(Icons.flight_takeoff),
                hintText: 'Enter departure city',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: 'To',
                prefixIcon: Icon(Icons.flight_land),
                hintText: 'Enter destination city',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFields() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Departure Date'),
              subtitle: Text(
                _departureDate != null
                    ? DateFormat('MMM dd, yyyy').format(_departureDate!)
                    : 'Select date',
              ),
              onTap: () => _selectDate(true),
            ),
            if (_isRoundTrip) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Return Date'),
                subtitle: Text(
                  _returnDate != null
                      ? DateFormat('MMM dd, yyyy').format(_returnDate!)
                      : 'Select date',
                ),
                onTap: () => _selectDate(false),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClassSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<String>(
          value: _selectedClass,
          decoration: const InputDecoration(
            labelText: 'Class',
            prefixIcon: Icon(Icons.airline_seat_recline_normal),
          ),
          items: _flightClasses.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedClass = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildFlightResults() {
    // Mock flight results
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Best Deals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildFlightCard(
          airline: 'Emirates',
          price: '\$750',
          duration: '7h 30m',
          departure: '10:30 AM',
          arrival: '6:00 PM',
          stops: 1,
        ),
        _buildFlightCard(
          airline: 'Qatar Airways',
          price: '\$820',
          duration: '8h 15m',
          departure: '2:15 PM',
          arrival: '10:30 PM',
          stops: 0,
        ),
        _buildFlightCard(
          airline: 'Lufthansa',
          price: '\$680',
          duration: '9h 45m',
          departure: '11:45 AM',
          arrival: '9:30 PM',
          stops: 2,
        ),
      ],
    );
  }

  Widget _buildFlightCard({
    required String airline,
    required String price,
    required String duration,
    required String departure,
    required String arrival,
    required int stops,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  airline,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      departure,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Departure',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      duration,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$stops ${stops == 1 ? 'stop' : 'stops'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      arrival,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Arrival',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isDeparture) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDeparture
          ? _departureDate ?? DateTime.now()
          : _returnDate ?? _departureDate ?? DateTime.now(),
      firstDate: isDeparture ? DateTime.now() : _departureDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isDeparture) {
          _departureDate = picked;
          if (_returnDate != null && _returnDate!.isBefore(_departureDate!)) {
            _returnDate = null;
          }
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _searchFlights() {
    // TODO: Implement flight search functionality
    // This would typically involve calling an API to search for flights
    // For now, we're just showing mock results
  }
}
