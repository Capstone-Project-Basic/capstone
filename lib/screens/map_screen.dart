import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:pocekt_teacher/highfive.dart';
import 'package:pocekt_teacher/model/user.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart' as prifix;
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/utils/cookie_manager.dart';

late UserModel loginUser;
int? currentmemberID = 1;

Future<UserModel> currentUser() async {
  var dio = Dio();
  dio.interceptors.add(CookieManager(MyCookieManager.instance.cookieJar));

  final response = await dio.get("http://13.51.143.99:8080");

  print('Status code: ${response.statusCode}');
  print('Response body: ${response.data}');

  if (response.statusCode == 200) {
    loginUser = UserModel.fromJson(response.data as Map<String, dynamic>);
    currentmemberID = loginUser.id;
    print('loginUser: $loginUser');
    print('currentmemberID: $currentmemberID');
    return loginUser;
  } else {
    throw Exception('Failed to load currentUser');
  }
}

class MapWithMyLocation extends StatefulWidget {
  const MapWithMyLocation({Key? key}) : super(key: key);

  @override
  MapWithMyLocationState createState() => MapWithMyLocationState();
}

class MapWithMyLocationState extends State<MapWithMyLocation> {
  final Completer<GoogleMapController> _controller = Completer();
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

  final Map<String, LatLng> friendLocations = {
    '1': const LatLng(37.301325547635074, 127.03838221728802),
    '2': const LatLng(37.29229148220293, 127.01645672207641),
    '3': const LatLng(37.30608339051031, 127.01508343106079),
    '4': const LatLng(37.304581424208585, 127.03302204495239),
    '5': const LatLng(37.308581424208585, 127.03702204495239),
    '6': const LatLng(37.309581424208585, 127.03802204495239),
    '7': const LatLng(37.310581424208585, 127.03902204495239),
    '8': const LatLng(37.311581424208585, 127.04002204495239),
    '9': const LatLng(37.312581424208585, 127.04102204495239),
    '10': const LatLng(37.313581424208585, 127.04202204495239),
    '11': const LatLng(37.314581424208585, 127.04302204495239),
    '12': const LatLng(37.315581424208585, 127.04402204495239),
    '13': const LatLng(37.316581424208585, 127.04502204495239),
    '14': const LatLng(37.317581424208585, 127.04602204495239),
    '15': const LatLng(37.318581424208585, 127.04702204495239),
    '16': const LatLng(37.319581424208585, 127.04802204495239),
    '17': const LatLng(37.320581424208585, 127.04902204495239),
    '18': const LatLng(37.321581424208585, 127.05002204495239),
    '19': const LatLng(37.322581424208585, 127.05102204495239),
  };

  final Map<String, Marker> _markers = {};
  late Future<List<UserModel>> futureMembers = Future.value([]);
  late List<UserModel> friends;

