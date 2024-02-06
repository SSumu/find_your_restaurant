import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as places;
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class Debouncer {
  final int milliseconds;
  VoidCallback action;

  Debouncer({required this.milliseconds, required this.action});

  void run(VoidCallback callback) {
    if (action is! Future) {
      action();
    }
    action = () {
      Future.delayed(Duration(milliseconds: milliseconds), callback);
    };
  }
}

Future<BitmapDescriptor> _loadResizedRestaurantIcon(double width, double height,
    {double markerSize = 1.0}) async {
  ByteData data = await rootBundle.load(
      'assets/images/map-navigation-pin-point-restaurant-icon--14-removebg-preview.png');
  Uint8List bytes = data.buffer.asUint8List();
  // ui.Codec codec = await ui.instantiateImageCodec(bytes);
  // ui.FrameInfo fi = await codec.getNextFrame();
  // ui.Image image = fi.image;

  img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;

  double newWidth = width * markerSize;
  double newHeight = height * markerSize;

  img.Image resizedImage =
      img.copyResize(image, width: newWidth.toInt(), height: newHeight.toInt());

  // ByteData? resizedByteData =
  //     await resizedImage.toByteData(format: ui.ImageByteFormat.png);
  List<int> resizedBytes = img.encodePng(resizedImage);

  return BitmapDescriptor.fromBytes(Uint8List.fromList(resizedBytes));
}

class UserCustomGoogleMap extends StatefulWidget {
  final Function(LatLng)? onLocationSelected;
  final Function(GoogleMapController)? onMapCreated;
  final Function(LatLng)? onMapTap;

  const UserCustomGoogleMap({
    super.key,
    this.onLocationSelected,
    this.onMapCreated,
    this.onMapTap,
  });

  @override
  UserCustomGoogleMapState createState() => UserCustomGoogleMapState();
  // State<GoogleMap> createState() => _GoogleMapState(
}

