import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

mostrarAlerta( BuildContext context, String titulo, String subtitulo ) {
  
  if (Platform.isAndroid) {
    showDialog(
      context: context, 
      builder: ( _ ) => AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Ok'))
        ],
      ),
    );
    return;
  }

  showCupertinoDialog(
    context: context, 
    builder: ( _ ) => CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        CupertinoDialogAction(onPressed: () => context.pop(), child: const Text('Ok'))
      ],
    ),
  );

}