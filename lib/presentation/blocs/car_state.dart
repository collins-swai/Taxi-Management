// part of 'car_bloc.dart';
//
// abstract class CarState extends Equatable {
//   const CarState();
//
//   @override
//   List<Object> get props => [];
// }
//
// class CarInitial extends CarState {}
//
// class CarLoading extends CarState {}
//
// class CarLoaded extends CarState {
//   final List<Car> cars;
//
//   const CarLoaded(this.cars);
//
//   @override
//   List<Object> get props => [cars];
// }
//
// class CarCreated extends CarState {}
//
// class CarError extends CarState {
//   final String message;
//
//   const CarError(this.message);
//
//   @override
//   List<Object> get props => [message];
// }

part of 'car_bloc.dart';

abstract class CarState extends Equatable {
  const CarState();

  @override
  List<Object> get props => [];
}

class CarInitial extends CarState {}

class CarLoading extends CarState {}

class CarLoaded extends CarState {
  final List<Car> cars;

  const CarLoaded(this.cars);

  @override
  List<Object> get props => [cars];
}

class CarCreated extends CarState {}

class CarDeleted extends CarState {
  final String carId;

  const CarDeleted(this.carId);

  @override
  List<Object> get props => [carId];
}

class CarError extends CarState {
  final String message;

  const CarError(this.message);

  @override
  List<Object> get props => [message];
}


