import 'package:flutter/material.dart';

class BtnAzul extends StatelessWidget {

  final String text;
  final Function()? onPressed;

  const BtnAzul({
    super.key,
    required this.text,
    required this.onPressed, 
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      width: double.infinity,
      height: 55,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: onPressed != null ? MaterialStateProperty.all(Colors.blue[600]) : null,
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 18),)
      ),
    );
  }
}