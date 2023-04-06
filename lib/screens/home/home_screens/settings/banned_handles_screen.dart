import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/widgets/text_splitter.dart';

import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../widgets/top_appBar.dart';

class BannedHandlesScreen extends StatelessWidget {
  //make a static routeName
  static const String routeName = '/bannedHandles';
  //make a static route method
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => BannedHandlesScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  const BannedHandlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return a scaffold using top app bar
    return Scaffold(
      appBar: TopAppBar(),
      body:
          //blocbuilder of profile bloc
          BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          //if profileState is profile loaded
          if (profileState is ProfileLoaded) {
            //return a listview of the banned handles
            return ListView.builder(
              itemCount: profileState.user.blockedUsers.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: const Icon(Icons.person),
                    title: TextSplitter(profileState.user.blockedUsers[index],
                        context, Theme.of(context).textTheme.headline2!),
                    trailing:
                        //an elevated button that when clicked will unblock the user
                        //and rebuild the listview
                        ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                              UnblockUserHandle(
                                  blockedHandle:
                                      profileState.user.blockedUsers[index],
                                  context: context),
                            );
                      },
                      child: const Text('Unblock'),
                    ));
              },
            );
          }
          //else return a container
          return Container();
        },
      ),
    );
  }
}
