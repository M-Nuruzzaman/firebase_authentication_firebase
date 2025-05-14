import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_authentication/models/custom_error.dart';
import 'package:firebase_authentication/repositories/auth_repository.dart';
import 'package:firebase_authentication/utils/logger_service.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository authRepository;
  SigninCubit({required this.authRepository}) : super(SigninState.initial());

  Future<void> signin({required String email, required String password}) async {
    LoggerService.i('TRY Signing in with email: $email password: $password');
    emit(state.copyWith(signinStatus: SigninStatus.submitting));

    try {
      await authRepository.signin(email: email, password: password);

      emit(state.copyWith(signinStatus: SigninStatus.success));
      LoggerService.i('Sign in successful for: $email');
    } on CustomError catch (e, st) {
      emit(state.copyWith(signinStatus: SigninStatus.error, error: e));
      LoggerService.e('Sign in failed', e, st);
    }
  }
}
