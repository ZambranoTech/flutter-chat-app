import 'package:chat/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) => const Center(
          child: CircularProgressIndicator(strokeWidth: 2,),
         )
        ),
    );
  }

  Future checkLoginState(BuildContext context) async {
   final socketProvider = context.watch<SocketProvider>();

    final isLogged = await context.read<AuthProvider>().isLoggedIn();
      if (isLogged) {
        socketProvider.connect();
        if (context.mounted) context.pushReplacement('/users');
        return;
      } else {
        if (context.mounted) context.pushReplacement('/login');
      }
  } 
}