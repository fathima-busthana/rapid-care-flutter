import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/login_page.dart';
import 'firebase_options.dart';
import 'home_screen.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency Response App',
      home: HomeScreen(),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:project/login_page.dart';
// import 'firebase_options.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:sensors_plus/sensors_plus.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // ✅ Initialize the background service
//   await initializeService();

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Emergency Response App',
//       home: const LoginPage(),
//     );
//   }
// }

// /// ✅ Background Service Initialization
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();

//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       autoStart: true,
//       isForegroundMode: true, // Keeps service active in the foreground
//       notificationChannelId: 'emergency_service', // ✅ Required for notifications
//       initialNotificationTitle: "🚑 Emergency Monitoring Active",
//       initialNotificationContent: "Your movement is being monitored for accidents.",
//     ),
//     iosConfiguration: IosConfiguration(
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//   );

//   service.startService();
// }

// /// ✅ iOS Background Task
// bool onIosBackground(ServiceInstance service) {
//   return true; // Keep the service running in the background
// }

// /// 🚑 Accident Detection Logic in Background
// void onStart(ServiceInstance service) async {
//   if (service is AndroidServiceInstance) {
//     service.setAsForegroundService(); // ✅ Keeps service alive in background
    
//     service.setForegroundNotificationInfo( // ✅ Updated method for showing notification
//       title: "🚑 Emergency Detection Running",
//       content: "Monitoring your movements for accidents...",
//     );
//   }

//   // ✅ Listen to accelerometer data for accident detection
//   accelerometerEvents.listen((event) {
//     double acceleration = (event.x * event.x) + (event.y * event.y) + (event.z * event.z);

//     if (acceleration > 50) { // 🚨 Adjust threshold for accident detection
//       print("🚨 Accident detected!");

//       // ✅ Show alert if app is in foreground
//       service.invoke("show_alert", {"message": "🚨 Possible accident detected!"});

//       // ✅ Future feature: Send SMS, API call, or push notification
//     }
//   });
// }

  

