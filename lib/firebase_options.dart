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
    apiKey: 'AIzaSyB65SdZ8ocjIz0U6drcR2wZ5bJxIeX2kfs',
    appId: '1:880129103791:web:a70e3897517eed095bc15a',
    messagingSenderId: '880129103791',
    projectId: 'lorema-d6513',
    authDomain: 'lorema-d6513.firebaseapp.com',
    storageBucket: 'lorema-d6513.appspot.com',
    measurementId: 'G-LMF1QM1DZ3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgUC-SGzwpfqhgkmfAkdFTyXfKbD3Bvdg',
    appId: '1:880129103791:android:635a37fd2909cea35bc15a',
    messagingSenderId: '880129103791',
    projectId: 'lorema-d6513',
    storageBucket: 'lorema-d6513.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDSqqwdweC2n20Msd_7sV-TeceEvAIXTWw',
    appId: '1:880129103791:ios:26c8fef2a664acd85bc15a',
    messagingSenderId: '880129103791',
    projectId: 'lorema-d6513',
    storageBucket: 'lorema-d6513.appspot.com',
    androidClientId: '880129103791-nedshv731g64r037c0vmlm55dv8opqf9.apps.googleusercontent.com',
    iosClientId: '880129103791-feu0l2irds10f2rtm1clk9fui0hkeugp.apps.googleusercontent.com',
    iosBundleId: 'com.example.loremaAd',
  );
}
