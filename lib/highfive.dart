import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:lottie/lottie.dart';
import 'package:pocekt_teacher/constants.dart';
import 'package:pocekt_teacher/model/token.dart';
import 'package:pocekt_teacher/screens/map_screen.dart';
import 'package:vibration/vibration.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shake_detector/shake_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'api/firebase_api.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:http/http.dart' as http;

Future<Token> sendAlert(String token, BuildContext context) async {
  var response = await http.post(
      Uri.parse("http://13.51.143.99:8080/api/fcm/sendToAllExceptTwo2"),
      headers: <String, String>{"Content-Type": "application/json"},
      body: jsonEncode(<String, String>{
        "token": token,
      }));
  print("responseStatusCode : ${response.statusCode}");
  print("response.body : ${response.body}");

  if (response.statusCode == 200) {
    print("Success to send alert");
  } else {
    print("Failed to send alert");
  }
  return Token(
    id: 9999,
    token: 'error email',
  );
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const Home());
    case 'browser':
      return MaterialPageRoute(
          builder: (_) =>
              const DevicesListScreen(deviceType: DeviceType.browser));
    case 'advertiser':
      return MaterialPageRoute(
          builder: (_) =>
              const DevicesListScreen(deviceType: DeviceType.advertiser));
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

class Highfive extends StatelessWidget {
  const Highfive({super.key});

