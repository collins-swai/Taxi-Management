import '../../data/models/car_model.dart';
import '../../data/repositories/car_repository.dart';

class CarResponse {
  final bool isSuccessful;
  final Car? car;
  final String? errorMessage;

  CarResponse({
    required this.isSuccessful,
    this.car,
    this.errorMessage,
  });
}

class DeleteCarResponse {
  final bool isSuccessful;
  final String errorMessage;

  DeleteCarResponse({required this.isSuccessful, required this.errorMessage});
}


class CarUseCases {
  final CarRepository carRepository;

  CarUseCases(this.carRepository);

  Future<List<Car>> getCars(String token) async {
    return await carRepository.getCars(token);
  }

  Future<CarResponse> createCar(Car car, String token) async {
    try {
      final createdCar = await carRepository.createCar(car, token);
      return CarResponse(isSuccessful: true, car: createdCar);
    } catch (e) {
      return CarResponse(
        isSuccessful: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<CarResponse> updateCar(Car car, String token) async {
    try {
      final updatedCar = await carRepository.updateCar(car, token);
      return CarResponse(isSuccessful: true, car: updatedCar);
    } catch (e) {
      return CarResponse(
        isSuccessful: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<DeleteCarResponse> deleteCar(String carId, String token) async {
    try {
      await carRepository.deleteCar(carId, token);
      return DeleteCarResponse(isSuccessful: true, errorMessage: '');
    } catch (e) {
      return DeleteCarResponse(isSuccessful: false, errorMessage: e.toString());
    }
  }
}
