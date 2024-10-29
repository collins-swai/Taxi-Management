part of 'car_bloc.dart';

abstract class CarEvent extends Equatable {
  const CarEvent();

  @override
  List<Object> get props => [];
}

class FetchCars extends CarEvent {
  final String token;

  const FetchCars(this.token);

  @override
  List<Object> get props => [token];
}

class CreateCar extends CarEvent {
  final Car car;
  final String token;

  const CreateCar(this.car, this.token);

  @override
  List<Object> get props => [car, token];
}

class UpdateCar extends CarEvent {
  final Car car;
  final String token;

  const UpdateCar(this.car, this.token);

  @override
  List<Object> get props => [car, token];
}

class DeleteCar extends CarEvent {
  final String carId;
  final String token;

  DeleteCar(this.carId, this.token);

  @override
  List<Object> get props => [carId, token];
}
