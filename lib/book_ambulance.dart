// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BookAmbulancePage extends StatefulWidget {
//   @override
//   _BookAmbulancePageState createState() => _BookAmbulancePageState();
// }

// class _BookAmbulancePageState extends State<BookAmbulancePage> {
//   Position? _currentPosition;
//   List<String> _hospitals = ["Hospital 1", "Hospital 2", "Hospital 3"]; // Replace with dynamic list later
//   String? _selectedHospital;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = position;
//     });
//   }

//   // Function to pick a date
//   Future<void> _pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   // Function to pick a time
//   Future<void> _pickTime() async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (pickedTime != null) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });
//     }
//   }

//   void _bookAmbulance() {
//     if (_selectedHospital == null || _selectedDate == null || _selectedTime == null || _currentPosition == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please select a hospital, date, time, and allow location access!")),
//       );
//       return;
//     }

//     // Combine date and time into a single DateTime object
//     DateTime finalDateTime = DateTime(
//       _selectedDate!.year,
//       _selectedDate!.month,
//       _selectedDate!.day,
//       _selectedTime!.hour,
//       _selectedTime!.minute,
//     );

//     // Save the details to Firebase Firestore
//     FirebaseFirestore.instance.collection('booking_status').add({
//       "fromLocation": {
//         "latitude": _currentPosition!.latitude,
//         "longitude": _currentPosition!.longitude,
//       },
//       "toLocation": _selectedHospital,
//       "dateTime": finalDateTime.toIso8601String(), // Storing as ISO format
//       "status": "pending", // Initial status
//       "createdAt": FieldValue.serverTimestamp(), // Firestore timestamp
//     }).then((value) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🚑 Ambulance booked successfully!")),
//       );
//       Navigator.pop(context);
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error booking ambulance: $error")),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Book Ambulance")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hospital Dropdown
//             DropdownButtonFormField<String>(
//               decoration: InputDecoration(labelText: "Select Hospital"),
//               items: _hospitals.map((String hospital) {
//                 return DropdownMenuItem<String>(
//                   value: hospital,
//                   child: Text(hospital),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _selectedHospital = value;
//                 });
//               },
//             ),
//             SizedBox(height: 20),

//             // Date Picker
//             ListTile(
//               title: Text(
//                 _selectedDate == null ? "Select Date" : "📅 Date: ${_selectedDate!.toLocal()}".split(' ')[0],
//               ),
//               trailing: Icon(Icons.calendar_today),
//               onTap: _pickDate,
//             ),
//             SizedBox(height: 10),

//             // Time Picker
//             ListTile(
//               title: Text(
//                 _selectedTime == null ? "Select Time" : "⏰ Time: ${_selectedTime!.format(context)}",
//               ),
//               trailing: Icon(Icons.access_time),
//               onTap: _pickTime,
//             ),
//             SizedBox(height: 20),

//             // Confirm Booking Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: _bookAmbulance,
//                 child: Text("🚑 Confirm Booking"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';

// class BookAmbulancePage extends StatefulWidget {
//   @override
//   _BookAmbulancePageState createState() => _BookAmbulancePageState();
// }

// class _BookAmbulancePageState extends State<BookAmbulancePage> {
//   Position? _currentPosition;
//   String? _currentAddress;
//   List<String> _hospitals = [];
//   String? _selectedHospital;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   TextEditingController _patientNameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = position;
//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     });
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     final String overpassQuery =
//         '[out:json];node["amenity"="hospital"](around:3000,$lat,$lon);out;';
//     final String url =
//         'https://overpass-api.de/api/interpreter?data=$overpassQuery';

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         List<String> hospitalNames = [];

//         for (var element in data['elements']) {
//           if (element['tags'] != null && element['tags']['name'] != null) {
//             hospitalNames.add(element['tags']['name']);
//           }
//         }

//         setState(() {
//           _hospitals = hospitalNames.isNotEmpty ? hospitalNames : ["No hospitals found"];
//         });
//       } else {
//         print("Error fetching hospitals: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }

