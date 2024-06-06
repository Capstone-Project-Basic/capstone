import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

class MapWithMyLocation extends StatefulWidget {
  const MapWithMyLocation({Key? key}) : super(key: key);

  @override
  MapWithMyLocationState createState() => MapWithMyLocationState();
}

class Friend {
  final String name;
  final String id;
  final String profileImage;

  Friend({required this.name, required this.id, required this.profileImage});
}

class MapWithMyLocationState extends State<MapWithMyLocation> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentLocation;
  bool _isLocationServiceEnabled = false;
  Marker? _currentLocationMarker;
  late double latitude;
  late double longitude;
  StreamSubscription<Position>? _positionStreamSubscription;
  String? _mapStyle;
  late String _mapStyleString;

  final LatLngBounds _koreaBounds = LatLngBounds(
    southwest: const LatLng(33.0, 124.0),
    northeast: const LatLng(39.0, 132.0),
  );

  final List<Friend> _friends = [
    Friend(name: '김동글', id: '1', profileImage: 'assets/images/profile.png'),
    Friend(name: '이동글', id: '2', profileImage: 'assets/images/profile.png'),
    Friend(name: '박동글', id: '3', profileImage: 'assets/images/profile.png'),
    Friend(name: '정동글', id: '4', profileImage: 'assets/images/profile.png'),
  ];

  final Map<String, LatLng> _friendLocations = {
    '1': const LatLng(37.5665, 126.9780),
    '2': const LatLng(37.5765, 126.9880),
    '3': const LatLng(37.5865, 126.9980),
    '4': const LatLng(37.5965, 127.0080),
  };

  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkLocationService();
    _loadMapStyle().then((String style) {
      _mapStyle = style;
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isLocationServiceEnabled = serviceEnabled;
    });
    if (serviceEnabled) {
      await _requestLocationPermission();
      await _getCurrentLocation();
      _updateFriendLocation();
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
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        _currentLocation = LatLng(latitude, longitude);
        _addCurrentLocationMarker();
        _moveToCurrentLocation();
        _updateFriendLocation();
      });
    } catch (e) {
      print(e);
      setState(() {
        latitude = 37.5665;
        longitude = 126.9780;
        _currentLocation = LatLng(latitude, longitude);
        _addCurrentLocationMarker();
        _moveToCurrentLocation();
        _updateFriendLocation();
      });
    }
  }

  void _updateFriendLocation() {
    for (var friend in _friends) {
      _addFriendMarker(friend, _friendLocations[friend.id]!);
    }
  }

  void _addCurrentLocationMarker() {
    if (_currentLocation != null) {
      _currentLocationMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      setState(() {
        _markers['currentLocation'] = _currentLocationMarker!;
      });
    }
  }

  void _moveToCurrentLocation() {
    _controller.future.then((controller) {
      if (_currentLocation != null) {
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            _currentLocation!,
            17,
          ),
        );
      }
    });
  }

  Future<Uint8List> _getResizedImage(String imagePath, int width, int height) async {
    ByteData data = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  Future<void> _addFriendMarker(Friend friend, LatLng position) async {
    Uint8List imageData = await _getResizedImage(friend.profileImage, 120, 120);
    BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(imageData);

    Marker marker = Marker(
      markerId: MarkerId(friend.id),
      position: position,
      icon: markerIcon,
    );

    setState(() {
      _markers[friend.id] = marker;
    });
  }

  void _onMapLongPress(LatLng location) {
    print('Map long pressed at: $location');
    _showInviteDialog(location);
  }

  void _showInviteDialog(LatLng location) async {
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
                  children: _friends.map((friend) {
                    return ListTile(
                      title: Text(friend.name),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _handleFriendSelection(location, friend);
                          Navigator.pop(context);
                          _showInvitationResponseDialog(friend);
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

  void _handleFriendSelection(LatLng location, Friend friend) async {
    print('Invitation sent to ${friend.name} for location $location');
    _showInvitationResponseDialog(friend);
  }

  Future<void> _showInvitationResponseDialog(Friend friend) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });

        return AlertDialog(
          title: const Text('초대완료!'),
          content: Text('${friend.name}에게 초대를 보냈습니다'),
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

  Future<String> _loadMapStyle() async {
    return await rootBundle.loadString('assets/map_style.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_currentLocation"),
      ),
      body: _isLocationServiceEnabled
          ? GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(37.5665, 126.9780),
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _controller.future.then((controller) {
                  if (_mapStyle != null) {
                    controller.setMapStyle(_mapStyle);
                  }
                  _addCurrentLocationMarker();
                  _moveToCurrentLocation();
                  for (int i = 0; i < _friends.length; i++) {
                    _addFriendMarker(_friends[i], _friendLocations[_friends[i].id]!);
                  }
                });
              },
              myLocationEnabled: true,
              markers: Set<Marker>.of(_markers.values),
              onLongPress: _onMapLongPress,
              onCameraMove: _onCameraMove,
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

