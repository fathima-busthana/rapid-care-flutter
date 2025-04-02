// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class RequestBloodPage extends StatefulWidget {
//   @override
//   _RequestBloodPageState createState() => _RequestBloodPageState();
// }

// class _RequestBloodPageState extends State<RequestBloodPage> {
//   String? selectedBloodGroup;
//   List<Map<String, dynamic>> donors = [];

//   final List<String> bloodGroups = [
//     'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
//   ];

//   bool isLoading = false;

//   void _fetchDonors() async {
//     if (selectedBloodGroup == null) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('blood')
//           .where('bloodGroup', isEqualTo: selectedBloodGroup)
//           .get();

//       List<Map<String, dynamic>> fetchedDonors = querySnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();

//       setState(() {
//         donors = fetchedDonors;
//       });
//     } catch (e) {
//       print("❌ Error fetching donors: $e");
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Request Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Select Blood Group:", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 8),

//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//               items: bloodGroups.map((String group) {
//                 return DropdownMenuItem<String>(
//                   value: group,
//                   child: Text(group),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedBloodGroup = value;
//                   _fetchDonors();
//                 });
//               },
//               value: selectedBloodGroup,
//             ),

//             SizedBox(height: 20),

//             isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : Expanded(
//                     child: donors.isEmpty
//                         ? Center(child: Text("No donors available for $selectedBloodGroup"))
//                         : ListView.builder(
//                             itemCount: donors.length,
//                             itemBuilder: (context, index) {
//                               var donor = donors[index];
//                               return Card(
//                                 elevation: 3,
//                                 margin: EdgeInsets.symmetric(vertical: 8),
//                                 child: ListTile(
//                                   title: Text(donor['name']),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("📍 Location: ${donor['location']}"),
//                                       Text("📞 Phone: ${donor['phone']}"),
//                                     ],
//                                   ),
//                                   trailing: Icon(Icons.bloodtype, color: Colors.red),
//                                 ),
//                               );
//                             },
//                           ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class RequestBloodPage extends StatefulWidget {
//   @override
//   _RequestBloodPageState createState() => _RequestBloodPageState();
// }

// class _RequestBloodPageState extends State<RequestBloodPage> {
//   String? selectedBloodGroup;
//   List<Map<String, dynamic>> donors = [];
//   String? currentUserId;
//   String? currentUserName;

//   final List<String> bloodGroups = [
//     'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
//   ];

//   bool isLoading = false;

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
//         currentUserName = user.displayName ?? "Unknown";
//       });
//     }
//   }

//   void _fetchDonors() async {
//     if (selectedBloodGroup == null) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('blood')
//           .where('bloodGroup', isEqualTo: selectedBloodGroup)
//           .get();

//       List<Map<String, dynamic>> fetchedDonors = querySnapshot.docs
//           .map((doc) {
//             var data = doc.data() as Map<String, dynamic>;
//             data['id'] = doc.id; // Store document ID
//             return data;
//           })
//           .where((donor) => donor['userId'] != currentUserId) // Exclude logged-in user
//           .toList();

