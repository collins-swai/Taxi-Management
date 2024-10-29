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

  Future<void> _onAuthRegister(AuthRegister event,
      Emitter<AuthState> emit,) async {
    emit(AuthLoading());
    try {
      // Assuming register returns an AuthResponse containing the User
      final authResponse = await authUseCases.register(
        event.name,
        event.email,
        event.phone,
        event.password,
        event.confirmPassword,
      );

      // Extract the User and Token from AuthResponse
      final user = authResponse!.user; // Ensure `user` exists in AuthResponse
      final token = authResponse.token; // Ensure `token` exists in AuthResponse

      emit(AuthSuccess(user: user, token: token));
    } catch (_) {
      emit(AuthFailure('Registration failed'));
    }
  }

  Future<void> _onAuthLogin(AuthLogin event,
      Emitter<AuthState> emit,) async {
    emit(AuthLoading());
    try {
      // Assuming login returns an AuthResponse containing the User
      final authResponse = await authUseCases.login(
          event.emailOrPhone, event.password);

      // Extract the User and Token from AuthResponse
      final user = authResponse!.user; // Ensure `user` exists in AuthResponse
      final token = authResponse.token; // Ensure `token` exists in AuthResponse

      emit(AuthSuccess(user: user, token: token));
    } catch (_) {
      emit(AuthFailure('Login failed'));
    }
  }
}