//   Future<void> _pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _pickTime() async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (pickedTime != null) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });
//     }
//   }

//   void _bookAmbulance() {
//     if (_selectedHospital == null ||
//         _selectedDate == null ||
//         _selectedTime == null ||
//         _currentPosition == null ||
//         _patientNameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please fill in all fields before booking!")),
//       );
//       return;
//     }

//     DateTime finalDateTime = DateTime(
//       _selectedDate!.year,
//       _selectedDate!.month,
//       _selectedDate!.day,
//       _selectedTime!.hour,
//       _selectedTime!.minute,
//     );

//     FirebaseFirestore.instance.collection('booking_status').add({
//       "patientName": _patientNameController.text,
//       "fromLocation": {
//         "latitude": _currentPosition!.latitude,
//         "longitude": _currentPosition!.longitude,
//       },
//       "toLocation": _selectedHospital,
//       "dateTime": finalDateTime.toIso8601String(),
//       "status": "pending",
//       "createdAt": FieldValue.serverTimestamp(),
//     }).then((value) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("🚑 Ambulance booked successfully!")),
//       );
//       Navigator.pop(context);
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error booking ambulance: $error")),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Book Ambulance")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Display 'From' Location
//               if (_currentPosition != null)
//                 Text(
//                   "📍 From: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               SizedBox(height: 10),

//               // Patient Name Input
//               TextField(
//                 controller: _patientNameController,
//                 decoration: InputDecoration(labelText: "Patient Name"),
//               ),
//               SizedBox(height: 10),

//               // Hospital Dropdown
//               if (_hospitals.isEmpty)
//                 CircularProgressIndicator()
//               else
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(labelText: "Select Hospital"),
//                   items: _hospitals.map((String hospital) {
//                     return DropdownMenuItem<String>(
//                       value: hospital,
//                       child: Text(hospital),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedHospital = value;
//                     });
//                   },
//                 ),
//               SizedBox(height: 20),

//               // Date Picker
//               ListTile(
//                 title: Text(
//                   _selectedDate == null ? "Select Date" : "📅 Date: ${_selectedDate!.toLocal()}".split(' ')[0],
//                 ),
//                 trailing: Icon(Icons.calendar_today),
//                 onTap: _pickDate,
//               ),
//               SizedBox(height: 10),

//               // Time Picker
//               ListTile(
//                 title: Text(
//                   _selectedTime == null ? "Select Time" : "⏰ Time: ${_selectedTime!.format(context)}",
//                 ),
//                 trailing: Icon(Icons.access_time),
//                 onTap: _pickTime,
//               ),
//               SizedBox(height: 20),

//               // Confirm Booking Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _bookAmbulance,
//                   child: Text("🚑 Confirm Booking"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';

// class BookAmbulancePage extends StatefulWidget {
//   @override
//   _BookAmbulancePageState createState() => _BookAmbulancePageState();
// }

// class _BookAmbulancePageState extends State<BookAmbulancePage> {
//   Position? _currentPosition;
//   String? _currentAddress;
//   List<String> _hospitals = [];
//   String? _selectedHospital;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   TextEditingController _patientNameController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = position;
//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     });
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     final String overpassQuery =
//         '[out:json];node["amenity"="hospital"](around:3000,$lat,$lon);out;';
//     final String url =
//         'https://overpass-api.de/api/interpreter?data=$overpassQuery';

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         List<String> hospitalNames = [];

//         for (var element in data['elements']) {
//           if (element['tags'] != null && element['tags']['name'] != null) {
//             hospitalNames.add(element['tags']['name']);
//           }
//         }

//         setState(() {
//           _hospitals = hospitalNames.isNotEmpty ? hospitalNames : ["No hospitals found"];
//         });
//       } else {
//         print("Error fetching hospitals: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }

//   Future<void> _pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _pickTime() async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (pickedTime != null) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });
//     }
//   }

