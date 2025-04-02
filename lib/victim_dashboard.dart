// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';

// class VictimDashboard extends StatefulWidget {
//   const VictimDashboard({super.key});

//   @override
//   _VictimDashboardState createState() => _VictimDashboardState();
// }

// class _VictimDashboardState extends State<VictimDashboard> {
//   double accelX = 0, accelY = 0, accelZ = 0;
//   double gyroX = 0, gyroY = 0, gyroZ = 0;
//   bool accidentDetected = false;
//   Timer? _responseTimer;

//   @override
//   void initState() {
//     super.initState();

//     /// Listen to Accelerometer Data
//     accelerometerEvents.listen((event) {
//       setState(() {
//         accelX = event.x;
//         accelY = event.y;
//         accelZ = event.z;
//       });

//       detectAccident();
//     });

//     /// Listen to Gyroscope Data
//     gyroscopeEvents.listen((event) {
//       setState(() {
//         gyroX = event.x;
//         gyroY = event.y;
//         gyroZ = event.z;
//       });

//       detectAccident();
//     });
//   }

//   /// ✅ Function to Detect Accident
//   void detectAccident() {
//     double accelerationMagnitude =
//         sqrt(accelX * accelX + accelY * accelY + accelZ * accelZ);

//     /// ✔ Threshold Values for Accident Detection
//     if (accelerationMagnitude > 15 || // High impact detection
//         gyroX.abs() > 5 ||
//         gyroY.abs() > 5 ||
//         gyroZ.abs() > 5) {
//       if (!accidentDetected) {
//         setState(() {
//           accidentDetected = true;
//         });

//         /// Show Alert Dialog
//         showAccidentDialog();

//         /// Automatically close accident detection after 3 seconds
//         Future.delayed(const Duration(seconds: 3), () {
//           setState(() {
//             accidentDetected = false;
//           });
//         });
//       }
//     }
//   }

//   /// ✅ Function to Show Accident Dialog (No SMS)
//   void showAccidentDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text("🚨 Accident Detected"),
//         content: const Text("Are you okay? Do you need help?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _responseTimer?.cancel(); // Cancel the timer if user responds
//             },
//             child: const Text("Yes, I'm fine"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // You can add navigation to help/support here
//             },
//             child: const Text("No, I Need Help"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Victim Dashboard")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Accelerometer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("X: ${accelX.toStringAsFixed(2)}"),
//             Text("Y: ${accelY.toStringAsFixed(2)}"),
//             Text("Z: ${accelZ.toStringAsFixed(2)}"),
//             const SizedBox(height: 20),
//             const Text("Gyroscope", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Text("X: ${gyroX.toStringAsFixed(2)}"),
//             Text("Y: ${gyroY.toStringAsFixed(2)}"),
//             Text("Z: ${gyroZ.toStringAsFixed(2)}"),
//             const SizedBox(height: 30),
//             accidentDetected
//                 ? const Text("⚠️ Accident Detected!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red))
//                 : const Text("No Accident Detected", style: TextStyle(fontSize: 18, color: Colors.green)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

// /// ✅ Twilio Credentials
// const String accountSid = "AC5fe0b1b3e38146e9a3b2e92e96773850";
// const String authToken = "cf85d34c06f19d6d862df21c11c576df";
// const String twilioNumber = "+19897839571";
// const String toNumber = "+91 8086248944";  // ✅ Number to receive SMS

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late TwilioFlutter twilioFlutter;
//   bool alertShown = false;
//   Position? currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );

//     /// ✅ Continuously listen for sensor changes
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     /// ✅ Fetch Location when app starts
//     _getCurrentLocation();
//   }

//   /// ✅ Function to Detect Accident Based on Sensor Values
//   bool _detectAccident(double x, double y, double z) {
//     // Adjust these threshold values for accident detection
//     double threshold = 20.0;

//     if (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold) {
//       print("🚨 Accident Detected!");
//       return true;
//     }
//     return false;
//   }

//   /// ✅ Function to Fetch Current Location
//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   /// ✅ Function to Automatically Send SMS Via Twilio
//   void _sendSms() async {
//     String locationUrl =
//         "https://www.google.com/maps/search/?api=1&query=${currentPosition?.latitude},${currentPosition?.longitude}";

//     try {
//       await twilioFlutter.sendSMS(
//         toNumber: toNumber,
//         messageBody:
//             "🚨 Emergency Alert! Possible Accident Detected!\n\n"
//             "Live Location: $locationUrl\n"
//             "Please send help immediately!",
//       );
//       print("✅ SMS Sent Successfully with Location");
//     } catch (e) {
//       print("❌ Failed to send SMS: $e");
//     }
//   }

//   /// ✅ Function to Automatically Call Ambulance (108)
//   void _callAmbulance() async {
//     String emergencyNumber = "tel:108";
//     if (await canLaunchUrl(Uri.parse(emergencyNumber))) {
//       await launchUrl(Uri.parse(emergencyNumber));
//     } else {
//       print("❌ Failed to call 108");
//     }
//   }

