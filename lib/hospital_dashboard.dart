// // // import 'package:flutter/material.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';

// // // class MedicalReportsPage extends StatelessWidget {
// // //   final String hospitalName;
// // //   MedicalReportsPage({required this.hospitalName});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(title: Text("Medical Reports - $hospitalName")),
// // //       body: StreamBuilder<QuerySnapshot>(
// // //         stream: FirebaseFirestore.instance
// // //             .collection('medical_reports')
// // //             .where('hospital_name', isEqualTo: hospitalName)
// // //             .orderBy('timestamp', descending: true)
// // //             .snapshots(),
// // //         builder: (context, snapshot) {
// // //           if (snapshot.connectionState == ConnectionState.waiting) {
// // //             return Center(child: CircularProgressIndicator());
// // //           }

// // //           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
// // //             return Center(child: Text("No reports available."));
// // //           }

// // //           var reports = snapshot.data!.docs;

// // //           return ListView.builder(
// // //             itemCount: reports.length,
// // //             itemBuilder: (context, index) {
// // //               var report = reports[index];
// // //               return Card(
// // //                 margin: EdgeInsets.all(10),
// // //                 elevation: 3,
// // //                 child: ListTile(
// // //                   title: Text("🧑 ${report['patient_name']}"),
// // //                   subtitle: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text("🩺 Condition: ${report['condition']}"),
// // //                       Text("🤕 Injuries: ${report['injuries']}"),
// // //                       Text("❤️ BP: ${report['bp']}"),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               );
// // //             },
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// // class MedicalReportsPage extends StatefulWidget {
// //   @override
// //   _MedicalReportsPageState createState() => _MedicalReportsPageState();
// // }

// // class _MedicalReportsPageState extends State<MedicalReportsPage> {
// //   List<String> hospitalNames = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchHospitals();
// //   }

// //   // Fetch hospital names where role is "hospital"
// //   Future<void> fetchHospitals() async {
// //     QuerySnapshot snapshot = await FirebaseFirestore.instance
// //         .collection('users')
// //         .where('role', isEqualTo: 'hospital')
// //         .get();

// //     setState(() {
// //       hospitalNames = snapshot.docs
// //           .map((doc) => doc['hospitalName']?.toString() ?? "Unnamed Hospital")
// //           .toList();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Medical Reports")),
// //       body: hospitalNames.isEmpty
// //           ? Center(child: CircularProgressIndicator()) // Show loader until hospitals are fetched
// //           : StreamBuilder<QuerySnapshot>(
// //               stream: FirebaseFirestore.instance
// //                   .collection('medical_reports')
// //                   .where('hospital_name', whereIn: hospitalNames)
// //                   .orderBy('timestamp', descending: true)
// //                   .snapshots(),
// //               builder: (context, snapshot) {
// //                 if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

// //                 var reports = snapshot.data!.docs;
// //                 if (reports.isEmpty) return Center(child: Text("No medical reports found."));

// //                 return ListView.builder(
// //                   itemCount: reports.length,
// //                   itemBuilder: (context, index) {
// //                     var report = reports[index];
// //                     return Card(
// //                       margin: EdgeInsets.all(10),
// //                       child: ListTile(
// //                         title: Text("Patient: ${report['patient_name']}"),
// //                         subtitle: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text("Condition: ${report['condition']}"),
// //                             Text("Hospital: ${report['hospital_name']}"),
// //                             Text("BP: ${report['bp']}"),
// //                             Text("Injuries: ${report['injuries']}"),
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 );
// //               },
// //             ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class MedicalReportsPage extends StatefulWidget {
//   @override
//   _MedicalReportsPageState createState() => _MedicalReportsPageState();
// }

// class _MedicalReportsPageState extends State<MedicalReportsPage> {
//   List<String> hospitalNames = [];
//   bool isLoading = true; // Loading state

//   @override
//   void initState() {
//     super.initState();
//     fetchHospitals();
//   }

//   /// Fetch hospital names where role is "hospital"
//   Future<void> fetchHospitals() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('role', isEqualTo: 'Hospital')
//           .get();

//       setState(() {
//         hospitalNames = snapshot.docs
//             .map((doc) => doc['hospitalName']?.toString() ?? "Unnamed Hospital")
//             .toList();
//         isLoading = false; // Set loading to false after fetching
//       });
//     } catch (e) {
//       print("Error fetching hospitals: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Reports")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator()) // Show loader
//           : hospitalNames.isEmpty
//               ? Center(child: Text("No hospitals found."))
//               : StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('medical_reports')
//                       .where('hospital_name',
//                           whereIn: hospitalNames.length > 10
//                               ? hospitalNames.sublist(0, 10)
//                               : hospitalNames)
//                       .orderBy('timestamp', descending: true)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return Center(child: Text("No medical reports found."));
//                     }

