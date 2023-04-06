import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/signIn/cubit/signin_cubit.dart';
import 'package:hero/cubits/signupNew/cubit/signup_cubit.dart';
import 'package:hero/screens/onboarding/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/top_appBar.dart';
import '../../email_verification/email_verification_screen.dart';
import '../../onboarding/widgets/custom_opening_button.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  static route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => SignupScreen(),
    );
  }

  const SignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupScreen> createState() => _EmailState();
}

class _EmailState extends State<SignupScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupState) {
            if (state.status == SignupStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                ),
              );
            }
            if (state.status == SignupStatus.success) {
              Navigator.of(context).pushNamed('/verify');
            }
          }
        },
        child: Scaffold(
          //do not resize when keyboard is up
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
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      style: //headline 4
                          Theme.of(context).textTheme.headline5,
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
                        context.read<SignupCubit>().emailChanged(value);
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _passwordController,
                      onChanged: (value) {
                        context.read<SignupCubit>().passwordChanged(value);
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
                  //add some rich text that says "By signing up, you agree to our terms and conditions". Have the terms and conditions be a link that opens a new page with the terms and conditions
                  GestureDetector(
                    child: RichText(
                      text: TextSpan(
                          text: 'By signing up, you agree to our ',
                          style: Theme.of(context).textTheme.bodyText1,
                          children: [
                            TextSpan(
                              text: 'terms and conditions',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ]),
                    ),
                    onTap: ()
                        //open terms and conditions. user webview
                        async {
                      final Uri url =
                          Uri.parse('https://oceanwv-privacy-policy.web.app/');
                      if (!await launchUrl(url)) {
                        throw 'Could not launch $url';
                      }
                    },
                  ),

                  SizedBox(height: 10),
                  CustomOpeningButton(
                    onPressed: () =>
                        context.read<SignupCubit>().signUpWithCredentials(),
                    text: 'SIGN UP',
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