//   /// ✅ Function to Show Emergency Alert Dialog
//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendSms();
//                 _callAmbulance();
//               },
//             ),
//           ],
//         );
//       },
//     );

//     /// ✅ If no response within 20 seconds, send help automatically
//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendSms();
//         _callAmbulance();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("🚨 Accident Detection System"),
//       ),
//       body: Center(
//         child: Text("Monitoring Sensor Data..."),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dashboard.dart'; // Importing the dashboard page

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;

//   @override
//   void initState() {
//     super.initState();

//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Future: Add emergency alert function here
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         // Future: Add automatic alert function here
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚨 Accident Detection System")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Monitoring Sensor Data..."),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (context) => BloodRequestPage()));
//               },
//               child: Text("Go to Dashboard"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; // Import your dashboard page

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'YOUR_ACCOUNT_SID',  // Replace with your Twilio Account SID
//       authToken: 'YOUR_AUTH_TOKEN',    // Replace with your Twilio Auth Token
//       twilioNumber: 'YOUR_TWILIO_PHONE', // Replace with your Twilio phone number
//     );

//     // Listen for accelerometer changes
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage(); // Send alert message with location
//                 _makeEmergencyCall(); // Make emergency call
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚨 Accident Detection System")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Monitoring Sensor Data..."),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _sendEmergencyMessage,
//               child: Text("Send Test Alert"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => BloodRequestPage()));
//               },
//               child: Text("Go to Dashboard"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; // Import your dashboard page
// import 'book_ambulance.dart'; // Import the new ambulance booking page

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'YOUR_ACCOUNT_SID',  // Replace with your Twilio Account SID
//       authToken: 'YOUR_AUTH_TOKEN',    // Replace with your Twilio Auth Token
//       twilioNumber: 'YOUR_TWILIO_PHONE', // Replace with your Twilio phone number
//     );

//     // Listen for accelerometer changes
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage(); // Send alert message with location
//                 _makeEmergencyCall(); // Make emergency call
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚨 Accident Detection System")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Monitoring Sensor Data..."),
//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _sendEmergencyMessage,
//               child: Text("Send Test Alert"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) =>  BloodDonorListPage(bloodGroup: '',)),
//                 );
//               },
//               child: Text("Go to Dashboard"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BookAmbulancePage()),
//                 );
//               },
//               child: Text("🚑 Book Ambulance"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; // Import your dashboard page
// import 'book_ambulance.dart'; // Import the ambulance booking page
// import 'booking_status.dart'; // Import the booking status page

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'YOUR_ACCOUNT_SID',  // Replace with your Twilio Account SID
//       authToken: 'YOUR_AUTH_TOKEN',    // Replace with your Twilio Auth Token
//       twilioNumber: 'YOUR_TWILIO_PHONE', // Replace with your Twilio phone number
//     );

//     // Listen for accelerometer changes
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage(); // Send alert message with location
//                 _makeEmergencyCall(); // Make emergency call
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     String userId = FirebaseAuth.instance.currentUser?.uid ?? "unknown_user"; // Get the current user ID

//     return Scaffold(
//       appBar: AppBar(title: Text("🚨 Accident Detection System")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Monitoring Sensor Data..."),
//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _sendEmergencyMessage,
//               child: Text("Send Test Alert"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BloodDonorListPage(bloodGroup: '')),
//                 );
//               },
//               child: Text("Go to Dashboard"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BookAmbulancePage()),
//                 );
//               },
//               child: Text("🚑 Book Ambulance"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BookingStatusPage(userId: userId)), // Pass the user ID
//                 );
//               },
//               child: Text("📌 View Booking Status"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; // Import your dashboard page
// import 'book_ambulance.dart'; // Import the ambulance booking page
// import 'booking_status.dart'; // Import the booking status page

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser; // Store user info

//   @override
//   void initState() {
//     super.initState();
    
