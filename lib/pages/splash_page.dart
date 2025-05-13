import 'package:firebase_authentication/blocs/auth/auth_bloc.dart';
import 'package:firebase_authentication/blocs/auth/auth_state.dart';
import 'package:firebase_authentication/pages/home_page.dart';
import 'package:firebase_authentication/pages/signin_page.dart';
import 'package:firebase_authentication/utils/loader.dart';
import 'package:firebase_authentication/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  static const String routeName = '/';
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        logger.i('AuthState in listener: $state');

        if (state.authStatus == AuthStatus.unauthenticated) {
          logger.w('User unauthenticated – navigating to SigninPage.');
          Navigator.pushReplacementNamed(context, SigninPage.routeName);
        } else if (state.authStatus == AuthStatus.authenticated) {
          logger.i('User authenticated – navigating to HomePage.');
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        }
      },
      builder: (context, state) {
        return Loader();
      },
    );
  }
}
