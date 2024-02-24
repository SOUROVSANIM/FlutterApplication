// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAm3JEbbCDfvHy0_R0KtUG9Iv6Xyv6b_Kc',
    appId: '1:64901008194:web:92c57f39fa57a6fdcad6db',
    messagingSenderId: '64901008194',
    projectId: 'flutterapplication1-945e0',
    authDomain: 'flutterapplication1-945e0.firebaseapp.com',
    databaseURL: 'https://flutterapplication1-945e0-default-rtdb.firebaseio.com',
    storageBucket: 'flutterapplication1-945e0.appspot.com',
    measurementId: 'G-C58YQMB1PB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDoU9G5qWcFDcXp-jYr5bi4IUPgMUI85bQ',
    appId: '1:64901008194:android:b36493071ffb3957cad6db',
    messagingSenderId: '64901008194',
    projectId: 'flutterapplication1-945e0',
    databaseURL: 'https://flutterapplication1-945e0-default-rtdb.firebaseio.com',
    storageBucket: 'flutterapplication1-945e0.appspot.com',
  );
}