//     // Listen for authentication state changes
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       setState(() {
//         currentUser = user;
//       });
//     });

//     // Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'YOUR_ACCOUNT_SID',  // Replace with your Twilio Account SID
//       authToken: 'YOUR_AUTH_TOKEN',    // Replace with your Twilio Auth Token
//       twilioNumber: 'YOUR_TWILIO_PHONE', // Replace with your Twilio phone number
//     );

//     // Listen for accelerometer changes
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage(); // Send alert message with location
//                 _makeEmergencyCall(); // Make emergency call
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚨 Accident Detection System")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Monitoring Sensor Data..."),
//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _sendEmergencyMessage,
//               child: Text("Send Test Alert"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BloodDonorListPage(bloodGroup: '')),
//                 );
//               },
//               child: Text("Go to Dashboard"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BookAmbulancePage()),
//                 );
//               },
//               child: Text("🚑 Book Ambulance"),
//             ),

//             SizedBox(height: 20),

//             if (currentUser != null) // Only show if the user is logged in
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BookingStatusPage(userId: currentUser!.uid),
//                     ),
//                   );
//                 },
//                 child: Text("📌 View Booking Status"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; // Import your dashboard page
// import 'book_ambulance.dart'; // Import the ambulance booking page
// import 'booking_status.dart'; // Import the booking status page

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser; // Store user info

//   @override
//   void initState() {
//     super.initState();
    
//     // Listen for authentication state changes
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       setState(() {
//         currentUser = user;
//       });
//     });

//     // Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'YOUR_ACCOUNT_SID',  // Replace with your Twilio Account SID
//       authToken: 'YOUR_AUTH_TOKEN',    // Replace with your Twilio Auth Token
//       twilioNumber: 'YOUR_TWILIO_PHONE', // Replace with your Twilio phone number
//     );

//     // Listen for accelerometer changes
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage(); // Send alert message with location
//                 _makeEmergencyCall(); // Make emergency call
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   void _signOut() async {
//     await FirebaseAuth.instance.signOut();
//     setState(() {
//       currentUser = null;
//     });
//     // Redirect user to login page (Replace with your actual login page)
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => MyHomePage()), // Change to LoginPage if available
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("🚨 Accident Detection System"),
//         actions: [
//           if (currentUser != null)
//             IconButton(
//               icon: Icon(Icons.logout),
//               onPressed: _signOut,
//               tooltip: "Sign Out",
//             ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Monitoring Sensor Data..."),
//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _sendEmergencyMessage,
//               child: Text("Send Test Alert"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BloodDonorListPage(bloodGroup: '')),
//                 );
//               },
//               child: Text("Go to Dashboard"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BookAmbulancePage()),
//                 );
//               },
//               child: Text("🚑 Book Ambulance"),
//             ),

//             SizedBox(height: 20),

//             if (currentUser != null) // Only show if the user is logged in
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BookingStatusPage(userId: currentUser!.uid),
//                     ),
//                   );
//                 },
//                 child: Text("📌 View Booking Status"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:project/login_page.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; // Import your dashboard page
// import 'book_ambulance.dart'; // Import the ambulance booking page

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser; // Store user info

//   @override
//   void initState() {
//     super.initState();

//     // Get current user at start
//     currentUser = FirebaseAuth.instance.currentUser;

//     // Listen for authentication state changes
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (mounted) {
//         setState(() {
//           currentUser = user;
//         });
//       }
//     });

//     // Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'YOUR_ACCOUNT_SID',  // Replace with your Twilio Account SID
//       authToken: 'YOUR_AUTH_TOKEN',    // Replace with your Twilio Auth Token
//       twilioNumber: 'YOUR_TWILIO_PHONE', // Replace with your Twilio phone number
//     );

//     // Listen for accelerometer changes
//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX", // Replace with emergency contact number
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage(); // Send alert message with location
//                 _makeEmergencyCall(); // Make emergency call
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   void _signOut() async {
//     await FirebaseAuth.instance.signOut();

//     // Delay setState to ensure user data is not lost before navigation
//     Future.delayed(Duration(milliseconds: 200), () {
//       if (mounted) {
//         setState(() {
//           currentUser = null;
//         });
//       }
//     });

//     // Redirect user to login page (Replace with your actual login page)
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()), // Change to LoginPage if available
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("🚨 Accident Detection System"),
//         actions: [
//           if (currentUser != null)
//             IconButton(
//               icon: Icon(Icons.logout),
//               onPressed: _signOut,
//               tooltip: "Sign Out",
//             ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Monitoring Sensor Data..."),
//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _sendEmergencyMessage,
//               child: Text("Send Test Alert"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BloodDonorListPage(bloodGroup: '')),
//                 ).then((_) => setState(() {})); // Ensure state rebuild after returning
//               },
//               child: Text("Go to Dashboard"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BookAmbulancePage()),
//                 ).then((_) => setState(() {})); // Ensure state rebuild after returning
//               },
//               child: Text("🚑 Book Ambulance"),
//             ),

//             SizedBox(height: 20),

//             if (currentUser != null) // Only show if the user is logged in
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BookingStatusPage(),
//                     ),
//                   ).then((_) => setState(() {})); // Ensure state rebuild after returning
//                 },
//                 child: Text("📌 View Booking Status"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:project/login_page.dart';
// import 'package:project/donate_blood.dart'; // Import the Donate Blood page
// import 'package:project/request_blood.dart'; // Import the Request Blood page
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; 
// import 'book_ambulance.dart'; 

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();

//     currentUser = FirebaseAuth.instance.currentUser;

//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (mounted) {
//         setState(() {
//           currentUser = user;
//         });
//       }
//     });

//     twilioFlutter = TwilioFlutter(
//       accountSid: 'YOUR_ACCOUNT_SID',
//       authToken: 'YOUR_AUTH_TOKEN',
//       twilioNumber: 'YOUR_TWILIO_PHONE',
//     );

//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX",
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX",
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage();
//                 _makeEmergencyCall();
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   void _signOut() async {
//     await FirebaseAuth.instance.signOut();

//     Future.delayed(Duration(milliseconds: 200), () {
//       if (mounted) {
//         setState(() {
//           currentUser = null;
//         });
//       }
//     });

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("🚨 Accident Detection System"),
//         actions: [
//           if (currentUser != null)
//             IconButton(
//               icon: Icon(Icons.logout),
//               onPressed: _signOut,
//               tooltip: "Sign Out",
//             ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Monitoring Sensor Data..."),
//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: _sendEmergencyMessage,
//               child: Text("Send Test Alert"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BloodDonorListPage(bloodGroup: '')),
//                 ).then((_) => setState(() {}));
//               },
//               child: Text("Go to Dashboard"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BookAmbulancePage()),
//                 ).then((_) => setState(() {}));
//               },
//               child: Text("🚑 Book Ambulance"),
//             ),

//             SizedBox(height: 20),

//             if (currentUser != null)
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BookingStatusPage(),
//                     ),
//                   ).then((_) => setState(() {}));
//                 },
//                 child: Text("📌 View Booking Status"),
//               ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>  BloodDonorPage(),
//                   ),
//                 );
//               },
//               child: Text("💉 Donate Blood"),
//             ),

//             SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => RequestBloodPage(),
//                   ),
//                 );
//               },
//               child: Text("🩸 Request Blood"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:project/login_page.dart';
// import 'package:project/donate_blood.dart';
// import 'package:project/request_blood.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; 
// import 'book_ambulance.dart'; 

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();

//     currentUser = FirebaseAuth.instance.currentUser;

//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (mounted) {
//         setState(() {
//           currentUser = user;
//         });
//       }
//     });

//     twilioFlutter = TwilioFlutter(
//       accountSid: 'YOUR_ACCOUNT_SID',
//       authToken: 'YOUR_AUTH_TOKEN',
//       twilioNumber: 'YOUR_TWILIO_PHONE',
//     );

//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX",
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX",
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage();
//                 _makeEmergencyCall();
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   void _signOut() async {
//     await FirebaseAuth.instance.signOut();

//     Future.delayed(Duration(milliseconds: 200), () {
//       if (mounted) {
//         setState(() {
//           currentUser = null;
//         });
//       }
//     });

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("🚨 Accident Detection System"),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(Icons.account_circle, size: 80, color: Colors.white),
//                   SizedBox(height: 10),
//                   Text(
//                     currentUser != null ? currentUser!.email ?? "User" : "Guest",
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ],
//               ),
//             ),

//             ListTile(
//               leading: Icon(Icons.warning),
//               title: Text("Send Test Alert"),
//               onTap: () {
//                 _sendEmergencyMessage();
//                 Navigator.pop(context);
//               },
//             ),

//             ListTile(
//               leading: Icon(Icons.dashboard),
//               title: Text("Go to Dashboard"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BloodDonorListPage(bloodGroup: '')),
//                 );
//               },
//             ),

//             ListTile(
//               leading: Icon(Icons.local_hospital),
//               title: Text("🚑 Book Ambulance"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BookAmbulancePage()),
//                 );
//               },
//             ),

//             if (currentUser != null)
//               ListTile(
//                 leading: Icon(Icons.assignment),
//                 title: Text("📌 View Booking Status"),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => BookingStatusPage()),
//                   );
//                 },
//               ),

//             ListTile(
//               leading: Icon(Icons.bloodtype),
//               title: Text("💉 Donate Blood"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BloodDonorPage()),
//                 );
//               },
//             ),

//             ListTile(
//               leading: Icon(Icons.bloodtype_outlined),
//               title: Text("🩸 Request Blood"),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RequestBloodPage()),
//                 );
//               },
//             ),

//             if (currentUser != null)
//               ListTile(
//                 leading: Icon(Icons.logout),
//                 title: Text("Sign Out"),
//                 onTap: _signOut,
//               ),
//           ],
//         ),
//       ),
//       body: Center(
//         child: Text(
//           "📡 Monitoring Sensor Data...",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:project/login_page.dart';
// import 'package:project/donate_blood.dart';
// import 'package:project/request_blood.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; 
// import 'book_ambulance.dart'; 

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();

//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );

//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();

//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (mounted) {
//         setState(() {
//           currentUser = user;
//         });
//       }
//     });
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX",
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX",
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage();
//                 _makeEmergencyCall();
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   void _signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚨 Accident Detection System")),
//       drawer: AppDrawer(currentUser: currentUser, signOut: _signOut),
//       body: Center(
//         child: Text(
//           "📡 Monitoring Sensor Data...",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// /// **Persistent Drawer Widget**
// class AppDrawer extends StatelessWidget {
//   final User? currentUser;
//   final VoidCallback signOut;

//   const AppDrawer({Key? key, required this.currentUser, required this.signOut}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(Icons.account_circle, size: 80, color: Colors.white),
//                 SizedBox(height: 10),
//                 Text(
//                   currentUser != null ? currentUser!.email ?? "User" : "Guest",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ],
//             ),
//           ),

//           ListTile(
//             leading: Icon(Icons.warning),
//             title: Text("Send Test Alert"),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.dashboard),
//             title: Text("Go to Dashboard"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BloodDonorListPage(bloodGroup: '')));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.local_hospital),
//             title: Text("🚑 Book Ambulance"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BookAmbulancePage()));
//             },
//           ),

//           if (currentUser != null)
//             ListTile(
//               leading: Icon(Icons.assignment),
//               title: Text("📌 View Booking Status"),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => BookingStatusPage()));
//               },
//             ),

//           ListTile(
//             leading: Icon(Icons.bloodtype),
//             title: Text("💉 Donate Blood"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BloodDonorPage()));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.bloodtype_outlined),
//             title: Text("🩸 Request Blood"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => RequestBloodPage()));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text("Sign Out"),
//             onTap: () {
//               signOut();
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:project/login_page.dart';
// import 'package:project/donate_blood.dart';
// import 'package:project/request_blood.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:url_launcher/url_launcher.dart'; // To make emergency calls
// import 'dashboard.dart';
// import 'book_ambulance.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser;

//   double _accX = 0.0, _accY = 0.0, _accZ = 0.0;
//   double _gyroX = 0.0, _gyroY = 0.0, _gyroZ = 0.0;

//   @override
//   void initState() {
//     super.initState();

//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );

//     accelerometerEvents.listen((event) {
//       setState(() {
//         _accX = event.x;
//         _accY = event.y;
//         _accZ = event.z;
//       });

//       if (_detectAccident(event.x, event.y, event.z) && !alertShown) {
//         _showAlert();
//         alertShown = true;
//       }
//     });

//     gyroscopeEvents.listen((event) {
//       setState(() {
//         _gyroX = event.x;
//         _gyroY = event.y;
//         _gyroZ = event.z;
//       });
//     });

//     _getCurrentLocation();

//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (mounted) {
//         setState(() {
//           currentUser = user;
//         });
//       }
//     });
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX",
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() async {
//     final Uri phoneLaunchUri = Uri(scheme: 'tel', path: '108');
//     if (await canLaunchUrl(phoneLaunchUri)) {
//       await launchUrl(phoneLaunchUri);
//     } else {
//       print("❌ Could not launch phone call to 108.");
//     }
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage();
//                 _makeEmergencyCall();
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   void _signOut(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚨 Accident Detection System")),
//       drawer: AppDrawer(currentUser: currentUser, signOut: () => _signOut(context)),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("📡 Monitoring Sensor Data...",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             _buildSensorCard("📊 Accelerometer", _accX, _accY, _accZ),
//             SizedBox(height: 10),
//             _buildSensorCard("🔄 Gyroscope", _gyroX, _gyroY, _gyroZ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSensorCard(String title, double x, double y, double z) {
//     return Card(
//       elevation: 5,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Divider(),
//             Text("X: ${x.toStringAsFixed(2)}"),
//             Text("Y: ${y.toStringAsFixed(2)}"),
//             Text("Z: ${z.toStringAsFixed(2)}"),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AppDrawer extends StatelessWidget {
//   final User? currentUser;
//   final VoidCallback signOut;

//   const AppDrawer({Key? key, required this.currentUser, required this.signOut}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(Icons.account_circle, size: 80, color: Colors.white),
//                 SizedBox(height: 10),
//                 Text(currentUser != null ? currentUser!.email ?? "User" : "Guest",
//                     style: TextStyle(color: Colors.white, fontSize: 18)),
//               ],
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text("Sign Out"),
//             onTap: () => signOut(),
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:project/login_page.dart';
// import 'package:project/donate_blood.dart';
// import 'package:project/request_blood.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dashboard.dart'; 
// import 'book_ambulance.dart'; 

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();

//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );

//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();

//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (mounted) {
//         setState(() {
//           currentUser = user;
//         });
//       }
//     });
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX",
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX",
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage();
//                 _makeEmergencyCall();
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   void _signOut(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚨 Accident Detection System")),
//       drawer: AppDrawer(currentUser: currentUser, signOut: _signOut),
//       body: Center(
//         child: Text(
//           "📡 Monitoring Sensor Data...",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// /// **Persistent Drawer Widget**
// class AppDrawer extends StatelessWidget {
//   final User? currentUser;
//   final Function(BuildContext) signOut;

//   const AppDrawer({Key? key, required this.currentUser, required this.signOut}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(Icons.account_circle, size: 80, color: Colors.white),
//                 SizedBox(height: 10),
//                 Text(
//                   currentUser != null ? currentUser!.email ?? "User" : "Guest",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ],
//             ),
//           ),

//           ListTile(
//             leading: Icon(Icons.warning),
//             title: Text("Send Test Alert"),
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.dashboard),
//             title: Text("Go to Dashboard"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BloodDonorListPage(bloodGroup: '')));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.local_hospital),
//             title: Text("🚑 Book Ambulance"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BookAmbulancePage()));
//             },
//           ),

//           if (currentUser != null)
//             ListTile(
//               leading: Icon(Icons.assignment),
//               title: Text("📌 View Booking Status"),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => BookingStatusPage()));
//               },
//             ),

//           ListTile(
//             leading: Icon(Icons.bloodtype),
//             title: Text("💉 Donate Blood"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BloodDonorPage()));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.bloodtype_outlined),
//             title: Text("🩸 Request Blood"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => RequestBloodPage()));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text("Sign Out"),
//             onTap: () {
//               signOut(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/blood_donor_list.dart';
// import 'package:project/booking_status.dart';
// import 'package:project/login_page.dart';
// import 'package:project/donate_blood.dart';
// import 'package:project/request_blood.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'book_ambulance.dart'; 

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();

//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );

//     accelerometerEvents.listen((AccelerometerEvent event) {
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     _getCurrentLocation();

//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (mounted) {
//         setState(() {
//           currentUser = user;
//         });
//       }
//     });
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   void _sendEmergencyMessage() {
//     if (currentPosition != null) {
//       String googleMapsLink =
//           "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//       String message =
//           "🚨 EMERGENCY ALERT 🚨\n\n"
//           "An accident has been detected!\n"
//           "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//           "🔗 View on Maps: $googleMapsLink\n\n"
//           "Please send help immediately!";

//       twilioFlutter.sendSMS(
//         toNumber: "+91XXXXXXXXXX",
//         messageBody: message,
//       );

//       print("📩 Emergency message sent: $message");
//     } else {
//       print("❌ Location not available, cannot send message.");
//     }
//   }

//   void _makeEmergencyCall() {
//     twilioFlutter.sendSMS(
//       toNumber: "+91XXXXXXXXXX",
//       messageBody: "🚨 Accident detected! Please check immediately.",
//     );
//     print("📞 Calling emergency number...");
//   }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage();
//                 _makeEmergencyCall();
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   void _signOut(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚨 Accident Detection System")),
//       drawer: AppDrawer(currentUser: currentUser, signOut: _signOut),
//       body: Center(
//         child: Text(
//           "📡 Monitoring Sensor Data...",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }

// /// **Persistent Drawer Widget**
// class AppDrawer extends StatelessWidget {
//   final User? currentUser;
//   final Function(BuildContext) signOut;

//   const AppDrawer({Key? key, required this.currentUser, required this.signOut}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(Icons.account_circle, size: 80, color: Colors.white),
//                 SizedBox(height: 10),
//                 Text(
//                   currentUser != null ? currentUser!.email ?? "User" : "Guest",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ],
//             ),
//           ),

//           ListTile(
//             leading: Icon(Icons.local_hospital),
//             title: Text("🚑 Book Ambulance"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BookAmbulancePage()));
//             },
//           ),

//           if (currentUser != null)
//             ListTile(
//               leading: Icon(Icons.assignment),
//               title: Text("📌 View Booking Status"),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => BookingStatusPage()));
//               },
//             ),

//           ListTile(
//             leading: Icon(Icons.bloodtype),
//             title: Text("💉 Donate Blood"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BloodDonorPage()));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.bloodtype_outlined),
//             title: Text("🩸 Request Blood"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => RequestBloodPage()));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text("Sign Out"),
//             onTap: () {
//               signOut(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:project/booking_status.dart';
// import 'package:project/login_page.dart';
// import 'package:project/donate_blood.dart';
// import 'package:project/request_blood.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'book_ambulance.dart';
// const emergencyno = "+91 8086248944";

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   bool alertShown = false;
//   Position? currentPosition;
//   late TwilioFlutter twilioFlutter;
//   User? currentUser;

//   // Sensor data variables
//   double? accelerometerX = 0.0;
//   double? accelerometerY = 0.0;
//   double? accelerometerZ = 0.0;
//   double? gyroscopeX = 0.0;
//   double? gyroscopeY = 0.0;
//   double? gyroscopeZ = 0.0;

//   @override
//   void initState() {
//     super.initState();

//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );

//     accelerometerEvents.listen((AccelerometerEvent event) {
//       setState(() {
//         accelerometerX = event.x;
//         accelerometerY = event.y;
//         accelerometerZ = event.z;
//       });
//       if (_detectAccident(event.x, event.y, event.z)) {
//         if (!alertShown) {
//           _showAlert();
//           alertShown = true;
//         }
//       }
//     });

//     gyroscopeEvents.listen((GyroscopeEvent event) {
//       setState(() {
//         gyroscopeX = event.x;
//         gyroscopeY = event.y;
//         gyroscopeZ = event.z;
//       });
//     });

//     _getCurrentLocation();

//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (mounted) {
//         setState(() {
//           currentUser = user;
//         });
//       }
//     });
//   }

//   bool _detectAccident(double x, double y, double z) {
//     double threshold = 20.0;
//     return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
//   }

//   Future<void> _getCurrentLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       currentPosition = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       print("✅ Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}");
//     } else {
//       print("❌ Location permission denied");
//     }
//   }

//   // void _sendEmergencyMessage() {
//   //   if (currentPosition != null) {
//   //     String googleMapsLink =
//   //         "https://maps.google.com/?q=${currentPosition!.latitude},${currentPosition!.longitude}";

//   //     String message =
//   //         "🚨 EMERGENCY ALERT 🚨\n\n"
//   //         "An accident has been detected!\n"
//   //         "📍 Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}\n"
//   //         "🔗 View on Maps: $googleMapsLink\n\n"
//   //         "Please send help immediately!";

//   //     twilioFlutter.sendSMS(
//   //       toNumber: emergencyno,
//   //       messageBody: message,
//   //     );

//   //     print("📩 Emergency message sent: $message");
//   //   } else {
//   //     print("❌ Location not available, cannot send message.");
//   //   }
//   // }
//   void _sendEmergencyMessage() async {
//     String locationUrl =
//         "https://www.google.com/maps/search/?api=1&query=${currentPosition?.latitude},${currentPosition?.longitude}";

//     try {
//       await twilioFlutter.sendSMS(
//         toNumber: emergencyno,
//         messageBody:
//             "🚨 Emergency Alert! Possible Accident Detected!\n\n"
//             "Live Location: $locationUrl\n"
//             "Please send help immediately!",
//       );
//       print("✅ SMS Sent Successfully with Location");
//     } catch (e) {
//       print("❌ Failed to send SMS: $e");
//     }
//   }
//   void _makeEmergencyCall() async {
//   final Uri callUri = Uri(scheme: 'tel', path: '108'); // Emergency number 108
//   if (await canLaunch(callUri.toString())) {
//     await launch(callUri.toString());
//     print("📞 Calling emergency number 108...");
//   } else {
//     print("❌ Could not launch call.");
//   }
// }

//   // void _makeEmergencyCall() {
//   //   twilioFlutter.sendSMS(
//   //     toNumber: "+91XXXXXXXXXX",
//   //     messageBody: "🚨 Accident detected! Please check immediately.",
//   //   );
//   //   print("📞 Calling emergency number...");
//   // }

//   void _showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("🚨 Accident Detected"),
//           content: Text("Are you safe?"),
//           actions: [
//             TextButton(
//               child: Text("Yes, I'm Safe"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 alertShown = false;
//               },
//             ),
//             TextButton(
//               child: Text("No, Need Help"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _sendEmergencyMessage();
//                 _makeEmergencyCall();
//               },
//             ),
//           ],
//         );
//       },
//     );

//     Future.delayed(Duration(seconds: 20), () {
//       if (alertShown) {
//         print("⏳ No response within 20 seconds. Sending emergency alert.");
//         _sendEmergencyMessage();
//         _makeEmergencyCall();
//       }
//     });
//   }

//   void _signOut(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(" Accident Detection System")),
//       drawer: AppDrawer(currentUser: currentUser, signOut: _signOut),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "📡 Monitoring Sensor Data...",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             Card(
//               margin: EdgeInsets.all(15),
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Accelerometer Data:",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Text("X: ${accelerometerX?.toStringAsFixed(2)}"),
//                     Text("Y: ${accelerometerY?.toStringAsFixed(2)}"),
//                     Text("Z: ${accelerometerZ?.toStringAsFixed(2)}"),
//                   ],
//                 ),
//               ),
//             ),
//             Card(
//               margin: EdgeInsets.all(15),
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Gyroscope Data:",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 10),
//                     Text("X: ${gyroscopeX?.toStringAsFixed(2)}"),
//                     Text("Y: ${gyroscopeY?.toStringAsFixed(2)}"),
//                     Text("Z: ${gyroscopeZ?.toStringAsFixed(2)}"),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// **Persistent Drawer Widget**
// class AppDrawer extends StatelessWidget {
//   final User? currentUser;
//   final Function(BuildContext) signOut;

//   const AppDrawer({Key? key, required this.currentUser, required this.signOut}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(color: Colors.blue),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Icon(Icons.account_circle, size: 80, color: Colors.white),
//                 SizedBox(height: 10),
//                 Text(
//                   currentUser != null ? currentUser!.email ?? "User" : "Guest",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ],
//             ),
//           ),

//           ListTile(
//             leading: Icon(Icons.local_hospital),
//             title: Text(" Book Ambulance"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => BookAmbulancePage()));
//             },
//           ),

//           if (currentUser != null)
//             ListTile(
//               leading: Icon(Icons.assignment),
//               title: Text(" View Booking Status"),
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => BookingStatusPage()));
//               },
//             ),

//           ListTile(
//             leading: Icon(Icons.bloodtype),
//             title: Text(" Donate Blood"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => DonateBloodPage()));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.bloodtype_outlined),
//             title: Text(" Request Blood"),
//             onTap: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => RequestBloodPage()));
//             },
//           ),

//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text("Sign Out"),
//             onTap: () {
//               signOut(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/booking_status.dart';
import 'package:project/login_page.dart';
import 'package:project/donate_blood.dart';
import 'package:project/request_blood.dart';
import 'package:project/view_blood_requests.dart'; // ✅ Import new page
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'book_ambulance.dart';

const emergencyno = "+91 8086248944";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool alertShown = false;
  Position? currentPosition;
  late TwilioFlutter twilioFlutter;
  User? currentUser;

  // Sensor data variables
  double? accelerometerX = 0.0;
  double? accelerometerY = 0.0;
  double? accelerometerZ = 0.0;

  @override
  void initState() {
    super.initState();

    twilioFlutter = TwilioFlutter(
      accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
      authToken: 'cf85d34c06f19d6d862df21c11c576df',
      twilioNumber: '+19897839571',
    );

    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        accelerometerX = event.x;
        accelerometerY = event.y;
        accelerometerZ = event.z;
      });
      if (_detectAccident(event.x, event.y, event.z)) {
        if (!alertShown) {
          _showAlert();
          alertShown = true;
        }
      }
    });

    _getCurrentLocation();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          currentUser = user;
        });
      }
    });
  }

  bool _detectAccident(double x, double y, double z) {
    double threshold = 20.0;
    return (x.abs() > threshold || y.abs() > threshold || z.abs() > threshold);
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      print("❌ Location permission denied");
    }
  }

  void _sendEmergencyMessage() async {
    String locationUrl =
        "https://www.google.com/maps/search/?api=1&query=${currentPosition?.latitude},${currentPosition?.longitude}";

    try {
      await twilioFlutter.sendSMS(
        toNumber: emergencyno,
        messageBody:
            " Emergency Alert! Possible Accident Detected!\n\n"
            "Live Location: $locationUrl\n"
            "Please send help immediately!",
      );
      print(" SMS Sent Successfully with Location");
    } catch (e) {
      print(" Failed to send SMS: $e");
    }
  }

  void _makeEmergencyCall() async {
    final Uri callUri = Uri(scheme: 'tel', path: '108'); // Emergency number 108
    if (await canLaunch(callUri.toString())) {
      await launch(callUri.toString());
    } else {
      print(" Could not launch call.");
    }
  }

  void _showAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(" Accident Detected"),
          content: Text("Are you safe?"),
          actions: [
            TextButton(
              child: Text("Yes, I'm Safe"),
              onPressed: () {
                Navigator.of(context).pop();
                alertShown = false;
              },
            ),
            TextButton(
              child: Text("No, Need Help"),
              onPressed: () {
                Navigator.of(context).pop();
                _sendEmergencyMessage();
                _makeEmergencyCall();
              },
            ),
          ],
        );
      },
    );

    Future.delayed(Duration(seconds: 20), () {
      if (alertShown) {
        _sendEmergencyMessage();
        _makeEmergencyCall();
      }
    });
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" RapidCare")),
      drawer: AppDrawer(currentUser: currentUser, signOut: _signOut),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              " Monitoring Sensor Data...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// **📌 Drawer Widget**
class AppDrawer extends StatelessWidget {
  final User? currentUser;
  final Function(BuildContext) signOut;

  const AppDrawer({Key? key, required this.currentUser, required this.signOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle, size: 80, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  currentUser != null ? currentUser!.email ?? "User" : "Guest",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text("Book Ambulance"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookAmbulancePage()));
            },
          ),

          if (currentUser != null)
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text("View Booking Status"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => BookingStatusPage()));
              },
            ),

          ListTile(
            leading: Icon(Icons.water_drop),
            title: Text("Donate Blood"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DonateBloodPage()));
            },
          ),

          ListTile(
            leading: Icon(Icons.bloodtype_outlined),
            title: Text("Request Blood"),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RequestBloodPage()));
            },
          ),

          ListTile(
            leading: Icon(Icons.list),
            title: Text("View Blood Requests"),  // ✅ Added
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewBloodRequestsPage()));
            },
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sign Out"),
            onTap: () {
              signOut(context);
            },
          ),
        ],
      ),
    );
  }
}

