// import 'package:flutter/material.dart';

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Admin Dashboard')),
//       body: const Center(
//         child: Text(
//           "Welcome, Admin!\nManage users, monitor reports, and oversee the emergency system.",
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';

// // ✅ Twilio Credentials (Replace with actual credentials)
// const String accountSid = "YOUR_TWILIO_ACCOUNT_SID";
// const String authToken = "YOUR_TWILIO_AUTH_TOKEN";
// const String twilioNumber = "YOUR_TWILIO_PHONE_NUMBER";

// void main() {
//   runApp(Ambulancedashboard());
// }

// class Ambulancedashboard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Ambulancedashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching location...";
//   List<Map<String, String>> _nearbyHospitals = []; // Stores name & phone
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   /// ✅ Request Location Permission at Startup
//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       print("✅ Location permission granted.");
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = "❌ Location permission denied.";
//       });
//       print("❌ Location permission denied.");
//     }
//   }

//   /// 📍 Fetch Current Location
//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = position;
//       _locationMessage = "📍 Location: ${position.latitude}, ${position.longitude}";
//     });
//     _fetchNearbyHospitals(position.latitude, position.longitude);
//   }

//   /// 🏥 Fetch Nearby Hospitals with Contact Numbers (Overpass API)
//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String overpassQuery = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;

//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(overpassQuery)}";
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//       List<dynamic> elements = data['elements'];

//       setState(() {
//         _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//           String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//           String phone = hospital['tags']?['contact:phone']?.toString() ??
//                          hospital['tags']?['phone']?.toString() ??
//                          "No Contact Available";
//           return {"name": name, "phone": phone};
//         }).toList();
//       });
//     } else {
//       setState(() {
//         _nearbyHospitals = [{"name": "⚠️ Failed to load hospitals.", "phone": ""}];
//       });
//     }
//   }

//   /// 📩 Send Alert to Selected Hospital
//   void _sendAlert(String hospitalName, String hospitalPhone) async {
//     if (hospitalPhone == "No Contact Available") {
//       _showAlertDialog("Error", "⚠️ No contact number available for $hospitalName.");
//       return;
//     }

//     String message = "🚑 Emergency! A patient is en route to $hospitalName. Location: $_locationMessage";

//     try {
//       await twilioFlutter.sendSMS(toNumber: hospitalPhone, messageBody: message);
//       print("✅ Alert sent to $hospitalName at $hospitalPhone");
//       _showAlertDialog("Alert Sent", "🚑 Alert successfully sent to $hospitalName.");
//     } catch (e) {
//       print("❌ Failed to send alert: $e");
//       _showAlertDialog("Error", "⚠️ Could not send alert. Check Twilio setup.");
//     }
//   }

//   /// 🔔 Show Confirmation Dialog
//   void _showAlertDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             child: _nearbyHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _nearbyHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _nearbyHospitals[index]["name"]!;
//                       String hospitalPhone = _nearbyHospitals[index]["phone"]!;

//                       return ListTile(
//                         title: Text(hospitalName),
//                         subtitle: Text("📞 ${hospitalPhone == "No Contact Available" ? "N/A" : hospitalPhone}"),
//                         trailing: ElevatedButton(
//                           onPressed: () => _sendAlert(hospitalName, hospitalPhone),
//                           child: Text("Send Alert"),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';

// // ✅ Twilio Credentials (Replace with actual credentials)
// const String accountSid = "YOUR_TWILIO_ACCOUNT_SID";
// const String authToken = "YOUR_TWILIO_AUTH_TOKEN";
// const String twilioNumber = "YOUR_TWILIO_PHONE_NUMBER";

// void main() {
//   runApp(MyApp());
// }

// // ✅ Fix: Avoid Recursive Loop
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching location...";
//   List<Map<String, String>> _nearbyHospitals = []; // Stores name & phone
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   /// ✅ Request Location Permission at Startup
//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       print("✅ Location permission granted.");
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = "❌ Location permission denied.";
//       });
//       print("❌ Location permission denied.");
//     }
//   }

