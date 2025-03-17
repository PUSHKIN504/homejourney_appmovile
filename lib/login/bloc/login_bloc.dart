import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    
    // Simulate API call with delay
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      // Simple validation - in a real app, you would call an authentication service
      if (event.email == 'user@example.com' && event.password == 'password') {
        emit(LoginSuccess('User'));
      } else {
        emit(LoginFailure('Invalid email or password'));
      }
    } catch (e) {
      emit(LoginFailure('An error occurred: ${e.toString()}'));
    }
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(LoginInitial());
  }
}

