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
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyBX8Pgy_m8INLj0YpKwh9eK2dtqX0B1ewk',
    appId: '1:532133351694:web:3439832ac5b1b61784c75f',
    messagingSenderId: '532133351694',
    projectId: 'restaurant-app-31f2f',
    authDomain: 'restaurant-app-31f2f.firebaseapp.com',
    storageBucket: 'restaurant-app-31f2f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDK0wrR0Ea6KTwpXYncFxRBpdgXPZjPxc',
    appId: '1:532133351694:android:aa0afec07c34281d84c75f',
    messagingSenderId: '532133351694',
    projectId: 'restaurant-app-31f2f',
    storageBucket: 'restaurant-app-31f2f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBb4RRIAb0dOQmHi4qDaYywvzGX2KXE5j0',
    appId: '1:532133351694:ios:7c62d7c1ed04d3bf84c75f',
    messagingSenderId: '532133351694',
    projectId: 'restaurant-app-31f2f',
    storageBucket: 'restaurant-app-31f2f.appspot.com',
    iosBundleId: 'com.example.restaurantApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBb4RRIAb0dOQmHi4qDaYywvzGX2KXE5j0',
    appId: '1:532133351694:ios:b8bb3b07c56c492584c75f',
    messagingSenderId: '532133351694',
    projectId: 'restaurant-app-31f2f',
    storageBucket: 'restaurant-app-31f2f.appspot.com',
    iosBundleId: 'com.example.restaurantApp.RunnerTests',
  );
}
