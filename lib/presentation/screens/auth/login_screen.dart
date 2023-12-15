import 'package:chat/config/helpers/mostrar_alerta.dart';
import 'package:chat/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;


    return  Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Container(
            height: orientation == Orientation.portrait ? size.height * 0.9 : null,
            margin: const EdgeInsetsDirectional.only(top: 50, bottom: 20),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(title: 'Messenger'),
                _Form(),
                Labels(
                  title: 'Crea una ahora!',
                  subTitle: '¿No tienes una cuenta?',
                  ruta: '/register',
                ),
                Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final authProvider = context.watch<AuthProvider>();
    final socketProvider = context.read<SocketProvider>();

    return Column(
      children: [

        CustomInput(
          icon: Icons.email_outlined,
          placeholder: 'Email',
          keyboardType: TextInputType.emailAddress,
          textController: emailCtrl,
        ),
        CustomInput(
          icon: Icons.password_outlined,
          placeholder: 'password',
          textController: passCtrl,
          isPassword: true,
        ),


        BtnAzul(
          text: 'Ingrese',
          onPressed: authProvider.autenticando
          ? null
          : () async {
              FocusScope.of(context).unfocus();
              final loginOk = await authProvider.login(emailCtrl.text.trim(), passCtrl.text.trim());
              
              if (loginOk) {
                socketProvider.connect();
                if (context.mounted) context.pushReplacement('/users');
                return;
              } 

              if (context.mounted) mostrarAlerta(context, 'Login Incorrecto', 'Revise sus credenciales nuevamente');


            },
        )
      ],
    );
  }
}




