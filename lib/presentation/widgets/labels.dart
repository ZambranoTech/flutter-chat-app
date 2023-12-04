import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Labels extends StatelessWidget {

  final String ruta;
  final String title;
  final String subTitle;


  const Labels({super.key, required this.ruta, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(subTitle, style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w400),),
        const SizedBox(height: 10,),
        GestureDetector(
          onTap: () => context.push(ruta),
          child: Text(title, style: TextStyle(color: Colors.blue[600], fontSize: 18,fontWeight: FontWeight.bold),)
        )
      ],
    );
  }
}