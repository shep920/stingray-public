import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hero/cubits/signIn/cubit/signin_cubit.dart';
import 'package:hero/cubits/signupNew/cubit/signup_cubit.dart';
import 'package:hero/models/user_model.dart' as myUser;
import 'package:hero/repository/auth_repository.dart';
import 'package:provider/src/provider.dart';

class CustomLoginButton extends StatelessWidget {
  final String text;
  final String email;
  final String password;

  const CustomLoginButton({
    Key? key,
    this.text = 'START',
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepository = Provider.of<AuthRepository>(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: LinearGradient(colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).backgroundColor,
        ]),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          primary: Colors.transparent,
        ),
        onPressed: () async {
          context.read<SigninCubit>().signInWithCredentials();
          // authRepository.signInWithEmailAndPassword(
          //     email: email, password: password);
          // print(context.read<SigninCubit>().state);
          Navigator.pushNamed(context, '/wrapper/');
        },
        child: Container(
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
