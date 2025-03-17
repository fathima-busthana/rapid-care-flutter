// TODO Implement this library.
import 'package:flutter/material.dart';

// class DashboardPage extends StatefulWidget {
//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   String? selectedBloodGroup;
//   final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

//   void _showBloodRequestDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Request Blood Donation"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Select Blood Group:"),
//               SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: selectedBloodGroup,
//                 hint: Text("Choose Blood Group"),
//                 items: bloodGroups.map((blood) {
//                   return DropdownMenuItem(value: blood, child: Text(blood));
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedBloodGroup = value;
//                   });
//                 },
//                 decoration: InputDecoration(border: OutlineInputBorder()),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: Text("Request"),
//               onPressed: () {
//                 if (selectedBloodGroup != null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Blood request sent for $selectedBloodGroup")),
//                   );
//                   Navigator.of(context).pop();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Please select a blood group!")),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Emergency Dashboard")),
//       body: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           _dashboardTile("🚨 Accident Detection", () {}),
//           _dashboardTile("🏥 Nearby Hospitals", () {}),
//           _dashboardTile("💉 Request Blood", _showBloodRequestDialog),
//           _dashboardTile("🎁 Rewards System", () {}),
//         ],
//       ),
//     );
//   }

//   Widget _dashboardTile(String title, VoidCallback onTap) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         trailing: Icon(Icons.arrow_forward_ios),
//         onTap: onTap,
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'blood_donor_list.dart';

// class DashboardPage extends StatefulWidget {
//   @override
//   State<DashboardPage> createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   String? selectedBloodGroup;
//   final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

//   void _showBloodRequestDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Request Blood Donation"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Select Blood Group:"),
//               SizedBox(height: 8),
//               DropdownButtonFormField<String>(
//                 value: selectedBloodGroup,
//                 hint: Text("Choose Blood Group"),
//                 items: bloodGroups.map((blood) {
//                   return DropdownMenuItem(value: blood, child: Text(blood));
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedBloodGroup = value;
//                   });
//                 },
//                 decoration: InputDecoration(border: OutlineInputBorder()),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: Text("Request"),
//               onPressed: () {
//                 if (selectedBloodGroup != null) {
//                   Navigator.of(context).pop();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => BloodDonorListPage(bloodGroup: selectedBloodGroup!),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text("Please select a blood group!")),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Emergency Dashboard")),
//       body: ListView(
//         padding: EdgeInsets.all(16),
//         children: [
//           _dashboardTile("🚨 Accident Detection", () {}),
//           _dashboardTile("🏥 Nearby Hospitals", () {}),
//           _dashboardTile("💉 Request Blood", _showBloodRequestDialog),
//           _dashboardTile("🎁 Rewards System", () {}),
//         ],
//       ),
//     );
//   }

//   Widget _dashboardTile(String title, VoidCallback onTap) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         trailing: Icon(Icons.arrow_forward_ios),
//         onTap: onTap,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BloodRequestPage extends StatefulWidget {
  @override
  _BloodRequestPageState createState() => _BloodRequestPageState();
}

class _BloodRequestPageState extends State<BloodRequestPage> {
  String? selectedBloodGroup;
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void _submitRequest() async {
    if (selectedBloodGroup == null || nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields!")),
      );
      return;
    }

    // ✅ Add request to Firestore
    DocumentReference docRef = await FirebaseFirestore.instance.collection('blood_requests').add({
      'bloodGroup': selectedBloodGroup,
      'requesterName': nameController.text,
      'requesterPhone': phoneController.text,
      'status': 'Pending', // Default status
      'timestamp': FieldValue.serverTimestamp(), // To sort by latest requests
    });

    String requestId = docRef.id;
    print("✅ Blood request created with ID: $requestId");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Blood request submitted successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Blood")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Your Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Your Name", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Your Phone", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedBloodGroup,
              hint: Text("Choose Blood Group"),
              items: bloodGroups.map((blood) {
                return DropdownMenuItem(value: blood, child: Text(blood));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBloodGroup = value;
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitRequest,
              child: Text("🚑 Request Blood"),
            ),
          ],
        ),
      ),
    );
  }
}
