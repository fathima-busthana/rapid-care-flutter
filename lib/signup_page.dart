// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'login_page.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();

//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Sign up function
//   void _signup() async {
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match')),
//       );
//       return;
//     }

//     try {
//       // Create user in Firebase Authentication
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );

//       // Save user data in Firestore under "users" collection
//       await _firestore.collection('users').doc(userCredential.user!.uid).set({
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'phone': _phoneController.text,
//         'userId': userCredential.user!.uid,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       // Show success message and navigate to Login Page
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Account created successfully!')),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to sign up: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               TextField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 15),
//               TextField(
//                 controller: _confirmPasswordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Confirm Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _signup,
//                 child: const Text('Sign Up'),
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
// import 'login_page.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _bloodGroupController = TextEditingController();
//   final _hospitalNameController = TextEditingController();
//   final _ambulanceIDController = TextEditingController();

//   String? _selectedRole;
//   final List<String> _roles = ['Victim (User)', 'Blood Donor', 'Community Responder', 'Ambulance 108 Assistant'];

//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// **Signup Function**
//   void _signup() async {
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match')),
//       );
//       return;
//     }

//     try {
//       // Create user in Firebase Authentication
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );

//       // User data
//       Map<String, dynamic> userData = {
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'phone': _phoneController.text,
//         'role': _selectedRole,
//         'userId': userCredential.user!.uid,
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       // **Add Role-Specific Fields**
//       if (_selectedRole == 'Blood Donor') {
//         userData['bloodGroup'] = _bloodGroupController.text;
//       } else if (_selectedRole == 'Ambulance 108 Assistant') {
//         userData['hospitalName'] = _hospitalNameController.text;
//         userData['ambulanceID'] = _ambulanceIDController.text;
//       }

//       // Store in Firestore
//       await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);

//       // Show success message and navigate to Login Page
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Account created successfully!')),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to sign up: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Full Name
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // Email
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // Phone Number
//               TextField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // **Role Selection Dropdown**
//               DropdownButtonFormField<String>(
//                 value: _selectedRole,
//                 items: _roles.map((role) {
//                   return DropdownMenuItem<String>(
//                     value: role,
//                     child: Text(role),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedRole = value!;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Select Role',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // **Blood Donor Fields**
//               if (_selectedRole == 'Blood Donor') ...[
//                 TextField(
//                   controller: _bloodGroupController,
//                   decoration: const InputDecoration(
//                     labelText: 'Blood Group (e.g., A+, B-, O+)',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//               ],

//               // **Ambulance Assistant Fields**
//               if (_selectedRole == 'Ambulance 108 Assistant') ...[
//                 TextField(
//                   controller: _hospitalNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Hospital Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _ambulanceIDController,
//                   decoration: const InputDecoration(
//                     labelText: 'Ambulance ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//               ],

//               // Password
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 15),

//               // Confirm Password
//               TextField(
//                 controller: _confirmPasswordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Confirm Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),

//               // Sign Up Button
//               ElevatedButton(
//                 onPressed: _signup,
//                 child: const Text('Sign Up'),
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
// import 'login_page.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _hospitalNameController = TextEditingController();
//   final _ambulanceIDController = TextEditingController();
//   final _privateAmbulanceIDController = TextEditingController();
//   final _privateOwnerPhoneController = TextEditingController();

//   String? _selectedRole;
//   String? _selectedBloodGroup;
  
//   final List<String> _roles = [
//     'Victim (User)',
//     'Community Responder',
//     'Ambulance 108 Assistant',
//     'Private Owners' // ✅ 'Blood Donor' Removed
//   ];

//   final List<String> _bloodGroups = [
//     'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
//   ];

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// **Signup Function**
//   void _signup() async {
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match')),
//       );
//       return;
//     }

//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );

//       // User data
//       Map<String, dynamic> userData = {
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'phone': _phoneController.text,
//         'role': _selectedRole,
//         'bloodGroup': _selectedBloodGroup, // ✅ Blood Group Added
//         'userId': userCredential.user!.uid,
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       // **Role-Specific Fields**
//       if (_selectedRole == 'Ambulance 108 Assistant') {
//         userData['hospitalName'] = _hospitalNameController.text;
//         userData['ambulanceID'] = _ambulanceIDController.text;
//       } else if (_selectedRole == 'Private Owners') {  
//         userData['privateAmbulanceID'] = _privateAmbulanceIDController.text;
//         userData['privateOwnerPhone'] = _privateOwnerPhoneController.text;
//       }

