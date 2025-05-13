import 'package:firebase_authentication/models/user_model.dart';

part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState with EquatableMixin {
  final User user;
  final ProfileStatus profileStatus;
  final CustomError error;
  ProfileState({
    required this.user,
    required this.profileStatus,
    required this.error,
  });

  factory ProfileState.initial() {
    return ProfileState(
      user: User.initialUser(),
      profileStatus: ProfileStatus.initial,
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [user, profileStatus, error];

  @override
  bool get stringify => true;

  ProfileState copyWith({
    User? user,
    ProfileStatus? profileStatus,
    CustomError? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      profileStatus: profileStatus ?? this.profileStatus,
      error: error ?? this.error,
    );
  }
}
