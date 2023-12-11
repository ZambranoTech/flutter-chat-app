import 'dart:convert';

import 'package:chat/Infrastructure/models/login_response.dart';
import 'package:chat/config/constants/environment.dart';
import 'package:chat/domain/domain.dart';
import 'package:chat/shared/services/key_value_storage_service.dart';
import 'package:chat/shared/services/key_value_storage_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {

  late Usuario usuario;
  bool _autenticando = false;
  KeyValueStorageService keyValueStorageService = KeyValueStorageServiceImpl();

  bool get autenticando => _autenticando;

  set autenticando( bool valor ) {
    _autenticando = valor;
    notifyListeners();
  }

  Future<String?> getToken() async {
    return await keyValueStorageService.getValue('token');
  }

  Future<bool> isLoggedIn() async {

    final token = await getToken();

    if (token != null) {
        final resp = await http.get( Uri.parse('${Environment.apiUrl}/login/renew'),
          headers: {
            'Content-Type': 'application/json',
            'x-token': token
          }
        );

        if (resp.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(resp.body);
          final loginResponse = LoginResponse.fromJson(responseData);
          usuario = loginResponse.usuario;

          _guardarToken(loginResponse.token);

          return true;
        }
    }
    logout();
    return false;
  }


  Future<bool> login ( String email, String password ) async {
    autenticando = true;

    final data = {
      'email': email,
      'password': password,
    };

    final resp = await http.post( Uri.parse('${Environment.apiUrl}/login'), // Convert the string to Uri
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    autenticando = false;

    if (resp.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(resp.body);
      final loginResponse = LoginResponse.fromJson(responseData);
      usuario = loginResponse.usuario;

      _guardarToken(loginResponse.token);

      return true;
    }

    return false;
  }

  Future<(bool, String)> register( String nombre, String email, String password ) async {
    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
    };

    final resp = await http.post( Uri.parse('${Environment.apiUrl}/login/new'), // Convert the string to Uri
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    autenticando = false;

    if (resp.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(resp.body);
      final loginResponse = LoginResponse.fromJson(responseData);
      usuario = loginResponse.usuario;

      _guardarToken(loginResponse.token);

      return (true, '');
    }
    final respBody = jsonDecode(resp.body);
    return (false, respBody['msg'].toString());
  }

  Future<void> _guardarToken(String token) async {
    await keyValueStorageService.setKeyValue('token', token);
  }

  Future<void> logout() async {
    await keyValueStorageService.removeKey('token');
  }
    
}