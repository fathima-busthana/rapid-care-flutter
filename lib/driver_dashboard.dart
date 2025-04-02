// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   // Function to update booking status
//   void _updateStatus(String bookingId, String newStatus) {
//     FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//       "status": newStatus,
//     }).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Status updated to $newStatus")),
//       );
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: snapshot.data!.docs.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName']}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: ${data['fromLocation']['latitude']}, ${data['fromLocation']['longitude']}"),
//                       Text("🏥 To: ${data['toLocation']}"),
//                       Text("📅 Date: ${data['dateTime'].toString().split('T')[0]}"),
//                       Text("⏰ Time: ${DateTime.parse(data['dateTime']).toLocal().hour}:${DateTime.parse(data['dateTime']).toLocal().minute}"),
//                       Text("📌 Status: ${data['status']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) => _updateStatus(doc.id, value),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "On the way", child: Text("🚑 On the way")),
//                       PopupMenuItem(value: "Completed", child: Text("✔️ Completed")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:math';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   Position? _driverPosition;

//   @override
//   void initState() {
//     super.initState();
//     _getDriverLocation();
//   }

//   /// Get Driver's Current Location
//   Future<void> _getDriverLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _driverPosition = position;
//     });
//   }

//   /// Calculate Distance Between Two Coordinates (Haversine Formula)
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double R = 6371; // Earth radius in km
//     double dLat = _toRadians(lat2 - lat1);
//     double dLon = _toRadians(lon2 - lon1);
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
//             sin(dLon / 2) * sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c; // Distance in km
//   }

//   double _toRadians(double degree) {
//     return degree * pi / 180;
//   }

//   /// Update Booking Status
//   void _updateStatus(String bookingId, String newStatus) {
//     FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//       "status": newStatus,
//     }).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Status updated to $newStatus")),
//       );
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           List<DocumentSnapshot> bookings = snapshot.data!.docs;

//           // Sort bookings based on distance from the driver
//           if (_driverPosition != null) {
//             bookings.sort((a, b) {
//               var aData = a.data() as Map<String, dynamic>;
//               var bData = b.data() as Map<String, dynamic>;

//               double aLat = aData['fromLocation']['latitude'];
//               double aLon = aData['fromLocation']['longitude'];
//               double bLat = bData['fromLocation']['latitude'];
//               double bLon = bData['fromLocation']['longitude'];

//               double distanceA = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, aLat, aLon);
//               double distanceB = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, bLat, bLon);

//               return distanceA.compareTo(distanceB);
//             });
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: bookings.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;

//               double bookingLat = data['fromLocation']['latitude'];
//               double bookingLon = data['fromLocation']['longitude'];
//               double distance = _driverPosition != null
//                   ? _calculateDistance(_driverPosition!.latitude, _driverPosition!.longitude, bookingLat, bookingLon)
//                   : 0.0;

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName']}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: ${bookingLat}, ${bookingLon}"),
//                       Text("🏥 To: ${data['toLocation']}"),
//                       Text("📅 Date: ${data['dateTime'].toString().split('T')[0]}"),
//                       Text("⏰ Time: ${DateTime.parse(data['dateTime']).toLocal().hour}:${DateTime.parse(data['dateTime']).toLocal().minute}"),
//                       Text("📏 Distance: ${distance.toStringAsFixed(2)} km"),
//                       Text("📌 Status: ${data['status']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) => _updateStatus(doc.id, value),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "On the way", child: Text("🚑 On the way")),
//                       PopupMenuItem(value: "Completed", child: Text("✔️ Completed")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dart:math';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   Position? _driverPosition;
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _getDriverLocation();

//     // Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );
//   }

//   /// Get Driver's Current Location
//   Future<void> _getDriverLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _driverPosition = position;
//     });
//   }

//   /// Calculate Distance Between Two Coordinates (Haversine Formula)
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double R = 6371; // Earth radius in km
//     double dLat = _toRadians(lat2 - lat1);
//     double dLon = _toRadians(lon2 - lon1);
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
//             sin(dLon / 2) * sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c; // Distance in km
//   }

//   double _toRadians(double degree) {
//     return degree * pi / 180;
//   }

//   /// Update Booking Status and Send SMS Alert
//   void _updateStatus(String bookingId, String newStatus) async {
//     try {
//       // Fetch the booking document to get the userId
//       DocumentSnapshot bookingDoc = await FirebaseFirestore.instance
//           .collection('booking_status')
//           .doc(bookingId)
//           .get();

//       if (!bookingDoc.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Booking not found.")),
//         );
//         return;
//       }

//       // Extract userId of the patient
//       Map<String, dynamic> bookingData = bookingDoc.data() as Map<String, dynamic>;
//       String? userId = bookingData['userId'];

//       if (userId == null || userId.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ User ID not found for this booking.")),
//         );
//         return;
//       }

//       // Fetch patient's phone number from the 'users' collection
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();

//       if (!userDoc.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ User not found in database.")),
//         );
//         return;
//       }

//       // Extract phone number
//       Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
//       String? patientPhone = userData['phone']; // Assuming 'phone' field exists

//       if (patientPhone == null || patientPhone.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ No phone number found for the user.")),
//         );
//         return;
//       }

//       // Update Firestore booking status
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       // Show confirmation message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );

//       // Send SMS alert if status is "On the way"
//       if (newStatus == "On the way") {
//         await twilioFlutter.sendSMS(
//           toNumber: patientPhone,
//           messageBody: "🚑 Alert: Your ambulance is on the way! Stay ready for pickup.",
//         );
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("📩 SMS sent to patient.")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           List<DocumentSnapshot> bookings = snapshot.data!.docs;

//           // Sort bookings based on distance from the driver
//           if (_driverPosition != null) {
//             bookings.sort((a, b) {
//               var aData = a.data() as Map<String, dynamic>;
//               var bData = b.data() as Map<String, dynamic>;

//               double aLat = aData['fromLocation']['latitude'];
//               double aLon = aData['fromLocation']['longitude'];
//               double bLat = bData['fromLocation']['latitude'];
//               double bLon = bData['fromLocation']['longitude'];

//               double distanceA = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, aLat, aLon);
//               double distanceB = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, bLat, bLon);

//               return distanceA.compareTo(distanceB);
//             });
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: bookings.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;