//   /// 📍 Fetch Current Location
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       if (mounted) {
//         setState(() {
//           _currentPosition = position;
//           _locationMessage = "📍 Location: ${position.latitude}, ${position.longitude}";
//         });
//         _fetchNearbyHospitals(position.latitude, position.longitude);
//       }
//     } catch (e) {
//       print("❌ Error fetching location: $e");
//     }
//   }

//   /// 🏥 Fetch Nearby Hospitals with Contact Numbers (Overpass API)
//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String overpassQuery = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;

//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(overpassQuery)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         if (mounted) {
//           setState(() {
//             _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//               String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//               String phone = hospital['tags']?['contact:phone']?.toString() ??
//                   hospital['tags']?['phone']?.toString() ??
//                   "No Contact Available";
//               return {"name": name, "phone": phone};
//             }).toList();
//           });
//         }
//       } else {
//         _handleErrorFetchingHospitals();
//       }
//     } catch (e) {
//       print("❌ Error fetching hospitals: $e");
//       _handleErrorFetchingHospitals();
//     }
//   }

//   /// 🚨 Handle Error in Fetching Hospitals
//   void _handleErrorFetchingHospitals() {
//     if (mounted) {
//       setState(() {
//         _nearbyHospitals = [
//           {"name": "⚠️ Failed to load hospitals.", "phone": ""}
//         ];
//       });
//     }
//   }

//   /// 📩 Send Alert to Selected Hospital
//   void _sendAlert(String hospitalName, String hospitalPhone) async {
//     if (hospitalPhone == "No Contact Available" || hospitalPhone.isEmpty) {
//       _showAlertDialog("Error", "⚠️ No contact number available for $hospitalName.");
//       return;
//     }

//     String message = "🚑 Emergency! A patient is en route to $hospitalName. Location: $_locationMessage";

//     try {
//       await twilioFlutter.sendSMS(toNumber: hospitalPhone, messageBody: message);
//       print("✅ Alert sent to $hospitalName at $hospitalPhone");
//       _showAlertDialog("Alert Sent", "🚑 Alert successfully sent to $hospitalName.");
//     } catch (e) {
//       print("❌ Failed to send alert: $e");
//       _showAlertDialog("Error", "⚠️ Could not send alert. Check Twilio setup.");
//     }
//   }

//   /// 🔔 Show Confirmation Dialog
//   void _showAlertDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             child: _nearbyHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _nearbyHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _nearbyHospitals[index]["name"]!;
//                       String hospitalPhone = _nearbyHospitals[index]["phone"]!;

//                       return ListTile(
//                         title: Text(hospitalName),
//                         subtitle: Text("📞 ${hospitalPhone == "No Contact Available" ? "N/A" : hospitalPhone}"),
//                         trailing: ElevatedButton(
//                           onPressed: () => _sendAlert(hospitalName, hospitalPhone),
//                           child: Text("Send Alert"),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart'; // ✅ Import geocoding package
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';

// // ✅ Twilio Credentials (Replace with actual credentials)
// const String accountSid = "YOUR_TWILIO_ACCOUNT_SID";
// const String authToken = "YOUR_TWILIO_AUTH_TOKEN";
// const String twilioNumber = "YOUR_TWILIO_PHONE_NUMBER";

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = []; // Stores name & phone
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   /// ✅ Request Location Permission & Fetch Location
//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       print("✅ Location permission granted.");
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = "❌ Location permission denied.";
//       });
//       print("❌ Location permission denied.");
//     }
//   }

//   /// 📍 Fetch Real-Time Location & Address
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      
//       if (mounted) {
//         setState(() {
//           _currentPosition = position;
//           _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//         });
//       }

//       // ✅ Fetch Address using Reverse Geocoding
//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];

//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       if (mounted) {
//         setState(() {
//           _locationMessage = "📍 $address";
//         });
//         _fetchNearbyHospitals(position.latitude, position.longitude);
//       }
//     } catch (e) {
//       print("❌ Error fetching location: $e");
//       setState(() {
//         _locationMessage = "❌ Unable to fetch location.";
//       });
//     }
//   }

//   /// 🏥 Fetch Nearby Hospitals (Overpass API)
//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String overpassQuery = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;

//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(overpassQuery)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         if (mounted) {
//           setState(() {
//             _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//               String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//               String phone = hospital['tags']?['contact:phone']?.toString() ??
//                   hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//               return {"name": name, "phone": phone};
//             }).toList();
//           });
//         }
//       } else {
//         _handleErrorFetchingHospitals();
//       }
//     } catch (e) {
//       print("❌ Error fetching hospitals: $e");
//       _handleErrorFetchingHospitals();
//     }
//   }

//   /// 🚨 Handle Error in Fetching Hospitals
//   void _handleErrorFetchingHospitals() {
//     if (mounted) {
//       setState(() {
//         _nearbyHospitals = [
//           {"name": "⚠️ Failed to load hospitals.", "phone": ""}
//         ];
//       });
//     }
//   }

//   /// 📩 Send Alert to Selected Hospital
//   void _sendAlert(String hospitalName, String hospitalPhone) async {
//     if (hospitalPhone == "No Contact Available" || hospitalPhone.isEmpty) {
//       _showAlertDialog("Error", "⚠️ No contact number available for $hospitalName.");
//       return;
//     }

//     String message = "🚑 Emergency! A patient is en route to $hospitalName. Location: $_locationMessage";

//     try {
//       await twilioFlutter.sendSMS(toNumber: hospitalPhone, messageBody: message);
//       print("✅ Alert sent to $hospitalName at $hospitalPhone");
//       _showAlertDialog("Alert Sent", "🚑 Alert successfully sent to $hospitalName.");
//     } catch (e) {
//       print("❌ Failed to send alert: $e");
//       _showAlertDialog("Error", "⚠️ Could not send alert. Check Twilio setup.");
//     }
//   }

//   /// 📄 Generate Medical Report (Placeholder Function)
//   void _generateMedicalReport(String hospitalName) {
//     _showAlertDialog("Medical Report", "📝 Medical report for $hospitalName generated.");
//   }

//   /// 🔔 Show Confirmation Dialog
//   void _showAlertDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             child: _nearbyHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _nearbyHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _nearbyHospitals[index]["name"]!;
//                       String hospitalPhone = _nearbyHospitals[index]["phone"]!;

//                       return Card(
//                         elevation: 3,
//                         margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(hospitalName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                               SizedBox(height: 5),
//                               Text("📞 ${hospitalPhone == "No Contact Available" ? "N/A" : hospitalPhone}"),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () => _sendAlert(hospitalName, hospitalPhone),
//                                     child: Text("Send Alert"),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () => _generateMedicalReport(hospitalName),
//                                     child: Text("Generate Medical Report"),
//                                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// // ✅ Twilio Credentials (Replace with actual credentials)
// const String accountSid = "YOUR_TWILIO_ACCOUNT_SID";
// const String authToken = "YOUR_TWILIO_AUTH_TOKEN";
// const String twilioNumber = "YOUR_TWILIO_PHONE_NUMBER";

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = [];
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   /// ✅ Request Location Permission & Fetch Location
//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = "❌ Location permission denied.";
//       });
//     }
//   }

//   /// 📍 Fetch Real-Time Location & Address
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       setState(() {
//         _locationMessage = "📍 $address";
//       });

//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _locationMessage = "❌ Unable to fetch location.";
//       });
//     }
//   }

//   /// 🏥 Fetch Nearby Hospitals
//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String query = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;
//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         setState(() {
//           _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//             String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//             String phone = hospital['tags']?['contact:phone']?.toString() ??
//                 hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//             return {"name": name, "phone": phone};
//           }).toList();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _nearbyHospitals = [{"name": "⚠️ Failed to load hospitals.", "phone": ""}];
//       });
//     }
//   }

//   /// 📩 Send Alert to Selected Hospital
//   void _sendAlert(String hospitalName, String hospitalPhone) async {
//     if (hospitalPhone == "No Contact Available" || hospitalPhone.isEmpty) {
//       _showAlertDialog("Error", "⚠️ No contact number available for $hospitalName.");
//       return;
//     }

//     String message = "🚑 Emergency! A patient is en route to $hospitalName. Location: $_locationMessage";

//     try {
//       await twilioFlutter.sendSMS(toNumber: hospitalPhone, messageBody: message);
//       _showAlertDialog("Alert Sent", "🚑 Alert successfully sent to $hospitalName.");
//     } catch (e) {
//       _showAlertDialog("Error", "⚠️ Could not send alert. Check Twilio setup.");
//     }
//   }

//   /// 📄 Navigate to Medical Report Form
//   void _generateMedicalReport(String hospitalName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicalReportForm(hospitalName: hospitalName),
//       ),
//     );
//   }

//   /// 🔔 Show Dialog
//   void _showAlertDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             child: _nearbyHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _nearbyHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _nearbyHospitals[index]["name"]!;
//                       return ListTile(
//                         title: Text(hospitalName),
//                         subtitle: Text("📞 ${_nearbyHospitals[index]["phone"]!}"),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () => _sendAlert(hospitalName, _nearbyHospitals[index]["phone"]!),
//                               child: Text("Send Alert"),
//                             ),
//                             SizedBox(width: 8),
//                             ElevatedButton(
//                               onPressed: () => _generateMedicalReport(hospitalName),
//                               child: Text("Medical Report"),
//                               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// 📝 Medical Report Form
// class MedicalReportForm extends StatelessWidget {
//   final String hospitalName;
//   MedicalReportForm({required this.hospitalName});

//   final _formKey = GlobalKey<FormState>();
//   final patientController = TextEditingController();
//   final conditionController = TextEditingController();

//   Future<void> _submitReport(BuildContext context) async {
//     await FirebaseFirestore.instance.collection('medical_report').add({
//       'hospital_name': hospitalName,
//       'patient_name': patientController.text,
//       'condition': conditionController.text,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Report")),
//       body: Column(children: [
//         TextField(controller: patientController, decoration: InputDecoration(labelText: "Patient Name")),
//         TextField(controller: conditionController, decoration: InputDecoration(labelText: "Condition")),
//         ElevatedButton(onPressed: () => _submitReport(context), child: Text("Submit"))
//       ]),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// // ✅ Twilio Credentials (Replace with actual credentials)
// const String accountSid = "YOUR_TWILIO_ACCOUNT_SID";
// const String authToken = "YOUR_TWILIO_AUTH_TOKEN";
// const String twilioNumber = "YOUR_TWILIO_PHONE_NUMBER";

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = [];
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   /// ✅ Request Location Permission & Fetch Location
//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = "❌ Location permission denied.";
//       });
//     }
//   }

//   /// 📍 Fetch Real-Time Location & Address
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       setState(() {
//         _locationMessage = "📍 $address";
//       });

//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _locationMessage = "❌ Unable to fetch location.";
//       });
//     }
//   }

//   /// 🏥 Fetch Nearby Hospitals
//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String query = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;
//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         setState(() {
//           _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//             String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//             String phone = hospital['tags']?['contact:phone']?.toString() ?? 
//                 hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//             return {"name": name, "phone": phone};
//           }).toList();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _nearbyHospitals = [{"name": "⚠️ Failed to load hospitals.", "phone": ""}];
//       });
//     }
//   }

//   /// 📩 Send Alert to Selected Hospital
//   void _sendAlert(String hospitalName, String hospitalPhone) async {
//     if (hospitalPhone == "No Contact Available" || hospitalPhone.isEmpty) {
//       _showAlertDialog("Error", "⚠️ No contact number available for $hospitalName.");
//       return;
//     }

//     String message = "🚑 Emergency! A patient is en route to $hospitalName. Location: $_locationMessage";

//     try {
//       await twilioFlutter.sendSMS(toNumber: hospitalPhone, messageBody: message);
//       _showAlertDialog("Alert Sent", "🚑 Alert successfully sent to $hospitalName.");
//     } catch (e) {
//       _showAlertDialog("Error", "⚠️ Could not send alert. Check Twilio setup.");
//     }
//   }

//   /// 📄 Navigate to Medical Report Form
//   void _generateMedicalReport(String hospitalName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicalReportForm(hospitalName: hospitalName),
//       ),
//     );
//   }

//   /// 🔔 Show Dialog
//   void _showAlertDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             child: _nearbyHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _nearbyHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _nearbyHospitals[index]["name"]!;
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         child: ListTile(
//                           title: Text(hospitalName, style: TextStyle(fontWeight: FontWeight.bold)),
//                           subtitle: Text("📞 ${_nearbyHospitals[index]["phone"]!}"),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () => _sendAlert(hospitalName, _nearbyHospitals[index]["phone"]!),
//                                 child: Text("Send Alert"),
//                               ),
//                               SizedBox(width: 8),
//                               ElevatedButton(
//                                 onPressed: () => _generateMedicalReport(hospitalName),
//                                 child: Text("Medical Report"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// 📝 Medical Report Form
// class MedicalReportForm extends StatelessWidget {
//   final String hospitalName;
//   MedicalReportForm({required this.hospitalName});

//   final _formKey = GlobalKey<FormState>();
//   final patientController = TextEditingController();
//   final conditionController = TextEditingController();

//   Future<void> _submitReport(BuildContext context) async {
//     await FirebaseFirestore.instance.collection('medical_reports').add({
//       'hospital_name': hospitalName,
//       'patient_name': patientController.text,
//       'condition': conditionController.text,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Report Submitted Successfully")));
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Report - $hospitalName")),
//       body: Column(children: [
//         TextField(controller: patientController, decoration: InputDecoration(labelText: "Patient Name")),
//         TextField(controller: conditionController, decoration: InputDecoration(labelText: "Condition")),
//         ElevatedButton(onPressed: () => _submitReport(context), child: Text("Submit"))
//       ]),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// const String accountSid = "YOUR_TWILIO_ACCOUNT_SID";
// const String authToken = "YOUR_TWILIO_AUTH_TOKEN";
// const String twilioNumber = "YOUR_TWILIO_PHONE_NUMBER";

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = [];
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = "❌ Location permission denied.";
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       setState(() {
//         _locationMessage = "📍 $address";
//       });

//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _locationMessage = "❌ Unable to fetch location.";
//       });
//     }
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String query = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;
//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         setState(() {
//           _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//             String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//             String phone = hospital['tags']?['contact:phone']?.toString() ?? 
//                 hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//             return {"name": name, "phone": phone};
//           }).toList();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _nearbyHospitals = [{"name": "⚠️ Failed to load hospitals.", "phone": ""}];
//       });
//     }
//   }

//   void _sendAlert(String hospitalName, String hospitalPhone) async {
//     if (hospitalPhone == "No Contact Available" || hospitalPhone.isEmpty) {
//       _showAlertDialog("Error", "⚠️ No contact number available for $hospitalName.");
//       return;
//     }

//     String message = "🚑 Emergency! A patient is en route to $hospitalName. Location: $_locationMessage";

//     try {
//       await twilioFlutter.sendSMS(toNumber: hospitalPhone, messageBody: message);
//       _showAlertDialog("Alert Sent", "🚑 Alert successfully sent to $hospitalName.");
//     } catch (e) {
//       _showAlertDialog("Error", "⚠️ Could not send alert. Check Twilio setup.");
//     }
//   }

//   void _generateMedicalReport(String hospitalName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicalReportForm(hospitalName: hospitalName),
//       ),
//     );
//   }

//   void _showAlertDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             child: _nearbyHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _nearbyHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _nearbyHospitals[index]["name"]!;
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 hospitalName,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () => _sendAlert(hospitalName, _nearbyHospitals[index]["phone"]!),
//                                     child: Text("Send Alert"),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () => _generateMedicalReport(hospitalName),
//                                     child: Text("Medical Report"),
//                                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MedicalReportForm extends StatelessWidget {
//   final String hospitalName;
//   MedicalReportForm({required this.hospitalName});

//   final _formKey = GlobalKey<FormState>();
//   final patientController = TextEditingController();
//   final conditionController = TextEditingController();

//   Future<void> _submitReport(BuildContext context) async {
//     await FirebaseFirestore.instance.collection('medical_reports').add({
//       'hospital_name': hospitalName,
//       'patient_name': patientController.text,
//       'condition': conditionController.text,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Report Submitted Successfully")));
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Report - $hospitalName")),
//       body: Column(children: [
//         TextField(controller: patientController, decoration: InputDecoration(labelText: "Patient Name")),
//         TextField(controller: conditionController, decoration: InputDecoration(labelText: "Condition")),
//         ElevatedButton(onPressed: () => _submitReport(context), child: Text("Submit"))
//       ]),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// const String accountSid = "YOUR_TWILIO_ACCOUNT_SID";
// const String authToken = "YOUR_TWILIO_AUTH_TOKEN";
// const String twilioNumber = "YOUR_TWILIO_PHONE_NUMBER";

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = [];
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = "❌ Location permission denied.";
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       setState(() {
//         _locationMessage = "📍 $address";
//       });

//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _locationMessage = "❌ Unable to fetch location.";
//       });
//     }
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String query = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;
//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         setState(() {
//           _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//             String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//             String phone = hospital['tags']?['contact:phone']?.toString() ?? 
//                 hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//             return {"name": name, "phone": phone};
//           }).toList();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _nearbyHospitals = [{"name": "⚠️ Failed to load hospitals.", "phone": ""}];
//       });
//     }
//   }

//   void _sendAlert(String hospitalName, String hospitalPhone) async {
//     if (hospitalPhone == "No Contact Available" || hospitalPhone.isEmpty) {
//       _showAlertDialog("Error", "⚠️ No contact number available for $hospitalName.");
//       return;
//     }

//     String message = "🚑 Emergency! A patient is en route to $hospitalName. Location: $_locationMessage";

//     try {
//       await twilioFlutter.sendSMS(toNumber: hospitalPhone, messageBody: message);
//       _showAlertDialog("Alert Sent", "🚑 Alert successfully sent to $hospitalName.");
//     } catch (e) {
//       _showAlertDialog("Error", "⚠️ Could not send alert. Check Twilio setup.");
//     }
//   }

//   void _generateMedicalReport(String hospitalName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicalReportForm(hospitalName: hospitalName),
//       ),
//     );
//   }

//   void _showAlertDialog(String title, String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             child: _nearbyHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _nearbyHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _nearbyHospitals[index]["name"]!;
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 hospitalName,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () => _sendAlert(hospitalName, _nearbyHospitals[index]["phone"]!),
//                                     child: Text("Send Alert"),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () => _generateMedicalReport(hospitalName),
//                                     child: Text("Medical Report"),
//                                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MedicalReportForm extends StatelessWidget {
//   final String hospitalName;
//   MedicalReportForm({required this.hospitalName});

//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController patientController = TextEditingController();
//   final TextEditingController conditionController = TextEditingController();

//   Future<void> _submitReport(BuildContext context) async {
//     await FirebaseFirestore.instance.collection('medical_reports').add({
//       'hospital_name': hospitalName,
//       'patient_name': patientController.text,
//       'condition': conditionController.text,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Report Submitted Successfully")));
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Report - $hospitalName")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(children: [
//           TextField(controller: patientController, decoration: InputDecoration(labelText: "Patient Name")),
//           TextField(controller: conditionController, decoration: InputDecoration(labelText: "Condition")),
//           SizedBox(height: 20),
//           ElevatedButton(onPressed: () => _submitReport(context), child: Text("Submit")),
//         ]),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// const String accountSid = "YOUR_TWILIO_ACCOUNT_SID";
// const String authToken = "YOUR_TWILIO_AUTH_TOKEN";
// const String twilioNumber = "YOUR_TWILIO_PHONE_NUMBER";

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = [];
//   late TwilioFlutter twilioFlutter;
//   String? _selectedInjury;

//   final List<String> _injuryTypes = [
//     "Head Injury",
//     "Fracture",
//     "Burn",
//     "Heart Attack",
//     "Stroke",
//     "Accident Trauma",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = "❌ Location permission denied.";
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       setState(() {
//         _locationMessage = "📍 $address";
//       });

//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _locationMessage = "❌ Unable to fetch location.";
//       });
//     }
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String query = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;
//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         setState(() {
//           _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//             String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//             String phone = hospital['tags']?['contact:phone']?.toString() ?? 
//                 hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//             return {"name": name, "phone": phone};
//           }).toList();
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _nearbyHospitals = [{"name": "⚠️ Failed to load hospitals.", "phone": ""}];
//       });
//     }
//   }

//   void _generateMedicalReport(String hospitalName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicalReportForm(hospitalName: hospitalName),
//       ),
//     );
//   }

//   void _sendAlert(String phoneNumber, String message) {
//     twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: message);
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("📩 Alert Sent!")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Expanded(
//             child: _nearbyHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _nearbyHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _nearbyHospitals[index]["name"]!;
//                       String phoneNumber = _nearbyHospitals[index]["phone"]!;
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 hospitalName,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: () => _generateMedicalReport(hospitalName),
//                                 child: Text("Generate Report"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => _sendAlert(phoneNumber, "Emergency at $hospitalName!"),
//                                 child: Text("Send Alert"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MedicalReportForm extends StatefulWidget {
//   final String hospitalName;

//   MedicalReportForm({required this.hospitalName});

//   @override
//   _MedicalReportFormState createState() => _MedicalReportFormState();
// }

// class _MedicalReportFormState extends State<MedicalReportForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController bpController = TextEditingController();
//   final TextEditingController injuryController = TextEditingController();

//   void _submitReport() async {
//     if (_formKey.currentState!.validate()) {
//       await FirebaseFirestore.instance.collection('medical_reports').add({
//         'name': nameController.text,
//         'age': ageController.text,
//         'blood_pressure': bpController.text,
//         'injury': injuryController.text,
//         'hospital': widget.hospitalName,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Report Submitted")));
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Report - ${widget.hospitalName}")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: "Name"),
//                 validator: (value) => value!.isEmpty ? "Please enter the name" : null,
//               ),
//               TextFormField(
//                 controller: ageController,
//                 decoration: InputDecoration(labelText: "Age"),
//                 validator: (value) => value!.isEmpty ? "Please enter the age" : null,
//               ),
//               TextFormField(
//                 controller: bpController,
//                 decoration: InputDecoration(labelText: "Blood Pressure (BP)"),
//                 validator: (value) => value!.isEmpty ? "Please enter the BP" : null,
//               ),
//               TextFormField(
//                 controller: injuryController,
//                 decoration: InputDecoration(labelText: "Injury Type (Critical/Normal)"),
//                 validator: (value) => value!.isEmpty ? "Please enter injury status" : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitReport,
//                 child: Text("Submit Report"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// const String accountSid = "AC5fe0b1b3e38146e9a3b2e92e96773850";
// const String authToken = "cf85d34c06f19d6d862df21c11c576df";
// const String twilioNumber = "+19897839571";

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = [];
//   List<Map<String, String>> _filteredHospitals = [];
//   late TwilioFlutter twilioFlutter;
//   String? _selectedInjury;

//   final List<String> _injuryTypes = [
//     "Head Injury",
//     "Fracture",
//     "Burn",
//     "Heart Attack",
//     "Stroke",
//     "Accident Trauma",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = " Location permission denied.";
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       setState(() {
//         _locationMessage = "📍 $address";
//       });

//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _locationMessage = " Unable to fetch location.";
//       });
//     }
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String query = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;
//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         setState(() {
//           _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//             String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//             String phone = hospital['tags']?['contact:phone']?.toString() ?? hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//             return {"name": name, "phone": phone};
//           }).toList();
//           _filteredHospitals = List.from(_nearbyHospitals); // Initialize filtered list with all hospitals
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _nearbyHospitals = [{"name": " Failed to load hospitals.", "phone": ""}];
//         _filteredHospitals = _nearbyHospitals;
//       });
//     }
//   }

//   void _generateMedicalReport(String hospitalName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicalReportForm(hospitalName: hospitalName),
//       ),
//     );
//   }

//   void _sendAlert(String phoneNumber, String message) {
//     twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: message);
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Alert Sent!")));
//   }

//   void _filterHospitalsByInjury(String injuryType) {
//     // Placeholder: In a real scenario, hospitals might be tagged with injury types
//     setState(() {
//       _selectedInjury = injuryType;
//       _filteredHospitals = _nearbyHospitals.where((hospital) {
//         // Filtering hospitals based on injury type (this is just an example)
//         return hospital['name']!.toLowerCase().contains(injuryType.toLowerCase());
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(" Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButton<String>(
//               hint: Text("Select Injury Type"),
//               value: _selectedInjury,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedInjury = newValue;
//                   _filterHospitalsByInjury(newValue!);
//                 });
//               },
//               items: _injuryTypes.map<DropdownMenuItem<String>>((String injury) {
//                 return DropdownMenuItem<String>(
//                   value: injury,
//                   child: Text(injury),
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: _filteredHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _filteredHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _filteredHospitals[index]["name"]!;
//                       String phoneNumber = _filteredHospitals[index]["phone"]!;
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 hospitalName,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 10),
//                               ElevatedButton(
//                                 onPressed: () => _generateMedicalReport(hospitalName),
//                                 child: Text("Generate Report"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () => _sendAlert(phoneNumber, "Emergency at $hospitalName!"),
//                                 child: Text("Send Alert"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MedicalReportForm extends StatefulWidget {
//   final String hospitalName;

//   MedicalReportForm({required this.hospitalName});

//   @override
//   _MedicalReportFormState createState() => _MedicalReportFormState();
// }

// class _MedicalReportFormState extends State<MedicalReportForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController bpController = TextEditingController();
//   final TextEditingController injuryController = TextEditingController();

//   void _submitReport() async {
//     if (_formKey.currentState!.validate()) {
//       await FirebaseFirestore.instance.collection('medical_reports').add({
//         'name': nameController.text,
//         'age': ageController.text,
//         'blood_pressure': bpController.text,
//         'injury': injuryController.text,
//         'hospital': widget.hospitalName,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Report Submitted")));
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Report - ${widget.hospitalName}")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: "Name"),
//                 validator: (value) => value!.isEmpty ? "Please enter the name" : null,
//               ),
//               TextFormField(
//                 controller: ageController,
//                 decoration: InputDecoration(labelText: "Age"),
//                 validator: (value) => value!.isEmpty ? "Please enter the age" : null,
//               ),
//               TextFormField(
//                 controller: bpController,
//                 decoration: InputDecoration(labelText: "Blood Pressure (BP)"),
//                 validator: (value) => value!.isEmpty ? "Please enter the BP" : null,
//               ),
//               TextFormField(
//                 controller: injuryController,
//                 decoration: InputDecoration(labelText: "Injury Type (Critical/Normal)"),
//                 validator: (value) => value!.isEmpty ? "Please enter injury status" : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitReport,
//                 child: Text("Submit Report"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// const String accountSid = "AC5fe0b1b3e38146e9a3b2e92e96773850";
// const String authToken = "cf85d34c06f19d6d862df21c11c576df";
// const String twilioNumber = "+19897839571";

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = [];
//   List<Map<String, String>> _filteredHospitals = [];
//   late TwilioFlutter twilioFlutter;
//   String? _selectedInjury;

//   final List<String> _injuryTypes = [
//     "Head Injury",
//     "Fracture",
//     "Burn",
//     "Heart Attack",
//     "Stroke",
//     "Accident Trauma",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = " Location permission denied.";
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       setState(() {
//         _locationMessage = "📍 $address";
//       });

//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _locationMessage = " Unable to fetch location.";
//       });
//     }
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String query = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;
//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         setState(() {
//           _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//             String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//             String phone = hospital['tags']?['contact:phone']?.toString() ?? hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//             return {"name": name, "phone": phone};
//           }).toList();
//           _filteredHospitals = List.from(_nearbyHospitals); // Initialize filtered list with all hospitals
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _nearbyHospitals = [{"name": " Failed to load hospitals.", "phone": ""}];
//         _filteredHospitals = _nearbyHospitals;
//       });
//     }
//   }

//   void _generateMedicalReport(String hospitalName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicalReportForm(hospitalName: hospitalName),
//       ),
//     );
//   }

//   void _sendAlert(String phoneNumber, String message) {
//     twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: message);
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Alert Sent!")));
//   }

//   void _filterHospitalsByInjury(String injuryType) {
//     setState(() {
//       _selectedInjury = injuryType;
//       _filteredHospitals = _nearbyHospitals.where((hospital) {
//         return hospital['name']!.toLowerCase().contains(injuryType.toLowerCase());
//       }).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(" Ambulance Dashboard")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButton<String>(
//               hint: Text("Select Injury Type"),
//               value: _selectedInjury,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedInjury = newValue;
//                   _filterHospitalsByInjury(newValue!);
//                 });
//               },
//               items: _injuryTypes.map<DropdownMenuItem<String>>((String injury) {
//                 return DropdownMenuItem<String>(
//                   value: injury,
//                   child: Text(injury),
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: _filteredHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _filteredHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _filteredHospitals[index]["name"]!;
//                       String phoneNumber = _filteredHospitals[index]["phone"]!;
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 hospitalName,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons in a row
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () => _generateMedicalReport(hospitalName),
//                                     child: Text("Generate Report"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue, // Set the same color for both buttons
//                                     ),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () => _sendAlert(phoneNumber, "Emergency at $hospitalName!"),
//                                     child: Text("Send Alert"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue, // Set the same color for both buttons
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MedicalReportForm extends StatefulWidget {
//   final String hospitalName;

//   MedicalReportForm({required this.hospitalName});

//   @override
//   _MedicalReportFormState createState() => _MedicalReportFormState();
// }

// class _MedicalReportFormState extends State<MedicalReportForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController bpController = TextEditingController();
//   final TextEditingController injuryController = TextEditingController();

//   void _submitReport() async {
//     if (_formKey.currentState!.validate()) {
//       await FirebaseFirestore.instance.collection('medical_reports').add({
//         'name': nameController.text,
//         'age': ageController.text,
//         'blood_pressure': bpController.text,
//         'injury': injuryController.text,
//         'hospital': widget.hospitalName,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Report Submitted")));
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Report - ${widget.hospitalName}")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: "Name"),
//                 validator: (value) => value!.isEmpty ? "Please enter the name" : null,
//               ),
//               TextFormField(
//                 controller: ageController,
//                 decoration: InputDecoration(labelText: "Age"),
//                 validator: (value) => value!.isEmpty ? "Please enter the age" : null,
//               ),
//               TextFormField(
//                 controller: bpController,
//                 decoration: InputDecoration(labelText: "Blood Pressure (BP)"),
//                 validator: (value) => value!.isEmpty ? "Please enter the BP" : null,
//               ),
//               TextFormField(
//                 controller: injuryController,
//                 decoration: InputDecoration(labelText: "Injury Type (Critical/Normal)"),
//                 validator: (value) => value!.isEmpty ? "Please enter injury status" : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitReport,
//                 child: Text("Submit Report"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';

// const String accountSid = "AC5fe0b1b3e38146e9a3b2e92e96773850";
// const String authToken = "cf85d34c06f19d6d862df21c11c576df";
// const String twilioNumber = "+19897839571";

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = [];
//   List<Map<String, String>> _filteredHospitals = [];
//   late TwilioFlutter twilioFlutter;
//   String? _selectedInjury;

//   final List<String> _injuryTypes = [
//     "Head Injury",
//     "Fracture",
//     "Burn",
//     "Heart Attack",
//     "Stroke",
//     "Accident Trauma",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = " Location permission denied.";
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       setState(() {
//         _locationMessage = "📍 $address";
//       });

//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _locationMessage = " Unable to fetch location.";
//       });
//     }
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String query = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;
//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         setState(() {
//           _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//             String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//             String phone = hospital['tags']?['contact:phone']?.toString() ?? hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//             return {"name": name, "phone": phone};
//           }).toList();
//           _filteredHospitals = List.from(_nearbyHospitals); // Initialize filtered list with all hospitals
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _nearbyHospitals = [{"name": " Failed to load hospitals.", "phone": ""}];
//         _filteredHospitals = _nearbyHospitals;
//       });
//     }
//   }

//   void _generateMedicalReport(String hospitalName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicalReportForm(hospitalName: hospitalName),
//       ),
//     );
//   }

//   void _sendAlert(String phoneNumber, String message) {
//     twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: message);
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Alert Sent!")));
//   }

//   void _filterHospitalsByInjury(String injuryType) {
//     setState(() {
//       _selectedInjury = injuryType;
//       _filteredHospitals = _nearbyHospitals.where((hospital) {
//         return hospital['name']!.toLowerCase().contains(injuryType.toLowerCase());
//       }).toList();
//     });
//   }

//   void _signOut() {
//     // Implement your sign-out logic here (e.g., Firebase sign out, clearing session data).
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signed out")));
//     // For example, you could use FirebaseAuth to sign out:
//     // FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Ambulance Dashboard"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app), // Sign-out icon
//             onPressed: _signOut, // Call the sign-out function when pressed
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButton<String>(
//               hint: Text("Select Injury Type"),
//               value: _selectedInjury,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedInjury = newValue;
//                   _filterHospitalsByInjury(newValue!);
//                 });
//               },
//               items: _injuryTypes.map<DropdownMenuItem<String>>((String injury) {
//                 return DropdownMenuItem<String>(
//                   value: injury,
//                   child: Text(injury),
//                 );
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: _filteredHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _filteredHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _filteredHospitals[index]["name"]!;
//                       String phoneNumber = _filteredHospitals[index]["phone"]!;
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 hospitalName,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons in a row
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () => _generateMedicalReport(hospitalName),
//                                     child: Text("Generate Report"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue, // Set the same color for both buttons
//                                     ),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () => _sendAlert("+91 8086248944", "Emergency at $hospitalName!"),
//                                     child: Text("Send Alert"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue, // Set the same color for both buttons
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MedicalReportForm extends StatefulWidget {
//   final String hospitalName;

//   MedicalReportForm({required this.hospitalName});

//   @override
//   _MedicalReportFormState createState() => _MedicalReportFormState();
// }

// class _MedicalReportFormState extends State<MedicalReportForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController bpController = TextEditingController();
//   final TextEditingController injuryController = TextEditingController();

//   void _submitReport() async {
//     if (_formKey.currentState!.validate()) {
//       await FirebaseFirestore.instance.collection('medical_reports').add({
//         'name': nameController.text,
//         'age': ageController.text,
//         'blood_pressure': bpController.text,
//         'injury': injuryController.text,
//         'hospital': widget.hospitalName,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Report Submitted")));
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Report - ${widget.hospitalName}")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: "Name"),
//                 validator: (value) => value!.isEmpty ? "Please enter the name" : null,
//               ),
//               TextFormField(
//                 controller: ageController,
//                 decoration: InputDecoration(labelText: "Age"),
//                 validator: (value) => value!.isEmpty ? "Please enter the age" : null,
//               ),
//               TextFormField(
//                 controller: bpController,
//                 decoration: InputDecoration(labelText: "Blood Pressure (BP)"),
//                 validator: (value) => value!.isEmpty ? "Please enter the BP" : null,
//               ),
//               TextFormField(
//                 controller: injuryController,
//                 decoration: InputDecoration(labelText: "Injury Type "),
//                 validator: (value) => value!.isEmpty ? "Please enter injury status" : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitReport,
//                 child: Text("Submit Report"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:project/login_page.dart';

// const String accountSid = "AC5fe0b1b3e38146e9a3b2e92e96773850";
// const String authToken = "cf85d34c06f19d6d862df21c11c576df";
// const String twilioNumber = "+19897839571";

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: AmbulanceDashboard(),
//     );
//   }
// }

// class AmbulanceDashboard extends StatefulWidget {
//   @override
//   _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
// }

// class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
//   Position? _currentPosition;
//   String _locationMessage = "Fetching real-time location...";
//   List<Map<String, String>> _nearbyHospitals = [];
//   List<Map<String, String>> _filteredHospitals = [];
//   late TwilioFlutter twilioFlutter;
//   String? _selectedInjury;

//   final List<String> _injuryTypes = [
//     "Head Injury",
//     "Fracture",
//     "Burn",
//     "Heart Attack",
//     "Stroke",
//     "Accident Trauma",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//     twilioFlutter = TwilioFlutter(
//       accountSid: accountSid,
//       authToken: authToken,
//       twilioNumber: twilioNumber,
//     );
//   }

//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status == PermissionStatus.granted) {
//       _getCurrentLocation();
//     } else {
//       setState(() {
//         _locationMessage = " Location permission denied.";
//       });
//     }
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = position;
//         _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
//       });

//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];
//       String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

//       setState(() {
//         _locationMessage = "📍 $address";
//       });

//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     } catch (e) {
//       setState(() {
//         _locationMessage = " Unable to fetch location.";
//       });
//     }
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     String query = """
//       [out:json];
//       node["amenity"="hospital"](around:5000,$lat,$lon);
//       out;
//     """;
//     String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> data = json.decode(response.body);
//         List<dynamic> elements = data['elements'];

//         setState(() {
//           _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
//             String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
//             String phone = hospital['tags']?['contact:phone']?.toString() ?? hospital['tags']?['phone']?.toString() ?? "No Contact Available";
//             return {"name": name, "phone": phone};
//           }).toList();
//           _filteredHospitals = List.from(_nearbyHospitals); // Initialize filtered list with all hospitals
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _nearbyHospitals = [{"name": " Failed to load hospitals.", "phone": ""}];
//         _filteredHospitals = _nearbyHospitals;
//       });
//     }
//   }

//   void _generateMedicalReport(String hospitalName) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MedicalReportForm(hospitalName: hospitalName),
//       ),
//     );
//   }

//   void _sendAlert(String phoneNumber, String message) {
//     twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: message);
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Alert Sent!")));
//   }

//   void _filterHospitalsByInjury(String injuryType) {
//     setState(() {
//       _selectedInjury = injuryType;
//       _filteredHospitals = _nearbyHospitals.where((hospital) {
//         return hospital['name']!.toLowerCase().contains(injuryType.toLowerCase());
//       }).toList();
//     });
//   }

//   void _signOut() {
//     // Implement your sign-out logic here (e.g., Firebase sign out, clearing session data).
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signed out")));
  
//     // Redirect to the login screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to LoginScreen
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Ambulance Dashboard"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app), // Sign-out icon
//             onPressed: _signOut, // Call the sign-out function when pressed
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: DropdownButton<String>(
//               hint: Text("Select Injury Type"),
//               value: _selectedInjury,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedInjury = newValue;
//                   _filterHospitalsByInjury(newValue!);
//                 });
//               },
//               items: _injuryTypes.map<DropdownMenuItem<String>>((String injury) {
//                 return DropdownMenuItem<String>(value: injury, child: Text(injury));
//               }).toList(),
//             ),
//           ),
//           Expanded(
//             child: _filteredHospitals.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount: _filteredHospitals.length,
//                     itemBuilder: (context, index) {
//                       String hospitalName = _filteredHospitals[index]["name"]!;
//                       String phoneNumber = _filteredHospitals[index]["phone"]!;
//                       return Card(
//                         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 hospitalName,
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons in a row
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () => _generateMedicalReport(hospitalName),
//                                     child: Text("Generate Report"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue, // Set the same color for both buttons
//                                     ),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () => _sendAlert("+91 8086248944", "Emergency at $hospitalName!"),
//                                     child: Text("Send Alert"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.blue, // Set the same color for both buttons
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MedicalReportForm extends StatefulWidget {
//   final String hospitalName;

//   MedicalReportForm({required this.hospitalName});

//   @override
//   _MedicalReportFormState createState() => _MedicalReportFormState();
// }

// class _MedicalReportFormState extends State<MedicalReportForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//   final TextEditingController bpController = TextEditingController();
//   final TextEditingController injuryController = TextEditingController();

//   void _submitReport() async {
//     if (_formKey.currentState!.validate()) {
//       await FirebaseFirestore.instance.collection('medical_reports').add({
//         'name': nameController.text,
//         'age': ageController.text,
//         'blood_pressure': bpController.text,
//         'injury': injuryController.text,
//         'hospital': widget.hospitalName,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Report Submitted")));
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Report - ${widget.hospitalName}")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(labelText: "Name"),
//                 validator: (value) => value!.isEmpty ? "Please enter the name" : null,
//               ),
//               TextFormField(
//                 controller: ageController,
//                 decoration: InputDecoration(labelText: "Age"),
//                 validator: (value) => value!.isEmpty ? "Please enter the age" : null,
//               ),
//               TextFormField(
//                 controller: bpController,
//                 decoration: InputDecoration(labelText: "Blood Pressure (BP)"),
//                 validator: (value) => value!.isEmpty ? "Please enter the BP" : null,
//               ),
//               TextFormField(
//                 controller: injuryController,
//                 decoration: InputDecoration(labelText: "Injury Type "),
//                 validator: (value) => value!.isEmpty ? "Please enter injury status" : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitReport,
//                 child: Text("Submit Report"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Implement login logic here
//             // For now, we just navigate to the dashboard after pressing the button
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => AmbulanceDashboard()),
//             );
//           },
//           child: Text("Login"),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Import the LoginPage.dart file here
import 'login_page.dart';

const String accountSid = "AC5fe0b1b3e38146e9a3b2e92e96773850";
const String authToken = "cf85d34c06f19d6d862df21c11c576df";
const String twilioNumber = "+19897839571";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AmbulanceDashboard(),
    );
  }
}

class AmbulanceDashboard extends StatefulWidget {
  @override
  _AmbulanceDashboardState createState() => _AmbulanceDashboardState();
}

class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
  Position? _currentPosition;
  String _locationMessage = "Fetching real-time location...";
  List<Map<String, String>> _nearbyHospitals = [];
  List<Map<String, String>> _filteredHospitals = [];
  late TwilioFlutter twilioFlutter;
  String? _selectedInjury;

  final List<String> _injuryTypes = [
    "Head Injury",
    "Fracture",
    "Burn",
    "Heart Attack",
    "Stroke",
    "Accident Trauma",
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    twilioFlutter = TwilioFlutter(
      accountSid: accountSid,
      authToken: authToken,
      twilioNumber: twilioNumber,
    );
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else {
      setState(() {
        _locationMessage = " Location permission denied.";
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _locationMessage = "📍 ${position.latitude}, ${position.longitude} (Fetching Address...)";
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() {
        _locationMessage = "📍 $address";
      });

      _fetchNearbyHospitals(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _locationMessage = " Unable to fetch location.";
      });
    }
  }

  Future<void> _fetchNearbyHospitals(double lat, double lon) async {
    String query = """
      [out:json];
      node["amenity"="hospital"](around:5000,$lat,$lon);
      out;
    """;
    String url = "https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> elements = data['elements'];

        setState(() {
          _nearbyHospitals = elements.map<Map<String, String>>((hospital) {
            String name = hospital['tags']?['name']?.toString() ?? "Unnamed Hospital";
            String phone = hospital['tags']?['contact:phone']?.toString() ?? hospital['tags']?['phone']?.toString() ?? "No Contact Available";
            return {"name": name, "phone": phone};
          }).toList();
          _filteredHospitals = List.from(_nearbyHospitals); // Initialize filtered list with all hospitals
        });
      }
    } catch (e) {
      setState(() {
        _nearbyHospitals = [{"name": " Failed to load hospitals.", "phone": ""}];
        _filteredHospitals = _nearbyHospitals;
      });
    }
  }

  void _generateMedicalReport(String hospitalName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicalReportForm(hospitalName: hospitalName),
      ),
    );
  }

  void _sendAlert(String phoneNumber, String message) {
    twilioFlutter.sendSMS(toNumber: phoneNumber, messageBody: message);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Alert Sent!")));
  }

  void _filterHospitalsByInjury(String injuryType) {
    setState(() {
      _selectedInjury = injuryType;
      _filteredHospitals = _nearbyHospitals.where((hospital) {
        return hospital['name']!.toLowerCase().contains(injuryType.toLowerCase());
      }).toList();
    });
  }

  void _signOut() {
    // Implement your sign-out logic here (e.g., Firebase sign out, clearing session data).
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signed out")));
  
    // Redirect to the login screen (login_page.dart)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to your LoginPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ambulance Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app), // Sign-out icon
            onPressed: _signOut, // Call the sign-out function when pressed
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(_locationMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              hint: Text("Select Injury Type"),
              value: _selectedInjury,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedInjury = newValue;
                  _filterHospitalsByInjury(newValue!);
                });
              },
              items: _injuryTypes.map<DropdownMenuItem<String>>((String injury) {
                return DropdownMenuItem<String>(value: injury, child: Text(injury));
              }).toList(),
            ),
          ),
          Expanded(
            child: _filteredHospitals.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredHospitals.length,
                    itemBuilder: (context, index) {
                      String hospitalName = _filteredHospitals[index]["name"]!;
                      String phoneNumber = _filteredHospitals[index]["phone"]!;
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hospitalName,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons in a row
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _generateMedicalReport(hospitalName),
                                    child: Text("Generate Report"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, // Set the same color for both buttons
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _sendAlert("+91 8086248944", "Emergency at $hospitalName!"),
                                    child: Text("Send Alert"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, // Set the same color for both buttons
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MedicalReportForm extends StatefulWidget {
  final String hospitalName;

  MedicalReportForm({required this.hospitalName});

  @override
  _MedicalReportFormState createState() => _MedicalReportFormState();
}

class _MedicalReportFormState extends State<MedicalReportForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bpController = TextEditingController();
  final TextEditingController injuryController = TextEditingController();

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('medical_reports').add({
        'name': nameController.text,
        'age': ageController.text,
        'blood_pressure': bpController.text,
        'injury': injuryController.text,
        'hospital': widget.hospitalName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Report Submitted")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medical Report - ${widget.hospitalName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Please enter the name" : null,
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: "Age"),
                validator: (value) => value!.isEmpty ? "Please enter the age" : null,
              ),
              TextFormField(
                controller: bpController,
                decoration: InputDecoration(labelText: "Blood Pressure (BP)"),
                validator: (value) => value!.isEmpty ? "Please enter the BP" : null,
              ),
              TextFormField(
                controller: injuryController,
                decoration: InputDecoration(labelText: "Injury Type "),
                validator: (value) => value!.isEmpty ? "Please enter injury status" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReport,
                child: Text("Submit Report"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
