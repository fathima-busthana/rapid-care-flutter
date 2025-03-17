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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  final List<String> _roles = [
    'Victim (User)',
    'Community Responder',
    'Ambulance 108 Assistant',
    'Private Owners',
    'Hospital' // ✅ New Role Added
  ];

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

              // **Ambulance Assistant Fields**
              if (_selectedRole == 'Ambulance 108 Assistant') ...[
                TextField(
                  controller: _hospitalNameController,
                  decoration: const InputDecoration(
                    labelText: 'Hospital Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _ambulanceIDController,
                  decoration: const InputDecoration(
                    labelText: 'Ambulance ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
              ],

              // **Private Owners Fields**
              if (_selectedRole == 'Private Owners') ...[
                TextField(
                  controller: _privateAmbulanceIDController,
                  decoration: const InputDecoration(
                    labelText: 'Ambulance ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _privateOwnerPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Private Owner Contact Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
              ],

              // **Hospital Fields**
              if (_selectedRole == 'Hospital') ...[
                TextField(
                  controller: _hospitalIDController,
                  decoration: const InputDecoration(
                    labelText: 'Hospital ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _hospitalNameController,
                  decoration: const InputDecoration(
                    labelText: 'Hospital Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _hospitalPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Hospital Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
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
