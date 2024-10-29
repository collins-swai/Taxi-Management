import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car_model.dart';

class CarRepository {
  final String baseUrl;

  CarRepository(this.baseUrl);

  Future<List<Car>> getCars(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/cars'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final List<dynamic> carsJson = jsonResponse['data'];

      return carsJson.map((json) => Car.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cars: ${response.reasonPhrase}');
    }
  }

  Future<Car> createCar(Car car, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/cars'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(car.toJson()),
    );
    if (response.statusCode == 201) {
      return Car.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create car');
    }
  }

  Future<Car> updateCar(Car car, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/cars/${car.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(car.toJson()),
    );

    if (response.statusCode == 200) {
      return Car.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update car');
    }
  }

  Future<void> deleteCar(String carId, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/cars/$carId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('Car deleted successfully');
    } else {
      print('Error deleting car: ${response.body}');
      throw Exception('Failed to delete car. Status code: ${response.statusCode}');
    }
  }
}