//       // Store in Firestore
//       await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Account created successfully!')),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to sign up: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Full Name
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // Email
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // Phone Number
//               TextField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // **Role Selection Dropdown**
//               DropdownButtonFormField<String>(
//                 value: _selectedRole,
//                 items: _roles.map((role) {
//                   return DropdownMenuItem<String>(
//                     value: role,
//                     child: Text(role),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedRole = value!;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Select Role',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // **Blood Group Selection Dropdown**
//               DropdownButtonFormField<String>(
//                 value: _selectedBloodGroup,
//                 items: _bloodGroups.map((group) {
//                   return DropdownMenuItem<String>(
//                     value: group,
//                     child: Text(group),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedBloodGroup = value!;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Select Blood Group',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // **Ambulance Assistant Fields**
//               if (_selectedRole == 'Ambulance 108 Assistant') ...[
//                 TextField(
//                   controller: _hospitalNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Hospital Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _ambulanceIDController,
//                   decoration: const InputDecoration(
//                     labelText: 'Ambulance ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//               ],

//               // **Private Owners Fields (Private Ambulance Drivers)**
//               if (_selectedRole == 'Private Owners') ...[
//                 TextField(
//                   controller: _privateAmbulanceIDController,
//                   decoration: const InputDecoration(
//                     labelText: 'Ambulance ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _privateOwnerPhoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Private Owner Contact Number',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 15),
//               ],

//               // Password
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 15),

//               // Confirm Password
//               TextField(
//                 controller: _confirmPasswordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Confirm Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),

//               // Sign Up Button
//               ElevatedButton(
//                 onPressed: _signup,
//                 child: const Text('Sign Up'),
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
// import 'login_page.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _hospitalNameController = TextEditingController();
//   final _hospitalIDController = TextEditingController();
//   final _hospitalPhoneController = TextEditingController();
//   final _ambulanceIDController = TextEditingController();
//   final _privateAmbulanceIDController = TextEditingController();
//   final _privateOwnerPhoneController = TextEditingController();

//   String? _selectedRole;
//   String? _selectedBloodGroup;

//   final List<String> _roles = [
//     'Victim (User)',
//     'Community Responder',
//     'Ambulance 108 Assistant',
//     'Private Owners',
//     'Hospital' // ✅ New Role Added
//   ];

//   final List<String> _bloodGroups = [
//     'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
//   ];

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// **Signup Function**
//   void _signup() async {
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Passwords do not match')),
//       );
//       return;
//     }

//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );

//       // User data
//       Map<String, dynamic> userData = {
//         'name': _nameController.text,
//         'email': _emailController.text,
//         'phone': _phoneController.text,
//         'role': _selectedRole,
//         'bloodGroup': _selectedBloodGroup, // ✅ Blood Group Added
//         'userId': userCredential.user!.uid,
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       // **Role-Specific Fields**
//       if (_selectedRole == 'Ambulance 108 Assistant') {
//         userData['hospitalName'] = _hospitalNameController.text;
//         userData['ambulanceID'] = _ambulanceIDController.text;
//       } else if (_selectedRole == 'Private Owners') {
//         userData['privateAmbulanceID'] = _privateAmbulanceIDController.text;
//         userData['privateOwnerPhone'] = _privateOwnerPhoneController.text;
//       } else if (_selectedRole == 'Hospital') {
//         userData['hospitalID'] = _hospitalIDController.text;
//         userData['hospitalName'] = _hospitalNameController.text;
//         userData['hospitalPhone'] = _hospitalPhoneController.text;
//       }

//       // Store in Firestore
//       await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Account created successfully!')),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to sign up: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Up')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Full Name
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // Email
//               TextField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // Phone Number
//               TextField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // **Role Selection Dropdown**
//               DropdownButtonFormField<String>(
//                 value: _selectedRole,
//                 items: _roles.map((role) {
//                   return DropdownMenuItem<String>(
//                     value: role,
//                     child: Text(role),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedRole = value!;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Select Role',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // **Blood Group Selection Dropdown**
//               DropdownButtonFormField<String>(
//                 value: _selectedBloodGroup,
//                 items: _bloodGroups.map((group) {
//                   return DropdownMenuItem<String>(
//                     value: group,
//                     child: Text(group),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedBloodGroup = value!;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Select Blood Group',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // **Ambulance Assistant Fields**
//               if (_selectedRole == 'Ambulance 108 Assistant') ...[
//                 TextField(
//                   controller: _hospitalNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Hospital Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _ambulanceIDController,
//                   decoration: const InputDecoration(
//                     labelText: 'Ambulance ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//               ],

