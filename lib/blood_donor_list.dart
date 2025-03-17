// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class BloodDonorListPage extends StatelessWidget {
//   final String bloodGroup;

//   BloodDonorListPage({required this.bloodGroup});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Blood Donors - $bloodGroup")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .where('role', isEqualTo: 'Blood Donor') // ✅ Only Blood Donors
//             .where('bloodGroup', isEqualTo: bloodGroup) // ✅ Matching Blood Group
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No donors available for $bloodGroup"));
//           }

//           var donors = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: donors.length,
//             itemBuilder: (context, index) {
//               var donor = donors[index];

//               return Card(
//                 margin: EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text(donor['name'] ?? "Unknown", style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📧 Email: ${donor['email'] ?? 'N/A'}"),
//                       Text("📞 Phone: ${donor['phone'] ?? 'N/A'}"),
//                     ],
//                   ),
//                   trailing: IconButton(
//                     icon: Icon(Icons.phone, color: Colors.green),
//                     onPressed: () {
//                       _makePhoneCall(donor['phone']);
//                     },
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   /// ✅ Function to Make a Phone Call
//   void _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       print("❌ Could not launch call");
//     }
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BloodDonorListPage extends StatelessWidget {
//   final String bloodGroup;

//   BloodDonorListPage({required this.bloodGroup});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Blood Donors - $bloodGroup")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .where('role', isEqualTo: 'Blood Donor') // ✅ Only Blood Donors
//             .where('bloodGroup', isEqualTo: bloodGroup) // ✅ Matching Blood Group
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No donors available for $bloodGroup"));
//           }

//           var donors = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: donors.length,
//             itemBuilder: (context, index) {
//               var donor = donors[index];

//               return Card(
//                 margin: EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text(donor['name'] ?? "Unknown", style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("📧 Email: ${donor['email'] ?? 'N/A'}"),
//                       Text("📞 Phone: ${donor['phone'] ?? 'N/A'}"),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.phone, color: Colors.green),
//                         onPressed: () {
//                           _makePhoneCall(donor['phone']);
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.notification_important, color: Colors.red),
//                         onPressed: () {
//                           _sendAlertToDonor(donor.id, donor['name']);
//                         },
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

//   /// ✅ Function to Make a Phone Call
//   void _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       print("❌ Could not launch call");
//     }
//   }

//   /// ✅ Function to Send Emergency Alert to Blood Donors
//   void _sendAlertToDonor(String donorId, String donorName) async {
//     try {
//       // 🔥 Get the Firebase Messaging Token of the donor
//       DocumentSnapshot donorDoc =
//           await FirebaseFirestore.instance.collection('users').doc(donorId).get();

//       String? donorToken = donorDoc['fcmToken']; // Token field in Firestore
//       if (donorToken != null) {
//         await FirebaseFirestore.instance.collection('notifications').add({
//           'token': donorToken,
//           'title': "🚨 Blood Donation Request",
//           'body': "Urgent request for blood donation! Please respond quickly.",
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         print("✅ Alert sent to $donorName!");
//       } else {
//         print("❌ Donor does not have a valid FCM Token");
//       }
//     } catch (e) {
//       print("❌ Failed to send alert: $e");
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BloodDonorListPage extends StatelessWidget {
  final String bloodGroup;

  BloodDonorListPage({required this.bloodGroup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blood Donors - $bloodGroup")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Blood Donor')
            .where('bloodGroup', isEqualTo: bloodGroup)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No donors available for $bloodGroup"));
          }

          var donors = snapshot.data!.docs;

          return ListView.builder(
            itemCount: donors.length,
            itemBuilder: (context, index) {
              var donor = donors[index];

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(donor['name'] ?? "Unknown", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📧 Email: ${donor['email'] ?? 'N/A'}"),
                      Text("📞 Phone: ${donor['phone'] ?? 'N/A'}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.phone, color: Colors.green),
                        onPressed: () {
                          _makePhoneCall(donor['phone']);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.notification_important, color: Colors.red),
                        onPressed: () {
                          _sendAlertToDonor(donor.id, donor['name'], donor['phone'], context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ✅ Function to Make a Phone Call
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print("❌ Could not launch call");
    }
  }

  /// ✅ Function to Send Alert to a Specific Donor
  void _sendAlertToDonor(String donorId, String donorName, String donorPhone, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('blood_requests').add({
        'donorId': donorId,
        'donorName': donorName,
        'donorPhone': donorPhone,
        'status': 'Pending',
        'requestedBy': FirebaseAuth.instance.currentUser!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("🚀 Alert sent to $donorName! Waiting for response.")),
      );
    } catch (e) {
      print("❌ Failed to send alert: $e");
    }
  }
}
