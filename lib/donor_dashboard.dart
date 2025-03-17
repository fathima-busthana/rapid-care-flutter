// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class DonorResponsePage extends StatelessWidget {
//   final String requestId;

//   DonorResponsePage({required this.requestId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Confirm Blood Donation")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("Will you donate blood?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _updateStatus(requestId, 'Accepted', context),
//               child: Text("✅ Accept"),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => _updateStatus(requestId, 'Declined', context),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               child: Text("❌ Decline"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _updateStatus(String requestId, String status, BuildContext context) async {
//     await FirebaseFirestore.instance.collection('blood_requests').doc(requestId).update({
//       'status': status,
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Status updated to $status")),
//     );

//     Navigator.pop(context);
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class BloodRequestsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Pending Blood Requests")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('blood_requests')
//             .where('status', isEqualTo: 'Pending') // ✅ Show only pending requests
//             .orderBy('timestamp', descending: true) // Latest first
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No pending blood requests."));
//           }

//           var requests = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: requests.length,
//             itemBuilder: (context, index) {
//               var request = requests[index];
//               String requestId = request.id; // ✅ Unique ID of request
//               String bloodGroup = request['bloodGroup'];
//               String requesterName = request['requesterName'];
//               String requesterPhone = request['requesterPhone'];

//               return Card(
//                 margin: EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text("Blood Group: $bloodGroup", style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("👤 Name: $requesterName"),
//                       Text("📞 Phone: $requesterPhone"),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => _updateStatus(requestId, 'Accepted', context),
//                         child: Text("✅ Accept"),
//                       ),
//                       SizedBox(width: 5),
//                       ElevatedButton(
//                         onPressed: () => _updateStatus(requestId, 'Declined', context),
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                         child: Text("❌ Decline"),
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

//   /// ✅ **Update Firestore when donor accepts/declines**
//   void _updateStatus(String requestId, String status, BuildContext context) async {
//     await FirebaseFirestore.instance.collection('blood_requests').doc(requestId).update({
//       'status': status,
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Status updated to $status")),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class DonorDashboardPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("💉 Blood Donor Dashboard")),
//       body: Column(
//         children: [
//           _dashboardTile("📋 View & Respond to Requests", () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => BloodRequestsPage()),
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   Widget _dashboardTile(String title, VoidCallback onTap) {
//     return Card(
//       margin: EdgeInsets.all(8),
//       child: ListTile(
//         title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         trailing: Icon(Icons.arrow_forward_ios),
//         onTap: onTap,
//       ),
//     );
//   }
// }

// class BloodRequestsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Pending Blood Requests")),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('blood_requests')
//             .where('status', isEqualTo: 'Pending') // ✅ Fetch only Pending requests
//             .orderBy('timestamp', descending: true) // ✅ Latest first
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("No pending blood requests."));
//           }

//           var requests = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: requests.length,
//             itemBuilder: (context, index) {
//               var request = requests[index];
//               String requestId = request.id; // ✅ Unique request ID
//               String bloodGroup = request['bloodGroup'];
//               String requesterName = request['requesterName'];
//               String requesterPhone = request['requesterPhone'];

//               return Card(
//                 margin: EdgeInsets.all(8),
//                 child: ListTile(
//                   title: Text("Blood Group: $bloodGroup", style: TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("👤 Name: $requesterName"),
//                       Text("📞 Phone: $requesterPhone"),
//                     ],
//                   ),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => _updateStatus(requestId, 'Accepted', context),
//                         child: Text("✅ Accept"),
//                       ),
//                       SizedBox(width: 5),
//                       ElevatedButton(
//                         onPressed: () => _updateStatus(requestId, 'Declined', context),
//                         style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                         child: Text("❌ Decline"),
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

//   /// ✅ **Update Firestore when donor accepts/declines**
//   void _updateStatus(String requestId, String status, BuildContext context) async {
//     try {
//       print("🔄 Updating request ID: $requestId to status: $status");

//       await FirebaseFirestore.instance.collection('blood_requests').doc(requestId).update({
//         'status': status,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Status updated to $status")),
//       );
//     } catch (e) {
//       print("❌ Error updating status: $e");
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonorDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("💉 Blood Donor Dashboard")),
      body: Column(
        children: [
          _dashboardTile("📋 View & Respond to Requests", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BloodRequestsPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _dashboardTile(String title, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class BloodRequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🚑 Pending Blood Requests")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('blood_requests')
            .where('status', isEqualTo: 'Pending') // ✅ Fetch only Pending requests
            .orderBy('timestamp', descending: true) // ✅ Latest first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Debugging: Print snapshot data
          print("📡 Firestore Response: ${snapshot.data?.docs.length ?? 0} requests found");

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No pending blood requests."));
          }

          var requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index];

              // ✅ Safe Data Fetching (Avoids App Crash)
              String requestId = request.id; // Unique request ID
              String bloodGroup = request['bloodGroup'] ?? "Unknown";
              String requesterName = request['requesterName'] ?? "Anonymous";
              String requesterPhone = request['requesterPhone'] ?? "Not Available";

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Blood Group: $bloodGroup", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("👤 Name: $requesterName"),
                      Text("📞 Phone: $requesterPhone"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => _updateStatus(requestId, 'Accepted', context),
                        child: Text("✅ Accept"),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () => _updateStatus(requestId, 'Declined', context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text("❌ Decline"),
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

  /// ✅ **Update Firestore when donor accepts/declines**
  void _updateStatus(String requestId, String status, BuildContext context) async {
    try {
      print("🔄 Updating request ID: $requestId to status: $status");

      await FirebaseFirestore.instance.collection('blood_requests').doc(requestId).update({
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status updated to $status")),
      );
    } catch (e) {
      print("❌ Error updating status: $e");
    }
  }
}
