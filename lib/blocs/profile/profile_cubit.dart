import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_authentication/models/custom_error.dart';
import 'package:firebase_authentication/models/user_model.dart';
import 'package:firebase_authentication/repositories/profile_repository.dart';
import 'package:firebase_authentication/utils/logger_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit({required this.profileRepository})
    : super(ProfileState.initial());

  Future<void> getProfile({required String uid}) async {
    LoggerService.d('Fetching profile for UID: $uid');

    emit(state.copyWith(profileStatus: ProfileStatus.loading));

    try {
      final User user = await profileRepository.getProfile(uid: uid);
      LoggerService.i('Profile fetched successfully for UID: $uid');

      emit(state.copyWith(profileStatus: ProfileStatus.loaded, user: user));
    } on CustomError catch (e, st) {
      LoggerService.e('Failed to fetch profile for UID: $uid', e, st);

      emit(state.copyWith(profileStatus: ProfileStatus.error, error: e));
    }
  }
}
