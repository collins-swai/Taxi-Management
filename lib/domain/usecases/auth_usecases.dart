import '../../data/repositories/auth_repository.dart';
import '../../data/models/user_model.dart';

class AuthUseCases {
  final AuthRepository authRepository;

  AuthUseCases(this.authRepository);

  Future<AuthResponse?> register(
      String name,
      String email,
      String phone,
      String password,
      String passwordConfirmation,
      ) async {
    return await authRepository.register(
      name,
      email,
      phone,
      password,
      passwordConfirmation,
    );
  }

  Future<AuthResponse?> login(String emailOrPhone, String password) async {
    return await authRepository.login(emailOrPhone, password);
  }
}
