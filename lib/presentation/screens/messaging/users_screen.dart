import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/domain/domain.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);


  @override
  Widget build(BuildContext context) {

    final List<User> usuarios = [
      User(uid: '1', nombre: 'Juan', email: 'test1@test.com', online: true),
      User(uid: '2', nombre: 'Javier', email: 'test2@test.com', online: false),
      User(uid: '3', nombre: 'Adrian', email: 'test3@test.com', online: true),
    ];
      
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.exit_to_app_rounded)
        ),
        title: const Text('Mi Nombre'),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.check_circle_rounded, color: Colors.blue[400],)
            // icon: Icon(Icons.offline_bolt, color: Colors.red,)
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
   await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

}

class _ListViewUsuarios extends StatelessWidget {
  const _ListViewUsuarios({
    required this.usuarios,
  });

  final List<User> usuarios;

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

  final User usuario;

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
    );
  }
}