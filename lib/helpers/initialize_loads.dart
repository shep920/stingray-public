import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hero/blocs/like/like_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/blocs/user%20discovery%20swiping/user_discovery_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/cloud_messaging/cloud_messaging_bloc.dart';
import '../blocs/leaderboad/leaderboard_bloc.dart';
import '../blocs/stingrays/stingray_bloc.dart';
import '../repository/messaging_repository.dart';

void initializeLoads(BuildContext context, String uid) {
  if (kIsWeb) {
  } else {
    MessagingRepository().getPermission();
    Provider.of<CloudMessagingBloc>(context, listen: false)
        .add(LoadCloudMessaging(id: uid));
    // NOT running on the web! You can check for additional platforms here.
  }

  

  //add LoadDiscovery from ProfileBloc
}
