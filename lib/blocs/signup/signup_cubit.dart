import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_authentication/models/custom_error.dart';
import 'package:firebase_authentication/repositories/auth_repository.dart';
import 'package:firebase_authentication/utils/logger_service.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;
  SignupCubit({required this.authRepository}) : super(SignupState.initial());

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    LoggerService.i(
      'TRY Signup with name: $name, email: $email, password: $password',
    );
    emit(state.copyWith(signupStatus: SignupStatus.submitting));

    try {
      await authRepository.signup(name: name, email: email, password: password);

      emit(state.copyWith(signupStatus: SignupStatus.success));
      LoggerService.i(
        'Sign up successful with email: $email password: $password',
      );
    } on CustomError catch (e, st) {
      emit(state.copyWith(signupStatus: SignupStatus.error, error: e));
      LoggerService.e('Sign up faield', e, st);
    }
  }
}
