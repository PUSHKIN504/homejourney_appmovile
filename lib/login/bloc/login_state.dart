abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String username;
  final String? token;
  final int? usuarioId;
  final String? nombre;
  final String? rolNombre;

  LoginSuccess({
    required this.username,
    this.token,
    this.usuarioId,
    this.nombre,
    this.rolNombre,
  });
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}

