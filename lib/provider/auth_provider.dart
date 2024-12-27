import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isLoggedIn = false;
  String _role = '';
  String _userName = '';

  // API URL base
  static const _baseUrl = 'http://127.0.0.1:8000/api';

  // Getter untuk loading, error, login status, role, dan userName
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  String get role => _role;
  String get userName => _userName;

  // Periksa status login dan muat data user
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _role = prefs.getString('role') ?? '';
    _userName = prefs.getString('name') ?? '';
    notifyListeners();
  }

  // Fungsi login
  Future<bool> login(String email, String password) async {
    _setLoadingState(true);

    final url = '$_baseUrl/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _saveUserData(responseData);
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _setErrorMessage(responseData['message'] ?? 'Login gagal');
        return false;
      }
    } catch (error) {
      _setErrorMessage('Terjadi kesalahan: $error');
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  // Fungsi register
  Future<bool> register(String name, String email, String password,
      String confirmPassword) async {
    _setLoadingState(true);

    final url = '$_baseUrl/register';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        _setErrorMessage('Pendaftaran berhasil. Silakan login.');
        return true;
      } else {
        _setErrorMessage(_extractErrorMessage(responseData));
        return false;
      }
    } catch (error) {
      _setErrorMessage('Terjadi kesalahan: $error');
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  // Fungsi logout
  Future<bool> logout() async {
    _setLoadingState(true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = '$_baseUrl/logout';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await _clearUserData();
        notifyListeners();
        return true;
      } else {
        throw Exception('Logout gagal');
      }
    } catch (error) {
      _setErrorMessage('Terjadi kesalahan: $error');
      return false;
    } finally {
      _setLoadingState(false);
    }
  }

  // Simpan data pengguna ke SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('token', data['token']);
    await prefs.setString('role', data['role']);
    await prefs.setString('name', data['user']['name']);
    _role = data['role'];
    _userName = data['user']['name'];
  }

  // Hapus data pengguna dari SharedPreferences
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('name');
    _isLoggedIn = false;
    _role = '';
    _userName = '';
  }

  // Ekstrak pesan error dari respons API
  String _extractErrorMessage(Map<String, dynamic> responseData) {
    if (responseData.containsKey('message')) {
      return responseData['message'];
    } else if (responseData.containsKey('errors')) {
      return (responseData['errors'] as Map<String, dynamic>)
          .values
          .map((e) => e.join(', '))
          .join('\n');
    }
    return 'Terjadi kesalahan.';
  }

  // Set pesan error dan notifikasi
  void _setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Set status loading dan notifikasi
  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }
}