//   /// 🚑 **Updated function to include userId**
//   void _bookAmbulance() async {
//     // ✅ Get the currently logged-in user
//     User? currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Error: Please log in to book an ambulance.")),
//       );
//       return;
//     }

//     if (_selectedHospital == null ||
//         _selectedDate == null ||
//         _selectedTime == null ||
//         _currentPosition == null ||
//         _patientNameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please fill in all fields before booking!")),
//       );
//       return;
//     }

//     DateTime finalDateTime = DateTime(
//       _selectedDate!.year,
//       _selectedDate!.month,
//       _selectedDate!.day,
//       _selectedTime!.hour,
//       _selectedTime!.minute,
//     );

//     await FirebaseFirestore.instance.collection('booking_status').add({
//       "userId": currentUser.uid, // ✅ Store userId
//       "patientName": _patientNameController.text,
//       "fromLocation": {
//         "latitude": _currentPosition!.latitude,
//         "longitude": _currentPosition!.longitude,
//       },
//       "toLocation": _selectedHospital,
//       "dateTime": finalDateTime.toIso8601String(),
//       "status": "pending",
//       "createdAt": FieldValue.serverTimestamp(),
//     }).then((value) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Ambulance booked successfully!")),
//       );
//       Navigator.pop(context);
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error booking ambulance: $error")),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Book Ambulance")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Display 'From' Location
//               if (_currentPosition != null)
//                 Text(
//                   "📍 From: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               SizedBox(height: 10),

//               // Patient Name Input
//               TextField(
//                 controller: _patientNameController,
//                 decoration: InputDecoration(labelText: "Patient Name"),
//               ),
//               SizedBox(height: 10),

//               // Hospital Dropdown
//               if (_hospitals.isEmpty)
//                 CircularProgressIndicator()
//               else
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(labelText: "Select Hospital"),
//                   items: _hospitals.map((String hospital) {
//                     return DropdownMenuItem<String>(
//                       value: hospital,
//                       child: Text(hospital),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedHospital = value;
//                     });
//                   },
//                 ),
//               SizedBox(height: 20),

//               // Date Picker
//               ListTile(
//                 title: Text(
//                   _selectedDate == null ? "Select Date" : "📅 Date: ${_selectedDate!.toLocal()}".split(' ')[0],
//                 ),
//                 trailing: Icon(Icons.calendar_today),
//                 onTap: _pickDate,
//               ),
//               SizedBox(height: 10),

//               // Time Picker
//               ListTile(
//                 title: Text(
//                   _selectedTime == null ? "Select Time" : "⏰ Time: ${_selectedTime!.format(context)}",
//                 ),
//                 trailing: Icon(Icons.access_time),
//                 onTap: _pickTime,
//               ),
//               SizedBox(height: 20),

//               // Confirm Booking Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _bookAmbulance,
//                   child: Text("🚑 Confirm Booking"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:convert';

// class BookAmbulancePage extends StatefulWidget {
//   @override
//   _BookAmbulancePageState createState() => _BookAmbulancePageState();
// }

// class _BookAmbulancePageState extends State<BookAmbulancePage> {
//   Position? _currentPosition;
//   String? _currentAddress;
//   List<String> _hospitals = [];
//   String? _selectedHospital;
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;

//   TextEditingController _patientNameController = TextEditingController();
//   TextEditingController _phoneNumberController = TextEditingController(); // 🔹 Added for phone number

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = position;
//       _fetchNearbyHospitals(position.latitude, position.longitude);
//     });
//   }

//   Future<void> _fetchNearbyHospitals(double lat, double lon) async {
//     final String overpassQuery =
//         '[out:json];node["amenity"="hospital"](around:3000,$lat,$lon);out;';
//     final String url =
//         'https://overpass-api.de/api/interpreter?data=$overpassQuery';

//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         List<String> hospitalNames = [];

//         for (var element in data['elements']) {
//           if (element['tags'] != null && element['tags']['name'] != null) {
//             hospitalNames.add(element['tags']['name']);
//           }
//         }

