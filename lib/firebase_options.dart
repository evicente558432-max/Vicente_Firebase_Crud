
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'Firebase has not been configured for Linux.',
        );
      default:
        throw UnsupportedError(
          'This platform is not supported.',
        );
    }
  }

  // ANDROID CONFIGURATION
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFr2jaf4zf-0x6TT1IJMfdV0kJj2t56ro',
    appId: '1:969510736826:android:f5c5244262ac9147dd0383',
    messagingSenderId: '969510736826',
    projectId: 'notes-f3585',
    storageBucket: 'notes-f3585.firebasestorage.app',
  );

  // WEB CONFIGURATION
  // Register a Web app in Firebase Console to get these values.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: '969510736826',
    projectId: 'notes-f3585',
    authDomain: 'notes-f3585.firebaseapp.com',
    storageBucket: 'notes-f3585.firebasestorage.app',
  );

  // IOS CONFIGURATION
  // Register an iOS app to get the correct values.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '969510736826',
    projectId: 'notes-f3585',
    storageBucket: 'notes-f3585.firebasestorage.app',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );

  // MACOS CONFIGURATION
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: '969510736826',
    projectId: 'notes-f3585',
    storageBucket: 'notes-f3585.firebasestorage.app',
  );

  // WINDOWS CONFIGURATION
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WINDOWS_APP_ID',
    messagingSenderId: '969510736826',
    projectId: 'notes-f3585',
    authDomain: 'notes-f3585.firebaseapp.com',
    storageBucket: 'notes-f3585.firebasestorage.app',
  );
}