//       setState(() {
//         donors = fetchedDonors;
//       });
//     } catch (e) {
//       print("❌ Error fetching donors: $e");
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> _requestBlood(Map<String, dynamic> donor) async {
//     if (currentUserId == null) return;

//     try {
//       // Prevent duplicate requests
//       QuerySnapshot existingRequests = await FirebaseFirestore.instance
//           .collection('request_blood')
//           .where('requesterId', isEqualTo: currentUserId)
//           .where('donorId', isEqualTo: donor['userId'])
//           .get();

//       if (existingRequests.docs.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("You have already requested blood from ${donor['name']}")),
//         );
//         return;
//       }

//       // Store blood request in Firestore
//       await FirebaseFirestore.instance.collection('request_blood').add({
//         'requesterId': currentUserId,
//         'requesterName': currentUserName,
//         'donorId': donor['userId'],
//         'donorName': donor['name'],
//         'bloodGroup': donor['bloodGroup'],
//         'status': 'pending', // Initially set status to "pending"
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Blood request sent to ${donor['name']}")),
//       );
//     } catch (e) {
//       print("❌ Error sending request: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to send request. Try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Request Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Select Blood Group:", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 8),

//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//               items: bloodGroups.map((String group) {
//                 return DropdownMenuItem<String>(
//                   value: group,
//                   child: Text(group),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedBloodGroup = value;
//                   _fetchDonors();
//                 });
//               },
//               value: selectedBloodGroup,
//             ),

//             SizedBox(height: 20),

//             isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : Expanded(
//                     child: donors.isEmpty
//                         ? Center(child: Text("No donors available for $selectedBloodGroup"))
//                         : ListView.builder(
//                             itemCount: donors.length,
//                             itemBuilder: (context, index) {
//                               var donor = donors[index];
//                               return Card(
//                                 elevation: 3,
//                                 margin: EdgeInsets.symmetric(vertical: 8),
//                                 child: ListTile(
//                                   title: Text(donor['name']),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("📍 Location: ${donor['location']}"),
//                                       Text("📞 Phone: ${donor['phone']}"),
//                                     ],
//                                   ),
//                                   trailing: ElevatedButton(
//                                     onPressed: () => _requestBlood(donor),
//                                     child: Text("Request"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class RequestBloodPage extends StatefulWidget {
//   @override
//   _RequestBloodPageState createState() => _RequestBloodPageState();
// }

// class _RequestBloodPageState extends State<RequestBloodPage> {
//   String? selectedBloodGroup;
//   List<Map<String, dynamic>> donors = [];
//   String? currentUserId;
//   String? currentUserName;
//   bool isLoading = false;

//   final List<String> bloodGroups = [
//     'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   /// ✅ Fetches logged-in user details (Fixes 'Unknown' issue)
//   void _getCurrentUser() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       currentUserId = user.uid;

//       // Fetch name from Firestore (if not stored in FirebaseAuth)
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users') // Ensure users are stored here
//           .doc(currentUserId)
//           .get();

//       if (userDoc.exists) {
//         setState(() {
//           currentUserName = userDoc['name'] ?? "Unknown";
//         });
//       } else {
//         setState(() {
//           currentUserName = "Unknown";
//         });
//       }
//     }
//   }

//   /// ✅ Fetches donors based on the selected blood group
//   void _fetchDonors() async {
//     if (selectedBloodGroup == null) return;

//     setState(() {
//       isLoading = true;
//     });

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('blood')
//           .where('bloodGroup', isEqualTo: selectedBloodGroup)
//           .get();

//       List<Map<String, dynamic>> fetchedDonors = querySnapshot.docs
//           .map((doc) {
//             var data = doc.data() as Map<String, dynamic>;
//             data['id'] = doc.id;
//             return data;
//           })
//           .where((donor) => donor['userId'] != currentUserId) // Exclude logged-in user
//           .toList();

//       setState(() {
//         donors = fetchedDonors;
//       });
//     } catch (e) {
//       print("❌ Error fetching donors: $e");
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   /// ✅ Sends a blood request (Fixes 'Unknown' requesterName)
//   Future<void> _requestBlood(Map<String, dynamic> donor) async {
//     if (currentUserId == null || currentUserName == null) return;

//     try {
//       // Prevent duplicate requests
//       QuerySnapshot existingRequests = await FirebaseFirestore.instance
//           .collection('request_blood')
//           .where('requesterId', isEqualTo: currentUserId)
//           .where('donorId', isEqualTo: donor['userId'])
//           .get();

//       if (existingRequests.docs.isNotEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("You have already requested blood from ${donor['name']}")),
//         );
//         return;
//       }

//       // Store blood request in Firestore
//       await FirebaseFirestore.instance.collection('request_blood').add({
//         'requesterId': currentUserId,
//         'requesterName': currentUserName, // Fixed issue here
//         'donorId': donor['userId'],
//         'donorName': donor['name'],
//         'bloodGroup': donor['bloodGroup'],
//         'status': 'pending',
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Blood request sent to ${donor['name']}")),
//       );
//     } catch (e) {
//       print("❌ Error sending request: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to send request. Try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Request Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Select Blood Group:", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 8),

//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//               items: bloodGroups.map((String group) {
//                 return DropdownMenuItem<String>(
//                   value: group,
//                   child: Text(group),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedBloodGroup = value;
//                   _fetchDonors();
//                 });
//               },
//               value: selectedBloodGroup,
//             ),

//             SizedBox(height: 20),

//             isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : Expanded(
//                     child: donors.isEmpty
//                         ? Center(child: Text("No donors available for $selectedBloodGroup"))
//                         : ListView.builder(
//                             itemCount: donors.length,
//                             itemBuilder: (context, index) {
//                               var donor = donors[index];
//                               return Card(
//                                 elevation: 3,
//                                 margin: EdgeInsets.symmetric(vertical: 8),
//                                 child: ListTile(
//                                   title: Text(donor['name']),
//                                   subtitle: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("📍 Location: ${donor['location']}"),
//                                       Text("📞 Phone: ${donor['phone']}"),
//                                     ],
//                                   ),
//                                   trailing: ElevatedButton(
//                                     onPressed: () => _requestBlood(donor),
//                                     child: Text("Request"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.red,
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RequestBloodPage extends StatefulWidget {
//   @override
//   _RequestBloodPageState createState() => _RequestBloodPageState();
// }

// class _RequestBloodPageState extends State<RequestBloodPage> {
//   String? _selectedBloodGroup;
//   List<DocumentSnapshot> _donors = [];
//   bool _isLoading = false;

//   /// 📌 Fetch Matching Blood Donors from Firestore
//   Future<void> _fetchDonors() async {
//     if (_selectedBloodGroup == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❗ Please select a blood group!")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     var querySnapshot = await FirebaseFirestore.instance
//         .collection('blood_donors')
//         .where('bloodGroup', isEqualTo: _selectedBloodGroup)
//         .get();

//     setState(() {
//       _donors = querySnapshot.docs;
//       _isLoading = false;
//     });

//     if (_donors.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🚫 No donors found for $_selectedBloodGroup")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Request Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: "🩸 Select Blood Group"),
//               value: _selectedBloodGroup,
//               items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"].map((group) {
//                 return DropdownMenuItem<String>(
//                   value: group,
//                   child: Text(group),
//                 );
//               }).toList(),
//               validator: (value) => value == null ? "Select a blood group" : null,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedBloodGroup = value;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _fetchDonors,
//               child: Text("🔎 Request Blood"),
//             ),
//             SizedBox(height: 20),
//             _isLoading ? CircularProgressIndicator() : _buildDonorList(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Display Matching Donors
//   Widget _buildDonorList() {
//     if (_donors.isEmpty) {
//       return Center(
//         child: Text("No donors available", style: TextStyle(fontSize: 16)),
//       );
//     }

//     return Expanded(
//       child: ListView(
//         children: _donors.map((doc) {
//           var data = doc.data() as Map<String, dynamic>;
//           return Card(
//             child: ListTile(
//               title: Text("👤 ${data['name']}"),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("📞 Phone: ${data['phone']}"),
//                   Text("📍 Location: ${data['location']['latitude']}, ${data['location']['longitude']}"),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RequestBloodPage extends StatefulWidget {
//   @override
//   _RequestBloodPageState createState() => _RequestBloodPageState();
// }

// class _RequestBloodPageState extends State<RequestBloodPage> {
//   String? _selectedBloodGroup;
//   List<DocumentSnapshot> _donors = [];
//   bool _isLoading = false;

//   /// 📌 Fetch Matching Blood Donors from Firestore
//   Future<void> _fetchDonors() async {
//     if (_selectedBloodGroup == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❗ Please select a blood group!")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     var querySnapshot = await FirebaseFirestore.instance
//         .collection('blood_donors')
//         .where('bloodGroup', isEqualTo: _selectedBloodGroup)
//         .get();

//     setState(() {
//       _donors = querySnapshot.docs;
//       _isLoading = false;
//     });

//     if (_donors.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🚫 No donors found for $_selectedBloodGroup")),
//       );
//     }
//   }

//   /// 📌 Send Blood Request (Update Status)
//   Future<void> _sendRequest(String donorId) async {
//     try {
//       await FirebaseFirestore.instance.collection('blood_donors').doc(donorId).update({
//         'status': 'pending',
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Blood request sent successfully!")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Failed to send request! Try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Request Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: "🩸 Select Blood Group"),
//               value: _selectedBloodGroup,
//               items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"].map((group) {
//                 return DropdownMenuItem<String>(
//                   value: group,
//                   child: Text(group),
//                 );
//               }).toList(),
//               validator: (value) => value == null ? "Select a blood group" : null,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedBloodGroup = value;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _fetchDonors,
//               child: Text("🔎 Request Blood"),
//             ),
//             SizedBox(height: 20),
//             _isLoading ? CircularProgressIndicator() : _buildDonorList(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Display Matching Donors with Request Button
//   Widget _buildDonorList() {
//     if (_donors.isEmpty) {
//       return Center(
//         child: Text("No donors available", style: TextStyle(fontSize: 16)),
//       );
//     }

//     return Expanded(
//       child: ListView(
//         children: _donors.map((doc) {
//           var data = doc.data() as Map<String, dynamic>;
//           return Card(
//             child: ListTile(
//               title: Text("👤 ${data['name']}"),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("📞 Phone: ${data['phone']}"),
//                   Text("📍 Location: ${data['location']['latitude']}, ${data['location']['longitude']}"),
//                   Text("🔹 Status: ${data.containsKey('status') ? data['status'] : 'Available'}"),
//                 ],
//               ),
//               trailing: ElevatedButton(
//                 onPressed: () => _sendRequest(doc.id),
//                 child: Text("🩸 Request"),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class RequestBloodPage extends StatefulWidget {
//   @override
//   _RequestBloodPageState createState() => _RequestBloodPageState();
// }

// class _RequestBloodPageState extends State<RequestBloodPage> {
//   String? _selectedBloodGroup;
//   String? _location = "Fetching location...";
//   List<DocumentSnapshot> _donors = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }

//   /// 📌 Get Real-Time User Location
//   Future<void> _getLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];

//       setState(() {
//         _location = "${place.locality}, ${place.administrativeArea}";
//       });
//     } catch (e) {
//       setState(() {
//         _location = "Location unavailable";
//       });
//     }
//   }

//   /// 📌 Fetch Matching Blood Donors from Firestore
//   Future<void> _fetchDonors() async {
//     if (_selectedBloodGroup == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❗ Please select a blood group!")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     var querySnapshot = await FirebaseFirestore.instance
//         .collection('blood_donors')
//         .where('bloodGroup', isEqualTo: _selectedBloodGroup)
//         .where('status', isEqualTo: 'available') // Fetch only available donors
//         .get();

//     setState(() {
//       _donors = querySnapshot.docs;
//       _isLoading = false;
//     });

//     if (_donors.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🚫 No donors found for $_selectedBloodGroup")),
//       );
//     }
//   }

//   /// 📌 Send Blood Request & Store in Firestore
//   Future<void> _sendRequest(String donorId, String donorName, String donorPhone) async {
//     try {
//       User? currentUser = FirebaseAuth.instance.currentUser;

//       if (currentUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("❌ User not logged in!")),
//         );
//         return;
//       }

//       // Debugging Logs
//       print("User ID: ${currentUser.uid}");
//       print("User Name: ${currentUser.displayName ?? 'Unknown'}");
//       print("User Phone: ${currentUser.phoneNumber ?? 'Unknown'}");

//       await FirebaseFirestore.instance.collection('requests').add({
//         'requesterId': currentUser.uid,
//         'requesterName': currentUser.displayName ?? "Unknown",
//         'requesterPhone': currentUser.phoneNumber ?? "Unknown",
//         'requesterLocation': _location ?? "Unknown",
//         'requiredBlood': _selectedBloodGroup,
//         'donorId': donorId,
//         'donorName': donorName,
//         'donorPhone': donorPhone,
//         'status': 'pending',
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Blood request sent successfully!")),
//       );
//     } catch (e) {
//       print("Error sending request: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Failed to send request! Try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🩸 Request Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: "🩸 Select Blood Group"),
//               value: _selectedBloodGroup,
//               items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"].map((group) {
//                 return DropdownMenuItem<String>(
//                   value: group,
//                   child: Text(group),
//                 );
//               }).toList(),
//               validator: (value) => value == null ? "Select a blood group" : null,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedBloodGroup = value;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(labelText: "📍 Location"),
//               initialValue: _location,
//               readOnly: true,
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _fetchDonors,
//               child: Text("🔎 Find Donors"),
//             ),
//             SizedBox(height: 20),
//             _isLoading ? CircularProgressIndicator() : _buildDonorList(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Display Matching Donors with Request Button
//   Widget _buildDonorList() {
//     if (_donors.isEmpty) {
//       return Center(
//         child: Text("No donors available", style: TextStyle(fontSize: 16)),
//       );
//     }

//     return Expanded(
//       child: ListView(
//         children: _donors.map((doc) {
//           var data = doc.data() as Map<String, dynamic>;
//           return Card(
//             child: ListTile(
//               title: Text("👤 ${data['name']}"),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("📞 Phone: ${data['phone']}"),
//                   Text("📍 Location: ${data['location']}"),
//                   Text("🔹 Status: ${data.containsKey('status') ? data['status'] : 'Available'}"),
//                 ],
//               ),
//               trailing: ElevatedButton(
//                 onPressed: () => _sendRequest(doc.id, data['name'], data['phone']),
//                 child: Text("🩸 Request"),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class RequestBloodPage extends StatefulWidget {
//   @override
//   _RequestBloodPageState createState() => _RequestBloodPageState();
// }

// class _RequestBloodPageState extends State<RequestBloodPage> {
//   String? _selectedBloodGroup;
//   String? _location = "Fetching location...";
//   List<DocumentSnapshot> _donors = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }

//   /// 📌 Get Real-Time User Location
//   Future<void> _getLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];

//       setState(() {
//         _location = "${place.locality}, ${place.administrativeArea}";
//       });
//     } catch (e) {
//       setState(() {
//         _location = "Location unavailable";
//       });
//     }
//   }

//   /// 📌 Fetch Matching Blood Donors from Firestore
//   Future<void> _fetchDonors() async {
//     if (_selectedBloodGroup == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❗ Please select a blood group!")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     var querySnapshot = await FirebaseFirestore.instance
//         .collection('blood')
//         .where('bloodGroup', isEqualTo: _selectedBloodGroup)
//         .where('status', isEqualTo: 'available') // Fetch only available donors
//         .get();

//     setState(() {
//       _donors = querySnapshot.docs;
//       _isLoading = false;
//     });

//     if (_donors.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🚫 No donors found for $_selectedBloodGroup")),
//       );
//     }
//   }

//   /// 📌 Send Blood Request & Store in Firestore
//   Future<void> _sendRequest(String donorId, String donorName, String donorPhone) async {
//     try {
//       User? currentUser = FirebaseAuth.instance.currentUser;

//       if (currentUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("❌ User not logged in!")),
//         );
//         return;
//       }

//       // Debugging Logs
//       print("User ID: ${currentUser.uid}");
//       print("User Name: ${currentUser.displayName ?? 'Unknown'}");
//       print("User Phone: ${currentUser.phoneNumber ?? 'Unknown'}");

//       await FirebaseFirestore.instance.collection('requests').add({
//         'requesterId': currentUser.uid,
//         'requesterName': currentUser.displayName ?? "Unknown",
//         'requesterPhone': currentUser.phoneNumber ?? "Unknown",
//         'requesterLocation': _location ?? "Unknown",
//         'requiredBlood': _selectedBloodGroup,
//         'donorId': donorId,
//         'donorName': donorName,
//         'donorPhone': donorPhone,
//         'status': 'pending',
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Blood request sent successfully!")),
//       );
//     } catch (e) {
//       print("Error sending request: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Failed to send request! Try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(" Request Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: " Select Blood Group"),
//               value: _selectedBloodGroup,
//               items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"].map((group) {
//                 return DropdownMenuItem<String>(
//                   value: group,
//                   child: Text(group),
//                 );
//               }).toList(),
//               validator: (value) => value == null ? "Select a blood group" : null,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedBloodGroup = value;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(labelText: "📍 Location"),
//               initialValue: _location,
//               readOnly: true,
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _fetchDonors,
//               child: Text("🔎 Find Donors"),
//             ),
//             SizedBox(height: 20),
//             _isLoading ? CircularProgressIndicator() : _buildDonorList(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Display Matching Donors with Request Button
//   Widget _buildDonorList() {
//     if (_donors.isEmpty) {
//       return Center(
//         child: Text("No donors available", style: TextStyle(fontSize: 16)),
//       );
//     }

//     return Expanded(
//       child: ListView(
//         children: _donors.map((doc) {
//           var data = doc.data() as Map<String, dynamic>;
//           return Card(
//             child: ListTile(
//               title: Text("👤 ${data['name']}"),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("📞 Phone: ${data['phone']}"),
//                   Text("📍 Location: ${data['location']}"),
//                   Text("🔹 Status: ${data.containsKey('status') ? data['status'] : 'Available'}"),
//                 ],
//               ),
//               trailing: ElevatedButton(
//                 onPressed: () => _sendRequest(doc.id, data['name'], data['phone']),
//                 child: Text("Request"),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class RequestBloodPage extends StatefulWidget {
//   @override
//   _RequestBloodPageState createState() => _RequestBloodPageState();
// }

// class _RequestBloodPageState extends State<RequestBloodPage> {
//   String? _selectedBloodGroup;
//   String? _location = "Fetching location...";
//   List<DocumentSnapshot> _donors = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }

//   /// 📌 Get Real-Time User Location
//   Future<void> _getLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks =
//           await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];

//       setState(() {
//         _location = "${place.locality}, ${place.administrativeArea}";
//       });
//     } catch (e) {
//       setState(() {
//         _location = "Location unavailable";
//       });
//     }
//   }

//   /// 📌 Fetch Matching Blood Donors from Firestore
//   Future<void> _fetchDonors() async {
//     if (_selectedBloodGroup == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❗ Please select a blood group!")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     // Fetch donors based on selected blood group (no status filter)
//     var querySnapshot = await FirebaseFirestore.instance
//         .collection('blood')
//         .where('bloodGroup', isEqualTo: _selectedBloodGroup)
//         .get();

//     setState(() {
//       _donors = querySnapshot.docs;
//       _isLoading = false;
//     });

//     if (_donors.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🚫 No donors found for $_selectedBloodGroup")),
//       );
//     }
//   }

//   /// 📌 Send Blood Request & Store in Firestore
//   Future<void> _sendRequest(String donorId, String donorName, String donorPhone) async {
//     try {
//       User? currentUser = FirebaseAuth.instance.currentUser;

//       if (currentUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("❌ User not logged in!")),
//         );
//         return;
//       }

//       await FirebaseFirestore.instance.collection('requests').add({
//         'requesterId': currentUser.uid,
//         'requesterName': currentUser.displayName ?? "Unknown",
//         'requesterPhone': currentUser.phoneNumber ?? "Unknown",
//         'requesterLocation': _location ?? "Unknown",
//         'requiredBlood': _selectedBloodGroup,
//         'donorId': donorId,
//         'donorName': donorName,
//         'donorPhone': donorPhone,
//         'status': 'pending',
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Blood request sent successfully!")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Failed to send request! Try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Request Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: "Select Blood Group"),
//               value: _selectedBloodGroup,
//               items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"].map((group) {
//                 return DropdownMenuItem<String>(
//                   value: group,
//                   child: Text(group),
//                 );
//               }).toList(),
//               validator: (value) => value == null ? "Select a blood group" : null,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedBloodGroup = value;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(labelText: "📍 Location"),
//               initialValue: _location,
//               readOnly: true,
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _fetchDonors,
//               child: Text("🔎 Find Donors"),
//             ),
//             SizedBox(height: 20),
//             _isLoading ? CircularProgressIndicator() : _buildDonorList(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Display Matching Donors with Request Button
//   Widget _buildDonorList() {
//     if (_donors.isEmpty) {
//       return Center(
//         child: Text("No donors available", style: TextStyle(fontSize: 16)),
//       );
//     }

//     return Expanded(
//       child: ListView(
//         children: _donors.map((doc) {
//           var data = doc.data() as Map<String, dynamic>;
//           return Card(
//             child: ListTile(
//               title: Text("👤 ${data['name']}"),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("📞 Phone: ${data['phone']}"),
//                   Text("📍 Location: ${data['location']}"),
//                   // No status field, simply display the donor info
//                 ],
//               ),
//               trailing: ElevatedButton(
//                 onPressed: () => _sendRequest(doc.id, data['name'], data['phone']),
//                 child: Text("Request"),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class RequestBloodPage extends StatefulWidget {
//   @override
//   _RequestBloodPageState createState() => _RequestBloodPageState();
// }

// class _RequestBloodPageState extends State<RequestBloodPage> {
//   String? _selectedBloodGroup;
//   String? _location = "Fetching location...";
//   List<DocumentSnapshot> _donors = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _getLocation();
//   }

//   /// 📌 Get User Location
//   Future<void> _getLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//       Placemark place = placemarks[0];

//       setState(() {
//         _location = "${place.locality}, ${place.administrativeArea}";
//       });
//     } catch (e) {
//       setState(() {
//         _location = "Location unavailable";
//       });
//     }
//   }

//   /// 📌 Fetch Matching Donors
//   Future<void> _fetchDonors() async {
//     if (_selectedBloodGroup == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❗ Please select a blood group!")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     var querySnapshot = await FirebaseFirestore.instance
//         .collection('blood')
//         .where('bloodGroup', isEqualTo: _selectedBloodGroup)
//         .get();

//     setState(() {
//       _donors = querySnapshot.docs;
//       _isLoading = false;
//     });

//     if (_donors.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🚫 No donors found for $_selectedBloodGroup")),
//       );
//     }
//   }

//   /// 📌 Send Request & Store in Firestore
//   Future<void> _sendRequest(String donorId, String donorName, String donorPhone) async {
//     try {
//       User? currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ User not logged in!")));
//         return;
//       }

//       await FirebaseFirestore.instance.collection('requests').add({
//         'requesterId': currentUser.uid,
//         'requesterName': currentUser.displayName ?? "Unknown",
//         'requesterPhone': currentUser.phoneNumber ?? "Unknown",
//         'requesterLocation': _location ?? "Unknown",
//         'requiredBlood': _selectedBloodGroup,
//         'donorId': donorId,
//         'donorName': donorName,
//         'donorPhone': donorPhone,
//         'status': 'pending',
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Blood request sent successfully!")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Failed to send request! Try again.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Request Blood")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: "Select Blood Group"),
//               value: _selectedBloodGroup,
//               items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"].map((group) {
//                 return DropdownMenuItem<String>(value: group, child: Text(group));
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedBloodGroup = value;
//                 });
//               },
//             ),
//             SizedBox(height: 10),
//             TextFormField(
//               decoration: InputDecoration(labelText: "📍 Location"),
//               initialValue: _location,
//               readOnly: true,
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(onPressed: _fetchDonors, child: Text("🔎 Find Donors")),
//             SizedBox(height: 20),
//             _isLoading ? CircularProgressIndicator() : _buildDonorList(),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 📌 Display Matching Donors
//   Widget _buildDonorList() {
//     if (_donors.isEmpty) {
//       return Center(child: Text("No donors available", style: TextStyle(fontSize: 16)));
//     }

