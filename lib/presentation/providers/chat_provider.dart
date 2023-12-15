import 'dart:convert';

import 'package:chat/Infrastructure/models/mensajes_response.dart';
import 'package:chat/config/constants/environment.dart';
import 'package:chat/domain/domain.dart';
import 'package:chat/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ChatProvider with ChangeNotifier {

  late Usuario usuarioPara;

  Future<List<Mensaje>> getChat( String usuarioID ) async {

    final token = await AuthProvider.getToken();

    if (token != null) {
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID'), 
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      });

      final Map<String, dynamic> responseData = jsonDecode(resp.body);
      final mensajesResponse = ChatResponse.fromJson(responseData);

      return mensajesResponse.mensajes;

    }
    
    return [];

  }

}

