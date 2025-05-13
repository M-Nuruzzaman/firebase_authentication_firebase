import 'package:firebase_authentication/blocs/signin/signin_cubit.dart';
import 'package:firebase_authentication/blocs/signup/signup_cubit.dart';
import 'package:firebase_authentication/pages/home_page.dart';
import 'package:firebase_authentication/pages/signin_page.dart';
import 'package:firebase_authentication/utils/error_dialog.dart';
import 'package:firebase_authentication/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validators/validators.dart'; // For isEmail

class SignupPage extends StatefulWidget {
  static const String routeName = "/signup";
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _passwordController = TextEditingController();

  String? _name, _email, _password;

  void _submit() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    form.save();

    print('name: $_name, email: $_email, password: $_password');

    context.read<SignupCubit>().signup(
      name: _name!,
      email: _email!,
      password: _password!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () =>
              FocusScope.of(
                context,
              ).unfocus(), // Dismiss keyboard on tap outside
      child: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state.signupStatus == SignupStatus.error) {
            errorDialog(context, state.error);
          }
          if (state.signupStatus == SignupStatus.success) {
            Navigator.pushNamed(context, HomePage.routeName);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Sign In")),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  reverse: true,
                  children:
                      [
                        Image.asset(
                          'assets/images/firebase.png',
                          width: 250,
                          height: 250,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.account_box),
                          ),
                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name required';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                          onSaved: (String? value) => _name = value?.trim(),
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
                          onSaved: (String? value) => _email = value?.trim(),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
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
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            labelText: 'Confirm password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (String? value) {
                            if (_passwordController.text != value) {
                              return 'Passwords not match';
                            }
                            return null;
                          },
                          onSaved: (String? value) => _password = value,
                        ),

                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed:
                              state.signupStatus == SignupStatus.submitting
                                  ? null
                                  : _submit,
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                          ),
                          child: Text(
                            state.signupStatus == SignupStatus.submitting
                                ? "Loading.."
                                : "Sign up",
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        TextButton(
                          onPressed:
                              state.signupStatus == SigninStatus.submitting
                                  ? null
                                  : () {
                                    Navigator.pushNamed(
                                      context,
                                      SigninPage.routeName,
                                    );
                                  },
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          child: Text('Already a member? Sign in!'),
                        ),
                      ].reversed.toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
