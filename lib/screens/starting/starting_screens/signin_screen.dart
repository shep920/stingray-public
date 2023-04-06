import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/signIn/cubit/signin_cubit.dart';
import 'package:hero/repository/auth_repository.dart';
import 'package:hero/screens/onboarding/widgets/custom_login_button.dart';
import 'package:hero/screens/onboarding/widgets/widgets.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:provider/src/provider.dart';

import '../../onboarding/widgets/custom_opening_button.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = '/signIn';
  const SignInScreen({Key? key}) : super(key: key);

  //make the Route
  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => SignInScreen(),
    );
  }

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _emailFocusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);

    return BlocListener<SigninCubit, SigninState>(
        listener: (context, state) {
          if (state is SigninState) {
            if (state.status == SigninStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                ),
              );
            }
            if (state.status == SigninStatus.success) {
              Navigator.of(context).pushNamed('/mainPage');
            }
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: TopAppBar(
            title: 'Sign In',
            hasActions: false,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      focusNode: _emailFocusNode,
                      style: //headline 4
                          Theme.of(context).textTheme.headline5,
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        hintText: 'Enter your email',
                        contentPadding:
                            const EdgeInsets.only(bottom: 5.0, top: 12.5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onChanged: (value) {
                        context.read<SigninCubit>().emailChanged(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      onChanged: (value) {
                        context.read<SigninCubit>().passwordChanged(value);
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).scaffoldBackgroundColor,
                        hintText: 'Enter your password',
                        contentPadding:
                            const EdgeInsets.only(bottom: 5.0, top: 12.5),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  CustomOpeningButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Wow thats crazy'),
                      ),
                    ),
                    text: 'FORGOT PASSWORD?',
                  ),
                  SizedBox(height: 20),
                  CustomOpeningButton(
                    onPressed: () =>
                        context.read<SigninCubit>().signInWithCredentials(),
                    text: 'LOGIN',
                  ),
                  SizedBox(height: 20),
                  CustomOpeningButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: 'BACK',
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