//                     var reports = snapshot.data!.docs;

//                     return ListView.builder(
//                       itemCount: reports.length,
//                       itemBuilder: (context, index) {
//                         var report = reports[index];
//                         return Card(
//                           margin: EdgeInsets.all(10),
//                           child: ListTile(
//                             title: Text("Patient: ${report['patient_name']}"),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Condition: ${report['condition']}"),
//                                 Text("Hospital: ${report['hospital_name']}"),
//                                 Text("BP: ${report['bp']}"),
//                                 Text("Injuries: ${report['injuries']}"),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class MedicalReportsPage extends StatefulWidget {
//   @override
//   _MedicalReportsPageState createState() => _MedicalReportsPageState();
// }

// class _MedicalReportsPageState extends State<MedicalReportsPage> {
//   String? hospitalName; // Hospital name of logged-in user

//   /// Fetch hospital name of the currently logged-in user
//   Future<String?> fetchHospitalName() async {
//     try {
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();

//       return userDoc['hospitalName']?.toString();
//     } catch (e) {
//       print("Error fetching hospital name: $e");
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Reports")),
//       body: FutureBuilder<String?>(
//         future: fetchHospitalName(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text("⚠️ Unable to fetch hospital details."));
//           }

//           hospitalName = snapshot.data;

//           return StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('medical_reports')
//                 .where('hospital_name', isEqualTo: hospitalName)
//                 .orderBy('timestamp', descending: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               }
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return Center(child: Text("No medical reports found."));
//               }

//               var reports = snapshot.data!.docs;

//               return ListView.builder(
//                 itemCount: reports.length,
//                 itemBuilder: (context, index) {
//                   var report = reports[index];
//                   return Card(
//                     margin: EdgeInsets.all(10),
//                     child: ListTile(
//                       title: Text("Patient: ${report['patient_name']}"),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Condition: ${report['condition']}"),
//                           Text("BP: ${report['bp']}"),
//                           Text("Injuries: ${report['injuries']}"),
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
// import 'package:firebase_auth/firebase_auth.dart';

// class MedicalReportsPage extends StatefulWidget {
//   @override
//   _MedicalReportsPageState createState() => _MedicalReportsPageState();
// }

// class _MedicalReportsPageState extends State<MedicalReportsPage> {
//   String? hospitalName;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchHospitalName();
//   }

//   /// Fetch logged-in hospital's name from 'users' collection
//   Future<void> fetchHospitalName() async {
//     try {
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();

//       String? fetchedHospitalName = userDoc['hospitalName']?.toString();
//       print("✅ Logged-in Hospital Name: $fetchedHospitalName");

//       setState(() {
//         hospitalName = fetchedHospitalName;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("❌ Error fetching hospital name: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Reports")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator()) // Show loading
//           : hospitalName == null
//               ? Center(child: Text("❌ Unable to fetch hospital details."))
//               : StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('medical_reports')
//                       .where('hospital_name', isEqualTo: hospitalName)
//                       .orderBy('timestamp', descending: true)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       print("⚠️ No medical reports found for: $hospitalName");
//                       return Center(child: Text("No medical reports found."));
//                     }

//                     var reports = snapshot.data!.docs;
//                     print("📄 Found ${reports.length} reports for $hospitalName");

//                     return ListView.builder(
//                       itemCount: reports.length,
//                       itemBuilder: (context, index) {
//                         var report = reports[index];
//                         print("📝 Report Data: ${report.data()}");

//                         return Card(
//                           margin: EdgeInsets.all(10),
//                           child: ListTile(
//                             title: Text("Patient: ${report['patient_name']}"),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Condition: ${report['condition']}"),
//                                 Text("BP: ${report['bp']}"),
//                                 Text("Injuries: ${report['injuries']}"),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class MedicalReportsPage extends StatefulWidget {
//   @override
//   _MedicalReportsPageState createState() => _MedicalReportsPageState();
// }

// class _MedicalReportsPageState extends State<MedicalReportsPage> {
//   String? hospitalName;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchHospitalName();
//   }

