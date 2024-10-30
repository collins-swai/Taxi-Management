import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases authUseCases;

  AuthBloc(this.authUseCases) : super(AuthInitial()) {
    on<AuthRegister>(_onAuthRegister);
    on<AuthLogin>(_onAuthLogin);
  }

  Future<void> _onAuthRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final authResponse = await authUseCases.register(
        event.name,
        event.email,
        event.phone,
        event.password,
        event.confirmPassword,
      );

      print('Auth Response: $authResponse');

      if (authResponse != null && authResponse.user != null) {
        final user = authResponse.user;

        emit(AuthSuccesses(user: user));
        print('Registration successful: ${user.name}');
      } else {
        emit(AuthFailure('Registration failed: No user data returned'));
      }
    } catch (error) {
      print('Registration Error: $error');
      emit(AuthFailure('Registration failed'));
    }
  }

  Future<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final authResponse = await authUseCases.login(
          event.emailOrPhone, event.password);

      print('Login Response: $authResponse');

      if (authResponse != null && authResponse.user != null) {
        final user = authResponse.user;
        final token = authResponse.token;

        emit(AuthSuccess(user: user, token: token));
        print('Login successful: ${user.name}');
      } else {
        emit(AuthFailure('Login failed: No user data returned'));
      }
    } catch (error) {
      // Log the error for debugging
      print('Login Error: $error');
      emit(AuthFailure('Login failed'));
    }
  }
}
