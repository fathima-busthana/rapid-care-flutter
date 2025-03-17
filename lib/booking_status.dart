// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BookingStatusPage extends StatelessWidget {
//   final String userId; // Required parameter for user ID

//   BookingStatusPage({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("📌 My Ambulance Booking")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('booking_status')
//             .where("userId", isEqualTo: userId) // Fetch only the user's booking
//             .orderBy("createdAt", descending: true) // Show latest booking first
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No active bookings found."));
//           }

//           var booking = snapshot.data!.docs.first; // Get latest booking
//           var data = booking.data() as Map<String, dynamic>;

//           return Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("🏥 Hospital: ${data['toLocation']}", 
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 10),
//                 Text("📅 Date: ${data['dateTime'].toString().split('T')[0]}"),
//                 Text("⏰ Time: ${DateTime.parse(data['dateTime']).toLocal().hour}:" 
//                     "${DateTime.parse(data['dateTime']).toLocal().minute}"),
//                 SizedBox(height: 10),
//                 Text("📌 Current Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Text(
//                   data['status'], // Display real-time status
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: _getStatusColor(data['status']),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Center(
//                   child: Image.asset(_getStatusIcon(data['status']), height: 100),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Get color based on status
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Accepted":
//         return Colors.orange;
//       case "On the way":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       default:
//         return Colors.red;
//     }
//   }

//   // Get image based on status
//   String _getStatusIcon(String status) {
//     switch (status) {
//       case "Accepted":
//         return "assets/accepted.png"; // Replace with actual image paths
//       case "On the way":
//         return "assets/ambulance.png";
//       case "Completed":
//         return "assets/completed.png";
//       default:
//         return "assets/pending.png";
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BookingStatusPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     User? currentUser = FirebaseAuth.instance.currentUser; // Get the logged-in user

//     if (currentUser == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text("📌 Booking Status")),
//         body: Center(child: Text("❌ You are not logged in!")),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text("📌 My Ambulance Booking")),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('booking_status')
//             .where("userId", isEqualTo: currentUser.uid) // Fetch user's booking
//             .orderBy("createdAt", descending: true) // Show latest first
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text("❌ Error loading data"));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("📌 No active bookings found."));
//           }

//           var booking = snapshot.data!.docs.first; // Get latest booking
//           var data = booking.data() as Map<String, dynamic>;

//           return _buildBookingDetails(data);
//         },
//       ),
//     );
//   }

//   Widget _buildBookingDetails(Map<String, dynamic> data) {
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("🏥 Hospital: ${data['toLocation']}", 
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Text("📅 Date: ${data['dateTime'].toString().split('T')[0]}"),
//           Text("⏰ Time: ${DateTime.parse(data['dateTime']).toLocal().hour}:"
//               "${DateTime.parse(data['dateTime']).toLocal().minute}"),
//           SizedBox(height: 10),
//           Text("📌 Current Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Text(
//             data['status'], // Display real-time status
//             style: TextStyle(
//               fontSize: 20,
//               color: _getStatusColor(data['status']),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Image.asset(_getStatusIcon(data['status']), height: 100),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Accepted": return Colors.orange;
//       case "On the way": return Colors.blue;
//       case "Completed": return Colors.green;
//       default: return Colors.red;
//     }
//   }

//   String _getStatusIcon(String status) {
//     switch (status) {
//       case "Accepted": return "assets/accepted.png";
//       case "On the way": return "assets/ambulance.png";
//       case "Completed": return "assets/completed.png";
//       default: return "assets/pending.png";
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BookingStatusPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     User? currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text("📌 Booking Status")),
//         body: Center(child: Text("❌ You are not logged in!")),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text("📌 My Ambulance Booking")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('booking_status')
//             .where("userId", isEqualTo: currentUser.uid)
//             .orderBy("createdAt", descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text("❌ Error loading data: ${snapshot.error}"));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("📌 No active bookings found."));
//           }

//           var booking = snapshot.data!.docs.first;
//           var data = booking.data() as Map<String, dynamic>;

//           if (!data.containsKey('toLocation') ||
//               !data.containsKey('dateTime') ||
//               !data.containsKey('status')) {
//             return Center(child: Text("❌ Invalid booking data"));
//           }

//           return _buildBookingDetails(context, data);
//         },
//       ),
//     );
//   }