//   /// 🔍 Debug function: Fetch all hospital names from Firestore
//   void debugHospitalNames() async {
//     QuerySnapshot snapshot =
//         await FirebaseFirestore.instance.collection('medical_reports').get();
//     print("📊 All hospital names in 'medical_reports':");
//     for (var doc in snapshot.docs) {
//       print("➡️ ${doc['hospital_name']}");
//     }
//   }

//   /// Fetch logged-in hospital's name from 'users' collection
//   Future<void> fetchHospitalName() async {
//     try {
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();

//       String? fetchedHospitalName = userDoc['hospitalName']?.toString().trim();
//       print("✅ Logged-in Hospital Name: $fetchedHospitalName");

//       setState(() {
//         hospitalName = fetchedHospitalName;
//         isLoading = false;
//       });

//       // Debug hospital names in Firestore
//       debugHospitalNames();
//     } catch (e) {
//       print("❌ Error fetching hospital name: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Reports")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator()) // Show loading
//           : hospitalName == null
//               ? Center(child: Text("❌ Unable to fetch hospital details."))
//               : StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('medical_reports')
//                       .where('hospital_name', isEqualTo: hospitalName)
//                       .orderBy('timestamp', descending: true)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       print("⚠️ No medical reports found for: $hospitalName");
//                       return Center(child: Text("No medical reports found."));
//                     }

//                     var reports = snapshot.data!.docs;
//                     print("📄 Found ${reports.length} reports for $hospitalName");

//                     return ListView.builder(
//                       itemCount: reports.length,
//                       itemBuilder: (context, index) {
//                         var report = reports[index];
//                         print("📝 Report Data: ${report.data()}");

//                         return Card(
//                           margin: EdgeInsets.all(10),
//                           child: ListTile(
//                             title: Text("Patient: ${report['patient_name']}"),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Condition: ${report['condition']}"),
//                                 Text("BP: ${report['bp']}"),
//                                 Text("Injuries: ${report['injuries']}"),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class MedicalReportsPage extends StatefulWidget {
//   @override
//   _MedicalReportsPageState createState() => _MedicalReportsPageState();
// }

// class _MedicalReportsPageState extends State<MedicalReportsPage> {
//   String? hospitalName;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchHospitalName();
//   }

//   /// Fetch the logged-in hospital's name from Firestore
//   Future<void> fetchHospitalName() async {
//     try {
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();

//       String? fetchedHospitalName = userDoc['hospitalName']?.toString().trim();
//       print("✅ Logged-in Hospital Name: '$fetchedHospitalName'");

//       setState(() {
//         hospitalName = fetchedHospitalName;
//         isLoading = false;
//       });

//       if (hospitalName == null || hospitalName!.isEmpty) {
//         print("❌ Hospital name is missing in Firestore!");
//       } else {
//         debugMedicalReports();
//       }
//     } catch (e) {
//       print("❌ Error fetching hospital name: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   /// Debug function: Check if reports exist for the hospital
//   void debugMedicalReports() async {
//     if (hospitalName == null) return;

//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('medical_reports')
//         .where('hospital_name', isEqualTo: hospitalName)
//         .get();

//     if (snapshot.docs.isEmpty) {
//       print("⚠️ No reports found for hospital: '$hospitalName'");
//     } else {
//       print("📄 Found ${snapshot.docs.length} reports for '$hospitalName'");
//       for (var doc in snapshot.docs) {
//         print("➡️ Report: ${doc.data()}");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Medical Reports")),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator()) // Show loading
//           : hospitalName == null
//               ? Center(child: Text("❌ Unable to fetch hospital details."))
//               : StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('medical_reports')
//                       .where('hospital_name', isEqualTo: hospitalName)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: CircularProgressIndicator());
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return Center(
//                           child:
//                               Text("⚠️ No medical reports found for '$hospitalName'"));
//                     }

//                     var reports = snapshot.data!.docs;

//                     return ListView.builder(
//                       itemCount: reports.length,
//                       itemBuilder: (context, index) {
//                         var report = reports[index];
//                         var data = report.data() as Map<String, dynamic>;

//                         return Card(
//                           margin: EdgeInsets.all(10),
//                           child: ListTile(
//                             title: Text("Patient: ${data['patient_name']}"),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Condition: ${data['condition']}"),
//                                 Text("BP: ${data['bp']}"),
//                                 Text("Injuries: ${data['injuries']}"),
//                                 if (data.containsKey('timestamp'))
//                                   Text("Date: ${data['timestamp'].toDate()}"), 
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }
 
