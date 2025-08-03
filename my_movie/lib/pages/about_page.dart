import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Build: v2.0.0\nLast Upadte: 02.08.2025', 
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFFFAEBD7),
          fontWeight: FontWeight.w200
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
