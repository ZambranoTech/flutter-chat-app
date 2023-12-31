import 'package:chat/presentation/providers/auth_provider.dart';
import 'package:chat/presentation/providers/chat_provider.dart';
import 'package:chat/presentation/providers/providers.dart';
import 'package:chat/shared/services/usuarios_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/domain/domain.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  List<Usuario> usuarios = [];


  @override
  void initState() {
    super.initState();
    _cargarUsuarios();
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = context.watch<AuthProvider>();
    final socketProvider = context.watch<SocketProvider>();

    final usuario = authProvider.usuario;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        leading: IconButton(
          onPressed: () {

            socketProvider.disconnect();

            context.read<AuthProvider>().logout();
            context.pushReplacement('/login');

          },
          icon: const Icon(Icons.exit_to_app_rounded)
        ),
        title: Text(usuario.nombre),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: (socketProvider.serverStatus == ServerStatus.online)
            ? Icon(Icons.check_circle_rounded, color: Colors.blue[400],)
            : const Icon(Icons.offline_bolt, color: Colors.red,)
          )
        ],

        centerTitle: true,
      ),
      body: Scaffold(
        body: SmartRefresher(
          controller: _refreshController,

          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: const WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue,),
            waterDropColor: Colors.blue,
          ),
          child: _ListViewUsuarios(usuarios: usuarios)
        ),
      ),
    );
  }

  _cargarUsuarios() async {
    usuarios = await UsuariosService.getUsuarios();
    setState(() {});
  //  await Future.delayed(Duration(milliseconds: 1000));
  //  if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

}

class _ListViewUsuarios extends StatelessWidget {
  const _ListViewUsuarios({
    required this.usuarios,
  });

  final List<Usuario> usuarios;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => _UsuarioListTile(usuario: usuarios[index]), 
      separatorBuilder: (context, index) => const Divider(),
      itemCount: usuarios.length
    );
  }
}

class _UsuarioListTile extends StatelessWidget {
  const _UsuarioListTile({
    required this.usuario,
  });

  final Usuario usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0,2),),
      ),
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green : Colors.red,
          shape: BoxShape.circle
        ),
      ),
      onTap: () {
        context.read<ChatProvider>().usuarioPara = usuario;
        context.push('/chat');
      },
    );
  }
}