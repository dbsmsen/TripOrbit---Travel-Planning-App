import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trip_orbit/core/services/location_service.dart';

class LocationSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Color iconColor;
  final Function(Map<String, dynamic>) onPlaceSelected;

  const LocationSearchWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    required this.iconColor,
    required this.onPlaceSelected,
  });

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  List<Map<String, dynamic>> _searchResults = [];
  bool _showResults = false;
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showResults = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showResults = true;
    });

    try {
      final results = await LocationService.searchPlaces(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error searching places: $e');
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: Icon(widget.prefixIcon, color: widget.iconColor),
            border: InputBorder.none,
          ),
        ),
        if (_showResults) ...[
          const Divider(height: 1),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final place = _searchResults[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(place['name']),
                        subtitle: Text(
                          place['address'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          widget.controller.text = place['name'];
                          widget.onPlaceSelected(place);
                          setState(() => _showResults = false);
                        },
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }
}
