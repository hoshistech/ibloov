import 'package:flutter/material.dart';

class EventTerms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextButton(onPressed: () {}, child: Text("Back")),
          const SizedBox(height: 30),
          Text("Terms of Service", style: TextStyle(),),

        ],
      ),
    );
  }
}