  Future<UserModel> sendAlert(
      String senderId, String targetId, String location) async {
    var response =
        await http.post(Uri.parse("http://13.51.143.99:8080/api/fcm/sendToOne"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode(<String, String>{
              "senderId": senderId,
              "targetId": targetId,
              "location": location,
            }));
    print("responseStatusCode : ${response.statusCode}");
    print("response.body : ${response.body}");

    if (response.statusCode == 200) {
      print("Success to send alert");
    } else {
      print("Failed to send alert");
    }
    return UserModel(
      id: 0,
      loginId: '',
      loginPassword: '',
      name: '',
      stamp_cnt: 0,
      token: '',
      image_path: '',
      role: '',
    );
  }

  Future<List<UserModel>> fetchMembers() async {
    final response =
        await http.get(Uri.parse("http://13.51.143.99:8080/members"));

    if (response.statusCode == 200) {
      final List body = json.decode(utf8.decode(response.bodyBytes));
      return body.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load Stamp data');
    }
  }

  @override
  void initState() {
    super.initState();

    _checkLocationService();
    _loadMapStyle().then((String style) {
      _mapStyle = style;
    });
    // 현재 위치를 가져와서 맵을 해당 위치로 이동
    _getCurrentLocation();
    futureMembers = fetchMembers();
    futureMembers.then((members) {
      setState(() {
        friends = members;
        _updateFriendLocation();
      });
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await currentUser();
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
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
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

  void _addFriendMarker(UserModel friend, LatLng friendLocation) async {
    Uint8List imageData =
        await _getResizedImageWithBorder('assets/images/hiyoko.png', 100, 100);
    BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(imageData);

    Marker marker = Marker(
      markerId: MarkerId(friend.id.toString()),
      position: friendLocation,
      icon: markerIcon,
      infoWindow: InfoWindow(title: friend.name),
    );

    setState(() {
      _markers[friend.id.toString()] = marker;
    });
  }

  void _updateFriendLocation() async {
    friends = await futureMembers;
    for (var friend in friends) {
      print("friend: $friend");
      print("friend name: ${friend.name}");
      print("friend id: ${friend.id}");

      var locationKey = friend.id.toString();
      print("locationKey: $locationKey");
      var location = friendLocations[locationKey];
      print("location : $location");
      if (location != null) {
        _addFriendMarker(friend, location);
      } else {
        print('Location not found for friend with id: $locationKey');
      }
    }
  }

  Future<UserModel> registerUser(
      String memberId, String location, BuildContext context) async {
    var response =
        await http.post(Uri.parse("http://13.51.143.99:8080/login/new"),
            headers: <String, String>{"Content-Type": "application/json"},
            body: jsonEncode(<String, String>{
              "memberId": memberId,
              "location": location,
            }));

    print(response.body);
    if (response.statusCode == 200) {}

    return UserModel(
      id: 9999,
      loginId: 'error email',
      loginPassword: 'error password',
      name: 'error name',
      stamp_cnt: 0,
      token: '',
      image_path: '',
      role: '',
    );
  }

  Future<void> _addCurrentLocationMarker() async {
    if (_currentLocation != null) {
      Uint8List imageData = await _getResizedImageWithBorder(
          'assets/images/hiyokohuka.png', 120, 120);
      BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(imageData);

      _currentLocationMarker = Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentLocation!,
        icon: markerIcon,
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

  Future<Uint8List> _getResizedImageWithBorder(
      String imagePath, int width, int height) async {
    // Load profile image
    ByteData imageData = await rootBundle.load(imagePath);
    ui.Codec codec = await ui.instantiateImageCodec(
        imageData.buffer.asUint8List(),
        targetWidth: width,
        targetHeight: height);
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    // Create a PictureRecorder to draw the image and border
    ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);

    // Draw white circle border
    Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(Offset(width / 2, height / 2), width / 2, borderPaint);

    // Draw the profile image inside the border
    Paint imagePaint = Paint()
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;
    Rect imageRect = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
    canvas.drawImageRect(frameInfo.image, imageRect, imageRect, imagePaint);

    // Convert the drawn picture to an Image
    ui.Image image =
        await pictureRecorder.endRecording().toImage(width, height);

    // Convert the Image to bytes
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _onMapLongPress(LatLng location) {
    print('Map long pressed at: $location');
    _showInviteDialog(location);
  }

  void _showInviteDialog(LatLng location) async {
    String fullAddress = await _getAddressFromLatLng(location);
    List<String> parts = fullAddress.split(',');
    String address = parts[0].trim();

    function(UserModel user, String address) {
      _handleFriendSelection(location, user);
      Navigator.pop(context);
      _showInvitationResponseDialog(user);
      sendAlert(currentmemberID.toString(), user.id.toString(), address);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade200,
          title: Center(
            child: Text(
              '모이자!',
              style: kMediumText.copyWith(
                  color: Colors.black, fontWeight: FontWeight.w300),
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: FutureBuilder<List<UserModel>>(
              future: futureMembers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final users = snapshot.data!;
                  users.sort((a, b) => a.stampCnt.compareTo(b.stampCnt));
                  print(users);
                  return buildUsers(users, function, address);
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text("Error loading users");
                }
                return const Text("No Data Available...");
              },
            ),
          ),
        );
      },
    );
    // Column(
    //   children: [
    //     Center(child: Text('모이자 위치: $address')),
    //     const SizedBox(height: 16.0),
    //     // Column(
    //     //   children: friends.map((friend) {
    //     //     return ListTile(
    //     //       title: Text(friend.name),
    //     //       trailing: ElevatedButton(
    //     //         onPressed: () {
    //     //           _handleFriendSelection(location, friend);
    //     //           Navigator.pop(context);
    //     //           _showInvitationResponseDialog(friend);
    //     //         },
    //     //         child: const Text('초대'),
    //     //       ),
    //     //     );
    //     //   }).toList(),
    //     // ),
    //   ],
    // ),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           child: const Text('취소'),
    //         ),
    //       ],
    //     );
    //   },
    // );
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

  void _handleFriendSelection(LatLng location, UserModel friend) async {
    print('Invitation sent to ${friend.name} for location $location');
    _showInvitationResponseDialog(friend);
  }

  Future<void> _showInvitationResponseDialog(UserModel friend) async {
    Dialogs.materialDialog(
      color: Colors.white,
      msg: '${friend.name}친구에게 모이자고 말했어요!',
      title: '모이자 성공!',
      lottieBuilder: prifix.Lottie.asset(
        'assets/lottie/hand.json',
        fit: BoxFit.contain,
      ),
      dialogWidth: kIsWeb ? 0.3 : null,
      context: context,
    );
  }

  Future<String> _loadMapStyle() async {
    return await rootBundle.loadString('assets/map/map_style.json');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.large(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          disabledElevation: 0,
          elevation: 0,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Highfive())),
          child: const Image(
            image: AssetImage('assets/images/kutsurogu_kids2.png'),
          ),
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
                    for (int i = 0; i < friends.length; i++) {
                      _addFriendMarker(
                          friends[i], friendLocations[friends[i].id]!);
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
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    if (!_koreaBounds.contains(position.target)) {
      _moveToCurrentLocation();
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: MapWithMyLocation(),
  ));
}

Widget buildUsers(List<UserModel> users, Function function, String address) {
  return Expanded(
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        Color color = Colors.grey;
        Color bgColor = Colors.grey.shade200;

        return GestureDetector(
          onTap: () {
            function(user, address);
          },
          child: NameCardLight(
            name: user.name,
            color: color,
            backgroundColor: bgColor,
          ),
        );
      },
    ),
  );
}

class NameCardLight extends StatelessWidget {
  NameCardLight({
    super.key,
    required this.name,
    required this.color,
    required this.backgroundColor,
  });

  String name;
  Color color;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: const Border(
              bottom: BorderSide(
            color: children,
            width: 1,
          ))
          // borderRadius: BorderRadius.circular(8),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 10.0,
                  ),
                  const CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/images/hiyoko.png'),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    name,
                    style: kSmallText.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
