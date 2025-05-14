import 'package:firebase_authentication/blocs/signin/signin_cubit.dart';
import 'package:firebase_authentication/pages/home_page.dart';
import 'package:firebase_authentication/pages/signup_page.dart';
import 'package:firebase_authentication/utils/error_dialog.dart';
import 'package:firebase_authentication/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart'; // For isEmail

class SigninPage extends StatefulWidget {
  static const String routeName = "/signin";
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? _email, _password;

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('email: $_email, password: $_password');

    context.read<SigninCubit>().signin(email: _email!, password: _password!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap:
            () =>
                FocusScope.of(
                  context,
                ).unfocus(), // Dismiss keyboard on tap outside
        child: BlocConsumer<SigninCubit, SigninState>(
          listener: (context, state) {
            if (state.signinStatus == SigninStatus.error) {
              errorDialog(context, state.error);
            }
            if (state.signinStatus == SigninStatus.success) {
              Navigator.pushNamed(context, HomePage.routeName);
            }
          },
          builder: (context, state) {
            // ignore: deprecated_member_use
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text("Sign In"),
                ),
                body: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autovalidateMode,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Image.asset(
                              'assets/images/firebase.png',
                              width: 250,
                              height: 250,
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                              ),
                              validator: (String? value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email required';
                                }
                                if (!isEmail(value.trim())) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                              onSaved:
                                  (String? value) => _email = value?.trim(),
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              obscureText: true,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password required';
                                }
                                if (value.trim().length < 6) {
                                  return 'Password too short';
                                }
                                return null;
                              },
                              onSaved: (String? value) => _password = value,
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed:
                                  state.signinStatus == SigninStatus.submitting
                                      ? null
                                      : _submit,
                              style: ElevatedButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                ),
                              ),
                              child: Text("Sign In"),
                            ),
                            const SizedBox(height: 10.0),
                            TextButton(
                              onPressed:
                                  state.signinStatus == SigninStatus.submitting
                                      ? null
                                      : () {
                                        Navigator.pushNamed(
                                          context,
                                          SignupPage.routeName,
                                        );
                                      },
                              style: TextButton.styleFrom(
                                textStyle: const TextStyle(
                                  fontSize: 20.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              child: const Text('Not a member? Sign Up!'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.signinStatus == SigninStatus.submitting)
                      const Loader(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