//         setState(() {
//           _hospitals = hospitalNames.isNotEmpty ? hospitalNames : ["No hospitals found"];
//         });
//       } else {
//         print("Error fetching hospitals: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }

//   Future<void> _pickDate() async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _pickTime() async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );

//     if (pickedTime != null) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });
//     }
//   }

//   /// 🚑 **Updated function to include userId and phone number**
//   void _bookAmbulance() async {
//     // ✅ Get the currently logged-in user
//     User? currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Error: Please log in to book an ambulance.")),
//       );
//       return;
//     }

//     if (_selectedHospital == null ||
//         _selectedDate == null ||
//         _selectedTime == null ||
//         _currentPosition == null ||
//         _patientNameController.text.isEmpty ||
//         _phoneNumberController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please fill in all fields before booking!")),
//       );
//       return;
//     }

//     if (_phoneNumberController.text.length != 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Please enter a valid 10-digit phone number!")),
//       );
//       return;
//     }

//     DateTime finalDateTime = DateTime(
//       _selectedDate!.year,
//       _selectedDate!.month,
//       _selectedDate!.day,
//       _selectedTime!.hour,
//       _selectedTime!.minute,
//     );

//     await FirebaseFirestore.instance.collection('booking_status').add({
//       "userId": currentUser.uid, // ✅ Store userId
//       "patientName": _patientNameController.text,
//       "phoneNumber": _phoneNumberController.text, // 🔹 Store phone number
//       "fromLocation": {
//         "latitude": _currentPosition!.latitude,
//         "longitude": _currentPosition!.longitude,
//       },
//       "toLocation": _selectedHospital,
//       "dateTime": finalDateTime.toIso8601String(),
//       "status": "pending",
//       "createdAt": FieldValue.serverTimestamp(),
//     }).then((value) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("✅ Ambulance booked successfully!")),
//       );
//       Navigator.pop(context);
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("⚠️ Error booking ambulance: $error")),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("🚑 Book Ambulance")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Display 'From' Location
//               if (_currentPosition != null)
//                 Text(
//                   "📍 From: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               SizedBox(height: 10),

//               // Patient Name Input
//               TextField(
//                 controller: _patientNameController,
//                 decoration: InputDecoration(labelText: "Patient Name"),
//               ),
//               SizedBox(height: 10),

//               // Phone Number Input
//               TextField(
//                 controller: _phoneNumberController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: "Phone Number",
//                   prefixText: "+91 ", // 🔹 Added country code
//                 ),
//               ),
//               SizedBox(height: 10),

//               // Hospital Dropdown
//               if (_hospitals.isEmpty)
//                 CircularProgressIndicator()
//               else
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(labelText: "Select Hospital"),
//                   items: _hospitals.map((String hospital) {
//                     return DropdownMenuItem<String>(
//                       value: hospital,
//                       child: Text(hospital),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedHospital = value;
//                     });
//                   },
//                 ),
//               SizedBox(height: 20),

//               // Date Picker
//               ListTile(
//                 title: Text(
//                   _selectedDate == null ? "Select Date" : "📅 Date: ${_selectedDate!.toLocal()}".split(' ')[0],
//                 ),
//                 trailing: Icon(Icons.calendar_today),
//                 onTap: _pickDate,
//               ),
//               SizedBox(height: 10),

//               // Time Picker
//               ListTile(
//                 title: Text(
//                   _selectedTime == null ? "Select Time" : "⏰ Time: ${_selectedTime!.format(context)}",
//                 ),
//                 trailing: Icon(Icons.access_time),
//                 onTap: _pickTime,
//               ),
//               SizedBox(height: 20),

//               // Confirm Booking Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _bookAmbulance,
//                   child: Text("🚑 Confirm Booking"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // 🌍 To convert lat-lon to address
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class BookAmbulancePage extends StatefulWidget {
  @override
  _BookAmbulancePageState createState() => _BookAmbulancePageState();
}

