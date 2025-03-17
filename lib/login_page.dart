// // import 'package:flutter/material.dart';
// // import 'signup_page.dart';

// // class LoginPage extends StatefulWidget {
// //   const LoginPage({super.key});

// //   @override
// //   State<LoginPage> createState() => _LoginPageState();
// // }

// // class _LoginPageState extends State<LoginPage> {
// //   final _emailController = TextEditingController();
// //   final _passwordController = TextEditingController();

// //   void _login() {
// //     // Add authentication logic here
// //     print('Email: ${_emailController.text}');
// //     print('Password: ${_passwordController.text}');
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Login')),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             TextField(
// //               controller: _emailController,
// //               decoration: const InputDecoration(
// //                 labelText: 'Email',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),
// //             const SizedBox(height: 15),
// //             TextField(
// //               controller: _passwordController,
// //               decoration: const InputDecoration(
// //                 labelText: 'Password',
// //                 border: OutlineInputBorder(),
// //               ),
// //               obscureText: true,
// //             ),
// //             const SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: _login,
// //               child: const Text('Login'),
// //             ),
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => const SignupPage()),
// //                 );
// //               },
// //               child: const Text("Don't have an account? Sign up"),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'signup_page.dart';
// import 'victim_dashboard.dart';  // Screen for Victim
// import 'ambulance_dashboard.dart'; // Screen for 108 Assistants
// import 'responder_dashboard.dart'; // Screen for Community Responders
// import 'donor_dashboard.dart'; // Screen for Blood Donors

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// ✅ Login Function with Role-Based Navigation
//   void _login() async {
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠️ Please enter email and password")),
//       );
//       return;
//     }

//     try {
//       // Authenticate User
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       // Fetch user role from Firestore
//       DocumentSnapshot userSnapshot =
//           await _firestore.collection('users').doc(userCredential.user!.uid).get();

//       if (!userSnapshot.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("❌ User not found! Please sign up.")),
//         );
//         return;
//       }

//       String role = userSnapshot['role']; // Fetch role from Firestore

//       // ✅ Role-Based Navigation
//       if (role == 'Victim') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const VictimDashboard()),
//         );
//       } else if (role == 'AmbulanceAssistant') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const AdminDashboard()),
//         );
//       } else if (role == 'CommunityResponder') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const ResponderDashboard()),
//         );
//       } else if (role == 'BloodDonor') {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HospitalDashboard()),
//         );
//       }else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("🚨 Unknown role. Contact support.")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Login Failed: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _login,
//               child: const Text('Login'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SignupPage()),
//                 );
//               },
//               child: const Text("Don't have an account? Sign up"),
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
// import 'package:project/driver_dashboard.dart';
// import 'victim_dashboard.dart';
// import 'donor_dashboard.dart';
// import 'ambulance_dashboard.dart';
// import 'signup_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool _isLoading = false;

//   /// 🔹 Function to Handle Login
//   Future<void> _login() async {
//     setState(() => _isLoading = true);

//     try {
//       // Authenticate user
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       // Fetch user details from Firestore
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userCredential.user!.uid)
//           .get();

//       if (!userDoc.exists) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ User not found")));
//         return;
//       }

//       String role = userDoc['role'];

//       // 🔹 Navigate based on role
//       if (role == "Victim (User)") {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
//       } else if (role == "Private Owners") {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DriverDashboard ()));
//       } else if (role == "Blood Donor") {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BloodRequestsPage()));
//       } else if (role == "Ambulance 108 Assistant") {
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AmbulanceDashboard()));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("❌ Unknown Role")),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("❌ Error: ${e.message}")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 15),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             _isLoading
//                 ? const CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _login,
//                     child: const Text('Login'),
//                   ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SignupPage()),
//                 );
//               },
//               child: const Text("Don't have an account? Sign up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/driver_dashboard.dart';
import 'victim_dashboard.dart';
import 'donor_dashboard.dart';
import 'ambulance_dashboard.dart';
import 'hospital_dashboard.dart';  // ✅ Import Hospital Dashboard
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  /// 🔹 Function to Handle Login
  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      // Authenticate user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Fetch user details from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ User not found")));
        return;
      }

      String role = userDoc['role'];

      // 🔹 Navigate based on role
      if (role == "Victim (User)") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
      } else if (role == "Private Owners") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DriverDashboard()));
      } else if (role == "Blood Donor") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BloodRequestsPage()));
      } else if (role == "Ambulance 108 Assistant") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AmbulanceDashboard()));
      } else if (role == "Hospital") {  // ✅ NEW Role
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MedicalReportsPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Unknown Role")),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${e.message}")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text("Don't have an account? Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
