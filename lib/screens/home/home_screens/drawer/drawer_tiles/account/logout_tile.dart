import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';

class LogoutTile extends StatelessWidget {
  const LogoutTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('Logout', style: Theme.of(context).textTheme.headline4),
      onTap: () {
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        _firebaseAuth.signOut();

        BlocProvider.of<ProfileBloc>(context).add(CloseProfile());
        Navigator.popAndPushNamed(context, '/wrapper/');
      },
    );
  }
}