class _BookAmbulancePageState extends State<BookAmbulancePage> {
  Position? _currentPosition;
  String? _currentAddress; // ✅ Holds formatted address
  List<String> _hospitals = [];
  String? _selectedHospital;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  TextEditingController _patientNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController(); 

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// 🔹 Get Current Location & Convert to Address
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Convert Lat-Lon to Address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];
      String formattedAddress =
          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() {
        _currentPosition = position;
        _currentAddress = formattedAddress;
      });

      _fetchNearbyHospitals(position.latitude, position.longitude);
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  /// 🔹 Fetch Nearby Hospitals using OpenStreetMap API
  Future<void> _fetchNearbyHospitals(double lat, double lon) async {
    final String overpassQuery =
        '[out:json];node["amenity"="hospital"](around:5000,$lat,$lon);out;';
    final String url =
        'https://overpass-api.de/api/interpreter?data=$overpassQuery';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> hospitalNames = [];

        for (var element in data['elements']) {
          if (element['tags'] != null && element['tags']['name'] != null) {
            hospitalNames.add(element['tags']['name']);
          }
        }

        setState(() {
          _hospitals = hospitalNames.isNotEmpty ? hospitalNames : ["No hospitals found"];
        });
      } else {
        print("Error fetching hospitals: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  /// 🔹 Pick Date
  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  /// 🔹 Pick Time
  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  /// 🔹 Book Ambulance & Save to Firebase
  void _bookAmbulance() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Please log in to book an ambulance.")),
      );
      return;
    }

    if (_selectedHospital == null ||
        _selectedDate == null ||
        _selectedTime == null ||
        _currentAddress == null ||
        _patientNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Please fill in all fields!")),
      );
      return;
    }

    if (_phoneNumberController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Enter a valid 10-digit phone number!")),
      );
      return;
    }

    DateTime finalDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    await FirebaseFirestore.instance.collection('booking_status').add({
      "userId": currentUser.uid,
      "patientName": _patientNameController.text,
      "phoneNumber": _phoneNumberController.text,
      "fromLocation": _currentAddress, // ✅ Store address instead of lat-lon
      "toLocation": _selectedHospital,
      "dateTime": finalDateTime.toIso8601String(),
      "status": "pending",
      "createdAt": FieldValue.serverTimestamp(),
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Ambulance booked successfully!")),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error booking ambulance: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("🚑 Book Ambulance")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Display formatted 'From' address
              Text(
                _currentAddress != null
                    ? "📍 From: $_currentAddress"
                    : "📍 Fetching location...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Patient Name
              TextField(
                controller: _patientNameController,
                decoration: InputDecoration(labelText: "Patient Name"),
              ),
              SizedBox(height: 10),

              // Phone Number
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixText: "+91 ",
                ),
              ),
              SizedBox(height: 10),

              // Hospital Dropdown
              if (_hospitals.isEmpty)
                CircularProgressIndicator()
              else
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: "Select Hospital"),
                  items: _hospitals.map((String hospital) {
                    return DropdownMenuItem<String>(
                      value: hospital,
                      child: Text(hospital),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedHospital = value;
                    });
                  },
                ),
              SizedBox(height: 20),

              // Date & Time Pickers
              ListTile(title: Text(_selectedDate == null ? "Select Date" : "📅 Date: ${_selectedDate!.toLocal()}".split(' ')[0]), trailing: Icon(Icons.calendar_today), onTap: _pickDate),
              ListTile(title: Text(_selectedTime == null ? "Select Time" : "⏰ Time: ${_selectedTime!.format(context)}"), trailing: Icon(Icons.access_time), onTap: _pickTime),
              SizedBox(height: 20),

              // Confirm Booking Button
              Center(child: ElevatedButton(onPressed: _bookAmbulance, child: Text("🚑 Confirm Booking"))),
            ],
          ),
        ),
      ),
    );
  }
}

