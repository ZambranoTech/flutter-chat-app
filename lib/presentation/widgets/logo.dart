import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String title;

  const Logo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          child: Image.asset(
            'assets/images/tag-logo.png',
            height: 150,
          ),
        ),
        const SizedBox(height: 20,),
        Text(
          title,
          style: const TextStyle(fontSize: 30, ),
        )
      ],
    );
  }
}