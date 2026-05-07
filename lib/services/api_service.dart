import 'dart:convert';

import 'package:http/http.dart' as http;

import 'session_service.dart';

class ApiService {
  static const String baseUrl =
      'https://lemuel-unsatisfiable-empathetically.ngrok-free.dev/api';

  static Map<String, String> get _jsonHeaders => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };

  static Map<String, String> _authHeaders(String? token) => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final result = _handleResponse(response);

    final token = result['data']?['access_token'];
    if (token != null) {
      await SessionService.saveToken(token.toString());
    }

    return result;
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String noTelp,
    required String password,
    required String passwordConfirmation,
    required String kewarganegaraan,
    required String jenisIdentitas,
    required String nomorIdentitas,
    required String jenisKelamin,
    required String tanggalLahir,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _jsonHeaders,
      body: jsonEncode({
        'name': name,
        'email': email,
        'no_telp': noTelp,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'kewarganegaraan': kewarganegaraan,
        'jenis_identitas': jenisIdentitas,
        'nomor_identitas': nomorIdentitas,
        'jenis_kelamin': jenisKelamin,
        'tanggal_lahir': tanggalLahir,
      }),
    );

    final result = _handleResponse(response);

    final token = result['data']?['access_token'];
    if (token != null) {
      await SessionService.saveToken(token.toString());
    }

    return result;
  }

  static Future<Map<String, dynamic>> me() async {
    final token = await SessionService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: _authHeaders(token),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> logout() async {
    final token = await SessionService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: _authHeaders(token),
    );

    final result = _handleResponse(response);
    await SessionService.clearToken();

    return result;
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> body = <String, dynamic>{};

    try {
      if (response.body.isNotEmpty) {
        body = jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (_) {
      throw Exception(
        'Response server bukan JSON. Cek URL ngrok atau route Laravel.',
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    String message = body['message']?.toString() ?? 'Terjadi kesalahan';

    if (body['errors'] is Map) {
      final errors = body['errors'] as Map;
      if (errors.isNotEmpty) {
        final firstValue = errors.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          message = firstValue.first.toString();
        }
      }
    }

    throw Exception(message);
  }
}