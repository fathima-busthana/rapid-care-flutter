import 'package:flutter/material.dart';

class ResponderDashboard extends StatelessWidget {
  const ResponderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responder Dashboard')),
      body: const Center(
        child: Text(
          "Welcome, Responder!\nHere you can receive emergency alerts and assist victims.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