//               double bookingLat = data['fromLocation']['latitude'];
//               double bookingLon = data['fromLocation']['longitude'];
//               double distance = _driverPosition != null
//                   ? _calculateDistance(_driverPosition!.latitude, _driverPosition!.longitude, bookingLat, bookingLon)
//                   : 0.0;

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName']}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: ${bookingLat}, ${bookingLon}"),
//                       Text("🏥 To: ${data['toLocation']}"),
//                       Text("📅 Date: ${data['dateTime'].toString().split('T')[0]}"),
//                       Text("⏰ Time: ${DateTime.parse(data['dateTime']).toLocal().hour}:${DateTime.parse(data['dateTime']).toLocal().minute}"),
//                       Text("📏 Distance: ${distance.toStringAsFixed(2)} km"),
//                       Text("📌 Status: ${data['status']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) => _updateStatus(doc.id, value),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "On the way", child: Text("🚑 On the way")),
//                       PopupMenuItem(value: "Completed", child: Text("✔️ Completed")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dart:math';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   Position? _driverPosition;
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _getDriverLocation();

//     // 🔹 Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );
//   }

//   /// 🔹 Get Driver's Current Location
//   Future<void> _getDriverLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _driverPosition = position;
//     });
//   }

//   /// 🔹 Calculate Distance Between Two Coordinates (Haversine Formula)
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double R = 6371; // Earth radius in km
//     double dLat = _toRadians(lat2 - lat1);
//     double dLon = _toRadians(lon2 - lon1);
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
//             sin(dLon / 2) * sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c; // Distance in km
//   }

//   double _toRadians(double degree) {
//     return degree * pi / 180;
//   }

//   /// 🚑 Update Booking Status & Notify Patient via SMS
//   void _updateStatus(String bookingId, String newStatus) async {
//     try {
//       // 🔹 Get booking details from Firestore
//       DocumentSnapshot bookingDoc = await FirebaseFirestore.instance
//           .collection('booking_status')
//           .doc(bookingId)
//           .get();

//       if (!bookingDoc.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Booking not found.")),
//         );
//         return;
//       }

//       Map<String, dynamic> bookingData = bookingDoc.data() as Map<String, dynamic>;
//       String? patientPhone = bookingData['phoneNumber']; // Fetch phone directly from 'booking_status'

//       if (patientPhone == null || patientPhone.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Phone number missing from booking data.")),
//         );
//         return;
//       }

//       // 🔹 Update Firestore booking status
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       // 🔹 Show confirmation message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );

//       // 🔹 Send SMS if status is "On the way"
//       if (newStatus == "On the way") {
//         await twilioFlutter.sendSMS(
//           toNumber: patientPhone,
//           messageBody: "🚑 Alert: Your ambulance is on the way! Stay ready for pickup.",
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("📩 SMS sent to patient.")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           List<DocumentSnapshot> bookings = snapshot.data!.docs;

//           // 🔹 Sort bookings based on distance from the driver
//           if (_driverPosition != null) {
//             bookings.sort((a, b) {
//               var aData = a.data() as Map<String, dynamic>;
//               var bData = b.data() as Map<String, dynamic>;

//               double aLat = aData['fromLocation']['latitude'];
//               double aLon = aData['fromLocation']['longitude'];
//               double bLat = bData['fromLocation']['latitude'];
//               double bLon = bData['fromLocation']['longitude'];

//               double distanceA = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, aLat, aLon);
//               double distanceB = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, bLat, bLon);

//               return distanceA.compareTo(distanceB);
//             });
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: bookings.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;

//               double bookingLat = data['fromLocation']['latitude'];
//               double bookingLon = data['fromLocation']['longitude'];
//               double distance = _driverPosition != null
//                   ? _calculateDistance(_driverPosition!.latitude, _driverPosition!.longitude, bookingLat, bookingLon)
//                   : 0.0;

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName']}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: ${bookingLat}, ${bookingLon}"),
//                       Text("🏥 To: ${data['toLocation']}"),
//                       Text("📅 Date: ${data['dateTime'].toString().split('T')[0]}"),
//                       Text("⏰ Time: ${DateTime.parse(data['dateTime']).toLocal().hour}:${DateTime.parse(data['dateTime']).toLocal().minute}"),
//                       Text("📏 Distance: ${distance.toStringAsFixed(2)} km"),
//                       Text("📌 Status: ${data['status']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) => _updateStatus(doc.id, value),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "On the way", child: Text("🚑 On the way")),
//                       PopupMenuItem(value: "Completed", child: Text("✔️ Completed")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dart:math';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   Position? _driverPosition;
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _getDriverLocation();

//     // 🔹 Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );
//   }

//   /// 🔹 Get Driver's Current Location
//   Future<void> _getDriverLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _driverPosition = position;
//     });
//   }

//   /// 🔹 Calculate Distance Between Two Coordinates (Haversine Formula)
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double R = 6371; // Earth radius in km
//     double dLat = _toRadians(lat2 - lat1);
//     double dLon = _toRadians(lon2 - lon1);
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
//             sin(dLon / 2) * sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c; // Distance in km
//   }

//   double _toRadians(double degree) {
//     return degree * pi / 180;
//   }

//   /// 🚑 Update Booking Status & Send SMS with Driver's Location
//   void _updateStatus(String bookingId, String newStatus) async {
//     try {
//       // 🔹 Get booking details from Firestore
//       DocumentSnapshot bookingDoc = await FirebaseFirestore.instance
//           .collection('booking_status')
//           .doc(bookingId)
//           .get();

//       if (!bookingDoc.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Booking not found.")),
//         );
//         return;
//       }

//       Map<String, dynamic> bookingData = bookingDoc.data() as Map<String, dynamic>;
//       String? patientPhone = bookingData['phoneNumber']; // Fetch phone number

//       if (patientPhone == null || patientPhone.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Phone number missing from booking data.")),
//         );
//         return;
//       }

//       // 🔹 Update Firestore booking status
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       // 🔹 Show confirmation message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );

//       // 🔹 If status is "On the way", send SMS with driver's live location
//       if (newStatus == "On the way" && _driverPosition != null) {
//         String locationMessage =
//             "🚑 Alert: Your ambulance is on the way!\n📍 Driver's Location:\nhttps://www.google.com/maps/search/?api=1&query=${_driverPosition!.latitude},${_driverPosition!.longitude}";

//         await twilioFlutter.sendSMS(
//           toNumber: patientPhone,
//           messageBody: locationMessage,
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("📩 SMS sent with live location.")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           List<DocumentSnapshot> bookings = snapshot.data!.docs;

