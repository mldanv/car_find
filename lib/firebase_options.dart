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
    apiKey: 'AIzaSyBG_qH4Rkq6P9pXUFMeJHtvxwVTWcIpvUU',
    appId: '1:278603931501:web:0ca781bcf48e2cbc324464',
    messagingSenderId: '278603931501',
    projectId: 'car-find-f0681',
    authDomain: 'car-find-f0681.firebaseapp.com',
    databaseURL: 'https://car-find-f0681-default-rtdb.firebaseio.com',
    storageBucket: 'car-find-f0681.appspot.com',
    measurementId: 'G-XTLLEWW0X2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBmNcZcvNqfBTf_GhwMxJv9ysQFWYhAJA',
    appId: '1:278603931501:android:1e9e2a60a759e7d4324464',
    messagingSenderId: '278603931501',
    projectId: 'car-find-f0681',
    databaseURL: 'https://car-find-f0681-default-rtdb.firebaseio.com',
    storageBucket: 'car-find-f0681.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKbuA3GtaDMG8-yfHP_pPPJgjGOKbwNqU',
    appId: '1:278603931501:ios:1033725fbf88e4ca324464',
    messagingSenderId: '278603931501',
    projectId: 'car-find-f0681',
    databaseURL: 'https://car-find-f0681-default-rtdb.firebaseio.com',
    storageBucket: 'car-find-f0681.appspot.com',
    iosBundleId: 'com.example.carFind',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKbuA3GtaDMG8-yfHP_pPPJgjGOKbwNqU',
    appId: '1:278603931501:ios:1033725fbf88e4ca324464',
    messagingSenderId: '278603931501',
    projectId: 'car-find-f0681',
    databaseURL: 'https://car-find-f0681-default-rtdb.firebaseio.com',
    storageBucket: 'car-find-f0681.appspot.com',
    iosBundleId: 'com.example.carFind',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBG_qH4Rkq6P9pXUFMeJHtvxwVTWcIpvUU',
    appId: '1:278603931501:web:42a5ec01b2ce40d4324464',
    messagingSenderId: '278603931501',
    projectId: 'car-find-f0681',
    authDomain: 'car-find-f0681.firebaseapp.com',
    databaseURL: 'https://car-find-f0681-default-rtdb.firebaseio.com',
    storageBucket: 'car-find-f0681.appspot.com',
    measurementId: 'G-6RCFJZW9GH',
  );
}