//               // **Private Owners Fields**
//               if (_selectedRole == 'Private Owners') ...[
//                 TextField(
//                   controller: _privateAmbulanceIDController,
//                   decoration: const InputDecoration(
//                     labelText: 'Ambulance ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _privateOwnerPhoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Private Owner Contact Number',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 15),
//               ],

//               // **Hospital Fields**
//               if (_selectedRole == 'Hospital') ...[
//                 TextField(
//                   controller: _hospitalIDController,
//                   decoration: const InputDecoration(
//                     labelText: 'Hospital ID',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _hospitalNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Hospital Name',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 TextField(
//                   controller: _hospitalPhoneController,
//                   decoration: const InputDecoration(
//                     labelText: 'Hospital Phone Number',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 15),
//               ],

//               // Password
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 15),

//               // Confirm Password
//               TextField(
//                 controller: _confirmPasswordController,
//                 decoration: const InputDecoration(
//                   labelText: 'Confirm Password',
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),

//               // Sign Up Button
//               ElevatedButton(
//                 onPressed: _signup,
//                 child: const Text('Sign Up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _hospitalNameController = TextEditingController();
  final _hospitalIDController = TextEditingController();
  final _hospitalPhoneController = TextEditingController();
  final _ambulanceIDController = TextEditingController();
  final _privateAmbulanceIDController = TextEditingController();
  final _privateOwnerPhoneController = TextEditingController();

  String? _selectedRole;
  String? _selectedBloodGroup;
  List<String> _hospitalNames = []; // To store nearby hospital names

  final List<String> _roles = [
    'Victim (User)',
    'Ambulance 108 Assistant',
    'Private Owners',
    'Hospital' // ✅ New Role Added
  ];

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 📌 Get the current location of the user
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || permission == LocationPermission.deniedForever) {
      throw Exception('Location services are disabled or permission is denied forever');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  /// 📌 Fetch nearby hospitals using OpenStreetMap Overpass API
  Future<List<String>> _fetchNearbyHospitals(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://overpass-api.de/api/interpreter?data=[out:json];node(around:3000,$latitude,$longitude)[amenity=hospital];out;'
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> hospitalNames = [];
      for (var element in data['elements']) {
        if (element['tags']['name'] != null) {
          hospitalNames.add(element['tags']['name']);
        }
      }
      return hospitalNames;
    } else {
      throw Exception('Failed to load nearby hospitals');
    }
  }

  /// **Signup Function**
  void _signup() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // User data
      Map<String, dynamic> userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'role': _selectedRole,
        'bloodGroup': _selectedBloodGroup, // ✅ Blood Group Added
        'userId': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // **Role-Specific Fields**
      if (_selectedRole == 'Ambulance 108 Assistant') {
        userData['hospitalName'] = _hospitalNameController.text;
        userData['ambulanceID'] = _ambulanceIDController.text;
      } else if (_selectedRole == 'Private Owners') {
        userData['privateAmbulanceID'] = _privateAmbulanceIDController.text;
        userData['privateOwnerPhone'] = _privateOwnerPhoneController.text;
      } else if (_selectedRole == 'Hospital') {
        userData['hospitalID'] = _hospitalIDController.text;
        userData['hospitalName'] = _hospitalNameController.text;
        userData['hospitalPhone'] = _hospitalPhoneController.text;
      }

      // Store in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Full Name
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Phone Number
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // **Role Selection Dropdown**
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                    if (_selectedRole == 'Hospital') {
                      _getCurrentLocation().then((position) {
                        _fetchNearbyHospitals(position.latitude, position.longitude).then((hospitals) {
                          setState(() {
                            _hospitalNames = hospitals;
                          });
                        });
                      });
                    }
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Role',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // **Blood Group Selection Dropdown**
              DropdownButtonFormField<String>(
                value: _selectedBloodGroup,
                items: _bloodGroups.map((group) {
                  return DropdownMenuItem<String>(
                    value: group,
                    child: Text(group),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBloodGroup = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Blood Group',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // **Hospital Name Dropdown for Hospitals**
              if (_selectedRole == 'Hospital') ...[
                DropdownButtonFormField<String>(
                  value: _hospitalNames.isNotEmpty ? _hospitalNames.first : null,
                  items: _hospitalNames.map((hospitalName) {
                    return DropdownMenuItem<String>(
                      value: hospitalName,
                      child: Text(hospitalName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _hospitalNameController.text = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Select Hospital Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
              ],

              // Password
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),

              // Confirm Password
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),

              // Sign Up Button
              ElevatedButton(
                onPressed: _signup,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'login_page.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _hospitalNameController = TextEditingController();
//   final _hospitalIDController = TextEditingController();
//   final _hospitalPhoneController = TextEditingController();
//   final _ambulanceIDController = TextEditingController();
//   final _privateAmbulanceIDController = TextEditingController();
//   final _privateOwnerPhoneController = TextEditingController();

//   String? _selectedRole;
//   String? _selectedBloodGroup;
//   List<String> _hospitalNames = []; // Stores nearby hospital names

//   final List<String> _roles = [
//     'Victim (User)',
//     'Ambulance 108 Assistant',
//     'Private Owners',
//     'Hospital'
//   ];

//   final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// 📌 Fetch Nearby Hospitals
//   Future<List<String>> _fetchNearbyHospitals(double latitude, double longitude) async {
//     final url = Uri.parse(
//       'https://overpass-api.de/api/interpreter?data=[out:json];node(around:3000,$latitude,$longitude)[amenity=hospital];out;'
//     );

//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       List<String> hospitalNames = [];
//       for (var element in data['elements']) {
//         if (element['tags']['name'] != null) {
//           hospitalNames.add(element['tags']['name']);
//         }
//       }
//       return hospitalNames;
//     } else {
//       throw Exception('Failed to load nearby hospitals');
//     }
//   }

//   /// **Signup Function**
//   void _signup() async {
//     if (_passwordController.text != _confirmPasswordController.text) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('❌ Passwords do not match')),
//       );
//       return;
//     }

//     try {
//       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: _emailController.text.trim(),
//         password: _passwordController.text.trim(),
//       );

//       // Store User Data
//       Map<String, dynamic> userData = {
//         'name': _nameController.text.trim(),
//         'email': _emailController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'role': _selectedRole,
//         'bloodGroup': _selectedBloodGroup,
//         'userId': userCredential.user!.uid,
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       // Role-Specific Fields
//       if (_selectedRole == 'Ambulance 108 Assistant') {
//         userData['hospitalName'] = _hospitalNameController.text.trim();
//         userData['ambulanceID'] = _ambulanceIDController.text.trim();
//       } else if (_selectedRole == 'Private Owners') {
//         userData['privateAmbulanceID'] = _privateAmbulanceIDController.text.trim();
//         userData['privateOwnerPhone'] = _privateOwnerPhoneController.text.trim();
//       } else if (_selectedRole == 'Hospital') {
//         userData['hospitalID'] = _hospitalIDController.text.trim();
//         userData['hospitalName'] = _hospitalNameController.text.trim();
//         userData['hospitalPhone'] = _hospitalPhoneController.text.trim();
//       }

//       // Save in Firestore
//       await _firestore.collection('users').doc(userCredential.user!.uid).set(userData);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text(' Account created successfully!')),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(' Failed to sign up: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[200], // Light mode background
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25),
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white, // Inner box color
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 10),

//                   const Text(
//                     "Sign Up",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 20),

//                   // Name
//                   _buildTextField(_nameController, "Full Name"),

//                   // Email
//                   _buildTextField(_emailController, "Email"),

//                   // Phone Number
//                   _buildTextField(_phoneController, "Phone Number"),

//                   // Role Selection
//                   _buildDropdown("Select Role", _roles, _selectedRole, (value) {
//                     setState(() {
//                       _selectedRole = value;
//                     });
//                   }),

//                   // Blood Group Selection
//                   _buildDropdown("Select Blood Group", _bloodGroups, _selectedBloodGroup, (value) {
//                     setState(() {
//                       _selectedBloodGroup = value;
//                     });
//                   }),

//                   // Password
//                   _buildTextField(_passwordController, "Password", isPassword: true),

//                   // Confirm Password
//                   _buildTextField(_confirmPasswordController, "Confirm Password", isPassword: true),

//                   const SizedBox(height: 20),

//                   // Sign Up Button
//                   ElevatedButton(
//                     onPressed: _signup,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blueAccent,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     ),
//                     child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
//                   ),

//                   // Already have an account?
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => const LoginPage()),
//                       );
//                     },
//                     child: const Text(
//                       "Already have an account? Login",
//                       style: TextStyle(color: Colors.blueAccent),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// 🟢 Helper Method: Create a TextField
//   Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         obscureText: isPassword,
//       ),
//     );
//   }

//   /// 🔹 Helper Method: Create a Dropdown
//   Widget _buildDropdown(String label, List<String> items, String? selectedValue, Function(String?) onChanged) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: DropdownButtonFormField<String>(
//         value: selectedValue,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
