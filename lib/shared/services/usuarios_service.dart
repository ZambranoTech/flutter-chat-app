import 'dart:convert';

import 'package:chat/Infrastructure/models/usuarios_response.dart';
import 'package:chat/config/constants/environment.dart';
import 'package:chat/presentation/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:chat/domain/domain.dart';

class UsuariosService {

  static Future<List<Usuario>> getUsuarios() async {
    try {
      final token = await AuthProvider.getToken();
      if (token != null) {
          final resp = await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': token
          }
        );

        if (resp.statusCode == 200) {
         final Map<String, dynamic> responseData = jsonDecode(resp.body);
         final usuariosResponse = UsuariosResponse.fromJson(responseData);

          return usuariosResponse.usuarios;

        }
      }
      
     return [];

    } catch (e) {
      return [];
    }
  }

}