//           // 🔹 Sort bookings based on distance from the driver
//           if (_driverPosition != null) {
//             bookings.sort((a, b) {
//               var aData = a.data() as Map<String, dynamic>;
//               var bData = b.data() as Map<String, dynamic>;

//               double aLat = aData['fromLocation']['latitude'];
//               double aLon = aData['fromLocation']['longitude'];
//               double bLat = bData['fromLocation']['latitude'];
//               double bLon = bData['fromLocation']['longitude'];

//               double distanceA = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, aLat, aLon);
//               double distanceB = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, bLat, bLon);

//               return distanceA.compareTo(distanceB);
//             });
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: bookings.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;

//               double bookingLat = data['fromLocation']['latitude'];
//               double bookingLon = data['fromLocation']['longitude'];
//               double distance = _driverPosition != null
//                   ? _calculateDistance(_driverPosition!.latitude, _driverPosition!.longitude, bookingLat, bookingLon)
//                   : 0.0;

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName']}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: ${bookingLat}, ${bookingLon}"),
//                       Text("🏥 To: ${data['toLocation']}"),
//                       Text("📅 Date: ${data['dateTime'].toString().split('T')[0]}"),
//                       Text("⏰ Time: ${DateTime.parse(data['dateTime']).toLocal().hour}:${DateTime.parse(data['dateTime']).toLocal().minute}"),
//                       Text("📏 Distance: ${distance.toStringAsFixed(2)} km"),
//                       Text("📌 Status: ${data['status']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) => _updateStatus(doc.id, value),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "On the way", child: Text("🚑 On the way")),
//                       PopupMenuItem(value: "Completed", child: Text("✔️ Completed")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dart:math';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   Position? _driverPosition;
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _getDriverLocation();

//     // 🔹 Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );
//   }

//   /// 🔹 Get Driver's Current Location
//   Future<void> _getDriverLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _driverPosition = position;
//     });
//   }

//   /// 🔹 Calculate Distance Between Two Coordinates (Haversine Formula)
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double R = 6371; // Earth radius in km
//     double dLat = _toRadians(lat2 - lat1);
//     double dLon = _toRadians(lon2 - lon1);
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
//             sin(dLon / 2) * sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c; // Distance in km
//   }

//   double _toRadians(double degree) {
//     return degree * pi / 180;
//   }

//   /// 🔹 Format phone number to include country code
//   String formatPhoneNumber(String phoneNumber) {
//     if (phoneNumber.startsWith('+')) {
//       return phoneNumber; // Already formatted
//     } else {
//       return '+91$phoneNumber'; // Default to India, change as needed
//     }
//   }

//   /// 🚑 Update Booking Status & Send SMS with Driver Location
//   void _updateStatus(String bookingId, String newStatus) async {
//     try {
//       // 🔹 Get booking details from Firestore
//       DocumentSnapshot bookingDoc = await FirebaseFirestore.instance
//           .collection('booking_status')
//           .doc(bookingId)
//           .get();

//       if (!bookingDoc.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Booking not found.")),
//         );
//         return;
//       }

//       // 🔹 Extract booking details
//       Map<String, dynamic> bookingData = bookingDoc.data() as Map<String, dynamic>;
//       String? patientPhone = bookingData['phoneNumber'];

//       if (patientPhone == null || patientPhone.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Phone number missing from booking data.")),
//         );
//         return;
//       }

//       String formattedPhone = formatPhoneNumber(patientPhone); // Ensure country code

//       // 🔹 Update Firestore booking status
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       // 🔹 Show confirmation message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );

//       // 🔹 Send SMS with live location if status is "On the way"
//       if (newStatus == "On the way") {
//         String driverLocation = "https://www.google.com/maps/search/?api=1&query="
//             "${_driverPosition!.latitude},${_driverPosition!.longitude}";

