import 'dart:io';

import 'package:hero/models/arguements/full_screen_video_arg.dart';
import 'package:hero/models/arguements/video_page_view_arg.dart';
import 'package:hero/models/models.dart';
import 'package:hero/models/stories/story_model.dart';
import 'package:hero/screens/banned/banned_screen.dart';
import 'package:hero/screens/email_verification/email_verification_screen.dart';
import 'package:hero/screens/home/home_screens/admin/admin_screen.dart';
import 'package:hero/screens/home/home_screens/admin/admin_user_screen.dart';
import 'package:hero/screens/home/home_screens/admin/admin_verification/admin_verifications_screen.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/liked_waves_screen.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/my_waves_screen.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/whats_missing_screen.dart';
import 'package:hero/screens/home/home_screens/notifications_screen.dart';
import 'package:hero/screens/home/home_screens/store/store_screen.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_screens/tutorial_screen.dart';
import 'package:hero/screens/home/home_screens/user-verification/user_verification_screen.dart';
import 'package:hero/screens/home/home_screens/views/backpack/backpack_screen.dart';
import 'package:hero/screens/home/home_screens/views/generic_view.dart';
import 'package:hero/screens/home/home_screens/views/make_story/new_story_screen.dart';
import 'package:hero/screens/home/home_screens/views/photo_view/photo_view.dart';
import 'package:hero/screens/home/home_screens/views/prizes_screen/prize_shelf_screen.dart';
import 'package:hero/screens/home/home_screens/views/story/story_view.dart';
import 'package:hero/screens/home/home_screens/views/waves/compose_wave.dart';
import 'package:hero/screens/home/home_screens/views/waves/compose_wave_reply_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/sea_real/compose_sea_real_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/waves_replies_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/bubble/compose_bubble_screen.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/full_screen_page_view.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/video/full_screen_viewer.dart';
import 'package:hero/screens/home/home_screens/votes/all_waves_screen.dart';
import 'package:hero/screens/home/home_screens/votes/vote_screen.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:hero/screens/matches/matches_screen.dart';

import 'package:hero/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:hero/screens/starting/starting_screen.dart';

import '../screens/home/home_screens/discovery/discovery_chats_screen.dart';
import '../screens/home/home_screens/discovery/discovery_messages_screen.dart';
import '../screens/home/home_screens/setting_in_app/credits_screen.dart';
import '../screens/home/home_screens/settings/banned_handles_screen.dart';
import '../screens/home/home_screens/stingray_chats/comments_screen.dart';
import '../screens/home/home_screens/stingray_chats/stingray_messages_screen.dart';
import '../screens/home/home_screens/setting_in_app/swag_screen.dart';
import '../screens/home/home_screens/views/waves/widget/wave_tile.dart';
import '../screens/matches/user_likes_screen.dart';
import '../screens/starting/starting_screens/sign_up_screen.dart';
import '../screens/starting/starting_screens/signin_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('The Route is: ${settings.name}');

    switch (settings.name) {
      case '/':
        return MainPage.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      //notifications
      case NotificationsScreen.routeName:
        return NotificationsScreen.route();
      case TutorialScreen.routeName:
        return TutorialScreen.route();
      case UserLikesScreen.routeName:
        return UserLikesScreen.route();

      case MyWavesScreen.routeName:
        return MyWavesScreen.route();
      case LikedWavesScreen.routeName:
        return LikedWavesScreen.route();
      case ComposeSeaRealScreen.routeName:
        return ComposeSeaRealScreen.route();

      case OnboardingScreen.routeName:
        return OnboardingScreen.route(user: settings.arguments as User);
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case PrizeShelfScreen.routeName:
        return PrizeShelfScreen.route();
      case CreditsScreen.routeName:
        return CreditsScreen.route();
      case SwagScreen.routeName:
        return SwagScreen.route();
      case AdminScreen.routeName:
        return AdminScreen.route();
      case AdminUserScreen.routeName:
        return AdminUserScreen.route();
      case TeamScreen.routeName:
        return TeamScreen.route();
      case MainPage.routeName:
        return MainPage.route();
      case Wrapper.routeName:
        return Wrapper.route();
      case CommentsScreen.routeName:
        return CommentsScreen.route();
      case SignInScreen.routeName:
        return SignInScreen.route();
      case SignupScreen.routeName:
        return SignupScreen.route();
      case StartingScreen.routeName:
        return StartingScreen.route();
      case StingrayMessagesScreen.routeName:
        return StingrayMessagesScreen.route();

      case BackpackScreen.routeName:
        return BackpackScreen.route();
      case VerifyScreen.routeName:
        return VerifyScreen.route();
      case VoteScreen.routeName:
        return VoteScreen.route();
      case DiscoveryMessagesScreen.routeName:
        return DiscoveryMessagesScreen.route(
            map: settings.arguments as Map<String, dynamic>?);
      case DiscoveryChatsScreen.routeName:
        return DiscoveryChatsScreen.route();
      case ComposeWaveScreen.routeName:
        return ComposeWaveScreen.route(waveType: settings.arguments as String);
      //banned
      case BannedScreen.routeName:
        return BannedScreen.route();
      //BannedHandlesScreen
      case WaveVideoPageView.routeName:
        return WaveVideoPageView.route(arg: settings.arguments as PageViewArg);
      case BannedHandlesScreen.routeName:
        return BannedHandlesScreen.route();
      case ComposeBubbleScreen.routeName:
        return ComposeBubbleScreen.route(
          firstImage: settings.arguments as File,
        );
      case StoreScreen.routeName:
        return StoreScreen.route();


        //AllWavesScreen needs a User object
      case AllWavesScreen.routeName:
        return AllWavesScreen.route(voteUser: settings.arguments as User);

        //WhatsMissingScreen
      case WhatsMissingScreen.routeName:
        return WhatsMissingScreen.route();

      case UserVerificationScreen.routeName:
        return UserVerificationScreen.route();
      case AdminVerificationScreen.routeName:
        return AdminVerificationScreen.route();
      case NewStoryScreen.routeName:
        return NewStoryScreen.route();
      case StoryView.routeName:
        return StoryView.route(stories: settings.arguments as List<Story>);

      case ComposeWaveReplyScreen.routeName:
        return ComposeWaveReplyScreen.route(
            map: settings.arguments as Map<String, dynamic>);

      case WaveRepliesScreen.routeName:
        return WaveRepliesScreen.route(
            map: settings.arguments as Map<String, dynamic>);
      case MyPhotoView.routeName:
        return MyPhotoView.route(
            map: settings.arguments as Map<String, dynamic>);
      default:
        return _errorRoute();
    }
  }

  static const String routeName = '/';

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: Text('error'))),
      settings: RouteSettings(name: '/error'),
    );
  }
}
