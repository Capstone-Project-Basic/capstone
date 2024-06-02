import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; 
import 'package:permission_handler/permission_handler.dart';

class MapWithMyLocation extends StatefulWidget {
  const MapWithMyLocation({Key? key}) : super(key: key);

  @override
  MapWithMyLocationState createState() => MapWithMyLocationState();
}

class Friend {
  final String name;
  final String id;

  Friend({required this.name, required this.id});
}

class MapWithMyLocationState extends State<MapWithMyLocation> {
  GoogleMapController? _controller;
  LatLng? _currentLocation;
  bool _isLocationServiceEnabled = false;
  final LatLng _friendLocation = const LatLng(37.5665, 126.9780);
  Marker? _friendMarker;
  Marker? _currentLocationMarker;
  late double latitude;
  late double longitude;

  final LatLngBounds _koreaBounds = LatLngBounds(
    southwest: const LatLng(33.0, 124.0),
    northeast: const LatLng(39.0, 132.0),
  );

  @override
  void initState() {
    super.initState();
    _checkLocationService();
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isLocationServiceEnabled = serviceEnabled;
    });
    if (serviceEnabled) {
      await _requestLocationPermission();
      _getCurrentLocation();
    }
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return;
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }
  


  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        latitude = position.latitude;
        longitude = position.longitude;
    } catch (e) {
      print(e);
    }
    

    setState(() {
      _currentLocation = LatLng(latitude, longitude);
      _addCurrentLocationMarker();
      _moveToCurrentLocation();
    });
  }

  void _addCurrentLocationMarker() {
    _currentLocationMarker = Marker(
      markerId: const MarkerId('currentLocation'),
      position: _currentLocation!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    setState(() {});
  }

  void _moveToCurrentLocation() {
    if (_controller != null && _currentLocation != null) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation!,
            zoom: 15,
          ),
        ),
      );
    }
  }

  void _addFriendMarker() {
    _friendMarker = Marker(
      markerId: const MarkerId('friend'),
      position: _friendLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {});
  }

  Future<void> _updateFriendLocation() async {
    Future.delayed(const Duration(seconds: 10), _updateFriendLocation);
  }

  void _onMapLongPress(LatLng location) {
    print('Map long pressed at: $location');
    _showInviteDialog(location);
  }

  List<Friend> _getFriendList() {
    return [
      Friend(name: '김동글', id: '1'),
      Friend(name: '이동글', id: '2'),
      Friend(name: '박동글', id: '3'),
      Friend(name: '정동글', id: '4'),
    ];
  }

  void _showInviteDialog(LatLng location) async {
    List<Friend> friends = _getFriendList();
    String address = await _getAddressFromLatLng(location);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이 장소에서 모일 친구들을 초대해~'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location: $address'),
                const SizedBox(height: 16.0),
                const Text('친구 목록:'),
                const SizedBox(height: 8.0),
                Column(
                  children: friends.map((friend) {
                    return ListTile(
                      title: Text(friend.name),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _handleFriendSelection(location, friend);
                          Navigator.pop(context);
                        },
                        child: const Text('초대'),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _getAddressFromLatLng(LatLng location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      return '${placemark.street}, ${placemark.locality}, ${placemark.country}';
    }
    return 'Unknown location';
  }

  void _handleFriendSelection(LatLng location, Friend friend) {
    print('Invitation sent to ${friend.name} for location $location');
    _showInvitationResponseDialog(friend);
  }

  void _showInvitationResponseDialog(Friend friend) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invitation Response'),
          content: Text('Waiting for ${friend.name}\'s response...'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('위치'),
        title: Text("$_currentLocation"),
      ),
      body: _isLocationServiceEnabled
          ? Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(37.5665, 126.9780),
                      zoom: 15,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      _addFriendMarker();
                      _moveToCurrentLocation();
                      _updateFriendLocation();
                    },
                    myLocationEnabled: true,
                    markers: {
                      if (_currentLocationMarker != null) _currentLocationMarker!,
                      if (_friendMarker != null) _friendMarker!,
                    },
                    onLongPress: _onMapLongPress,
                    onCameraMove: _onCameraMove,
                  ),
                ),
              ],
            )
          : const Center(
              child: Text('Please enable location service.'),
            ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    if (_controller != null && !_koreaBounds.contains(position.target)) {
      _moveToCurrentLocation();
    }
  }
}


void main() {
  runApp(const MaterialApp(
    home: MapWithMyLocation(),
  ));
}