//         await twilioFlutter.sendSMS(
//           toNumber: formattedPhone,
//           messageBody: "🚑 Alert: Your ambulance is on the way! 🚑\nTrack live location: $driverLocation",
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("SMS sent to patient.")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(" Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           List<DocumentSnapshot> bookings = snapshot.data!.docs;

//           // 🔹 Sort bookings based on distance from the driver
//           if (_driverPosition != null) {
//             bookings.sort((a, b) {
//               var aData = a.data() as Map<String, dynamic>;
//               var bData = b.data() as Map<String, dynamic>;

//               double aLat = aData['fromLocation']['latitude'];
//               double aLon = aData['fromLocation']['longitude'];
//               double bLat = bData['fromLocation']['latitude'];
//               double bLon = bData['fromLocation']['longitude'];

//               double distanceA = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, aLat, aLon);
//               double distanceB = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, bLat, bLon);

//               return distanceA.compareTo(distanceB);
//             });
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: bookings.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;

//               double bookingLat = data['fromLocation']['latitude'];
//               double bookingLon = data['fromLocation']['longitude'];
//               double distance = _driverPosition != null
//                   ? _calculateDistance(_driverPosition!.latitude, _driverPosition!.longitude, bookingLat, bookingLon)
//                   : 0.0;

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName']}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: ${bookingLat}, ${bookingLon}"),
//                       Text("🏥 To: ${data['toLocation']}"),
//                       Text("📅 Date: ${data['dateTime'].toString().split('T')[0]}"),
//                       Text("⏰ Time: ${DateTime.parse(data['dateTime']).toLocal().hour}:${DateTime.parse(data['dateTime']).toLocal().minute}"),
//                       Text("📏 Distance: ${distance.toStringAsFixed(2)} km"),
//                       Text("📌 Status: ${data['status']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) => _updateStatus(doc.id, value),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "On the way", child: Text("🚑 On the way")),
//                       PopupMenuItem(value: "Completed", child: Text("✔️ Completed")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dart:math';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   Position? _driverPosition;
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     _getDriverLocation();

//     // 🔹 Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );
//   }

//   /// 🔹 Get Driver's Current Location
//   Future<void> _getDriverLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _driverPosition = position;
//     });
//   }

//   /// 🔹 Calculate Distance Between Two Coordinates (Haversine Formula)
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double R = 6371; // Earth radius in km
//     double dLat = _toRadians(lat2 - lat1);
//     double dLon = _toRadians(lon2 - lon1);
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
//             sin(dLon / 2) * sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c; // Distance in km
//   }

//   double _toRadians(double degree) {
//     return degree * pi / 180;
//   }

//   /// 🔹 Format phone number to include country code
//   String formatPhoneNumber(String phoneNumber) {
//     if (phoneNumber.startsWith('+')) {
//       return phoneNumber; // Already formatted
//     } else {
//       return '+91$phoneNumber'; // Default to India, change as needed
//     }
//   }

//   /// 🚑 Update Booking Status & Send SMS with Driver Location
//   void _updateStatus(String bookingId, String newStatus) async {
//     try {
//       // 🔹 Get booking details from Firestore
//       DocumentSnapshot bookingDoc = await FirebaseFirestore.instance
//           .collection('booking_status')
//           .doc(bookingId)
//           .get();

//       if (!bookingDoc.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Booking not found.")),
//         );
//         return;
//       }

//       // 🔹 Extract booking details
//       Map<String, dynamic> bookingData = bookingDoc.data() as Map<String, dynamic>;
//       String? patientPhone = bookingData['phoneNumber'];

//       if (patientPhone == null || patientPhone.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("⚠️ Phone number missing from booking data.")),
//         );
//         return;
//       }

//       String formattedPhone = formatPhoneNumber(patientPhone); // Ensure country code

//       // 🔹 Update Firestore booking status
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       // 🔹 Show confirmation message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );

//       // 🔹 Send SMS with live location if status is "On the way"
//       if (newStatus == "On the way") {
//         String driverLocation = "https://www.google.com/maps/search/?api=1&query="
//             "${_driverPosition!.latitude},${_driverPosition!.longitude}";

//         await twilioFlutter.sendSMS(
//           toNumber: formattedPhone,
//           messageBody: "🚑 Alert: Your ambulance is on the way! 🚑\nTrack live location: $driverLocation",
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("SMS sent to patient.")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           List<DocumentSnapshot> bookings = snapshot.data!.docs;

//           // 🔹 Sort bookings based on distance from the driver
//           if (_driverPosition != null) {
//             bookings.sort((a, b) {
//               var aData = a.data() as Map<String, dynamic>;
//               var bData = b.data() as Map<String, dynamic>;

//               double aLat = aData['fromLocation']['latitude'];
//               double aLon = aData['fromLocation']['longitude'];
//               double bLat = bData['fromLocation']['latitude'];
//               double bLon = bData['fromLocation']['longitude'];

//               double distanceA = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, aLat, aLon);
//               double distanceB = _calculateDistance(
//                   _driverPosition!.latitude, _driverPosition!.longitude, bLat, bLon);

//               return distanceA.compareTo(distanceB);
//             });
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: bookings.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;

//               double bookingLat = data['fromLocation']['latitude'];
//               double bookingLon = data['fromLocation']['longitude'];
//               double distance = _driverPosition != null
//                   ? _calculateDistance(_driverPosition!.latitude, _driverPosition!.longitude, bookingLat, bookingLon)
//                   : 0.0;

//               // ✅ Fixing Firestore Timestamp issue
//               DateTime dateTime;
//               if (data['dateTime'] is Timestamp) {
//                 dateTime = (data['dateTime'] as Timestamp).toDate();
//               } else {
//                 dateTime = DateTime.parse(data['dateTime']);
//               }

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName']}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: ${bookingLat}, ${bookingLon}"),
//                       Text("🏥 To: ${data['toLocation']}"),
//                       Text("📅 Date: ${dateTime.toLocal().toString().split(' ')[0]}"),
//                       Text("⏰ Time: ${dateTime.toLocal().hour}:${dateTime.toLocal().minute}"),
//                       Text("📏 Distance: ${distance.toStringAsFixed(2)} km"),
//                       Text("📌 Status: ${data['status']}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) => _updateStatus(doc.id, value),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "On the way", child: Text("🚑 On the way")),
//                       PopupMenuItem(value: "Completed", child: Text("✔️ Completed")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'dart:math';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );
//   }

//   /// 🚑 Update Booking Status & Notify Patient via SMS
//   void _updateStatus(String bookingId, String newStatus, String? patientPhone) async {
//     try {
//       // Update Firestore booking status
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       // Show confirmation message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );

//       // If the status is "On the way", send SMS to the patient
//       if (newStatus == "On the way" && patientPhone != null && patientPhone.isNotEmpty) {
//         await twilioFlutter.sendSMS(
//           toNumber: patientPhone,
//           messageBody: "🚑 Alert: Your ambulance is on the way! Stay ready for pickup.",
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("📩 SMS sent to patient.")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(" Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('booking_status')
//             .where('status', isEqualTo: 'pending') // Fetch only pending bookings
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No pending ambulance bookings found."));
//           }

//           List<DocumentSnapshot> bookings = snapshot.data!.docs;

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: bookings.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;

//               String patientName = data['patientName'] ?? 'Unknown Patient';
//               String toLocation = data['toLocation'] ?? 'Unknown Location';
//               String status = data['status'] ?? 'Pending';
//               String? patientPhone = data['phoneNumber']; // Fetch phone directly from 'booking_status'

//               // Fetching 'fromLocation' with latitude and longitude
//               double bookingLat = data['fromLocation']?['latitude'] ?? 0.0;
//               double bookingLon = data['fromLocation']?['longitude'] ?? 0.0;

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: $patientName"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: $bookingLat, $bookingLon"),
//                       Text("🏥 To: $toLocation"),
//                       Text("📅 Status: $status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) {
//                       if (value == "Started Journey") {
//                         _updateStatus(doc.id, "On the way", patientPhone);
//                       } else {
//                         _updateStatus(doc.id, "Accepted", patientPhone);
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "Started Journey", child: Text("🚑 Started Journey")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize Twilio
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );
//   }

//   /// 🚑 Update Booking Status & Notify Patient via SMS
//   void _updateStatus(String bookingId, String newStatus, String? patientPhone) async {
//     try {
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );

//       if (newStatus == "On the way" && patientPhone != null && patientPhone.isNotEmpty) {
//         await twilioFlutter.sendSMS(
//           toNumber: patientPhone,
//           messageBody: "🚑 Alert: Your ambulance is on the way! Stay ready for pickup.",
//         );

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("📩 SMS sent to patient.")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   /// ✅ **Safely convert latitude & longitude**
//   double _parseCoordinate(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble(); // Convert int to double
//     if (value is String) return double.tryParse(value) ?? 0.0; // Convert String to double
//     return 0.0; // Default fallback
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           Map<String, List<DocumentSnapshot>> groupedBookings = {};
//           for (var doc in snapshot.data!.docs) {
//             var data = doc.data() as Map<String, dynamic>;
//             String patientName = data['patientName'] ?? 'Unknown Patient';

