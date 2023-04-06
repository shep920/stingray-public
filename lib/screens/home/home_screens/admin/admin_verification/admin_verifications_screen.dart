import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/admin-verification/admin_verification_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/firebase_options.dart';
import 'package:hero/models/user-verification/user_verification_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/typesense_repo.dart';
import 'package:hero/screens/home/home_screens/admin/admin_verification/reject_verification_popup.dart';
import 'package:hero/screens/home/home_screens/views/photo_view/photo_view.dart';
import 'package:hero/screens/home/home_screens/votes/vote_view.dart';
import 'package:hero/widgets/top_appBar.dart';

class AdminVerificationScreen extends StatefulWidget {
  //make a static routename and route method
  static const String routeName = '/admin-verification';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => AdminVerificationScreen());
  }

  const AdminVerificationScreen({Key? key}) : super(key: key);

  @override
  State<AdminVerificationScreen> createState() =>
      _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  @override
  void initState() {
    if (BlocProvider.of<AdminVerificationBloc>(context).state
        is AdminVerificationLoading) {
      BlocProvider.of<AdminVerificationBloc>(context)
          .add(LoadAdminVerification());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(),
      body: BlocBuilder<AdminVerificationBloc, AdminVerificationState>(
        builder: (context, adminVerificationState) {
          if (adminVerificationState is AdminVerificationLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (adminVerificationState is AdminVerificationLoaded) {
            List<UserVerification> verifications =
                adminVerificationState.verifications;
            List<User> users = adminVerificationState.users;
            return ListView.builder(
              itemCount: verifications.length,
              itemBuilder: (BuildContext context, int index) {
                UserVerification _verification = verifications[index];
                User _user = users
                    .firstWhere((element) => element.id == _verification.id);
                return Column(
                  children: [
                    VoteView(
                      user: (BlocProvider.of<ProfileBloc>(context).state
                              as ProfileLoaded)
                          .user,
                      voteUser: _user,
                      waves: [],
                      imageUrlIndex: 0,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '${_user.name}\'s verification picture',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    InkWell(
                      child:
                          CachedNetworkImage(imageUrl: _verification.imageUrl),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          MyPhotoView.routeName,
                          arguments: {
                            'imageUrl': _verification.imageUrl,
                          },
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<AdminVerificationBloc>(context).add(
                                AcceptVerification(
                                    verification: _verification, verifiedAs: _user));
                          },
                          child: Text('Verify'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            //show modal popup
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return RejectVerificationPopup(
                                  userVerification: _verification,
                                  voteTarget: _user,
                                );
                              },
                            );
                          },
                          child: Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}

//write a test for the admin verification screen
