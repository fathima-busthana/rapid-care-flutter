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
    apiKey: 'AIzaSyBxywp6LdR5L9Hl_TJgNGD_-hDjPuY9apo',
    appId: '1:57618775650:web:1ad6fca1da45c7bf695b3b',
    messagingSenderId: '57618775650',
    projectId: 'flutter-notify-main-project',
    authDomain: 'flutter-notify-main-project.firebaseapp.com',
    databaseURL: 'https://flutter-notify-main-project-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-notify-main-project.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0yk3-hJapGOc-Ax4YzULGiqjIlc85YRw',
    appId: '1:57618775650:android:f698177d9b414779695b3b',
    messagingSenderId: '57618775650',
    projectId: 'flutter-notify-main-project',
    databaseURL: 'https://flutter-notify-main-project-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-notify-main-project.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJx7u3MlTqU5QISqtfrQxMOL7_gNJcOQU',
    appId: '1:57618775650:ios:b27819b5b74812a6695b3b',
    messagingSenderId: '57618775650',
    projectId: 'flutter-notify-main-project',
    databaseURL: 'https://flutter-notify-main-project-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-notify-main-project.firebasestorage.app',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJx7u3MlTqU5QISqtfrQxMOL7_gNJcOQU',
    appId: '1:57618775650:ios:b27819b5b74812a6695b3b',
    messagingSenderId: '57618775650',
    projectId: 'flutter-notify-main-project',
    databaseURL: 'https://flutter-notify-main-project-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-notify-main-project.firebasestorage.app',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBxywp6LdR5L9Hl_TJgNGD_-hDjPuY9apo',
    appId: '1:57618775650:web:2d38cc9cef7337e9695b3b',
    messagingSenderId: '57618775650',
    projectId: 'flutter-notify-main-project',
    authDomain: 'flutter-notify-main-project.firebaseapp.com',
    databaseURL: 'https://flutter-notify-main-project-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-notify-main-project.firebasestorage.app',
  );
}
