import 'package:firebase_authentication/blocs/auth/auth_bloc.dart';
import 'package:firebase_authentication/blocs/auth/auth_state.dart';
import 'package:firebase_authentication/pages/home_page.dart';
import 'package:firebase_authentication/pages/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  static const String routeName = '/';
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, SigninPage.routeName, (
            route,
          ) {
            print('route.settings.name: ${route.settings.name}');
            print('ModalRoute: ${ModalRoute.of(context)!.settings.name}');
            return route.settings.name == ModalRoute.of(context)!.settings.name
                ? true
                : false;
          });
        } else if (state.authStatus == AuthStatus.authenticated) {
          Navigator.pushNamed(context, HomePage.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
