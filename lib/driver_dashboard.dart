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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'dart:math';

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

  /// 🚑 Update Booking Status & Notify Patient via SMS
  void _updateStatus(String bookingId, String newStatus, String? patientPhone) async {
    try {
      // Update Firestore booking status
      await FirebaseFirestore.instance.collection('booking_status').doc(bookingId).update({
        "status": newStatus,
      });

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Status updated to $newStatus")),
      );

      // If the status is "On the way", send SMS to the patient
      if (newStatus == "On the way" && patientPhone != null && patientPhone.isNotEmpty) {
        await twilioFlutter.sendSMS(
          toNumber: patientPhone,
          messageBody: "🚑 Alert: Your ambulance is on the way! Stay ready for pickup.",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("📩 SMS sent to patient.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error updating status: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" Driver Dashboard")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('booking_status')
            .where('status', isEqualTo: 'pending') // Fetch only pending bookings
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No pending ambulance bookings found."));
          }

          List<DocumentSnapshot> bookings = snapshot.data!.docs;

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: bookings.map((doc) {
              var data = doc.data() as Map<String, dynamic>;

              String patientName = data['patientName'] ?? 'Unknown Patient';
              String toLocation = data['toLocation'] ?? 'Unknown Location';
              String status = data['status'] ?? 'Pending';
              String? patientPhone = data['phoneNumber']; // Fetch phone directly from 'booking_status'

              // Fetching 'fromLocation' with latitude and longitude
              double bookingLat = data['fromLocation']?['latitude'] ?? 0.0;
              double bookingLon = data['fromLocation']?['longitude'] ?? 0.0;

              return Card(
                margin: EdgeInsets.only(bottom: 10),
                elevation: 3,
                child: ListTile(
                  title: Text("🧑 Patient: $patientName"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📍 From: $bookingLat, $bookingLon"),
                      Text("🏥 To: $toLocation"),
                      Text("📅 Status: $status", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "Started Journey") {
                        _updateStatus(doc.id, "On the way", patientPhone);
                      } else {
                        _updateStatus(doc.id, "Accepted", patientPhone);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: "Accepted", child: Text("✅ Accept")),
                      PopupMenuItem(value: "Started Journey", child: Text("🚑 Started Journey")),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}