//     return Expanded(
//       child: ListView(
//         children: _donors.map((doc) {
//           var data = doc.data() as Map<String, dynamic>;
//           return Card(
//             child: ListTile(
//               title: Text("👤 ${data['name']}"),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("📞 Phone: ${data['phone']}"),
//                   Text("📍 Location: ${data['location']}"),
//                 ],
//               ),
//               trailing: ElevatedButton(
//                 onPressed: () => _sendRequest(doc.id, data['name'], data['phone']),
//                 child: Text("Request"),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestBloodPage extends StatefulWidget {
  @override
  _RequestBloodPageState createState() => _RequestBloodPageState();
}

class _RequestBloodPageState extends State<RequestBloodPage> {
  String? selectedBloodGroup;
  List<Map<String, dynamic>> donors = [];
  bool isLoading = false;

  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  Future<void> _fetchDonors() async {
    setState(() => isLoading = true);

    QuerySnapshot donorSnapshot = await FirebaseFirestore.instance
        .collection('donors')
        .where('bloodGroup', isEqualTo: selectedBloodGroup)
        .where('status', isEqualTo: 'none')
        .get();

    setState(() {
      donors = donorSnapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
      isLoading = false;
    });
  }

  Future<void> _requestBlood(String donorId) async {
    await FirebaseFirestore.instance.collection('donors').doc(donorId).update({'status': 'requested'});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Blood request sent!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Request Blood")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Select Blood Group"),
              items: bloodGroups.map((group) {
                return DropdownMenuItem(value: group, child: Text(group));
              }).toList(),
              onChanged: (value) => selectedBloodGroup = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchDonors,
              child: Text("Find Donors"),
            ),
            isLoading ? CircularProgressIndicator() : Expanded(
              child: ListView.builder(
                itemCount: donors.length,
                itemBuilder: (context, index) {
                  var donor = donors[index];
                  return ListTile(
                    title: Text(donor['name']),
                    subtitle: Text("Phone: ${donor['phone']}"),
                    trailing: ElevatedButton(
                      onPressed: () => _requestBlood(donor['id']),
                      child: Text("Request"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
