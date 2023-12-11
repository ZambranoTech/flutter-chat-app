import 'package:chat/shared/services/key_value_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {

  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    return await storage.read(key: key) as T?;
  }

  @override
  Future<bool> removeKey(String key) async {
    storage.delete(key: key);
    return true;
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    await storage.write(key: key, value: value.toString());
  }


}