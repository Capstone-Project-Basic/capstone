// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDHBtzueQ1ashd5Vu1qpYCLG0mPhKC-fqs',
    appId: '1:795397625032:web:99f2f57000e7585f2d81fd',
    messagingSenderId: '795397625032',
    projectId: 'pocket-teacher-1b526',
    authDomain: 'pocket-teacher-1b526.firebaseapp.com',
    storageBucket: 'pocket-teacher-1b526.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCtBXxwucM9GAmphhMPMgHEF2AnKOKXa4k',
    appId: '1:795397625032:android:f19589ee2e5119202d81fd',
    messagingSenderId: '795397625032',
    projectId: 'pocket-teacher-1b526',
    storageBucket: 'pocket-teacher-1b526.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCubmATzbictXPWgKzZpXas2pEX5f7gcxk',
    appId: '1:795397625032:ios:de6a3c04f86c11152d81fd',
    messagingSenderId: '795397625032',
    projectId: 'pocket-teacher-1b526',
    storageBucket: 'pocket-teacher-1b526.appspot.com',
    iosBundleId: 'com.example.pocektTeacher',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCubmATzbictXPWgKzZpXas2pEX5f7gcxk',
    appId: '1:795397625032:ios:de6a3c04f86c11152d81fd',
    messagingSenderId: '795397625032',
    projectId: 'pocket-teacher-1b526',
    storageBucket: 'pocket-teacher-1b526.appspot.com',
    iosBundleId: 'com.example.pocektTeacher',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDHBtzueQ1ashd5Vu1qpYCLG0mPhKC-fqs',
    appId: '1:795397625032:web:15ab2c855b43c2822d81fd',
    messagingSenderId: '795397625032',
    projectId: 'pocket-teacher-1b526',
    authDomain: 'pocket-teacher-1b526.firebaseapp.com',
    storageBucket: 'pocket-teacher-1b526.appspot.com',
  );
}