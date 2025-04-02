// TODO Implement this library.
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

// class ViewBloodRequestsPage extends StatefulWidget {
//   @override
//   _ViewBloodRequestsPageState createState() => _ViewBloodRequestsPageState();
// }

// class _ViewBloodRequestsPageState extends State<ViewBloodRequestsPage> {
//   List<Map<String, dynamic>> bloodRequests = [];

//   // Initialize Twilio for SMS Notifications
//   TwilioFlutter twilioFlutter = TwilioFlutter(
//     accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//     authToken: 'cf85d34c06f19d6d862df21c11c576df',
//     twilioNumber: '+19897839571',
//   );

//   // 🔹 Fetch Blood Requests from Firestore
//   Future<void> _fetchRequests() async {
//     try {
//       QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
//           .collection('donors')
//           .where('status', isEqualTo: 'requested')
//           .get();

//       if (requestSnapshot.docs.isNotEmpty) {
//         setState(() {
//           bloodRequests = requestSnapshot.docs
//               .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
//               .toList();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("No blood requests found!")));
//       }
//     } catch (e) {
//       print("Error fetching requests: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error loading data!")));
//     }
//   }

//   // 🔹 Accept Blood Request (Update Status & Send SMS)
//   Future<void> _acceptRequest(String donorId, String recipientPhone) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('donors')
//           .doc(donorId)
//           .update({'status': 'accepted'});

//       twilioFlutter.sendSMS(
//         toNumber: recipientPhone,
//         messageBody: "Your blood request has been accepted! Please contact the donor.",
//       );

//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Blood request accepted!")));

//       // Refresh list after accepting
//       _fetchRequests();
//     } catch (e) {
//       print("Error accepting request: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error accepting request!")));
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchRequests(); // Fetch requests on page load
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("View Blood Requests")),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _fetchRequests,
//             child: Text("Refresh Requests"),
//           ),
//           Expanded(
//             child: bloodRequests.isEmpty
//                 ? Center(child: Text("No blood requests available."))
//                 : ListView.builder(
//                     itemCount: bloodRequests.length,
//                     itemBuilder: (context, index) {
//                       final request = bloodRequests[index];
//                       return Card(
//                         margin: EdgeInsets.all(10),
//                         child: ListTile(
//                           title: Text("Blood Group: ${request['bloodGroup']}"),
//                           subtitle: Text("Phone: ${request['phone']}"),
//                           trailing: ElevatedButton(
//                             onPressed: () =>
//                                 _acceptRequest(request['id'], request['phone']),
//                             child: Text("Accept"),
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

// class ViewBloodRequestsPage extends StatefulWidget {
//   @override
//   _ViewBloodRequestsPageState createState() => _ViewBloodRequestsPageState();
// }

// class _ViewBloodRequestsPageState extends State<ViewBloodRequestsPage> {
//   List<Map<String, dynamic>> bloodRequests = [];

//   // Initialize Twilio for SMS Notifications
//   TwilioFlutter twilioFlutter = TwilioFlutter(
//     accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
//     authToken: 'cf85d34c06f19d6d862df21c11c576df',
//     twilioNumber: '+19897839571',
//   );

//   // 🔹 Fetch Blood Requests (Only Pending Requests)
//   Future<void> _fetchRequests() async {
//     try {
//       QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
//           .collection('donors')
//           .where('status', isEqualTo: 'requested') // Fetch only pending requests
//           .get();

//       if (requestSnapshot.docs.isNotEmpty) {
//         setState(() {
//           bloodRequests = requestSnapshot.docs
//               .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
//               .toList();
//         });
//       } else {
//         setState(() {
//           bloodRequests = [];
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("No blood requests found!")));
//       }
//     } catch (e) {
//       print("Error fetching requests: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error loading data!")));
//     }
//   }

//   // 🔹 Accept Blood Request (Update Status & Send SMS)
//   Future<void> _acceptRequest(String donorId, String recipientPhone) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('donors')
//           .doc(donorId)
//           .update({'status': 'accepted'});

//       twilioFlutter.sendSMS(
//         toNumber: "+91 9747128571",
//         messageBody: "Your blood request has been accepted! Please contact the donor.",
//       );

//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Blood request accepted!")));

//       // Refresh the list to remove accepted requests
//       _fetchRequests();
//     } catch (e) {
//       print("Error accepting request: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Error accepting request!")));
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchRequests(); // Fetch requests on page load
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("View Blood Requests")),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _fetchRequests,
//             child: Text("Refresh Requests"),
//           ),
//           Expanded(
//             child: bloodRequests.isEmpty
//                 ? Center(child: Text("No blood requests available."))
//                 : ListView.builder(
//                     itemCount: bloodRequests.length,
//                     itemBuilder: (context, index) {
//                       final request = bloodRequests[index];
//                       return Card(
//                         margin: EdgeInsets.all(10),
//                         child: ListTile(
//                           title: Text("Blood Group: ${request['bloodGroup']}"),
//                           subtitle: Text("Phone: ${request['phone']}"),
//                           trailing: ElevatedButton(
//                             onPressed: () =>
//                                 _acceptRequest(request['id'], request['phone']),
//                             child: Text("Accept"),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class ViewBloodRequestsPage extends StatefulWidget {
  @override
  _ViewBloodRequestsPageState createState() => _ViewBloodRequestsPageState();
}

class _ViewBloodRequestsPageState extends State<ViewBloodRequestsPage> {
  List<Map<String, dynamic>> bloodRequests = [];

  // Initialize Twilio for SMS Notifications
  TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC5fe0b1b3e38146e9a3b2e92e96773850',
    authToken: 'cf85d34c06f19d6d862df21c11c576df',
    twilioNumber: '+19897839571',
  );

  // 🔹 Fetch Blood Requests (Only Pending Requests)
  Future<void> _fetchRequests() async {
    try {
      QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('donors')
          .where('status', isEqualTo: 'requested') // Fetch only pending requests
          .get();

      if (requestSnapshot.docs.isNotEmpty) {
        setState(() {
          bloodRequests = requestSnapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
        });
      } else {
        setState(() {
          bloodRequests = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No blood requests found!")));
      }
    } catch (e) {
      print("Error fetching requests: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error loading data!")));
    }
  }

  // 🔹 Accept Blood Request (Update Status & Send SMS)
  Future<void> _acceptRequest(String donorId, String recipientPhone) async {
    try {
      await FirebaseFirestore.instance
          .collection('donors')
          .doc(donorId)
          .update({'status': 'accepted'});

      twilioFlutter.sendSMS(
        toNumber: "+91 8086248944",
        messageBody: "Your blood request has been accepted! Please contact the donor.",
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Blood request accepted!")));

      // Refresh the list to remove accepted requests
      _fetchRequests();
    } catch (e) {
      print("Error accepting request: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error accepting request!")));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRequests(); // Fetch requests on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Blood Requests")),
      body: Column(
        children: [
          Expanded(
            child: bloodRequests.isEmpty
                ? Center(child: Text("No blood requests available."))
                : ListView.builder(
                    itemCount: bloodRequests.length,
                    itemBuilder: (context, index) {
                      final request = bloodRequests[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text("Blood Group: ${request['bloodGroup']}"),
                          subtitle: Text("Phone: ${request['phone']}"),
                          trailing: ElevatedButton(
                            onPressed: () =>
                                _acceptRequest(request['id'], request['phone']),
                            child: Text("Accept"),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRequests, // Refresh requests on press
        child: Icon(Icons.refresh), // Refresh icon
        tooltip: "Refresh Requests", // Tooltip text
      ),
    );
  }
}