//             if (!groupedBookings.containsKey(patientName)) {
//               groupedBookings[patientName] = [];
//             }
//             groupedBookings[patientName]!.add(doc);
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: groupedBookings.entries.map((entry) {
//               String patientName = entry.key;
//               List<DocumentSnapshot> bookings = entry.value;

//               return Card(
//                 margin: EdgeInsets.only(bottom: 16),
//                 elevation: 4,
//                 child: ExpansionTile(
//                   title: Text("🧑 Patient: $patientName", style: TextStyle(fontWeight: FontWeight.bold)),
//                   children: bookings.map((doc) {
//                     var data = doc.data() as Map<String, dynamic>;
//                     String toLocation = data['toLocation'] ?? 'Unknown Location';
//                     String status = data['status'] ?? 'Pending';
//                     String? patientPhone = data['phoneNumber'];

//                     // ✅ **Parse latitude & longitude safely**
//                     double bookingLat = _parseCoordinate(data['fromLocation']?['latitude']);
//                     double bookingLon = _parseCoordinate(data['fromLocation']?['longitude']);

//                     return ListTile(
//                       title: Text("📍 From: $bookingLat, $bookingLon"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("🏥 To: $toLocation"),
//                           Text("📅 Status: $status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                         ],
//                       ),
//                       trailing: PopupMenuButton<String>(
//                         onSelected: (value) {
//                           if (value == "Started Journey") {
//                             _updateStatus(doc.id, "On the way", patientPhone);
//                           } else {
//                             _updateStatus(doc.id, "Accepted", patientPhone);
//                           }
//                         },
//                         itemBuilder: (context) => [
//                           PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                           PopupMenuItem(value: "Started Journey", child: Text("🚑 Started Journey")),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   // Function to update booking status
//   void _updateStatus(String bookingId, String newStatus) {
//     FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//       "status": newStatus,
//     }).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     });
//   }

//   /// ✅ Safely parse latitude & longitude
//   double _parseCoordinate(dynamic value) {
//     if (value == null) return 0.0;
//     if (value is double) return value;
//     if (value is int) return value.toDouble(); // Convert int to double
//     if (value is String) return double.tryParse(value) ?? 0.0; // Convert String to double
//     return 0.0; // Default fallback
//   }

//   /// ✅ Parse DateTime safely
//   String _formatDateTime(dynamic value) {
//     if (value == null) return "Unknown";
//     try {
//       DateTime parsedDate = DateTime.parse(value.toString()).toLocal();
//       return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year} - ${parsedDate.hour}:${parsedDate.minute}";
//     } catch (e) {
//       return "Invalid Date";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Driver Dashboard")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           return ListView(
//             padding: EdgeInsets.all(16.0),
//             children: snapshot.data!.docs.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;

//               // ✅ Ensure 'fromLocation' exists
//               var fromLocation = data['fromLocation'] ?? {};
//               double bookingLat = _parseCoordinate(fromLocation['latitude']);
//               double bookingLon = _parseCoordinate(fromLocation['longitude']);

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName'] ?? 'Unknown'}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: $bookingLat, $bookingLon"),
//                       Text("🏥 To: ${data['toLocation'] ?? 'Unknown Location'}"),
//                       Text("📅 Date & Time: ${_formatDateTime(data['dateTime'])}"),
//                       Text("📌 Status: ${data['status'] ?? 'Pending'}", 
//                           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) => _updateStatus(doc.id, value),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "On the way", child: Text("🚑 On the way")),
//                       PopupMenuItem(value: "Completed", child: Text("✔️ Completed")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   /// ✅ Function to update booking status
//   void _updateStatus(String bookingId, String newStatus) async {
//     try {
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   /// ✅ Convert latitude & longitude safely
//   double _parseCoordinate(dynamic value) {
//     try {
//       if (value == null) return 0.0;
//       if (value is double) return value;
//       if (value is int) return value.toDouble();
//       if (value is String) return double.tryParse(value) ?? 0.0;
//     } catch (e) {
//       print("⚠️ Error parsing coordinate: $e");
//     }
//     return 0.0;
//   }

//   /// ✅ Parse & format DateTime safely
//   String _formatDateTime(dynamic value) {
//     try {
//       if (value == null || value.toString().isEmpty) return "Unknown";
//       DateTime parsedDate = DateTime.parse(value.toString()).toLocal();
//       return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year} - ${parsedDate.hour}:${parsedDate.minute}";
//     } catch (e) {
//       print("⚠️ Error parsing DateTime: $e");
//     }
//     return "Invalid Date";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("RapidCare")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator()); // ✅ Show loading indicator
//           }

//           if (snapshot.hasError) {
//             print("⚠️ Firestore error: ${snapshot.error}");
//             return Center(child: Text("Error loading data"));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text(" No ambulance bookings found."));
//           }

//           var bookings = snapshot.data!.docs;

//           return ListView.builder(
//             padding: EdgeInsets.all(16.0),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               var doc = bookings[index];
//               var data = doc.data() as Map<String, dynamic>;

//               // ✅ Ensure 'fromLocation' exists
//               var fromLocation = data['fromLocation'] ?? {};
//               double bookingLat = _parseCoordinate(fromLocation['latitude']);
//               double bookingLon = _parseCoordinate(fromLocation['longitude']);

//               return Card(
//                 margin: EdgeInsets.only(bottom: 10),
//                 elevation: 3,
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName'] ?? 'Unknown'}"),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📍 From: $bookingLat, $bookingLon"),
//                       Text("🏥 To: ${data['toLocation'] ?? 'Unknown Location'}"),
//                       Text("📅 Date & Time: ${_formatDateTime(data['dateTime'])}"),
//                       Text("📌 Status: ${data['status'] ?? 'Pending'}", 
//                           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) => _updateStatus(doc.id, value),
//                     itemBuilder: (context) => [
//                       PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
//                       PopupMenuItem(value: "On the way", child: Text("🚑 On the way")),
//                       PopupMenuItem(value: "Completed", child: Text("✔️ Completed")),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   /// ✅ Function to update booking status
//   void _updateStatus(String bookingId, String newStatus) async {
//     try {
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   /// ✅ Convert latitude & longitude safely
//   double _parseCoordinate(dynamic value) {
//     try {
//       if (value == null) return 0.0;
//       if (value is double) return value;
//       if (value is int) return value.toDouble();
//       if (value is String) return double.tryParse(value) ?? 0.0;
//     } catch (e) {
//       print("⚠️ Error parsing coordinate: $e");
//     }
//     return 0.0;
//   }

//   /// ✅ Parse & format DateTime safely
//   String _formatDateTime(dynamic value) {
//     try {
//       if (value == null || value.toString().isEmpty) return "Unknown";
//       DateTime parsedDate = DateTime.parse(value.toString()).toLocal();
//       return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year} - ${parsedDate.hour}:${parsedDate.minute}";
//     } catch (e) {
//       print("⚠️ Error parsing DateTime: $e");
//     }
//     return "Invalid Date";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("🚑 Driver Dashboard"),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator()); // ✅ Show loading indicator
//           }

//           if (snapshot.hasError) {
//             print("⚠️ Firestore error: ${snapshot.error}");
//             return Center(child: Text("Error loading data"));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           var bookings = snapshot.data!.docs;

//           return ListView.builder(
//             padding: EdgeInsets.all(16.0),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               var doc = bookings[index];
//               var data = doc.data() as Map<String, dynamic>;

//               // ✅ Ensure 'fromLocation' exists
//               var fromLocation = data['fromLocation'] ?? {};
//               double bookingLat = _parseCoordinate(fromLocation['latitude']);
//               double bookingLon = _parseCoordinate(fromLocation['longitude']);

//               // ✅ Determine status color
//               Color statusColor = Colors.grey;
//               if (data['status'] == "Accepted") statusColor = Colors.blue;
//               if (data['status'] == "On the way") statusColor = Colors.orange;
//               if (data['status'] == "Completed") statusColor = Colors.green;

//               return Card(
//                 margin: EdgeInsets.only(bottom: 15),
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // ✅ Patient Name
//                       Row(
//                         children: [
//                           Icon(Icons.person, color: Colors.black54),
//                           SizedBox(width: 8),
//                           Text(
//                             "Patient: ${data['patientName'] ?? 'Unknown'}",
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 6),

//                       // ✅ Source Location
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, color: Colors.red),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               "From: $bookingLat, $bookingLon",
//                               style: TextStyle(color: Colors.black87),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4),

