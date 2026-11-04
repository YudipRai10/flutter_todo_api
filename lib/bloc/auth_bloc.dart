import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(_onAuthLoginEvent);

    on<AuthLogoutEvent>(_onAuthLogoutEvent);
  }

  void _onAuthLoginEvent(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final email = event.email.trim();
    final password = event.password;

    // 1. Email Regex Validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (email.isEmpty) {
      return emit(AuthFailure(error: 'Email cannot be empty.'));
    }

    if (!emailRegex.hasMatch(email)) {
      return emit(AuthFailure(error: 'Please enter a valid email address.'));
    }

    // 2. Password Validation
    if (password.isEmpty) {
      return emit(AuthFailure(error: 'Password cannot be empty.'));
    }

    if (password.length < 6) {
      return emit(
        AuthFailure(error: 'Password must be at least 6 characters long.'),
      );
    }

    try {
      await Future.delayed(const Duration(seconds: 1));

      return emit(AuthSuccess(uid: '$email-$password'));
    } catch (e) {
      return emit(AuthFailure(error: e.toString()));
    }
  }

  void _onAuthLogoutEvent(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await Future.delayed(const Duration(seconds: 1));

      return emit(AuthInitial());
    } catch (e) {
      return emit(AuthFailure(error: e.toString()));
    }
  }
}