//  import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class MedicalReportsPage extends StatefulWidget {
//   @override
//   _MedicalReportsPageState createState() => _MedicalReportsPageState();
// }

// class _MedicalReportsPageState extends State<MedicalReportsPage> {
//   String? hospitalName;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchHospitalName();
//   }

//   /// Fetch the logged-in hospital's name from Firestore
//   Future<void> fetchHospitalName() async {
//     try {
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();

//       String? fetchedHospitalName = userDoc['hospitalName']?.toString().trim();
//       print("✅ Logged-in Hospital Name: '$fetchedHospitalName'");

//       setState(() {
//         hospitalName = fetchedHospitalName;
//         isLoading = false;
//       });

//       if (hospitalName == null || hospitalName!.isEmpty) {
//         print("❌ Hospital name is missing in Firestore!");
//       } else {
//         debugMedicalReports();
//       }
//     } catch (e) {
//       print("❌ Error fetching hospital name: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   /// **Debugging Function:** Check if reports exist for the hospital
//   void debugMedicalReports() async {
//     if (hospitalName == null) return;

//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('medical_reports')
//         .where('hospital', isEqualTo: hospitalName) // 🔹 Ensure this matches Firestore
//         .get();

//     if (snapshot.docs.isEmpty) {
//       print("⚠️ No reports found for hospital: '$hospitalName'");
//     } else {
//       print("📄 Found ${snapshot.docs.length} reports for '$hospitalName'");
//       for (var doc in snapshot.docs) {
//         print("➡️ Report: ${doc.data()}");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Medical Reports")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator()) // Show loading
//           : hospitalName == null
//               ? const Center(child: Text("❌ Unable to fetch hospital details."))
//               : StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('medical_reports')
//                       .where('hospital', isEqualTo: hospitalName) // 🔹 Matches field in Firestore
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return Center(
//                         child: Text("⚠️ No medical reports found for '$hospitalName'"),
//                       );
//                     }

//                     var reports = snapshot.data!.docs;

//                     return ListView.builder(
//                       itemCount: reports.length,
//                       itemBuilder: (context, index) {
//                         var report = reports[index];
//                         var data = report.data() as Map<String, dynamic>;

//                         return Card(
//                           margin: const EdgeInsets.all(10),
//                           child: ListTile(
//                             title: Text("Patient: ${data['name'] ?? 'Unknown'}"),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Condition: ${data['injury'] ?? 'N/A'}"),
//                                 Text("BP: ${data['blood_pressure'] ?? 'N/A'}"),
//                                 Text("Age: ${data['age'] ?? 'N/A'}"),
//                                 if (data.containsKey('timestamp'))
//                                   Text("Date: ${data['timestamp'].toDate()}"),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class MedicalReportsPage extends StatefulWidget {
//   @override
//   _MedicalReportsPageState createState() => _MedicalReportsPageState();
// }

// class _MedicalReportsPageState extends State<MedicalReportsPage> {
//   String? hospitalName;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchHospitalName();
//   }

//   /// Fetch the logged-in hospital's name from Firestore
//   Future<void> fetchHospitalName() async {
//     try {
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();

//       String? fetchedHospitalName = userDoc['hospitalName']?.toString().trim();
//       print("✅ Logged-in Hospital Name: '$fetchedHospitalName'");

//       setState(() {
//         hospitalName = fetchedHospitalName;
//         isLoading = false;
//       });

//       if (hospitalName == null || hospitalName!.isEmpty) {
//         print("❌ Hospital name is missing in Firestore!");
//       } else {
//         debugMedicalReports();
//       }
//     } catch (e) {
//       print("❌ Error fetching hospital name: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   /// **Debugging Function:** Check if reports exist for the hospital
//   void debugMedicalReports() async {
//     if (hospitalName == null) return;

//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('medical_reports')
//         .where('hospital', isEqualTo: hospitalName) // 🔹 Matches Firestore
//         .get();

//     if (snapshot.docs.isEmpty) {
//       print("⚠️ No reports found for hospital: '$hospitalName'");
//     } else {
//       print("📄 Found ${snapshot.docs.length} reports for '$hospitalName'");
//       for (var doc in snapshot.docs) {
//         print("➡️ Report: ${doc.data()}");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Medical Reports")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator()) // Show loading
//           : hospitalName == null
//               ? const Center(child: Text("❌ Unable to fetch hospital details."))
//               : StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('medical_reports')
//                       .where('hospital', isEqualTo: hospitalName) // 🔹 Matches field in Firestore
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return Center(
//                         child: Text("⚠️ No medical reports found for '$hospitalName'"),
//                       );
//                     }

//                     var reports = snapshot.data!.docs;

//                     return ListView.builder(
//                       itemCount: reports.length,
//                       itemBuilder: (context, index) {
//                         var report = reports[index];
//                         var data = report.data() as Map<String, dynamic>;

//                         // **Correct Field Names from Firestore**
//                         String patientName = data.containsKey('name')
//                             ? data['name'].toString()
//                             : "Unknown";

//                         String age = data.containsKey('age')
//                             ? data['age'].toString()
//                             : "N/A";

//                         String bloodPressure = data.containsKey('blood_pressure')
//                             ? data['blood_pressure'].toString()
//                             : "N/A";

//                         String injury = data.containsKey('injury')
//                             ? data['injury'].toString()
//                             : "N/A";

//                         String timestamp = data.containsKey('timestamp')
//                             ? data['timestamp'].toDate().toString()
//                             : "No Date";

//                         return Card(
//                           margin: const EdgeInsets.all(10),
//                           child: ListTile(
//                             title: Text("Patient: $patientName"),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("Age: $age"),
//                                 Text("Blood Pressure: $bloodPressure"),
//                                 Text("Injury: $injury"),
//                                 Text("Date: $timestamp"),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart'; // Ensure this import points to your login page file.

class MedicalReportsPage extends StatefulWidget {
  @override
  _MedicalReportsPageState createState() => _MedicalReportsPageState();
}

class _MedicalReportsPageState extends State<MedicalReportsPage> {
  String? hospitalName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHospitalName();
  }

  /// Fetch the logged-in hospital's name from Firestore
  Future<void> fetchHospitalName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      String? fetchedHospitalName = userDoc['hospitalName']?.toString().trim();
      print("✅ Logged-in Hospital Name: '$fetchedHospitalName'");

      setState(() {
        hospitalName = fetchedHospitalName;
        isLoading = false;
      });

      if (hospitalName == null || hospitalName!.isEmpty) {
        print("❌ Hospital name is missing in Firestore!");
      } else {
        debugMedicalReports();
      }
    } catch (e) {
      print("❌ Error fetching hospital name: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  /// **Debugging Function:** Check if reports exist for the hospital
  void debugMedicalReports() async {
    if (hospitalName == null) return;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('medical_reports')
        .where('hospital', isEqualTo: hospitalName) // 🔹 Matches Firestore
        .get();

    if (snapshot.docs.isEmpty) {
      print("⚠️ No reports found for hospital: '$hospitalName'");
    } else {
      print("📄 Found ${snapshot.docs.length} reports for '$hospitalName'");
      for (var doc in snapshot.docs) {
        print("➡️ Report: ${doc.data()}");
      }
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: hospitalName == null
            ? Text("Medical Reports")
            : Text(" $hospitalName"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _signOut, // Sign-out on button press
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : hospitalName == null
              ? Center(child: Text("❌ Unable to fetch hospital details."))
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('medical_reports')
                      .where('hospital', isEqualTo: hospitalName) // 🔹 Matches field in Firestore
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text("⚠️ No medical reports found for '$hospitalName'"),
                      );
                    }

                    var reports = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        var report = reports[index];
                        var data = report.data() as Map<String, dynamic>;

                        // **Correct Field Names from Firestore**
                        String patientName = data.containsKey('name')
                            ? data['name'].toString()
                            : "Unknown";

                        String age = data.containsKey('age')
                            ? data['age'].toString()
                            : "N/A";

                        String bloodPressure = data.containsKey('blood_pressure')
                            ? data['blood_pressure'].toString()
                            : "N/A";

                        String injury = data.containsKey('injury')
                            ? data['injury'].toString()
                            : "N/A";

                        String timestamp = data.containsKey('timestamp')
                            ? data['timestamp'].toDate().toString()
                            : "No Date";

                        return Card(
                          margin: const EdgeInsets.all(12),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              "Patient: $patientName",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Age: $age", style: TextStyle(fontSize: 14)),
                                Text("Blood Pressure: $bloodPressure", style: TextStyle(fontSize: 14)),
                                Text("Injury: $injury", style: TextStyle(fontSize: 14)),
                                Text("Date: $timestamp", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            isThreeLine: true,
                            dense: true,
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
