import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                Logo(title: 'Registro'),
                _Form(),
                Labels(
                  title: 'Ingresa ahora!',
                  subTitle: '¿Ya tienes una cuenta?',
                  ruta: '/',
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

  final userCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        CustomInput(
          icon: Icons.perm_identity_rounded,
          placeholder: 'User',
          keyboardType: TextInputType.text,
          textController: userCtrl,
        ),

        CustomInput(
          icon: Icons.email_outlined,
          placeholder: 'Email',
          keyboardType: TextInputType.emailAddress,
          textController: emailCtrl,
        ),
        CustomInput(
          icon: Icons.password_outlined,
          placeholder: 'Password',
          textController: passCtrl,
          isPassword: true,
        ),


        BtnAzul(
          text: 'Registrate',
          onPressed: () {
            print(userCtrl.text);
            print(emailCtrl.text);
            print(passCtrl.text);
          },
        )
      ],
    );
  }
}




