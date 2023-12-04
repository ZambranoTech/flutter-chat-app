import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;


  const CustomInput({
    super.key, 
    required this.icon, 
    required this.placeholder, 
    required this.textController, 
    this.keyboardType = TextInputType.text, 
    this.isPassword = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: const Offset(0, 5),
                color: Colors.black.withOpacity(0.05),
              )
            ]),
        child: TextField(
          autocorrect: false,
          controller: textController,
          obscureText: isPassword,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
              ),
              focusedBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: placeholder),
        ),
      ),
    );
  }
}
