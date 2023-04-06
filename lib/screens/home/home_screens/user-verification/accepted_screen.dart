import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:path_provider/path_provider.dart';

class AcceptedVerificationScreen extends StatelessWidget {
  const AcceptedVerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Text(
            "GZ! You're verified, so now you're guaranteed to be who you say you are. Additionally, you\'ll come up quicker on searches, and your waves will be more popular by default. However, please note that attempting to impersonate someone else will result in a ban. Thank you for using our services and being a responsible member of our community.",
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
          ),
          Image.asset(
            "assets/stingray_logo.png",
            height: 200,
            width: 200,
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
