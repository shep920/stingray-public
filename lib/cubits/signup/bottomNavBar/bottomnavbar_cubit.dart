import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/chat/chat_bloc.dart';
import 'package:hero/blocs/leaderboad/leaderboard_bloc.dart';
import 'package:hero/blocs/like/like_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/typesense/bloc/search_bloc.dart';
import 'package:hero/cubits/kelp_memory/kelp_memory_cubit.dart';
import 'package:hero/helpers/get.dart';
import 'package:hero/screens/banned/banned_screen.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:provider/provider.dart';

import '../../../blocs/discovery_chat/discovery_chat_bloc.dart';

import '../../../blocs/user discovery swiping/user_discovery_bloc.dart';

class BottomnavbarCubit extends Cubit<int> {
  BottomnavbarCubit() : super(0);

  /// update index function to update the index onTap in BottomNavigationBar
  void updateIndex(int index, context) {
    final state = this.state;

    if (state != 1 && index == 1) {
      
    }

    if (state == 4 && index != 4) {
      BlocProvider.of<KelpMemoryCubit>(context)
          .clearMemory(Get.blocUser(context).id!);
    }

    emit(index);
  }

  /// for navigation button on single page
  void getHome() => emit(0);
  void getTasks() => emit(1);
  void getApps() => emit(2);
  void getNotification() => emit(3);
  void getProfile() => emit(4);
}
