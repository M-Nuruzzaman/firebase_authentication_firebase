import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_authentication/blocs/auth/auth_state.dart';
import 'package:firebase_authentication/repositories/auth_repository.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final StreamSubscription authSubcription;
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthState.unknown()) {
    authSubcription = authRepository.user.listen((fbAuth.User? user) {
      // Listen to changes in authentication state
      add(AuthStateChangeEvent(user: user));
    });

    on<AuthStateChangeEvent>((event, emit) {
      // If the user is not null, update the state to authenticated
      if (event.user != null) {
        emit(
          state.copyWith(
            authStatus: AuthStatus.authenticated,
            user: event.user,
          ),
        );
      } else {
        // If user is null, update the state to unauthenticated
        emit(
          state.copyWith(authStatus: AuthStatus.unauthenticated, user: null),
        );
      }
    });

    on<SignoutRequestEvent>((event, emit) async {
      await authRepository.signout();
    });
  }

  @override
  Future<void> close() {
    authSubcription.cancel();
    return super.close();
  }
}