//                       // ✅ Destination Location
//                       Row(
//                         children: [
//                           Icon(Icons.local_hospital, color: Colors.green),
//                           SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               "To: ${data['toLocation'] ?? 'Unknown Location'}",
//                               style: TextStyle(color: Colors.black87),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 4),

//                       // ✅ Booking Date & Time
//                       Row(
//                         children: [
//                           Icon(Icons.access_time, color: Colors.blue),
//                           SizedBox(width: 8),
//                           Text(
//                             _formatDateTime(data['dateTime']),
//                             style: TextStyle(color: Colors.black87),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 8),

//                       // ✅ Status Display
//                       Row(
//                         children: [
//                           Icon(Icons.info, color: statusColor),
//                           SizedBox(width: 8),
//                           Text(
//                             "Status: ${data['status'] ?? 'Pending'}",
//                             style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 12),

//                       // ✅ Status Action Buttons
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton.icon(
//                             onPressed: () => _updateStatus(doc.id, "Accepted"),
//                             icon: Icon(Icons.check_circle, color: Colors.white),
//                             label: Text("Accept"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                             ),
//                           ),
//                           ElevatedButton.icon(
//                             onPressed: () => _updateStatus(doc.id, "On the way"),
//                             icon: Icon(Icons.local_shipping, color: Colors.white),
//                             label: Text("On the way"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.deepOrangeAccent,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                             ),
//                           ),
//                           ElevatedButton.icon(
//                             onPressed: () => _updateStatus(doc.id, "Completed"),
//                             icon: Icon(Icons.done, color: Colors.white),
//                             label: Text("Completed"),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geocoding/geocoding.dart';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   /// ✅ Function to update booking status
//   void _updateStatus(String bookingId, String newStatus) async {
//     try {
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   /// ✅ Convert latitude & longitude safely
//   double _parseCoordinate(dynamic value) {
//     try {
//       if (value == null) return 0.0;
//       if (value is double) return value;
//       if (value is int) return value.toDouble();
//       if (value is String) return double.tryParse(value) ?? 0.0;
//     } catch (e) {
//       print("⚠️ Error parsing coordinate: $e");
//     }
//     return 0.0;
//   }

//   /// ✅ Convert Coordinates to Address
//   Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         return "${place.locality}, ${place.administrativeArea}";
//       }
//     } catch (e) {
//       print("⚠️ Error getting address: $e");
//     }
//     return "Unknown Location";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Driver Dashboard"),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator()); // ✅ Show loading indicator
//           }

//           if (snapshot.hasError) {
//             print("⚠️ Firestore error: ${snapshot.error}");
//             return Center(child: Text("Error loading data"));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           var bookings = snapshot.data!.docs;

//           return ListView.builder(
//             padding: EdgeInsets.all(16.0),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               var doc = bookings[index];
//               var data = doc.data() as Map<String, dynamic>;

//               // ✅ Ensure 'fromLocation' exists
//               var fromLocation = data['fromLocation'] ?? {};
//               double bookingLat = _parseCoordinate(fromLocation['latitude']);
//               double bookingLon = _parseCoordinate(fromLocation['longitude']);

//               return FutureBuilder<String>(
//                 future: _getAddressFromCoordinates(bookingLat, bookingLon),
//                 builder: (context, addressSnapshot) {
//                   String address = addressSnapshot.data ?? "Fetching location...";

//                   return Card(
//                     margin: EdgeInsets.only(bottom: 15),
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // ✅ Patient Name
//                           Row(
//                             children: [
//                               Icon(Icons.person, color: Colors.black54),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Patient: ${data['patientName'] ?? 'Unknown'}",
//                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 6),

//                           // ✅ Source Location (Converted Address)
//                           Row(
//                             children: [
//                               Icon(Icons.location_on, color: Colors.red),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   "From: $address",
//                                   style: TextStyle(color: Colors.black87),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4),

//                           // ✅ Destination Location
//                           Row(
//                             children: [
//                               Icon(Icons.local_hospital, color: Colors.green),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   "To: ${data['toLocation'] ?? 'Unknown Location'}",
//                                   style: TextStyle(color: Colors.black87),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4),

//                           // ✅ Booking Date & Time
//                           Row(
//                             children: [
//                               Icon(Icons.access_time, color: Colors.blue),
//                               SizedBox(width: 8),
//                               Text(
//                                 data['dateTime'] ?? "Unknown Date",
//                                 style: TextStyle(color: Colors.black87),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 8),

//                           // ✅ Status Display
//                           Row(
//                             children: [
//                               Icon(Icons.info, color: Colors.blueAccent),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Status: ${data['status'] ?? 'Pending'}",
//                                 style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 12),

//                           // ✅ Status Action Buttons (Aligned Properly)
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Expanded(
//                                 child: ElevatedButton.icon(
//                                   onPressed: () => _updateStatus(doc.id, "Accepted"),
//                                   icon: Icon(Icons.check_circle, color: Colors.white),
//                                   label: Text("Accept"),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blueAccent,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: ElevatedButton.icon(
//                                   onPressed: () => _updateStatus(doc.id, "On the way"),
//                                   icon: Icon(Icons.local_shipping, color: Colors.white),
//                                   label: Text("On the way"),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blueAccent,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: ElevatedButton.icon(
//                                   onPressed: () => _updateStatus(doc.id, "Completed"),
//                                   icon: Icon(Icons.done, color: Colors.white),
//                                   label: Text("Completed"),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.blueAccent,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// // import 'package:flutter_dotenv/flutter_dotenv.dart';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize Twilio
//    TwilioFlutter twilioFlutter = TwilioFlutter(
//     accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//     authToken: 'cf85d34c06f19d6d862df21c11c576df',
//     twilioNumber: '+19897839571',
//   );
//   }

//   /// ✅ Function to update booking status in Firestore and send SMS if needed
//   void _updateStatus(String bookingId, String newStatus, String userPhone, double lat, double lon) async {
//     try {
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
//         "status": newStatus,
//       });

//       if (newStatus == "On the way") {
//         String locationUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
//         String message = " Your ambulance is on the way! Track its location here: $locationUrl";

//         _sendSMS(userPhone, message);
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Status updated to $newStatus")),
//       );
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error updating status: $error")),
//       );
//     }
//   }

//   /// ✅ Function to send SMS via Twilio
//   void _sendSMS(String userPhone, String message) async {
//     try {
//       await twilioFlutter.sendSMS(
//         toNumber: userPhone,
//         messageBody: message,
//       );
//       print("✅ SMS sent to $userPhone");
//     } catch (e) {
//       print("⚠️ Error sending SMS: $e");
//     }
//   }

//   /// ✅ Convert latitude & longitude safely
//   double _parseCoordinate(dynamic value) {
//     try {
//       if (value == null) return 0.0;
//       if (value is double) return value;
//       if (value is int) return value.toDouble();
//       if (value is String) return double.tryParse(value) ?? 0.0;
//     } catch (e) {
//       print("⚠️ Error parsing coordinate: $e");
//     }
//     return 0.0;
//   }

//   /// ✅ Convert Coordinates to Address
//   Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         return "${place.locality}, ${place.administrativeArea}";
//       }
//     } catch (e) {
//       print("⚠️ Error getting address: $e");
//     }
//     return "Unknown Location";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(" Driver Dashboard"),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             print("⚠️ Firestore error: ${snapshot.error}");
//             return Center(child: Text("Error loading data"));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           var bookings = snapshot.data!.docs;

//           return ListView.builder(
//             padding: EdgeInsets.all(16.0),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               var doc = bookings[index];
//               var data = doc.data() as Map<String, dynamic>;

//               var fromLocation = data['fromLocation'] ?? {};
//               double bookingLat = _parseCoordinate(fromLocation['latitude']);
//               double bookingLon = _parseCoordinate(fromLocation['longitude']);

//               return FutureBuilder<String>(
//                 future: _getAddressFromCoordinates(bookingLat, bookingLon),
//                 builder: (context, addressSnapshot) {
//                   String address = addressSnapshot.data ?? "Fetching location...";

//                   return Card(
//                     margin: EdgeInsets.only(bottom: 15),
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.person, color: Colors.black54),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Patient: ${data['patientName'] ?? 'Unknown'}",
//                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 6),
//                           Row(
//                             children: [
//                               Icon(Icons.location_on, color: Colors.red),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   "From: $address",
//                                   style: TextStyle(color: Colors.black87),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Icon(Icons.local_hospital, color: Colors.green),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   "To: ${data['toLocation'] ?? 'Unknown Location'}",
//                                   style: TextStyle(color: Colors.black87),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 12),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton.icon(
//                                 onPressed: () => _updateStatus(doc.id, "Accepted", data['phoneNumber'], bookingLat, bookingLon),
//                                 icon: Icon(Icons.check_circle, color: Colors.white),
//                                 label: Text("Accept"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
//                               ),
//                               ElevatedButton.icon(
//                                 onPressed: () => _updateStatus(doc.id, "On the way", data['phoneNumber'], bookingLat, bookingLon),
//                                 icon: Icon(Icons.local_shipping, color: Colors.white),
//                                 label: Text("On the way"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                               ),
//                               ElevatedButton.icon(
//                                 onPressed: () => _updateStatus(doc.id, "Completed", data['phoneNumber'], bookingLat, bookingLon),
//                                 icon: Icon(Icons.done, color: Colors.white),
//                                 label: Text("Completed"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverDashboard extends StatefulWidget {
  @override
  _DriverDashboardState createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  late TwilioFlutter twilioFlutter;

  @override
  void initState() {
    super.initState();
    // Initialize Twilio
    twilioFlutter = TwilioFlutter(
      accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
      authToken: 'cf85d34c06f19d6d862df21c11c576df',
      twilioNumber: '+19897839571',
    );
  }

  /// ✅ Function to update booking status in Firestore and send SMS if needed
  void _updateStatus(String bookingId, String newStatus, String userPhone, double lat, double lon) async {
    try {
      await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
        "status": newStatus,
      });

      if (newStatus == "On the way") {
        String locationUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
        String message = "Your ambulance is on the way! Track its location here: $locationUrl";

        _sendSMS(userPhone, message);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Status updated to $newStatus")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error updating status: $error")),
      );
    }
  }

  /// ✅ Function to send SMS via Twilio
  void _sendSMS(String userPhone, String message) async {
    try {
      await twilioFlutter.sendSMS(
        toNumber: userPhone,
        messageBody: message,
      );
      print("✅ SMS sent to $userPhone");
    } catch (e) {
      print("⚠️ Error sending SMS: $e");
    }
  }

  /// ✅ Convert latitude & longitude safely
  double _parseCoordinate(dynamic value) {
    try {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
    } catch (e) {
      print("⚠️ Error parsing coordinate: $e");
    }
    return 0.0;
  }

  /// ✅ Convert Coordinates to Address
  Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.locality}, ${place.administrativeArea}";
      }
    } catch (e) {
      print("⚠️ Error getting address: $e");
    }
    return "Unknown Location";
  }

  /// ✅ Function to launch Google Maps with the location
  void _launchMaps(double latitude, double longitude) async {
    String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Dashboard"),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("⚠️ Firestore error: ${snapshot.error}");
            return Center(child: Text("Error loading data"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No ambulance bookings found."));
          }

          var bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var doc = bookings[index];
              var data = doc.data() as Map<String, dynamic>;

              var fromLocation = data['fromLocation'] ?? {};
              double bookingLat = _parseCoordinate(fromLocation['latitude']);
              double bookingLon = _parseCoordinate(fromLocation['longitude']);

              return FutureBuilder<String>(
                future: _getAddressFromCoordinates(bookingLat, bookingLon),
                builder: (context, addressSnapshot) {
                  String address = addressSnapshot.data ?? "Fetching location...";

                  return Card(
                    margin: EdgeInsets.only(bottom: 15),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.black54),
                              SizedBox(width: 8),
                              Text(
                                "Patient: ${data['patientName'] ?? 'Unknown'}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => _launchMaps(bookingLat, bookingLon),
                            child: Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.red),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "From: $address",
                                    style: TextStyle(color: Colors.black87, decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.local_hospital, color: Colors.green),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "To: ${data['toLocation'] ?? 'Unknown Location'}",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _updateStatus(doc.id, "Accepted", data['phoneNumber'], bookingLat, bookingLon),
                                icon: Icon(Icons.check_circle, color: Colors.white),
                                label: Text("Accept"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _updateStatus(doc.id, "On the way", data['phoneNumber'], bookingLat, bookingLon),
                                icon: Icon(Icons.local_shipping, color: Colors.white),
                                label: Text("On the way"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _updateStatus(doc.id, "Completed", data['phoneNumber'], bookingLat, bookingLon),
                                icon: Icon(Icons.done, color: Colors.white),
                                label: Text("Completed"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class DriverDashboard extends StatefulWidget {
//   @override
//   _DriverDashboardState createState() => _DriverDashboardState();
// }

// class _DriverDashboardState extends State<DriverDashboard> {
//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//       authToken: 'cf85d34c06f19d6d862df21c11c576df',
//       twilioNumber: '+19897839571',
//     );
//   }

//   void _updateStatus(String bookingId, String newStatus, String userPhone, double lat, double lon) async {
//     try {
//       await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({"status": newStatus});

//       if (newStatus == "On the way") {
//         String locationUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
//         String message = "Your ambulance is on the way! Track its location here: $locationUrl";
//         _sendSMS(userPhone, message);
//       }

//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Status updated to $newStatus")));
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ Error updating status: $error")));
//     }
//   }

//   void _sendSMS(String userPhone, String message) async {
//     try {
//       await twilioFlutter.sendSMS(toNumber: userPhone, messageBody: message);
//       print("✅ SMS sent to $userPhone");
//     } catch (e) {
//       print("⚠️ Error sending SMS: $e");
//     }
//   }

//   double _parseCoordinate(dynamic value) {
//     try {
//       if (value == null) return 0.0;
//       if (value is double) return value;
//       if (value is int) return value.toDouble();
//       if (value is String) return double.tryParse(value) ?? 0.0;
//     } catch (e) {
//       print("⚠️ Error parsing coordinate: $e");
//     }
//     return 0.0;
//   }

//   Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//       if (placemarks.isNotEmpty) {
//         return "${placemarks.first.locality}, ${placemarks.first.administrativeArea}";
//       }
//     } catch (e) {
//       print("⚠️ Error getting address: $e");
//     }
//     return "Unknown Location";
//   }

//   void _launchMaps(double latitude, double longitude) async {
//     String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//     if (await canLaunch(googleMapsUrl)) {
//       await launch(googleMapsUrl);
//     } else {
//       throw 'Could not open the map.';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Driver Dashboard"),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('booking_status').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             print("⚠️ Firestore error: ${snapshot.error}");
//             return Center(child: Text("Error loading data"));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No ambulance bookings found."));
//           }

//           var bookings = snapshot.data!.docs
//               .where((doc) => (doc.data() as Map<String, dynamic>)['status'] != "Completed")
//               .toList(); // ❌ Remove 'Completed' bookings

//           if (bookings.isEmpty) {
//             return Center(child: Text("No active bookings."));
//           }

//           return ListView.builder(
//             padding: EdgeInsets.all(16.0),
//             itemCount: bookings.length,
//             itemBuilder: (context, index) {
//               var doc = bookings[index];
//               var data = doc.data() as Map<String, dynamic>;

//               var fromLocation = data['fromLocation'] ?? {};
//               double bookingLat = _parseCoordinate(fromLocation['latitude']);
//               double bookingLon = _parseCoordinate(fromLocation['longitude']);

//               return FutureBuilder<String>(
//                 future: _getAddressFromCoordinates(bookingLat, bookingLon),
//                 builder: (context, addressSnapshot) {
//                   String address = addressSnapshot.data ?? "Fetching location...";

//                   return Card(
//                     margin: EdgeInsets.only(bottom: 15),
//                     elevation: 3,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(Icons.person, color: Colors.black54),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Patient: ${data['patientName'] ?? 'Unknown'}",
//                                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 6),
//                           GestureDetector(
//                             onTap: () => _launchMaps(bookingLat, bookingLon),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.location_on, color: Colors.red),
//                                 SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     "From: $address",
//                                     style: TextStyle(color: Colors.black87, decoration: TextDecoration.underline),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Icon(Icons.local_hospital, color: Colors.green),
//                               SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   "To: ${data['toLocation'] ?? 'Unknown Location'}",
//                                   style: TextStyle(color: Colors.black87),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: 12),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton.icon(
//                                 onPressed: () => _updateStatus(doc.id, "Accepted", data['phoneNumber'], bookingLat, bookingLon),
//                                 icon: Icon(Icons.check_circle, color: Colors.white),
//                                 label: Text("Accept"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
//                               ),
//                               ElevatedButton.icon(
//                                 onPressed: () => _updateStatus(doc.id, "On the way", data['phoneNumber'], bookingLat, bookingLon),
//                                 icon: Icon(Icons.local_shipping, color: Colors.white),
//                                 label: Text("On the way"),
//                                 style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }



