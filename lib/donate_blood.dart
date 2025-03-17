// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class DonateBloodPage extends StatefulWidget {
//   @override
//   _DonateBloodPageState createState() => _DonateBloodPageState();
// }

// class _DonateBloodPageState extends State<DonateBloodPage> {
//   final _formKey = GlobalKey<FormState>();

//   String? name;
//   String? bloodGroup;
//   String? location;
//   String? phone;
//   int rewards = 0; // Hidden field

//   final List<String> bloodGroups = [
//     'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
//   ];

//   bool isFetchingLocation = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchCurrentLocation(); // Fetch location on page load
//   }

//   Future<void> _fetchCurrentLocation() async {
//     setState(() {
//       isFetchingLocation = true;
//     });

//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);

//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           position.latitude, position.longitude);

//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         setState(() {
//           location =
//               "${place.locality}, ${place.subLocality}, ${place.administrativeArea}";
//         });
//       }
//     } catch (e) {
//       print("❌ Error fetching location: $e");
//     }

//     setState(() {
//       isFetchingLocation = false;
//     });
//   }

//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();

//       try {
//         await FirebaseFirestore.instance.collection('blood').add({
//           'name': name,
//           'bloodGroup': bloodGroup,
//           'location': location,
//           'phone': phone,
//           'rewards': rewards,
//           'timestamp': FieldValue.serverTimestamp(),
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("✅ Blood donation registered successfully!")),
//         );

//         Navigator.pop(context); // Go back after submission
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("❌ Error: ${e.toString()}")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("💉 Donate Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: "Name"),
//                 validator: (value) => value!.isEmpty ? "Enter your name" : null,
//                 onSaved: (value) => name = value!,
//               ),
//               SizedBox(height: 10),

//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(labelText: "Blood Group"),
//                 items: bloodGroups.map((String group) {
//                   return DropdownMenuItem<String>(
//                     value: group,
//                     child: Text(group),
//                   );
//                 }).toList(),
//                 validator: (value) => value == null ? "Select a blood group" : null,
//                 onChanged: (value) => bloodGroup = value,
//               ),
//               SizedBox(height: 10),

//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: "Location",
//                   suffixIcon: isFetchingLocation
//                       ? CircularProgressIndicator()
//                       : IconButton(
//                           icon: Icon(Icons.location_on),
//                           onPressed: _fetchCurrentLocation,
//                         ),
//                 ),
//                 readOnly: true,
//                 controller: TextEditingController(text: location ?? "Fetching..."),
//                 validator: (value) => value!.isEmpty ? "Fetching location..." : null,
//               ),
//               SizedBox(height: 10),

//               TextFormField(
//                 decoration: InputDecoration(labelText: "Phone Number"),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) =>
//                     (value!.isEmpty || value.length != 10) ? "Enter a valid 10-digit phone number" : null,
//                 onSaved: (value) => phone = value!,
//               ),
//               SizedBox(height: 20),

//               Center(
//                 child: ElevatedButton(
//                   onPressed: _submitForm,
//                   child: Text("Submit"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class DonateBloodPage extends StatefulWidget {
//   @override
//   _DonateBloodPageState createState() => _DonateBloodPageState();
// }

// class _DonateBloodPageState extends State<DonateBloodPage> {
//   String? currentUserId;
//   bool isLoading = false;
//   List<Map<String, dynamic>> bloodRequests = [];

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         currentUserId = user.uid;
//       });
//     }
//   }

//   void _fetchBloodRequests() async {
//     if (currentUserId == null) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('request_blood')
//           .where('donorId', isEqualTo: currentUserId)
//           .where('status', isEqualTo: 'pending') // Only fetch pending requests
//           .get();

//       List<Map<String, dynamic>> requests = querySnapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['id'] = doc.id; // Store document ID
//         return data;
//       }).toList();

//       setState(() {
//         bloodRequests = requests;
//       });
//     } catch (e) {
//       print("❌ Error fetching blood requests: $e");
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _updateRequestStatus(String requestId, String status) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('request_blood')
//           .doc(requestId)
//           .update({'status': status});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Request marked as $status")),
//       );

//       _fetchBloodRequests(); // Refresh the list
//     } catch (e) {
//       print("❌ Error updating request status: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to update request status")),
//       );
//     }
//   }

//   void _showBloodRequests() {
//     _fetchBloodRequests();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Blood Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : bloodRequests.isEmpty
//                       ? Center(child: Text("No pending blood requests"))
//                       : ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: bloodRequests.length,
//                           itemBuilder: (context, index) {
//                             var request = bloodRequests[index];
//                             return Card(
//                               elevation: 3,
//                               margin: EdgeInsets.symmetric(vertical: 8),
//                               child: ListTile(
//                                 title: Text(request['requesterName']),
//                                 subtitle: Text("Blood Group: ${request['bloodGroup']}"),
//                                 trailing: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     IconButton(
//                                       icon: Icon(Icons.check_circle, color: Colors.green),
//                                       onPressed: () => _updateRequestStatus(request['id'], 'accepted'),
//                                     ),
//                                     IconButton(
//                                       icon: Icon(Icons.cancel, color: Colors.red),
//                                       onPressed: () => _updateRequestStatus(request['id'], 'rejected'),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Donate Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(child: Center(child: Text("Blood Donation Form Here"))),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _showBloodRequests,
//               child: Text("View Blood Requests"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class DonateBloodPage extends StatefulWidget {
//   @override
//   _DonateBloodPageState createState() => _DonateBloodPageState();
// }

// class _DonateBloodPageState extends State<DonateBloodPage> {
//   String? currentUserId;
//   String? donorName, donorLocation, donorPhone, selectedBloodGroup;
//   bool isLoading = false;
//   List<Map<String, dynamic>> bloodRequests = [];

//   final _formKey = GlobalKey<FormState>();
//   final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         currentUserId = user.uid;
//       });
//     }
//   }

//   Future<void> _submitDonorApplication() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     try {
//       // Check if the user is already a donor
//       QuerySnapshot existingDonor = await FirebaseFirestore.instance
//           .collection('blood')
//           .where('userId', isEqualTo: currentUserId)
//           .get();

//       if (existingDonor.docs.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("You are already registered as a blood donor.")),
//         );
//         return;
//       }

//       // Add donor details to Firestore
//       await FirebaseFirestore.instance.collection('blood').add({
//         'userId': currentUserId,
//         'name': donorName,
//         'bloodGroup': selectedBloodGroup,
//         'location': donorLocation,
//         'phone': donorPhone,
//         'rewards': 0, // Default reward points
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Donor registration successful!")),
//       );
//     } catch (e) {
//       print("❌ Error submitting donor application: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to register as a donor.")),
//       );
//     }
//   }

//   void _fetchBloodRequests() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('request_blood')
//           .where('status', isEqualTo: 'pending') // Fetch all pending requests
//           .get();

//       List<Map<String, dynamic>> requests = querySnapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['id'] = doc.id; // Store document ID
//         return data;
//       }).toList();

//       setState(() {
//         bloodRequests = requests;
//       });
//     } catch (e) {
//       print("❌ Error fetching blood requests: $e");
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _updateRequestStatus(String requestId, String status) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('request_blood')
//           .doc(requestId)
//           .update({'status': status});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Request marked as $status")),
//       );

//       _fetchBloodRequests(); // Refresh the list
//     } catch (e) {
//       print("❌ Error updating request status: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to update request status")),
//       );
//     }
//   }

//   void _showBloodRequests() {
//     _fetchBloodRequests();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Blood Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : bloodRequests.isEmpty
//                       ? Center(child: Text("No pending blood requests"))
//                       : Expanded(
//                           child: ListView.builder(
//                             itemCount: bloodRequests.length,
//                             itemBuilder: (context, index) {
//                               var request = bloodRequests[index];
//                               return Card(
//                                 elevation: 3,
//                                 margin: EdgeInsets.symmetric(vertical: 8),
//                                 child: ListTile(
//                                   title: Text(request['requesterName'] ?? "Unknown"),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("Blood Group: ${request['bloodGroup']}"),
//                                       Text("📍 Location: ${request['requesterLocation'] ?? 'Not provided'}"),
//                                       Text("📞 Phone: ${request['requesterPhone'] ?? 'Not provided'}"),
//                                     ],
//                                   ),
//                                   trailing: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(Icons.check_circle, color: Colors.green),
//                                         onPressed: () => _updateRequestStatus(request['id'], 'accepted'),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.cancel, color: Colors.red),
//                                         onPressed: () => _updateRequestStatus(request['id'], 'rejected'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Donate Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("🩸 Become a Blood Donor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),

//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "Name"),
//                     validator: (value) => value!.isEmpty ? "Enter your name" : null,
//                     onSaved: (value) => donorName = value,
//                   ),
//                   SizedBox(height: 10),
//                   DropdownButtonFormField<String>(
//                     decoration: InputDecoration(labelText: "Blood Group"),
//                     items: bloodGroups.map((String group) {
//                       return DropdownMenuItem<String>(
//                         value: group,
//                         child: Text(group),
//                       );
//                     }).toList(),
//                     onChanged: (value) => selectedBloodGroup = value,
//                   ),
//                   SizedBox(height: 10),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "Location"),
//                     validator: (value) => value!.isEmpty ? "Enter your location" : null,
//                     onSaved: (value) => donorLocation = value,
//                   ),
//                   SizedBox(height: 10),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "Phone Number"),
//                     validator: (value) => value!.isEmpty ? "Enter your phone number" : null,
//                     onSaved: (value) => donorPhone = value,
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _submitDonorApplication,
//                     child: Text("Register as Donor"),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _showBloodRequests,
//               child: Text("View Blood Requests"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class DonateBloodPage extends StatefulWidget {
//   @override
//   _DonateBloodPageState createState() => _DonateBloodPageState();
// }

// class _DonateBloodPageState extends State<DonateBloodPage> {
//   String? currentUserId;
//   String? donorName, donorLocation, donorPhone, selectedBloodGroup;
//   bool isLoading = false;
//   List<Map<String, dynamic>> bloodRequests = [];

//   final _formKey = GlobalKey<FormState>();
//   final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         currentUserId = user.uid;
//       });
//     }
//   }

//   Future<void> _submitDonorApplication() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     try {
//       QuerySnapshot existingDonor = await FirebaseFirestore.instance
//           .collection('blood')
//           .where('userId', isEqualTo: currentUserId)
//           .get();

//       if (existingDonor.docs.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("You are already registered as a blood donor.")),
//         );
//         return;
//       }

//       await FirebaseFirestore.instance.collection('blood').add({
//         'userId': currentUserId,
//         'name': donorName,
//         'bloodGroup': selectedBloodGroup,
//         'location': donorLocation,
//         'phone': donorPhone,
//         'rewards': 0,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Donor registration successful!")),
//       );
//     } catch (e) {
//       print("❌ Error submitting donor application: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to register as a donor.")),
//       );
//     }
//   }

//   Future<void> _fetchBloodRequests() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('request_blood')
//           .where('status', isEqualTo: 'pending')
//           .get();

//       List<Map<String, dynamic>> requests = [];

//       for (var doc in querySnapshot.docs) {
//         var data = doc.data() as Map<String, dynamic>;
//         String requesterId = data['requesterId'];

//         // Fetch requester's name from 'users' collection
//         DocumentSnapshot userDoc =
//             await FirebaseFirestore.instance.collection('users').doc(requesterId).get();

//         String requesterName = userDoc.exists ? (userDoc['name'] ?? "Unknown") : "Unknown";

//         data['requesterName'] = requesterName;
//         data['id'] = doc.id;
//         requests.add(data);
//       }

//       setState(() {
//         bloodRequests = requests;
//       });
//     } catch (e) {
//       print("❌ Error fetching blood requests: $e");
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _updateRequestStatus(String requestId, String status) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('request_blood')
//           .doc(requestId)
//           .update({'status': status});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Request marked as $status")),
//       );

//       _fetchBloodRequests();
//     } catch (e) {
//       print("❌ Error updating request status: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to update request status")),
//       );
//     }
//   }

//   void _showBloodRequests() {
//     _fetchBloodRequests();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Blood Requests", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : bloodRequests.isEmpty
//                       ? Center(child: Text("No pending blood requests"))
//                       : Expanded(
//                           child: ListView.builder(
//                             itemCount: bloodRequests.length,
//                             itemBuilder: (context, index) {
//                               var request = bloodRequests[index];
//                               return Card(
//                                 elevation: 3,
//                                 margin: EdgeInsets.symmetric(vertical: 8),
//                                 child: ListTile(
//                                   title: Text(request['requesterName']),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("Blood Group: ${request['bloodGroup']}"),
//                                       Text("📍 Location: ${request['requesterLocation'] ?? 'Not provided'}"),
//                                       Text("📞 Phone: ${request['requesterPhone'] ?? 'Not provided'}"),
//                                     ],
//                                   ),
//                                   trailing: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(Icons.check_circle, color: Colors.green),
//                                         onPressed: () => _updateRequestStatus(request['id'], 'accepted'),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.cancel, color: Colors.red),
//                                         onPressed: () => _updateRequestStatus(request['id'], 'rejected'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Donate Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("🩸 Become a Blood Donor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),

//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "Name"),
//                     validator: (value) => value!.isEmpty ? "Enter your name" : null,
//                     onSaved: (value) => donorName = value,
//                   ),
//                   SizedBox(height: 10),
//                   DropdownButtonFormField<String>(
//                     decoration: InputDecoration(labelText: "Blood Group"),
//                     items: bloodGroups.map((String group) {
//                       return DropdownMenuItem<String>(
//                         value: group,
//                         child: Text(group),
//                       );
//                     }).toList(),
//                     onChanged: (value) => selectedBloodGroup = value,
//                   ),
//                   SizedBox(height: 10),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "Location"),
//                     validator: (value) => value!.isEmpty ? "Enter your location" : null,
//                     onSaved: (value) => donorLocation = value,
//                   ),
//                   SizedBox(height: 10),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: "Phone Number"),
//                     validator: (value) => value!.isEmpty ? "Enter your phone number" : null,
//                     onSaved: (value) => donorPhone = value,
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _submitDonorApplication,
//                     child: Text("Register as Donor"),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _showBloodRequests,
//               child: Text("View Blood Requests"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonateBloodPage extends StatefulWidget {
  @override
  _DonateBloodPageState createState() => _DonateBloodPageState();
}

class _DonateBloodPageState extends State<DonateBloodPage> {
  String? currentUserId;
  String? donorName, donorLocation, donorPhone, selectedBloodGroup;
  bool isLoading = false;
  List<Map<String, dynamic>> bloodRequests = [];

  final _formKey = GlobalKey<FormState>();
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  Future<void> _submitDonorApplication() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      QuerySnapshot existingDonor = await FirebaseFirestore.instance
          .collection('blood')
          .where('userId', isEqualTo: currentUserId)
          .get();

      if (existingDonor.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You are already registered as a blood donor.")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('blood').add({
        'userId': currentUserId,
        'name': donorName,
        'bloodGroup': selectedBloodGroup,
        'location': donorLocation,
        'phone': donorPhone,
        'rewards': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Donor registration successful!")),
      );
    } catch (e) {
      print("❌ Error submitting donor application: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to register as a donor.")),
      );
    }
  }

  Future<void> _fetchBloodRequestsWithDonors() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('request_blood')
          .where('status', isEqualTo: 'pending')
          .get();

      List<Map<String, dynamic>> requestsWithDonors = [];

      for (var requestDoc in requestSnapshot.docs) {
        var requestData = requestDoc.data() as Map<String, dynamic>;
        String requestedBloodGroup = requestData['bloodGroup'];

        // Fetch matching donors from 'blood' collection
        QuerySnapshot donorSnapshot = await FirebaseFirestore.instance
            .collection('blood')
            .where('bloodGroup', isEqualTo: requestedBloodGroup)
            .get();

        List<Map<String, dynamic>> matchingDonors = donorSnapshot.docs.map((doc) {
          var donorData = doc.data() as Map<String, dynamic>;
          donorData['id'] = doc.id;
          return donorData;
        }).toList();

        requestData['donors'] = matchingDonors;
        requestData['id'] = requestDoc.id;
        requestsWithDonors.add(requestData);
      }

      setState(() {
        bloodRequests = requestsWithDonors;
      });
    } catch (e) {
      print("❌ Error fetching blood requests with donors: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _showBloodRequests() {
    _fetchBloodRequestsWithDonors();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Blood Requests & Donors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : bloodRequests.isEmpty
                      ? Center(child: Text("No pending blood requests"))
                      : Expanded(
                          child: ListView.builder(
                            itemCount: bloodRequests.length,
                            itemBuilder: (context, index) {
                              var request = bloodRequests[index];
                              var donors = request['donors'] as List<Map<String, dynamic>>;

                              return Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ExpansionTile(
                                  title: Text("Request by: ${request['requesterName']}"),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Blood Group: ${request['bloodGroup']}"),
                                      Text("📍 Location: ${request['requesterLocation'] ?? 'Not provided'}"),
                                      Text("📞 Phone: ${request['requesterPhone'] ?? 'Not provided'}"),
                                    ],
                                  ),
                                  children: donors.isEmpty
                                      ? [Padding(padding: EdgeInsets.all(8), child: Text("No donors available"))]
                                      : donors.map((donor) {
                                          return ListTile(
                                            title: Text(donor['name']),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("📍 Location: ${donor['location']}"),
                                                Text("📞 Phone: ${donor['phone']}"),
                                                Text("🎖️ Rewards: ${donor['rewards']}"),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                ),
                              );
                            },
                          ),
                        ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" Donate Blood")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" Become a Blood Donor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: "Name"),
                    validator: (value) => value!.isEmpty ? "Enter your name" : null,
                    onSaved: (value) => donorName = value,
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Blood Group"),
                    items: bloodGroups.map((String group) {
                      return DropdownMenuItem<String>(
                        value: group,
                        child: Text(group),
                      );
                    }).toList(),
                    onChanged: (value) => selectedBloodGroup = value,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Location"),
                    validator: (value) => value!.isEmpty ? "Enter your location" : null,
                    onSaved: (value) => donorLocation = value,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Phone Number"),
                    validator: (value) => value!.isEmpty ? "Enter your phone number" : null,
                    onSaved: (value) => donorPhone = value,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitDonorApplication,
                    child: Text("Register as Donor"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showBloodRequests,
              child: Text("View Blood Requests"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class DonateBloodPage extends StatefulWidget {
//   @override
//   _DonateBloodPageState createState() => _DonateBloodPageState();
// }

// class _DonateBloodPageState extends State<DonateBloodPage> {
//   String? currentUserId;
//   String? donorName, donorLocation, donorPhone, selectedBloodGroup;
//   bool isLoading = false;
//   List<Map<String, dynamic>> bloodRequests = [];

//   final _formKey = GlobalKey<FormState>();
//   final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   void _getCurrentUser() {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       setState(() {
//         currentUserId = user.uid;
//       });
//     }
//   }

//   Future<void> _submitDonorApplication() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     try {
//       QuerySnapshot existingDonor = await FirebaseFirestore.instance
//           .collection('blood')
//           .where('userId', isEqualTo: currentUserId)
//           .get();

//       if (existingDonor.docs.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("You are already registered as a blood donor.")),
//         );
//         return;
//       }

//       await FirebaseFirestore.instance.collection('blood').add({
//         'userId': currentUserId,
//         'name': donorName,
//         'bloodGroup': selectedBloodGroup,
//         'location': donorLocation,
//         'phone': donorPhone,
//         'rewards': 0,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Donor registration successful!")),
//       );
//     } catch (e) {
//       print("❌ Error submitting donor application: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to register as a donor.")),
//       );
//     }
//   }

//   Future<void> _fetchBloodRequestsWithDonors() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
//           .collection('request_blood')
//           .where('status', isEqualTo: 'pending')
//           .get();

//       List<Map<String, dynamic>> requestsWithDonors = [];

//       for (var requestDoc in requestSnapshot.docs) {
//         var requestData = requestDoc.data() as Map<String, dynamic>;
//         String requestedBloodGroup = requestData['bloodGroup'];

//         // Fetch matching donors from 'blood' collection
//         QuerySnapshot donorSnapshot = await FirebaseFirestore.instance
//             .collection('blood')
//             .where('bloodGroup', isEqualTo: requestedBloodGroup)
//             .get();

//         List<Map<String, dynamic>> matchingDonors = donorSnapshot.docs.map((doc) {
//           var donorData = doc.data() as Map<String, dynamic>;
//           donorData['id'] = doc.id;
//           return donorData;
//         }).toList();

//         requestData['donors'] = matchingDonors;
//         requestData['id'] = requestDoc.id;
//         requestsWithDonors.add(requestData);
//       }

//       setState(() {
//         bloodRequests = requestsWithDonors;
//       });
//     } catch (e) {
//       print("❌ Error fetching blood requests with donors: $e");
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _updateRequestStatus(String requestId, String newStatus) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('request_blood')
//           .doc(requestId)
//           .update({'status': newStatus});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Request status updated to $newStatus")),
//       );

//       _fetchBloodRequestsWithDonors(); // Refresh the list
//     } catch (e) {
//       print("❌ Error updating request status: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to update request status.")),
//       );
//     }
//   }

//   void _showBloodRequests() {
//     _fetchBloodRequestsWithDonors();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Blood Requests & Donors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10),
//               isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : bloodRequests.isEmpty
//                       ? Center(child: Text("No pending blood requests"))
//                       : Expanded(
//                           child: ListView.builder(
//                             itemCount: bloodRequests.length,
//                             itemBuilder: (context, index) {
//                               var request = bloodRequests[index];
//                               var donors = request['donors'] as List<Map<String, dynamic>>;
//                               String status = request['status'];

//                               return Card(
//                                 elevation: 3,
//                                 margin: EdgeInsets.symmetric(vertical: 8),
//                                 child: ExpansionTile(
//                                   title: Text("Request by: ${request['requesterName']}"),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("Blood Group: ${request['bloodGroup']}"),
//                                       Text("📍 Location: ${request['requesterLocation'] ?? 'Not provided'}"),
//                                       Text("📞 Phone: ${request['requesterPhone'] ?? 'Not provided'}"),
//                                       Text("Status: ${status.toUpperCase()}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: status == 'selected' ? Colors.green : Colors.orange)),
//                                     ],
//                                   ),
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                       children: [
//                                         ElevatedButton(
//                                           onPressed: status == 'pending' ? () => _updateRequestStatus(request['id'], 'selected') : null,
//                                           child: Text("Accept"),
//                                           style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                                         ),
//                                         ElevatedButton(
//                                           onPressed: status == 'pending' ? () => _updateRequestStatus(request['id'], 'declined') : null,
//                                           child: Text("Decline"),
//                                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                                         ),
//                                       ],
//                                     ),
//                                     ...donors.isEmpty
//                                         ? [Padding(padding: EdgeInsets.all(8), child: Text("No donors available"))]
//                                         : donors.map((donor) {
//                                             return ListTile(
//                                               title: Text(donor['name']),
//                                               subtitle: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text("📍 Location: ${donor['location']}"),
//                                                   Text("📞 Phone: ${donor['phone']}"),
//                                                   Text("🎖️ Rewards: ${donor['rewards']}"),
//                                                 ],
//                                               ),
//                                               trailing: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   IconButton(
//                                                     icon: Icon(Icons.check_circle, color: Colors.green),
//                                                     onPressed: () => _updateRequestStatus(request['id'], 'accepted'),
//                                                   ),
//                                                   IconButton(
//                                                     icon: Icon(Icons.cancel, color: Colors.red),
//                                                     onPressed: () => _updateRequestStatus(request['id'], 'rejected'),
//                                                   ),
//                                                 ],
//                                               ),
//                                             );
//                                           }).toList(),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(" Donate Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: _showBloodRequests,
//               child: Text("View Blood Requests"),
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:math';

// class BloodDonorPage extends StatefulWidget {
//   @override
//   _BloodDonorPageState createState() => _BloodDonorPageState();
// }

// class _BloodDonorPageState extends State<BloodDonorPage> {
//   final _formKey = GlobalKey<FormState>();
//   String? _name, _bloodGroup, _phone;
//   Position? _donorLocation;
//   String? _donorBloodGroup;
//   String? _donorId = FirebaseAuth.instance.currentUser?.uid;

//   @override
//   void initState() {
//     super.initState();
//     _fetchDonorData();
//   }

//   /// 📌 Fetch Donor Info from Firestore
//   Future<void> _fetchDonorData() async {
//     if (_donorId == null) return;

//     var donorDoc = await FirebaseFirestore.instance.collection('blood_donors').doc(_donorId).get();
//     if (donorDoc.exists) {
//       setState(() {
//         _donorBloodGroup = donorDoc['bloodGroup'];
//       });
//     }
//   }

//   /// 📌 Get Current Location
//   Future<void> _getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _donorLocation = position;
//     });
//   }

//   /// 📌 Submit Donor Form
//   Future<void> _submitDonorApplication() async {
//     if (!_formKey.currentState!.validate() || _donorLocation == null) return;
//     _formKey.currentState!.save();

//     await FirebaseFirestore.instance.collection('blood_donors').doc(_donorId).set({
//       'name': _name,
//       'bloodGroup': _bloodGroup,
//       'phone': _phone,
//       'location': {'latitude': _donorLocation!.latitude, 'longitude': _donorLocation!.longitude},
//     });

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Donor registered successfully!")));
//   }

//   /// 📌 Calculate Distance (Haversine Formula)
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double R = 6371;
//     double dLat = (lat2 - lat1) * pi / 180;
//     double dLon = (lon2 - lon1) * pi / 180;
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
//             sin(dLon / 2) * sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   /// 📌 Accept or Decline Blood Request
//   Future<void> _updateRequestStatus(String requestId, String newStatus) async {
//     await FirebaseFirestore.instance.collection('blood_requests').doc(requestId).update({'status': newStatus});
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🔹 Status updated to $newStatus")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Blood Donor Portal")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _donorBloodGroup == null ? _buildDonorForm() : _buildMatchingRequests(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Blood Donor Registration Form
//   Widget _buildDonorForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             decoration: InputDecoration(labelText: "👤 Name"),
//             validator: (value) => value!.isEmpty ? "Enter your name" : null,
//             onSaved: (value) => _name = value,
//           ),
//           TextFormField(
//             decoration: InputDecoration(labelText: "🩸 Blood Group"),
//             validator: (value) => value!.isEmpty ? "Enter blood group" : null,
//             onSaved: (value) => _bloodGroup = value,
//           ),
//           TextFormField(
//             decoration: InputDecoration(labelText: "📞 Phone Number"),
//             validator: (value) => value!.isEmpty ? "Enter phone number" : null,
//             onSaved: (value) => _phone = value,
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: _getLocation,
//             child: Text("📍 Get My Location"),
//           ),
//           ElevatedButton(
//             onPressed: _submitDonorApplication,
//             child: Text("✅ Register as Donor"),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 📌 Display Matching Blood Requests
//   Widget _buildMatchingRequests() {
//     return Expanded(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('blood_requests')
//             .where('bloodGroup', isEqualTo: _donorBloodGroup)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("📌 No matching blood requests found."));
//           }

//           List<DocumentSnapshot> requests = snapshot.data!.docs;

//           // 🔹 Sort requests by distance
//           if (_donorLocation != null) {
//             requests.sort((a, b) {
//               var aData = a.data() as Map<String, dynamic>;
//               var bData = b.data() as Map<String, dynamic>;

//               double aLat = aData['location']['latitude'];
//               double aLon = aData['location']['longitude'];
//               double bLat = bData['location']['latitude'];
//               double bLon = bData['location']['longitude'];

//               double distanceA = _calculateDistance(_donorLocation!.latitude, _donorLocation!.longitude, aLat, aLon);
//               double distanceB = _calculateDistance(_donorLocation!.latitude, _donorLocation!.longitude, bLat, bLon);

//               return distanceA.compareTo(distanceB);
//             });
//           }

//           return ListView(
//             children: requests.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;
//               return Card(
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName']}"),
//                   subtitle: Text("📍 Location: ${data['location']['latitude']}, ${data['location']['longitude']}"),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(icon: Icon(Icons.check, color: Colors.green), onPressed: () => _updateRequestStatus(doc.id, "Accepted")),
//                       IconButton(icon: Icon(Icons.close, color: Colors.red), onPressed: () => _updateRequestStatus(doc.id, "Declined")),
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
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:math';

// class BloodDonorPage extends StatefulWidget {
//   @override
//   _BloodDonorPageState createState() => _BloodDonorPageState();
// }

// class _BloodDonorPageState extends State<BloodDonorPage> {
//   final _formKey = GlobalKey<FormState>();
//   String? _name, _bloodGroup, _phone;
//   Position? _donorLocation;
//   String? _donorBloodGroup;
//   String? _donorId = FirebaseAuth.instance.currentUser?.uid;

//   @override
//   void initState() {
//     super.initState();
//     _fetchDonorData();
//   }

//   /// 📌 Fetch Donor Info from Firestore
//   Future<void> _fetchDonorData() async {
//     if (_donorId == null) return;

//     var donorDoc = await FirebaseFirestore.instance.collection('blood_donors').doc(_donorId).get();
//     if (donorDoc.exists) {
//       setState(() {
//         _donorBloodGroup = donorDoc['bloodGroup'];
//       });
//     }
//   }

//   /// 📌 Get Current Location
//   Future<void> _getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _donorLocation = position;
//     });
//   }

//   /// 📌 Submit Donor Form
//   Future<void> _submitDonorApplication() async {
//     if (!_formKey.currentState!.validate() || _donorLocation == null) return;
//     _formKey.currentState!.save();

//     await FirebaseFirestore.instance.collection('blood_donors').doc(_donorId).set({
//       'name': _name,
//       'bloodGroup': _bloodGroup,
//       'phone': _phone,
//       'location': {'latitude': _donorLocation!.latitude, 'longitude': _donorLocation!.longitude},
//     });

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Donor registered successfully!")));
//   }

//   /// 📌 Calculate Distance (Haversine Formula)
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double R = 6371;
//     double dLat = (lat2 - lat1) * pi / 180;
//     double dLon = (lon2 - lon1) * pi / 180;
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
//             sin(dLon / 2) * sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   /// 📌 Accept or Decline Blood Request
//   Future<void> _updateRequestStatus(String requestId, String newStatus) async {
//     await FirebaseFirestore.instance.collection('blood_requests').doc(requestId).update({'status': newStatus});
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🔹 Status updated to $newStatus")));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Blood Donor Portal")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _donorBloodGroup == null ? _buildDonorForm() : _buildMatchingRequests(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Blood Donor Registration Form
//   Widget _buildDonorForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             decoration: InputDecoration(labelText: "👤 Name"),
//             validator: (value) => value!.isEmpty ? "Enter your name" : null,
//             onSaved: (value) => _name = value,
//           ),
//           DropdownButtonFormField<String>(
//             decoration: InputDecoration(labelText: "🩸 Blood Group"),
//             value: _bloodGroup,
//             items: [
//               "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"
//             ].map((group) {
//               return DropdownMenuItem<String>(
//                 value: group,
//                 child: Text(group),
//               );
//             }).toList(),
//             validator: (value) => value == null ? "Select blood group" : null,
//             onChanged: (value) {
//               setState(() {
//                 _bloodGroup = value;
//               });
//             },
//           ),
//           TextFormField(
//             decoration: InputDecoration(labelText: "📞 Phone Number"),
//             validator: (value) => value!.isEmpty ? "Enter phone number" : null,
//             onSaved: (value) => _phone = value,
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: _getLocation,
//             child: Text("📍 Get My Location"),
//           ),
//           ElevatedButton(
//             onPressed: _submitDonorApplication,
//             child: Text("✅ Register as Donor"),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 📌 Display Matching Blood Requests
//   Widget _buildMatchingRequests() {
//     return Expanded(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('blood_requests')
//             .where('bloodGroup', isEqualTo: _donorBloodGroup)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("📌 No matching blood requests found."));
//           }

//           List<DocumentSnapshot> requests = snapshot.data!.docs;

//           // 🔹 Sort requests by distance
//           if (_donorLocation != null) {
//             requests.sort((a, b) {
//               var aData = a.data() as Map<String, dynamic>;
//               var bData = b.data() as Map<String, dynamic>;

//               double aLat = aData['location']['latitude'];
//               double aLon = aData['location']['longitude'];
//               double bLat = bData['location']['latitude'];
//               double bLon = bData['location']['longitude'];

//               double distanceA = _calculateDistance(_donorLocation!.latitude, _donorLocation!.longitude, aLat, aLon);
//               double distanceB = _calculateDistance(_donorLocation!.latitude, _donorLocation!.longitude, bLat, bLon);

//               return distanceA.compareTo(distanceB);
//             });
//           }

//           return ListView(
//             children: requests.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;
//               return Card(
//                 child: ListTile(
//                   title: Text("🧑 Patient: ${data['patientName']}"),
//                   subtitle: Text("📍 Location: ${data['location']['latitude']}, ${data['location']['longitude']}"),
//                   trailing: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(icon: Icon(Icons.check, color: Colors.green), onPressed: () => _updateRequestStatus(doc.id, "Accepted")),
//                       IconButton(icon: Icon(Icons.close, color: Colors.red), onPressed: () => _updateRequestStatus(doc.id, "Declined")),
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
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:math';

// class BloodDonorPage extends StatefulWidget {
//   @override
//   _BloodDonorPageState createState() => _BloodDonorPageState();
// }

// class _BloodDonorPageState extends State<BloodDonorPage> {
//   final _formKey = GlobalKey<FormState>();
//   String? _name, _bloodGroup, _phone, _hospital;
//   Position? _donorLocation;
//   String? _donorBloodGroup;
//   String? _donorId = FirebaseAuth.instance.currentUser?.uid;

//   @override
//   void initState() {
//     super.initState();
//     _fetchDonorData();
//   }

//   /// 📌 Fetch Donor Info from Firestore
//   Future<void> _fetchDonorData() async {
//     if (_donorId == null) return;

//     var donorDoc = await FirebaseFirestore.instance.collection('blood_donors').doc(_donorId).get();
//     if (donorDoc.exists) {
//       setState(() {
//         _donorBloodGroup = donorDoc['bloodGroup'];
//       });
//     }
//   }

//   /// 📌 Get Current Location
//   Future<void> _getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _donorLocation = position;
//     });
//   }

//   /// 📌 Submit Donor Form
//   Future<void> _submitDonorApplication() async {
//     if (!_formKey.currentState!.validate() || _donorLocation == null) return;
//     _formKey.currentState!.save();

//     await FirebaseFirestore.instance.collection('blood_donors').doc(_donorId).set({
//       'name': _name,
//       'bloodGroup': _bloodGroup,
//       'phone': _phone,
//       'hospital': _hospital,
//       'location': {'latitude': _donorLocation!.latitude, 'longitude': _donorLocation!.longitude},
//       'status': 'pending', // Initially setting status as pending
//     });

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Donor registered successfully!")));
//   }

//   /// 📌 Calculate Distance (Haversine Formula)
//   double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//     const double R = 6371;
//     double dLat = (lat2 - lat1) * pi / 180;
//     double dLon = (lon2 - lon1) * pi / 180;
//     double a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
//             sin(dLon / 2) * sin(dLon / 2);
//     double c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   /// 📌 Fetch Pending Blood Requests Matching Donor's Blood Group
//   Future<void> _checkPendingRequests() async {
//     if (_donorBloodGroup == null) return;

//     var pendingRequests = await FirebaseFirestore.instance
//         .collection('blood_donors')
//         .where('status', isEqualTo: 'pending')
//         .where('bloodGroup', isEqualTo: _donorBloodGroup)
//         .get();

//     if (pendingRequests.docs.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("📌 No pending requests found.")));
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Pending Blood Requests"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: pendingRequests.docs.map((doc) {
//                 var data = doc.data() as Map<String, dynamic>;
//                 return ListTile(
//                   title: Text("🧑 Name: ${data['name']}"),
//                   subtitle: Text("📍 Hospital: ${data['hospital']}"),
//                   trailing: Text("📞 ${data['phone']}"),
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Close"))],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Blood Donor Portal")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _donorBloodGroup == null ? _buildDonorForm() : _buildMatchingRequests(),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _checkPendingRequests,
//               child: Text("🔍 Check Pending Requests"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Blood Donor Registration Form
//   Widget _buildDonorForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             decoration: InputDecoration(labelText: "👤 Name"),
//             validator: (value) => value!.isEmpty ? "Enter your name" : null,
//             onSaved: (value) => _name = value,
//           ),
//           DropdownButtonFormField<String>(
//             decoration: InputDecoration(labelText: "🩸 Blood Group"),
//             value: _bloodGroup,
//             items: [
//               "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"
//             ].map((group) {
//               return DropdownMenuItem<String>(
//                 value: group,
//                 child: Text(group),
//               );
//             }).toList(),
//             validator: (value) => value == null ? "Select blood group" : null,
//             onChanged: (value) {
//               setState(() {
//                 _bloodGroup = value;
//               });
//             },
//           ),
//           TextFormField(
//             decoration: InputDecoration(labelText: "📞 Phone Number"),
//             validator: (value) => value!.isEmpty ? "Enter phone number" : null,
//             onSaved: (value) => _phone = value,
//           ),
//           TextFormField(
//             decoration: InputDecoration(labelText: "🏥 Hospital"),
//             validator: (value) => value!.isEmpty ? "Enter hospital name" : null,
//             onSaved: (value) => _hospital = value,
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: _getLocation,
//             child: Text("📍 Get My Location"),
//           ),
//           ElevatedButton(
//             onPressed: _submitDonorApplication,
//             child: Text("✅ Register as Donor"),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 📌 Display Matching Blood Requests
//   Widget _buildMatchingRequests() {
//     return Expanded(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('blood_donors')
//             .where('bloodGroup', isEqualTo: _donorBloodGroup)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("📌 No matching blood requests found."));
//           }

//           List<DocumentSnapshot> requests = snapshot.data!.docs;

//           return ListView(
//             children: requests.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;
//               return Card(
//                 child: ListTile(
//                   title: Text("🧑 Name: ${data['name']}"),
//                   subtitle: Text("📍 Hospital: ${data['hospital']}"),
//                   trailing: Text("📞 ${data['phone']}"),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class BloodDonorPortal extends StatefulWidget {
//   @override
//   _BloodDonorPortalState createState() => _BloodDonorPortalState();
// }

// class _BloodDonorPortalState extends State<BloodDonorPortal> {
//   final _formKey = GlobalKey<FormState>();
//   String? _name, _phone, _bloodGroup, _hospital;
//   bool _isRegistered = false;
//   String? _donorBloodGroup;

//   @override
//   void initState() {
//     super.initState();
//     _checkIfAlreadyRegistered();
//   }

//   /// ✅ Check if the user has already registered as a donor
//   Future<void> _checkIfAlreadyRegistered() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     var doc = await FirebaseFirestore.instance
//         .collection('blood_donors')
//         .doc(user.uid)
//         .get();

//     if (doc.exists) {
//       setState(() {
//         _isRegistered = true;
//         _donorBloodGroup = doc['bloodGroup'];
//       });
//     }
//   }

//   /// ✅ Submit the donor application and redirect to Victim Dashboard
//   Future<void> _submitDonorApplication() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     await FirebaseFirestore.instance.collection('blood_donors').doc(user.uid).set({
//       "userId": user.uid,
//       "name": _name,
//       "phone": _phone,
//       "bloodGroup": _bloodGroup,
//       "hospital": _hospital,
//       "status": "available",
//       "createdAt": FieldValue.serverTimestamp(),
//     });

//     setState(() {
//       _isRegistered = true;
//       _donorBloodGroup = _bloodGroup;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text("✅ Registered successfully as a blood donor!"),
//     ));

//     // 🚀 Redirect back to Victim Dashboard
//     Navigator.pop(context);
//   }

//   /// ✅ Check pending blood requests matching the donor’s blood group
//   Future<void> _checkPendingRequests() async {
//     if (_donorBloodGroup == null) return;

//     var pendingRequests = await FirebaseFirestore.instance
//         .collection('blood_requests')
//         .where('status', isEqualTo: 'Pending')
//         .where('bloodGroup', isEqualTo: _donorBloodGroup)
//         .get();

//     if (pendingRequests.docs.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("📌 No pending requests found.")),
//       );
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Pending Blood Requests"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: pendingRequests.docs.map((doc) {
//                 var data = doc.data() as Map<String, dynamic>;
//                 return ListTile(
//                   title: Text("🧑 Name: ${data['name']}"),
//                   subtitle: Text("📍 Hospital: ${data['hospital']}"),
//                   trailing: Text("📞 ${data['phone']}"),
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Close"))],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Blood Donor Portal")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             _isRegistered ? _buildMatchingRequests() : _buildDonorForm(),
//             SizedBox(height: 20),

//             // ✅ Check Pending Requests Button (Visible after Registration)
//             if (_isRegistered)
//               ElevatedButton(
//                 onPressed: _checkPendingRequests,
//                 child: Text("🔍 Check Pending Requests"),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Blood Donor Registration Form (Shown Only Once)
//   Widget _buildDonorForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         children: [
//           TextFormField(
//             decoration: InputDecoration(labelText: "👤 Name"),
//             validator: (value) => value!.isEmpty ? "Enter your name" : null,
//             onSaved: (value) => _name = value,
//           ),
//           DropdownButtonFormField<String>(
//             decoration: InputDecoration(labelText: "🩸 Blood Group"),
//             items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
//                 .map((group) => DropdownMenuItem(value: group, child: Text(group)))
//                 .toList(),
//             validator: (value) => value == null ? "Select blood group" : null,
//             onChanged: (value) => _bloodGroup = value,
//           ),
//           TextFormField(
//             decoration: InputDecoration(labelText: "📞 Phone Number"),
//             validator: (value) => value!.isEmpty ? "Enter phone number" : null,
//             onSaved: (value) => _phone = value,
//           ),
//           TextFormField(
//             decoration: InputDecoration(labelText: "🏥 Hospital"),
//             validator: (value) => value!.isEmpty ? "Enter hospital name" : null,
//             onSaved: (value) => _hospital = value,
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: _submitDonorApplication,
//             child: Text("✅ Register as Donor"),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 📌 Display Matching Blood Requests (After Registration)
//   Widget _buildMatchingRequests() {
//     return Expanded(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('blood_requests')
//             .where('bloodGroup', isEqualTo: _donorBloodGroup)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text("📌 No matching blood requests found."));
//           }

//           List<DocumentSnapshot> requests = snapshot.data!.docs;

//           return ListView(
//             children: requests.map((doc) {
//               var data = doc.data() as Map<String, dynamic>;
//               return Card(
//                 child: ListTile(
//                   title: Text("🧑 Name: ${data['name']}"),
//                   subtitle: Text("📍 Hospital: ${data['hospital']}"),
//                   trailing: Text("📞 ${data['phone']}"),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }
// }

