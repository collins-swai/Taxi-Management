part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthRegister extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  AuthRegister(this.name,this.email, this.phone, this.password,this.confirmPassword);
}

class AuthLogin extends AuthEvent {
  final String emailOrPhone;
  final String password;

  AuthLogin(this.emailOrPhone, this.password);
}