  static String id = 'highfive_screen';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      onGenerateRoute: generateRoute,
      initialRoute: 'browser',
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, 'browser');
              },
              child: Container(
                color: Colors.red,
                child: const Center(
                    child: Text(
                  'Main',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                )),
              ),
            ),
          ),
          Expanded(
            child: ShakeDetectWrap(
              onShake: () {
                Navigator.pushNamed(context, 'advertiser');
              },
              child: Container(
                color: Colors.green,
                child: const Center(
                    child: Text(
                  'ADVERTISER',
                  style: TextStyle(color: Colors.white, fontSize: 40),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum DeviceType { advertiser, browser }

class DevicesListScreen extends StatefulWidget {
  const DevicesListScreen({super.key, required this.deviceType});

  final DeviceType deviceType;

  @override
  _DevicesListScreenState createState() => _DevicesListScreenState();
}

class _DevicesListScreenState extends State<DevicesListScreen> {
  List<Device> devices = [];
  List<Device> connectedDevices = [];
  late NearbyService nearbyService;
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;

  bool isInit = false;
  final bool _inviteIsVisible = true;
  // late final _title;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    subscription.cancel();
    receivedDataSubscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    // _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.deviceType.toString().substring(11).toUpperCase() ==
    //     'ADVERTISER') {
    //   _title = '하이파이브 요청 중!';
    // } else {
    //   _title = '내 친구들은 어디에?';
    // }
    bool isInviteShowing = false;
    return Scaffold(
      appBar: AppBar(
        title: ShakeDetectWrap(
            onShake: () {
              if (devices.isEmpty) {
                Navigator.pushNamed(context, 'advertiser');
                if (!isInviteShowing) {
                  isInviteShowing = true;
                  Dialogs.materialDialog(
                    color: Colors.white,
                    msg: '주변 친구에게 하이파이브를 시도하고 있어요!',
                    title: '하이파이브 요청 중!',
                    lottieBuilder: Lottie.asset(
                      'assets/lottie/hand.json',
                      fit: BoxFit.contain,
                    ),
                    dialogWidth: kIsWeb ? 0.3 : null,
                    context: context,
                    onClose: (_) {
                      isInviteShowing = false;
                    },
                  );
                }
              } else {
                log('there is device');
              }
            },
            // child: Text(_title)), //"${getItemCount()}"
            child: const Text('핸드폰을 흔들어보아요!')),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: children_light,
        child: Center(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: getItemCount(),
              itemBuilder: (context, index) {
                final device = widget.deviceType == DeviceType.advertiser
                    ? connectedDevices[index]
                    : devices[index];
                return Container(
                  color: children_light,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "하이파이브 요청!",
                        style: kMediumText,
                      ),
                      Text(
                        "내 친구 ${device.deviceName}로 부터", //
                        style: kSmallText,
                      ),
                      const Image(
                        image: AssetImage('assets/images/high_touch.png'),
                        height: 350,
                      ),
                      const Text(
                        "흔들어서 하이파이브!",
                        style: kSmallText,
                      ),
                      // Text(
                      //   getStateName(device.state),
                      //   style: TextStyle(
                      //     color: getStateColor(device.state),
                      //   ),
                      // ),
                      ShakeDetectWrap(
                        // Request connect
                        onShake: () => _onButtonClicked(device),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8.0),
                          padding: const EdgeInsets.all(8.0),
                          height: 35,
                          width: 100,
                          color: getButtonColor(device.state),
                          child: Center(
                            child: Text(
                              getButtonStateName(device.state),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  String getStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return "disconnected";
      case SessionState.connecting:
        return "waiting";
      default:
        return "connected";
    }
  }

  String getButtonStateName(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return "Connect";
      default:
        return "Disconnect";
    }
  }

  Color getStateColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
        return Colors.black;
      case SessionState.connecting:
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  Color getButtonColor(SessionState state) {
    switch (state) {
      case SessionState.notConnected:
      case SessionState.connecting:
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  // _onTabItemListener(Device device) {
  //   if (device.state == SessionState.connected) {
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           final myController = TextEditingController();
  //           return AlertDialog(
  //             title: const Text("Send message"),
  //             content: TextField(controller: myController),
  //             actions: [
  //               TextButton(
  //                 child: const Text("Cancel"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //               TextButton(
  //                 child: const Text("Send"),
  //                 onPressed: () {
  //                   nearbyService.sendMessage(
  //                       device.deviceId, myController.text);
  //                   myController.text = '';
  //                 },
  //               )
  //             ],
  //           );
  //         });
  //   }
  // }

  int getItemCount() {
    if (widget.deviceType == DeviceType.advertiser) {
      return connectedDevices.length;
    } else {
      return devices.length;
    }
  }

  _onButtonClicked(Device device) {
    switch (device.state) {
      case SessionState.notConnected:
        nearbyService.invitePeer(
          deviceID: device.deviceId,
          deviceName: device.deviceName,
        );
        break;
      case SessionState.connected:
        break;
      case SessionState.connecting:
        break;
    }
  }

  void init() async {
    nearbyService = NearbyService();
    String devInfo = '';
    FirebaseApi firebaseApi = FirebaseApi();
    await firebaseApi.initNotifications(); // 토큰을 초기화하고 기다립니다.
    String devToken = firebaseApi.fCMToken; // 초기화된 토큰을 가져옵니다.
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      devInfo = androidInfo.model;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      devInfo = iosInfo.localizedModel;
    }
    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: devInfo,
        strategy: Strategy.P2P_CLUSTER,
        callback: (isRunning) async {
          if (isRunning) {
            if (widget.deviceType == DeviceType.browser) {
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(const Duration(microseconds: 200));
              await nearbyService.startBrowsingForPeers();
            } else {
              await nearbyService.stopAdvertisingPeer();
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(const Duration(microseconds: 200));
              await nearbyService.startAdvertisingPeer();
              await nearbyService.startBrowsingForPeers();
            }
          }
        });

    bool isDialogShowing = false;
    subscription =
        nearbyService.stateChangedSubscription(callback: (devicesList) async {
      for (var element in devicesList) {
        print(
            "deviceId: ${element.deviceId} | deviceName: ${element.deviceName} | state: ${element.state}");

        if (Platform.isAndroid) {
          if (element.state == SessionState.connected) {
            nearbyService.stopBrowsingForPeers();
            Vibration.vibrate(duration: 1000);
            if (!isDialogShowing) {
              isDialogShowing = true;
              Dialogs.materialDialog(
                  color: Colors.white,
                  msg: '하이파이브 성공!',
                  title: '친구와 하이파이브에 성공했어요!',
                  lottieBuilder: Lottie.asset(
                    'assets/lottie/highfive.json',
                    fit: BoxFit.contain,
                  ),
                  dialogWidth: kIsWeb ? 0.3 : null,
                  context: context,
                  onClose: (_) {
                    isDialogShowing = false;
                  });
              String token = devToken;
              Token userToken = await sendAlert(token, context);
            }

            Navigator.of(context).popUntil((route) => route.isFirst);
            print("My token is $devToken");
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {
                devices.clear();
                devicesList.clear();
                connectedDevices.clear();
                init();
              });
            });
          } else {
            nearbyService.startBrowsingForPeers();
          }
        }
      }
      setState(() {
        devices.clear();
        devices.addAll(devicesList);
        connectedDevices.clear();
        connectedDevices.addAll(devicesList
            .where((d) => d.state == SessionState.connected)
            .toList());
      });
    });

    receivedDataSubscription =
        nearbyService.dataReceivedSubscription(callback: (data) {
      print("dataReceivedSubscription: ${jsonEncode(data)}");
      showToast(jsonEncode(data),
          context: context,
          axis: Axis.horizontal,
          alignment: Alignment.center,
          position: StyledToastPosition.bottom);
    });
  }
}
