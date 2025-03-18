import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc({required AuthService authService})
      : _authService = authService,
        super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    
    try {
      final response = await _authService.login(event.email, event.password);
      
      if (response.success && response.data != null) {
        emit(LoginSuccess(
          username: response.data!.username ?? event.email,
          token: response.data!.token,
          usuarioId: response.data!.usuarioId,
          nombre: response.data!.nombre,
          rolNombre: response.data!.rolNombre,
        ));
      } else {
        emit(LoginFailure(response.message));
      }
    } catch (e) {
      emit(LoginFailure('Error en el proceso de login: ${e.toString()}'));
    }
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(LoginInitial());
  }
}

