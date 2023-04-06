// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/discovery_chat/discovery_chat_bloc.dart';
import 'package:hero/blocs/discovery_chat_judgeable/discovery_chat_judgeable_bloc.dart';
import 'package:hero/blocs/discovery_chat_pending/discovery_chat_pending_bloc.dart';
import 'package:hero/blocs/swipe/swipe_bloc.dart';
import 'package:hero/cubits/localuser/localuser_cubit.dart';
import 'package:hero/cubits/signup/bottomNavBar/bottomnavbar_cubit.dart';
import 'package:hero/models/models.dart';
import 'package:hero/provider/new_version_timer.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/drawer/custom_drawer.dart';

import 'package:hero/screens/home/home_screens/screens.dart';
import 'package:hero/screens/home/home_screens/settings/settings_screen.dart';
import 'package:hero/screens/home/home_screens/store/store_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/user_verification_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/sea_real/sea_real_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/full_screen_page_view.dart';
import 'package:hero/screens/home/home_screens/views/widgets/main_page_action_button.dart';
import 'package:hero/screens/home/home_screens/votes/leaderboard_screen.dart';
import 'package:hero/widgets/top_appBar.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import '../../blocs/profile/profile_bloc.dart';
import '../profile/profile_screen.dart';
import 'home_screens/discovery/user_discovery_screen.dart';
import 'home_screens/yip_yap/yip_yap_screen.dart';

class MainPage extends StatefulWidget {
  @override
  static const String routeName = '/mainPage';
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => MainPage(),
      settings: RouteSettings(name: routeName),
    );
  }

  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  NewVersion newVersion = NewVersion(
    iOSId: 'com.matoitechnology.fishtank1256456456',
    androidId: 'com.matoitechnology.fishtank1256456456',
  );

  Timer? _timer;
  bool isFinished = false;

  //void method to reset the timer
  void resetTimer() {
    setState(() {
      _timer!.cancel();
      _timer = Timer.periodic(Duration(minutes: 5), (t) {
        isFinished = true;
      });
    });
  }

  @override
  void initState() {
    if (!kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _timer = Timer.periodic(Duration(minutes: 5), (t) {
            isFinished = true;
          });
        });
        advancedStatusCheck(newVersion, context, resetTimer);
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isFinished) {
      advancedStatusCheck(newVersion, context, resetTimer);
    }
    return BlocBuilder<BottomnavbarCubit, int>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: (state != 1)
                ? TopAppBar(
                    showDrawer: true,
                    showChats: true,
                  )
                : null,
            drawer: CustomDrawer(),
            body: _buildBody(state),
            bottomNavigationBar: _buildBottomNav(),
            floatingActionButton: (state == 0) ? MainPageActionButton() : null,
          ),
        );
      },
    );
  }

  Widget _buildBody(int index) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          List<StatefulWidget> _pageNavigation = [
            HomeScreen(),
            LeaderboardScreen(),
            if (user.castFirstVote) YipYapScreen(),
            if (user.finishedOnboarding) SeaRealScreen(),
            if (user.sentFirstSeaReal) UserDiscoveryScreen(),
          ];
          return _pageNavigation.elementAt(index);
        }
        return Container();
      },
    );
  }

  Widget _buildBottomNav() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          return BottomNavigationBar(
            //set background color of bottom nav bar
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconSize: 30,
            currentIndex: context.read<BottomnavbarCubit>().state,
            type: BottomNavigationBarType.fixed,
            onTap: _getChangeBottomNav,
            showSelectedLabels: false,
            showUnselectedLabels: false,

            // ignore: prefer_const_literals_to_create_immutables
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: "",
                activeIcon: Icon(Icons.home_filled),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_search_outlined),
                label: "",
                activeIcon: Icon(Icons.person_search),
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.anchor),
                activeIcon: FaIcon(FontAwesomeIcons.anchorCircleExclamation),
                label: "",
              ),
              if (user.finishedOnboarding)
                BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt_outlined),
                  label: "",
                  activeIcon: Icon(Icons.camera_alt),
                ),
              if (user.sentFirstSeaReal)
                BottomNavigationBarItem(
                  icon: FaIcon(FontAwesomeIcons.fish),
                  label: "",
                ),
            ],
          );
        }
        return Container();
      },
    );
  }

  void _getChangeBottomNav(int index) {
    BlocProvider.of<BottomnavbarCubit>(context).updateIndex(index, context);
  }
}

advancedStatusCheck(
    NewVersion newVersion, context, void Function() resetTimer) async {
  final status = await newVersion.getVersionStatus();

  if (isCurrentVersionOutdated(status!.localVersion, status.storeVersion)) {
    final String dialogText = //dialog text followed by the release notes
        status.releaseNotes != null
            ? 'Looks like this version is no longer supported. Please update to the latest version. \n Here\'s a look at what your missing:\n \n${status.releaseNotes!}'
            : '';
    debugPrint(status.releaseNotes);
    debugPrint(status.appStoreLink);
    debugPrint(status.localVersion);
    debugPrint(status.storeVersion);
    debugPrint(status.canUpdate.toString());
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: 'New Version Available',
      dialogText: dialogText,
      allowDismissal: false,
    );
  } else {
    if (!kDebugMode) {
      resetTimer();
    }
  }
}

bool isCurrentVersionOutdated(String currentVersion, String latestVersion) {
  final currentVersionParts = currentVersion.split('.');
  final latestVersionParts = latestVersion.split('.');

  int _currentVersionHighestValue =
      (int.parse(currentVersionParts[0]) * 1000000).round();

  int _currentVersionMiddleValue =
      (int.parse(currentVersionParts[1]) * 10).round();
  int _currentVersionLowestValue = int.parse(currentVersionParts[2]).round();

  int _latestVersionHighestValue =
      (int.parse(latestVersionParts[0]) * 1000000).round();
  int _latestVersionMiddleValue =
      (int.parse(latestVersionParts[1]) * 10).round();
  int _latestVersionLowestValue = int.parse(latestVersionParts[2]).round();

  final currentVersionPart = _currentVersionHighestValue +
      _currentVersionMiddleValue +
      _currentVersionLowestValue;
  final latestVersionPart = _latestVersionHighestValue +
      _latestVersionMiddleValue +
      _latestVersionLowestValue;

  if (currentVersionPart < latestVersionPart) {
    return true;
  }

  return false;
}
