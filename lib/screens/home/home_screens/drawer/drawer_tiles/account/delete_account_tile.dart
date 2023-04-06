import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/helpers/get.dart';
import 'package:hero/screens/home/home_screens/settings/settings_screen.dart';
import 'package:hero/screens/starting/starting_screen.dart';

class DeleteAccountTile extends StatelessWidget {
  const DeleteAccountTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.delete),
      title: Text('Delete Account',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Colors.red,
              )),
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Delete Account'),
              content: Text('Are you sure you want to delete your account?',
                  style: Theme.of(context).textTheme.headline2),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteDialog();
                      },
                    );
                  },
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  //text controllers for email and password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Reauthenticate'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Please enter your email and password to continue.'),
          SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
            //set the text color to white
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
          onPressed: () async {
            final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
            auth.AuthCredential credential = auth.EmailAuthProvider.credential(
              email: _emailController.text,
              password: _passwordController.text,
            );
            _firebaseAuth.currentUser!
                .reauthenticateWithCredential(credential)
                .then((value) {
              BlocProvider.of<ProfileBloc>(context).add(DeleteProfile(
                user: Get.blocUser(context),
              ));

              //delete the user
              _firebaseAuth.currentUser!.delete();

              //replace stack with StartingScreen.routeName
              Navigator.pushReplacementNamed(context, StartingScreen.routeName);
            }).catchError((error) =>
                    //create a snackbar to show the error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                      ),
                    ));
          },
          child: Text('Delete'),
        ),
      ],
    );
  }
}
