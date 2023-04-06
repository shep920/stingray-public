import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/helpers/pick_file.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/drawer/collapsable_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_header.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/account/admin_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/account/blocked_users_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/account/delete_account_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/account/logout_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/backpack_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/chat_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/drop_stingray_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/liked_waves_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/misc/credits_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/misc/matoi_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/misc/report_bug_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/misc/swag_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/missing_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/my_waves_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/privacy/eula_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/prizes_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/profile_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/tour_tile.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/verification_tile.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileLoaded) {
              User user = profileState.user;

              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  MyDrawerHeader(user: user),
                  const ProfileTile(),

                  const PrizesTile(),

                  if (!user.finishedOnboarding ||
                      !user.sentFirstSeaReal ||
                      !user.castFirstVote)
                    MissingTile(),

                  if (user.isStingray) DopStingrayTile(), 

                  CollapsibleMenu(
                    title: 'My Stuff',
                    body: Column(
                      children: [
                        const MyWavesTile(),
                        const LikedWavesTile(),
                        if (user.finishedOnboarding) const BackpackTile(),
                      ],
                    ),
                  ),

                  CollapsibleMenu(
                    title: 'Account',
                    body: Column(
                      children: [
                        const LogoutTile(),
                        if (user.isAdmin) const AdminTile(),
                        if (user.finishedOnboarding) const VerificationTile(),
                        const BlockedUsersTile(),
                        const DeleteAccountTile(),
                      ],
                    ),
                  ),

                  CollapsibleMenu(
                    title: 'Privacy',
                    body: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const EULATile(),
                      ],
                    ),
                  ),
                  CollapsibleMenu(
                    title: 'Misc',
                    body: Column(
                      children: [
                        const TourTile(),
                        const MatoiTile(),
                        const SwagTile(),
                        const ReportBugTile(),
                        const CreditsTile(),
                      ],
                    ),
                  ),

                  // if (user.finishedOnboarding)
                  //   //a list tile for the tutorial screen
                  //   ListTile(
                  //     //set the color of the backgrond of the listtile to scaffoldBackgroundColor
                  //     tileColor: Theme.of(context).scaffoldBackgroundColor,
                  //     leading: Icon(Icons.shopping_cart_outlined,
                  //         color: Theme.of(context).colorScheme.primary),
                  //     title: Text('Store',
                  //         style: Theme.of(context).textTheme.headline4),
                  //     onTap: () {
                  //       Navigator.pushNamed(context, StoreScreen.routeName);
                  //     },
                  //   ),
                ],
              );
            }
            return Container();
          },
        ));
  }
}