//   Widget _buildBookingDetails(BuildContext context, Map<String, dynamic> data) {
//     DateTime dateTime = DateTime.parse(data['dateTime']).toLocal();
//     TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);

//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("🏥 Hospital: ${data['toLocation']}",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Text("📅 Date: ${dateTime.toString().split(' ')[0]}"),
//           Text("⏰ Time: ${timeOfDay.format(context)}"), // Fixed: Pass context
//           SizedBox(height: 10),
//           Text("📌 Current Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Text(
//             data['status'],
//             style: TextStyle(
//               fontSize: 20,
//               color: _getStatusColor(data['status']),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 20),
//           Center(
//             child: Image.asset(_getStatusIcon(data['status']), height: 100),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Accepted":
//         return Colors.orange;
//       case "On the way":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       default:
//         return Colors.red;
//     }
//   }

//   String _getStatusIcon(String status) {
//     switch (status) {
//       case "Accepted":
//         return "assets/accepted.png";
//       case "On the way":
//         return "assets/ambulance.png";
//       case "Completed":
//         return "assets/completed.png";
//       default:
//         return "assets/pending.png";
//     }
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BookingStatusPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     User? currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       return Scaffold(
//         appBar: AppBar(title: Text("📌 Booking Status")),
//         body: Center(child: Text("❌ You are not logged in!")),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text("📌 My Ambulance Booking")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('booking_status')
//             .where("userId", isEqualTo: currentUser.uid)
//             .orderBy("createdAt", descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text("❌ Error loading data: ${snapshot.error}"));
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("📌 No active bookings found."));
//           }

//           var booking = snapshot.data!.docs.first;
//           var data = booking.data() as Map<String, dynamic>;

//           if (!data.containsKey('toLocation') ||
//               !data.containsKey('dateTime') ||
//               !data.containsKey('status')) {
//             return Center(child: Text("❌ Invalid booking data"));
//           }

//           return _buildBookingDetails(context, data);
//         },
//       ),
//     );
//   }

//   Widget _buildBookingDetails(BuildContext context, Map<String, dynamic> data) {
//     DateTime dateTime = DateTime.parse(data['dateTime']).toLocal();
//     TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);

//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("🏥 Hospital: ${data['toLocation']}",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           Text("📅 Date: ${dateTime.toString().split(' ')[0]}"),
//           Text("⏰ Time: ${timeOfDay.format(context)}"),
//           SizedBox(height: 10),
//           Text("📌 Current Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           Text(
//             data['status'],
//             style: TextStyle(
//               fontSize: 20,
//               color: _getStatusColor(data['status']),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case "Accepted":
//         return Colors.orange;
//       case "On the way":
//         return Colors.blue;
//       case "Completed":
//         return Colors.green;
//       default:
//         return Colors.red;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text("📌 Booking Status")),
        body: Center(child: Text("❌ You are not logged in!")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("📌 My Ambulance Booking")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('booking_status')
            .where("userId", isEqualTo: currentUser.uid)
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
          }

          if (snapshot.hasError) {
            return Center(child: Text("❌ Error loading data: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("📌 No active bookings found."));
          }

          // Safe access to the first document
          var booking = snapshot.data!.docs.first;
          var data = booking.data() as Map<String, dynamic>?;

          if (data == null ||
              !data.containsKey('toLocation') ||
              !data.containsKey('dateTime') ||
              !data.containsKey('status')) {
            return Center(child: Text("❌ Invalid booking data"));
          }

          return _buildBookingDetails(context, data);
        },
      ),
    );
  }

  Widget _buildBookingDetails(BuildContext context, Map<String, dynamic> data) {
    DateTime dateTime;
    TimeOfDay timeOfDay;

    try {
      dateTime = DateTime.parse(data['dateTime']).toLocal();
      timeOfDay = TimeOfDay.fromDateTime(dateTime);
    } catch (e) {
      return Center(child: Text("❌ Error parsing date/time."));
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🏥 Hospital: ${data['toLocation']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("📅 Date: ${dateTime.toString().split(' ')[0]}"),
          Text("⏰ Time: ${timeOfDay.format(context)}"),
          SizedBox(height: 10),
          Text("📌 Current Status:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(
            data['status'],
            style: TextStyle(
              fontSize: 20,
              color: _getStatusColor(data['status']),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Accepted":
        return Colors.orange;
      case "On the way":
        return Colors.blue;
      case "Completed":
        return Colors.green;
      default:
        return Colors.red;
    }
  }
}
