import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication/blocs/auth/auth_bloc.dart';
import 'package:firebase_authentication/blocs/profile/profile_cubit.dart';
import 'package:firebase_authentication/blocs/signin/signin_cubit.dart';
import 'package:firebase_authentication/blocs/signup/signup_cubit.dart';
import 'package:firebase_authentication/pages/home_page.dart';
import 'package:firebase_authentication/pages/signin_page.dart';
import 'package:firebase_authentication/pages/signup_page.dart';
import 'package:firebase_authentication/pages/splash_page.dart';
import 'package:firebase_authentication/repositories/auth_repository.dart';
import 'package:firebase_authentication/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Make sure this import exists
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create:
              (context) => AuthRepository(
                firebaseFirestore: FirebaseFirestore.instance,
                firebaseAuth: FirebaseAuth.instance,
              ),
        ),
        RepositoryProvider<ProfileRepository>(
          create:
              (context) => ProfileRepository(
                firebaseFirestore: FirebaseFirestore.instance,
              ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create:
                (context) =>
                    AuthBloc(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<SigninCubit>(
            create:
                (context) =>
                    SigninCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<SignupCubit>(
            create:
                (context) =>
                    SignupCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider<ProfileCubit>(
            create:
                (context) => ProfileCubit(
                  profileRepository: context.read<ProfileRepository>(),
                ),
          ),
        ],
        child: MaterialApp(
          title: 'Firebase Auth',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const SplashPage(),
          routes: {
            SignupPage.routeName: (context) => const SignupPage(),
            SigninPage.routeName: (context) => const SigninPage(),
            HomePage.routeName: (context) => const HomePage(),
          },
        ),
      ),
    );
  }
}
