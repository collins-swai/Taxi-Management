import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class AuthResponse {
  final User user;
  final String token;

  AuthResponse({required this.user, required this.token});
}

class AuthRepository {
  final String baseUrl;

  AuthRepository(this.baseUrl);

  bool isValidEmail(String email) {
    final RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  Future<AuthResponse?> register(
      String name,
      String email,
      String phone,
      String password,
      String passwordConfirmation,
      ) async {
    // Log user information before registration
    print("Registering user with:");
    print("Name: $name");
    print("Email: $email");
    print("Phone: $phone");

    if (!isValidEmail(email)) {
      throw Exception('Invalid email format');
    }

    if (password != passwordConfirmation) {
      throw Exception('Password confirmation does not match');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'password': password.trim(),
        'password_confirmation': passwordConfirmation.trim(),
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data['user']);
      final token = data['token'];
      return AuthResponse(user: user, token: token);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Registration failed with message: $errorData');
    }
  }

  Future<AuthResponse?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data['user']);
      final token = data['token'];
      return AuthResponse(user: user, token: token);
    } else {
      print('Error: ${response.body}');
      throw Exception('Login failed with message: ${response.body}');
    }
  }
}