class UserCustomGoogleMapState
    extends State<UserCustomGoogleMap> /*with WidgetsBindingObserver*/ {
  GoogleMapController? _controller;
  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final TextEditingController _searchController = TextEditingController();
  SearchBox? _searchBox;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};

  // final String darkMapStyle =
  //     '''[{"elementType": "geometry","stylers": [{"color": "#1d1d1d"}]},{"elementType": "labels.text.fill","stylers": [{"color": "#ffffff"}]},]''';

  // final String lightMapStyle =
  //     '''[{"elementType": "geometry","stylers": [{"color": "#f5f5f5"}]},{"elementType": "label.text.fill","stylers": [{"color": "#616161"}]},]''';

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addObserver(this);
    _checkLocationPermission();
  }

  // @override
  // void didChangePlatformBrightness() {
  //   _setMapStyle();
  // }

  // void _setMapStyle() async {
  //   final brightness = MediaQuery.of(context).platformBrightness;
  //   final isDarkMode = brightness == Brightness.dark;

  //   String mapStyle = isDarkMode ? darkMapStyle : lightMapStyle;

  //   if (_controller != null) {
  //     try {
  //       await _controller!.setMapStyle(mapStyle);
  //     } catch (e) {
  //       print('Error setting map style: $e');
  //     }
  //   }
  // }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      _locationData = await _location.getLocation();
      if (_controller != null && _locationData != null) {
        _controller!.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(_locationData!.latitude!, _locationData!.longitude!),
          15.0,
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }

  void _handleSearch(String query) async {
    try {
      final places.PlacesSearchResponse response =
          await places.GoogleMapsPlaces(
        apiKey: 'AIzaSyD9s7hQszcxMZ6ycQ9zbq21PF-apnTaIL4',
      ).searchByText(query);

      if (response.isOkay && response.results.isNotEmpty) {
        final places.PlacesDetailsResponse details =
            await places.GoogleMapsPlaces(
          apiKey: 'AIzaSyD9s7hQszcxMZ6ycQ9zbq21PF-apnTaIL4',
        ).getDetailsByPlaceId(
          response.results[0].placeId,
        );

        if (details.isOkay) {
          final location = details.result.geometry?.location;
          if (location != null && _controller != null) {
            LatLng restaurantLocation = LatLng(location.lat, location.lng);

            // BitmapDescriptor restaurantIcon =
            //     await BitmapDescriptor.fromAssetImage(
            //   ImageConfiguration(
            //     size: Size(48, 48),
            //   ),
            //   'assets/images/map-navigation-pin-point-restaurant-icon--14.png',
            // );

            double markerWidth = 5;
            double markerHeight = 5;
            double markerSize = 0.5;
            BitmapDescriptor restaurantIcon = await _loadResizedRestaurantIcon(
              markerWidth,
              markerHeight,
              markerSize: markerSize,
            );

            _addMarker(restaurantLocation, restaurantIcon);

            _controller!.animateCamera(
              CameraUpdate.newLatLngZoom(
                // LatLng(location.lat, location.lng),
                restaurantLocation,
                15.0,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error searching for place: $e');
      }
    } finally {
      _searchBox?.clearSuggestions();
    }
  }

  Future<BitmapDescriptor> _loadRestaurantIcon() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(
        size: Size(1, 1),
      ),
      'assets/images/map-navigation-pin-point-restaurant-icon--14-removebg-preview.png',
    );
  }

  // Future<BitmapDescriptor> _loadRestaurantIcon()async{
  //   ByteData data = await rootBundle.load('assets/images/map-navigation-pin-point-restaurant-icon--14.png');
  //   List<int> bytes = data.buffer.asInt8List();
  //   ui.Codec codec = await ui.instantImageCodec(bytes);
  //   ui.FrameInfo frame = await codec.getNextFrame();

  // }

  void _addMarker(LatLng position, BitmapDescriptor icon) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        icon: icon,
      ));
    });
  }

  void _handleSuggestionSelected(String suggestion) async {
    _searchController.text = suggestion;
    _handleSearch(suggestion);
    _searchBox?.clearSuggestions();
    FocusScope.of(context).unfocus();

    if (widget.onLocationSelected != null && _locationData != null) {
      widget.onLocationSelected!(
          LatLng(_locationData!.latitude!, _locationData!.longitude!));
      Navigator.pop(
          context, LatLng(_locationData!.latitude!, _locationData!.longitude!));
    }
  }

  // void _handleMapTap(LatLng location) {
  //   setState(() {
  //     _selectedLocation = location;
  //     _markers.clear();
  //     _markers.add(Marker(
  //       markerId: MarkerId(location.toString()),
  //       position: location,
  //       // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  //     ));
  //   });

  //   if (widget.onMapTap != null) {
  //     widget.onMapTap!(location);
  //   }
  // }

  void _handleMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;

      _loadRestaurantIcon().then((BitmapDescriptor restaurantIcon) {
        _addMarker(location, restaurantIcon);
      });

      if (widget.onMapTap != null) {
        widget.onMapTap!(location);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _controller = controller;
                _searchBox = SearchBox(
                  onSearch: _handleSearch,
                  onSuggestionSelected: _handleSuggestionSelected,
                  controller: _controller,
                  searchController: _searchController,
                  locationData: _locationData ?? LocationData.fromMap({}),
                  suggestions: const [],
                  focusNode: FocusNode(),
                );
              });
              if (widget.onMapCreated != null) {
                widget.onMapCreated!(controller);
              }
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 15,
            ),
            myLocationEnabled: true,
            compassEnabled: true,
            padding: const EdgeInsets.only(
              top: 300,
              bottom: 10,
            ),
            onTap: (location) {
              print('Map tapped');
              FocusScope.of(context).unfocus();
              _searchBox?.clearSuggestions();
              _handleMapTap(location);

              if (widget.onMapTap != null) {
                widget.onMapTap!(location);
              }
            },
            markers: _markers,
          ),
          CustomPaint(
            painter: LightBeamPainter(
              locationData: _locationData,
              controller: _controller,
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 60,
            right: 10,
            child: _searchBox != null ? _searchBox! : Container(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    super.dispose();
  }
}

class LightBeamPainter extends CustomPainter {
  final LocationData? locationData;
  final GoogleMapController? controller;

  LightBeamPainter({required this.locationData, required this.controller});

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    if (locationData == null || controller == null) return;

    final Paint paint = Paint()
      ..color = Colors.yellow.withOpacity(0.2)
      ..blendMode = BlendMode.plus;

    const double beamLength = 300.0;

    final LatLng userLatLng = LatLng(
      locationData?.latitude ?? 0.0,
      locationData?.longitude ?? 0.0,
    );

    final ScreenCoordinate userScreenCoordinate =
        (await controller?.getScreenCoordinate(userLatLng) ??
            const ScreenCoordinate(x: 0, y: 0));
    final ScreenCoordinate endPointScreen = ScreenCoordinate(
      x: (userScreenCoordinate.x + beamLength).toInt(),
      y: userScreenCoordinate.y.toInt(),
    );

    final Path path = Path()
      ..moveTo(
          userScreenCoordinate.x.toDouble(), userScreenCoordinate.y.toDouble())
      ..lineTo(endPointScreen.x.toDouble(), endPointScreen.y.toDouble());

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SearchBox extends StatefulWidget {
  final void Function(String) onSearch;
  final void Function(String) onSuggestionSelected;
  final GoogleMapController? controller;
  final TextEditingController searchController;
  final LocationData locationData;
  List<places.Prediction> suggestions;
  final FocusNode focusNode;
  final Function()? onMapTap;

  SearchBox({
    required this.onSearch,
    required this.onSuggestionSelected,
    this.controller,
    required this.locationData,
    required this.searchController,
    required this.focusNode,
    required List<places.Prediction> suggestions,
    this.onMapTap,
    super.key,
  })  : suggestions = List.from(suggestions);

  SearchBox copyWith({
    List<places.Prediction>? suggestions,
  }) {
    return SearchBox(
      onSearch: onSearch,
      onSuggestionSelected: onSuggestionSelected,
      controller: controller,
      locationData: locationData,
      searchController: searchController,
      suggestions: suggestions ?? this.suggestions,
      focusNode: focusNode,
      onMapTap: onMapTap,
    );
  }

  void clearSuggestions() {
    suggestions.clear();
  }

  @override
  _SearchBoxState createState() => _SearchBoxState(locationData: locationData);
}

class _SearchBoxState extends State<SearchBox> {
  String _sessionToken;
  late LocationData locationData;
  late final Debouncer _debouncer;

  final FocusNode _focusNode = FocusNode();

  _SearchBoxState({required this.locationData})
      : _sessionToken = DateTime.now().millisecondsSinceEpoch.toString(),
        _debouncer = Debouncer(milliseconds: 500, action: () {});

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              widget.clearSuggestions();
              widget.onMapTap?.call();
            },
            child: SizedBox(
              height: 60,
              child: TextField(
                controller: widget.searchController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search for restaurant...',
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(
                    bottom: 0.0,
                    left: 20,
                  ),
                ),
                onTap: _clearSearch,
                onChanged: (value) {
                  if (_focusNode.hasFocus) {
                    _debouncer.run(() async {
                      _sessionToken =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      final suggestions = await places.GoogleMapsPlaces(
                        apiKey: 'AIzaSyD9s7hQszcxMZ6ycQ9zbq21PF-apnTaIL4',
                      ).autocomplete(
                        value,
                        sessionToken: _sessionToken,
                        location: places.Location(
                          lat: widget.locationData.latitude ?? 0.0,
                          lng: widget.locationData.longitude ?? 0.0,
                        ),
                        radius: 10000,
                      );

                      setState(() {
                        widget.onSearch(value);
                        widget.suggestions =
                            suggestions.isOkay ? suggestions.predictions : [];
                      });
                    });
                  }
                },
                onSubmitted: (value) {
                  if (widget.controller != null) {
                    widget.onSearch(value);
                  }
                },
              ),
            ),
          ),
        ),
        _buildSuggestionsList(),
      ],
    );
  }

  Widget _buildSuggestionsList() {
    final suggestionsInSriLanka = widget.suggestions.where((prediction) {
      return prediction.structuredFormatting?.secondaryText
              ?.contains('Sri Lanka') ??
          false;
    }).toList();
    return suggestionsInSriLanka.isNotEmpty
        ? Positioned(
            top: 500,
            child: Container(
              color: Colors.black,
              height: 200,
              child: ListView.builder(
                itemCount: suggestionsInSriLanka.length,
                itemBuilder: (context, index) {
                  final prediction = suggestionsInSriLanka[index];
                  return ListTile(
                    title: Text(
                      prediction.description ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      widget.onSuggestionSelected(prediction.description ?? '');
                      _clearSearch();
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          )
        : Container();
  }

  void _clearSearch() {
    FocusScope.of(context).unfocus();
    widget.clearSuggestions();
    widget.onMapTap?.call();
  }

  void _showSuggestions() {
    _debouncer.run(() async {
      _sessionToken = DateTime.now().millisecondsSinceEpoch.toString();
      final suggestions = await places.GoogleMapsPlaces(
        apiKey: 'AIzaSyD9s7hQszcxMZ6ycQ9zbq21PF-apnTaIL4',
      ).autocomplete(
        widget.searchController.text,
        sessionToken: _sessionToken,
        location: places.Location(
          lat: widget.locationData.latitude ?? 0.0,
          lng: widget.locationData.longitude ?? 0.0,
        ),
      );

      setState(() {
        widget.suggestions = suggestions.isOkay ? suggestions.predictions : [];
      });

      widget.clearSuggestions();
    });
  }
}
