import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:find_your_restaurant/google_map.dart';

typedef OnMapCreatedCallback = void Function(GoogleMapController controller);

class RestaurantOwnerForm extends StatefulWidget {
  final OnMapCreatedCallback onMapCreated;

  const RestaurantOwnerForm({
    super.key,
    required this.onMapCreated,
  });

  @override
  State<RestaurantOwnerForm> createState() => _RestaurantOwnerFormState();
}

class _RestaurantOwnerFormState extends State<RestaurantOwnerForm> {
  final TextEditingController _restaurantNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();

  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
    widget.onMapCreated(controller);
    }

  void _selectLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _addMarker(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('selected-location'),
          position: location,
        ),
      );
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(location, 15.0),
      );
    } else {
      _selectLocation(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant Owner Form',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            color: Colors.orange,
            shadows: [
              Shadow(
                color: Color.fromARGB(255, 181, 112, 27),
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
        ),
        flexibleSpace: const Image(
          image: AssetImage(
            'assets/images/156757283_Bedford_Hotel__F_B__Botanica_Restaurant_and_Bar__General_View._4500x3000.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/restaurant-owner.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _restaurantNameController,
                  decoration: const InputDecoration(
                    labelText: 'Restaurant Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: _ownerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Owner Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: _openingHoursController,
                  decoration: const InputDecoration(
                    labelText: 'Opening Hours',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'Go to the map and mark your restaurant:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final selectedLocation = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserCustomGoogleMap(
                            onLocationSelected: _selectLocation,
                            onMapCreated: _onMapCreated,
                            onMapTap: _addMarker,
                          ),
                        ),
                      );

                      if (selectedLocation != null) {
                        _selectLocation(selectedLocation);
                        _restaurantNameController.text = 'Your Restaurant';
                        _addMarker(selectedLocation);
                      }
                    },
                    child: const Text('Go to map'),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                if (_selectedLocation != null)
                  SizedBox(
                    height: 200.0,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _selectedLocation ?? const LatLng(0.0, 0.0),
                        zoom: 15.0,
                      ),
                      onMapCreated: (controller) {
                        _onMapCreated(controller);
                      },
                      markers: _markers,
                    ),
                  ),
                const SizedBox(
                  height: 5.0,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedLocation != null) {
                        String restaurantName = _restaurantNameController.text;
                        String ownerName = _ownerNameController.text;
                        String openingHours = _phoneNumberController.text;
                        String phoneNumber = _phoneNumberController.text;

                        print('Restaurant Name: $restaurantName');
                        print('Owner\'s name: $ownerName');
                        print('Opening Hours: $openingHours');
                        print('Phone Number: $phoneNumber');
                        print(
                          'Selected Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                if (_selectedLocation != null)
                  Text(
                    'Selected Location: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
