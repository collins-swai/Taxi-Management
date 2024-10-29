import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/car_usecases.dart';
import '../../data/models/car_model.dart';

part 'car_event.dart';
part 'car_state.dart';

class CarBloc extends Bloc<CarEvent, CarState> {
  final CarUseCases carUseCases;

  CarBloc(this.carUseCases) : super(CarInitial()) {
    on<FetchCars>((event, emit) async {
      emit(CarLoading());
      print('Fetching cars with token: ${event.token}');
      try {
        final cars = await carUseCases.getCars(event.token);
        print('Fetched cars: $cars');
        emit(CarLoaded(cars));
      } catch (error) {
        _handleError(emit, error, 'Failed to fetch cars');
      }
    });

    on<CreateCar>((event, emit) async {
      emit(CarLoading());
      try {
        final response = await carUseCases.createCar(event.car, event.token);
        if (response.isSuccessful) {
          emit(CarCreated());
          add(FetchCars(event.token));
        } else {
          emit(CarError('Failed to create car: ${response.errorMessage}'));
        }
      } catch (error) {
        _handleError(emit, error, 'Failed to create car');
      }
    });

    on<UpdateCar>((event, emit) async {
      emit(CarLoading());
      try {
        await carUseCases.updateCar(event.car, event.token);
        add(FetchCars(event.token));
      } catch (error) {
        _handleError(emit, error, 'Failed to update car');
      }
    });

    on<DeleteCar>((event, emit) async {
      emit(CarLoading());
      try {
        final response = await carUseCases.deleteCar(event.carId, event.token);
        if (response.isSuccessful) {
          emit(CarDeleted(event.carId));
          add(FetchCars(event.token));
        } else {
          emit(CarError('Failed to delete car: ${response.errorMessage}'));
        }
      } catch (error) {
        _handleError(emit, error, 'Failed to delete car');
      }
    });
  }

  void _handleError(Emitter<CarState> emit, dynamic error, String defaultMessage) {
    print('Error: $error');
    emit(CarError(defaultMessage));
  }

  void handleRealTimeCarAdded(Car car) {
    if (state is CarLoaded) {
      final updatedCars = List<Car>.from((state as CarLoaded).cars)..add(car);
      emit(CarLoaded(updatedCars));
    }
  }

  void handleRealTimeCarUpdated(Car car) {
    if (state is CarLoaded) {
      final updatedCars = (state as CarLoaded).cars.map((c) => c.id == car.id ? car : c).toList();
      emit(CarLoaded(updatedCars));
    }
  }

  void handleRealTimeCarDeleted(String carId) {
    if (state is CarLoaded) {
      final updatedCars = (state as CarLoaded).cars.where((c) => c.id != carId).toList();
      emit(CarLoaded(updatedCars));
    }
  }
}
