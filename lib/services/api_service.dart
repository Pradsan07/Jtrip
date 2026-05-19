import 'dart:convert';

import 'package:http/http.dart' as http;

import 'session_service.dart';

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
    this.errors,
  });

  @override
  String toString() => message;
}

class ApiService {
  static const String baseUrl =
      'https://jtrip.biz.id/api';

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

static Future<Map<String, dynamic>> verifyOtp({
  required String email,
  required String otpCode,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/verify-otp'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
      'otp_code': otpCode,
    }),
  );

  return _handleResponse(response);
}

static Future<Map<String, dynamic>> resendOtp({
  required String email,
}) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/resend-otp'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': email,
    }),
  );

  return _handleResponse(response);
}

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

  print('STATUS LOGIN: ${response.statusCode}');
  print('BODY LOGIN: ${response.body}');

  final result = _handleResponse(response);

  final token = result['data']?['access_token'] ??
      result['access_token'] ??
      result['token'];

  print('TOKEN LOGIN YANG DISIMPAN: $token');

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

  print('STATUS REGISTER: ${response.statusCode}');
  print('BODY REGISTER: ${response.body}');

  return _handleResponse(response);
}

  static Future<Map<String, dynamic>> me() async {
  final token = await SessionService.getToken();

  print('TOKEN ME: $token');

  final response = await http.get(
    Uri.parse('$baseUrl/auth/me'),
    headers: _authHeaders(token),
  );

  print('URL ME: $baseUrl/auth/me');
  print('STATUS ME: ${response.statusCode}');
  print('BODY ME: ${response.body}');

  return _handleResponse(response);
}

  static Future<Map<String, dynamic>> logout() async {
  final token = await SessionService.getToken();

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/logout'),
      headers: _authHeaders(token),
    );

    final result = _handleResponse(response);
    await SessionService.clearToken();

    return result;
  } catch (e) {
    await SessionService.clearToken();
    rethrow;
  }
}

  static Map<String, dynamic> _handleResponse(http.Response response) {
  Map<String, dynamic> body = <String, dynamic>{};

  try {
    if (response.body.isNotEmpty) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        body = decoded;
      } else {
        throw const FormatException();
      }
    }
  } catch (_) {
    throw ApiException(
      message: 'Response server bukan JSON. Cek URL API atau route Laravel.',
      statusCode: response.statusCode,
    );
  }

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return body;
  }

  String message = body['message']?.toString() ?? 'Terjadi kesalahan';

  Map<String, dynamic>? errors;
  Map<String, dynamic>? data;

  if (body['errors'] is Map<String, dynamic>) {
    errors = body['errors'] as Map<String, dynamic>;

    if (errors.isNotEmpty) {
      final firstValue = errors.values.first;

      if (firstValue is List && firstValue.isNotEmpty) {
        message = firstValue.first.toString();
      } else {
        message = firstValue.toString();
      }
    }
  }

  if (body['data'] is Map<String, dynamic>) {
    data = body['data'] as Map<String, dynamic>;
  }

  throw ApiException(
    message: message,
    statusCode: response.statusCode,
    data: data,
    errors: errors,
  );
}

  static Future<Map<String, dynamic>> updateProfile({
  required String name,
  required String email,
  required String noTelp,
  required String kewarganegaraan,
  required String jenisIdentitas,
  required String nomorIdentitas,
  required String jenisKelamin,
  required String tanggalLahir,
}) async {
  final token = await SessionService.getToken();

  print('TOKEN UPDATE PROFILE: $token');

  final response = await http.put(
    Uri.parse('$baseUrl/auth/profile'),
    headers: _authHeaders(token),
    body: jsonEncode({
      'name': name,
      'email': email,
      'no_telp': noTelp,
      'kewarganegaraan': kewarganegaraan,
      'jenis_identitas': jenisIdentitas,
      'nomor_identitas': nomorIdentitas,
      'jenis_kelamin': jenisKelamin,
      'tanggal_lahir': tanggalLahir,
    }),
  );

  print('STATUS UPDATE PROFILE: ${response.statusCode}');
  print('BODY UPDATE PROFILE: ${response.body}');

  return _handleResponse(response);
}
static Future<List<dynamic>> getRiwayatPesanan() async {
  final token = await SessionService.getToken();

  print('TOKEN RIWAYAT PESANAN: $token');

  final response = await http.get(
    Uri.parse('$baseUrl/riwayat-pesanan'),
    headers: _authHeaders(token),
  );

  print('STATUS RIWAYAT PESANAN: ${response.statusCode}');
  print('BODY RIWAYAT PESANAN: ${response.body}');

  final result = _handleResponse(response);

  final data = result['data'];

  if (data is List) {
    return data;
  }

  return [];
}
static Future<List<dynamic>> getWisata() async {
  final response = await http.get(
    Uri.parse('$baseUrl/wisata'),
    headers: _jsonHeaders,
  );

  print('STATUS WISATA: ${response.statusCode}');
  print('BODY WISATA: ${response.body}');

  final result = _handleResponse(response);

  final data = result['data'];

  if (data is List) {
    return data;
  }

  return [];
}
static Future<List<dynamic>> getWisataPopuler() async {
  final response = await http.get(
    Uri.parse('$baseUrl/wisata-populer'),
    headers: _jsonHeaders,
  );

  print('STATUS WISATA POPULER: ${response.statusCode}');
  print('BODY WISATA POPULER: ${response.body}');

  final result = _handleResponse(response);
  final data = result['data'];

  if (data is List) {
    return data;
  }

  return [];
}
static Future<Map<String, dynamic>> checkoutTiket({
  required String idWisata,
  required String tanggalKunjungan,
  required int jumlahPengunjung,
  String metodePembayaran = 'Midtrans Snap',
}) async {
  final token = await SessionService.getToken();

  final response = await http.post(
    Uri.parse('$baseUrl/midtrans/checkout'),
    headers: _authHeaders(token),
    body: jsonEncode({
      'id_wisata': idWisata,
      'tanggal_kunjungan': tanggalKunjungan,
      'jumlah_pengunjung': jumlahPengunjung,
      'metode_pembayaran': metodePembayaran,
    }),
  );

  print('STATUS CHECKOUT: ${response.statusCode}');
  print('BODY CHECKOUT: ${response.body}');

  return _handleResponse(response);
}

static Future<Map<String, dynamic>> markPaymentSuccess({
  required String orderId,
  String paymentType = 'Midtrans',
}) async {
  final token = await SessionService.getToken();

  final response = await http.post(
    Uri.parse('$baseUrl/midtrans/success'),
    headers: _authHeaders(token),
    body: jsonEncode({
      'order_id': orderId,
      'payment_type': paymentType,
    }),
  );

  print('STATUS PAYMENT SUCCESS: ${response.statusCode}');
  print('BODY PAYMENT SUCCESS: ${response.body}');

  return _handleResponse(response);
}
static Future<List<dynamic>> getUmkm() async {
  final response = await http.get(
    Uri.parse('$baseUrl/umkm'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  print('STATUS UMKM: ${response.statusCode}');
  print('BODY UMKM: ${response.body}');

  final result = _handleResponse(response);

  if (result['data'] is List) {
    return result['data'];
  }

  return [];
}
}