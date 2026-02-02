import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _userKeyPrefix = 'user_';

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String?> register(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (prefs.containsKey(_userKeyPrefix + login)) {
      return 'Пользователь с таким логином уже существует';
    }

    String hashedPassword = _hashPassword(password);

    print('--- РЕГИСТРАЦИЯ ---');
    print('Логин: $login');
    print('Исходный пароль: $password');
    print('Хэш пароля (SHA-256): $hashedPassword');
    print('-------------------');

    await prefs.setString(_userKeyPrefix + login, hashedPassword);
    return null; // Успех
  }

  Future<bool> login(String login, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedHash = prefs.getString(_userKeyPrefix + login);

    if (storedHash == null) {
      print('ВХОД: Пользователь $login не найден');
      return false; 
    }

    String enteredHash = _hashPassword(password);

    print('--- ВХОД В СИСТЕМУ ---');
    print('Логин: $login');
    print('Введенный пароль: $password');
    print('Хэш введенного пароля: $enteredHash');
    print('Хэш в базе (SharedPreferences): $storedHash');
    print('Результат: ${enteredHash == storedHash ? 'УСПЕХ' : 'ОШИБКА'}');
    print('----------------------');

    return storedHash == enteredHash;
  }
}
