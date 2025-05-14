import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_authentication/blocs/auth/auth_state.dart';
import 'package:firebase_authentication/repositories/auth_repository.dart';
import 'package:firebase_authentication/utils/logger_service.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final StreamSubscription authSubcription;
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthState.unknown()) {
    LoggerService.i('AuthBloc initialized');

    // Listen to auth state changes
    authSubcription = authRepository.user.listen((fbAuth.User? user) {
      LoggerService.d('AuthRepository emitted user: ${user?.uid ?? 'null'}');
      add(AuthStateChangeEvent(user: user));
    });

    on<AuthStateChangeEvent>((event, emit) {
      if (event.user != null) {
        LoggerService.i('User authenticated: ${event.user!.uid}');
        emit(
          state.copyWith(
            authStatus: AuthStatus.authenticated,
            user: event.user,
          ),
        );
      } else {
        LoggerService.w('User unauthenticated (user is null)');
        emit(
          state.copyWith(authStatus: AuthStatus.unauthenticated, user: null),
        );
      }
    });

    on<SignoutRequestEvent>((event, emit) async {
      try {
        await authRepository.signout();
        LoggerService.i('User signed out successfully');
      } catch (e, st) {
        LoggerService.e('Sign out failed', e, st);
      }
    });
  }

  @override
  Future<void> close() {
    LoggerService.i('AuthBloc is being closed');
    authSubcription.cancel();
    return super.close();
  }
}
