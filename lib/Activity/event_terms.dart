import 'package:flutter/material.dart';
import 'package:ibloov/Constants/ColorList.dart';

class EventTerms extends StatelessWidget {
  final String terms;

  EventTerms(this.terms);

  @override
  Widget build(BuildContext context) {
    debugPrint("Terms: $terms");

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Back", style: TextStyle(color: ColorList.textFaint),)),
              const SizedBox(height: 30),
              Text(
                "Terms of Service",
                style: TextStyle(
                    color: ColorList.colorBlueHeading,
                    fontWeight: FontWeight.w500,
                    fontSize: 24),
              ),
              const SizedBox(height: 25),
              SingleChildScrollView(
                child: Text(terms,
                    style: TextStyle(
                        color: ColorList.textColor,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.02,
                        height: 0.5,
                        fontSize: 12)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
