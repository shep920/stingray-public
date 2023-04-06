import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/admin%20bloc/admin_bloc.dart';
import 'package:hero/blocs/discovery_messages/discovery_message_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/cubits/localuser/localuser_cubit.dart';
import 'package:hero/models/models.dart' as myUser;
import 'package:hero/models/stories/story_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/admin/admin_verification/admin_verifications_screen.dart';
import 'package:hero/screens/home/home_screens/discovery/discovery_messages_screen.dart';
import 'package:hero/screens/home/home_screens/views/generic_view.dart';
import 'package:hero/static_data/report_stuff.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../blocs/leaderboad/leaderboard_bloc.dart';
import '../../../../blocs/typesense/bloc/search_bloc.dart';
import '../../../../blocs/vote/vote_bloc.dart';
import '../../../../models/leaderboard_model.dart';
import '../../../../models/models.dart';
import '../../../../models/user_search_view_model.dart';
import '../../../onboarding/widgets/gradient_text.dart';
import '../views/waves/widget/wave_tile.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin';
  AdminScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => AdminScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<AdminBloc>(context, listen: false).add(CloseReports());
        return true;
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            myUser.User? user = state.user;
            return BlocBuilder<StingrayBloc, StingrayState>(
              builder: (context, stingrayState) {
                if (stingrayState is StingrayLoaded) {
                  return BlocBuilder<AdminBloc, AdminState>(
                    builder: (context, adminState) {
                      if (adminState is AdminLoading)
                        return Scaffold(
                          appBar: TopAppBar(title: 'Admin'),
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      if (adminState is AdminLoaded) {
                        List<Report?> reports = adminState.reports;
                        return Scaffold(
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            automaticallyImplyLeading: true,
                            elevation: 0,
                            title: Row(
                              children: [
                                Icon(Icons.search, color: Colors.black),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.6,
                                  child: TextFormField(
                                    initialValue: '@',
                                    onChanged: (query) async {
                                      context.read<SearchBloc>().add(
                                          SearchUsers(
                                              limit: 10,
                                              query: query,
                                              searcher: null));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          body: BlocBuilder<SearchBloc, SearchState>(
                            builder: (context, state) {
                              if (state is QueryLoaded) {
                                if (state.query == null ||
                                    state.query == '' ||
                                    state.query == '@') {
                                  return Column(
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                AdminVerificationScreen
                                                    .routeName);
                                          },
                                          child: Text('Verifications')),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: adminState.reports.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Report? report = reports[index];
                                            if (reports.isEmpty) {
                                              return Center(
                                                child: Text('No reports'),
                                              );
                                            }
                                            return _buildReport(
                                                report, context);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                if (state.users.isEmpty)
                                  return Center(
                                    child: Text("No users found you dumbass"),
                                  );
                                return Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: state.users.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          User? user = state.users[index];
                                          String votes = user!.votes.toString();
                                          return ListTile(
                                              onTap: () {
                                                context.read<AdminBloc>().add(
                                                    LoadAdminUserFromFirestore(
                                                        user.id));
                                                Navigator.pushNamed(
                                                    context, '/adminUser');
                                              },
                                              title: Text(user.name),
                                              subtitle: Text(user.handle),
                                              trailing: Text("Votes: $votes"),
                                              leading: CircleAvatar(
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          (state.users[index]!
                                                                  .imageUrls[0]
                                                              as String))));
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        );
                      }

                      return Container();
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

//a switch case that takes in the rport, checks the type, and returns the correct widget build method

Widget _buildReport(Report? report, BuildContext context) {
  if (report == null) return Container();
  //make a switch case for if the report type is a vote, return a vote report. if the report is of type mention, return a mention report.
  switch (report.type) {
    case ReportStuff.wave_type:
      return WaveReportTile(
        report: report,
      );
    case ReportStuff.user_type:
      return UserReportTile(
          reportedUser: report.reportedUser!,
          reporterUser: report.reporterUser!,
          report: report);
    case ReportStuff.discovery_chat_type:
      return DiscoveryReportTile(
        report: report,
        reportedUser: report.reportedUser!,
        reporterUser: report.reporterUser!,
      );
    case ReportStuff.story_type:
      return StoryReportTile(
        report: report,
        reportedUser: report.reportedUser!,
        reporterUser: report.reporterUser!,
        story: Story.storyFromString(report.storyString!),
      );

    default:
      return Container();
  }
}

class UserReportTile extends StatelessWidget {
  final User reportedUser;
  final User reporterUser;
  final Report report;
  const UserReportTile(
      {Key? key,
      required this.reportedUser,
      required this.reporterUser,
      required this.report})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //return a column with padding that says who reported who, and the available actions
        //available actions are to ban the user, or to delete the report, or to view the reported user's profile, or to view the reporter's profile
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        //add padding

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //text to say who it was reported by
          Text(
              'Reported by: ${reporterUser.name}, aka: ${reporterUser.handle} ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          Text('Reason: ${report.reason}',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          Text(
              'Reported user: ${report.reportedUser!.name}, aka: ${report.reportedUser!.handle} ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.purple,
                      )),
          //text saying available actions
          Text('Available actions: ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          //button to ban the user
          ElevatedButton(onPressed: () {}, child: Text('Ban user')),
          //button to delete the report
          ElevatedButton(
              onPressed: () {
                BlocProvider.of<AdminBloc>(context)
                    .add(IgnoreReport(report: report));
              },
              child: Text('Delete report')),
          //button to view the reported user's profile
          ElevatedButton(
              onPressed: () {
                context.read<AdminBloc>().add(LoadAdminUserFromFirestore(
                    reportedUser.id)); //load the user from firestore
                Navigator.pushNamed(
                    context, '/adminUser'); //navigate to the admin user page
              },
              child: Text('View reported user')),

          ElevatedButton(
              onPressed: () {
                Provider.of<DiscoveryMessageBloc>(context, listen: false).add(
                    LoadDiscoveryMessage(
                        chatId: report.chatId!, matchedUser: reportedUser));
                Navigator.pushNamed(context, DiscoveryMessagesScreen.routeName,
                    arguments: null);
              },
              child: Text('View reported Chat')),
          //button to view the reporter's profile
          ElevatedButton(
              onPressed: () {
                context.read<AdminBloc>().add(LoadAdminUserFromFirestore(
                    reporterUser.id)); //load the user from firestore
                Navigator.pushNamed(
                    context, '/adminUser'); //navigate to the admin user page
              },
              child: Text('View reporter')),
        ],
      ),
    );
  }
}

class StoryReportTile extends StatelessWidget {
  final User reportedUser;
  final User reporterUser;
  final Report report;
  final Story story;
  const StoryReportTile(
      {Key? key,
      required this.reportedUser,
      required this.reporterUser,
      required this.report,
      required this.story})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //return a column with padding that says who reported who, and the available actions
        //available actions are to ban the user, or to delete the report, or to view the reported user's profile, or to view the reporter's profile
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        //add padding

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //text to say who it was reported by
          Text(
              'Reported by: ${reporterUser.name}, aka: ${reporterUser.handle} ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          Text('Reason: ${report.reason}',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          Text(
              'Reported user: ${report.reportedUser!.name}, aka: ${report.reportedUser!.handle} ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.purple,
                      )),

          CachedNetworkImage(imageUrl: story.imageUrl),
          //text saying available actions
          Text('Available actions: ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          //button to ban the user

          //button to delete the report
          ElevatedButton(
              onPressed: () {
                BlocProvider.of<AdminBloc>(context)
                    .add(IgnoreReport(report: report));
              },
              child: Text('Delete report')),
          //button to view the reported user's profile
          ElevatedButton(
              onPressed: () {
                context.read<AdminBloc>().add(LoadAdminUserFromFirestore(
                    reportedUser.id)); //load the user from firestore
                Navigator.pushNamed(
                    context, '/adminUser'); //navigate to the admin user page
              },
              child: Text('View reported user')),
          //button to view the reporter's profile
          ElevatedButton(
              onPressed: () {
                context.read<AdminBloc>().add(LoadAdminUserFromFirestore(
                    reporterUser.id)); //load the user from firestore
                Navigator.pushNamed(context,
                    AdminScreen.routeName); //navigate to the admin user page
              },
              child: Text('View reporter')),

          ElevatedButton(
              onPressed: () {
                BlocProvider.of<StingrayBloc>(context)
                    .add(DeleteStory(story: story));

                BlocProvider.of<AdminBloc>(context)
                    .add(IgnoreReport(report: report));
              },
              child: Text('Delete Story')),
        ],
      ),
    );
  }
}

class DiscoveryReportTile extends StatelessWidget {
  final User reportedUser;
  final User reporterUser;
  final Report report;
  const DiscoveryReportTile(
      {Key? key,
      required this.reportedUser,
      required this.reporterUser,
      required this.report})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //return a column with padding that says who reported who, and the available actions
        //available actions are to ban the user, or to delete the report, or to view the reported user's profile, or to view the reporter's profile
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        //add padding

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //text to say who it was reported by
          Text(
              'Reported by: ${reporterUser.name}, aka: ${reporterUser.handle} ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          Text('Reason: ${report.reason}',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          Text(
              'Reported user: ${report.reportedUser!.name}, aka: ${report.reportedUser!.handle} ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.purple,
                      )),
          //text saying available actions
          Text('Available actions: ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          //button to ban the user
          ElevatedButton(onPressed: () {}, child: Text('Ban user')),
          //button to delete the report
          ElevatedButton(
              onPressed: () {
                BlocProvider.of<AdminBloc>(context)
                    .add(IgnoreReport(report: report));
              },
              child: Text('Delete report')),
          //button to view the reported user's profile
          ElevatedButton(
              onPressed: () {
                context.read<AdminBloc>().add(LoadAdminUserFromFirestore(
                    reportedUser.id)); //load the user from firestore
                Navigator.pushNamed(
                    context, '/adminUser'); //navigate to the admin user page
              },
              child: Text('View reported user')),
          //button to view the reporter's profile
          ElevatedButton(
              onPressed: () {
                context.read<AdminBloc>().add(LoadAdminUserFromFirestore(
                    reporterUser.id)); //load the user from firestore
                Navigator.pushNamed(context,
                    AdminScreen.routeName); //navigate to the admin user page
              },
              child: Text('View reporter')),

          ElevatedButton(
              onPressed: () {
                Provider.of<DiscoveryMessageBloc>(context, listen: false).add(
                    LoadDiscoveryMessage(
                        chatId: report.chatId!, matchedUser: reportedUser));
                Navigator.pushNamed(context, DiscoveryMessagesScreen.routeName,
                    arguments: null);
              },
              child: Text('View reported chat')),
        ],
      ),
    );
  }
}

class WaveReportTile extends StatelessWidget {
  final Report report;
  const WaveReportTile({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        //add padding

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WaveTile(
            poster: report.reportedUser!,
            wave: report.wave!,
          ),
          //text to say who it was reported by
          Text(
              'Reported by: ${report.reporterUser!.name}, aka: ${report.reporterUser!.handle} ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),

          //text to display the reason

          //text saying available actions
          Text('Available actions: ',
              style: //headline 2
                  Theme.of(context).textTheme.headline2),
          //row of buttons. One says ignore, one says delete, one says ban reported, one says ban reporter
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //ignore button
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AdminBloc>(context)
                            .add(IgnoreReport(report: report));
                      },
                      child: Text('Ignore Report')),
                  //delete button
                  ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AdminBloc>(context)
                            .add(DeleteWave(report: report));
                      },
                      child: Text('Delete Wave')),
                  //ban reported button
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //ban reported button
                  ElevatedButton(
                      onPressed: () {
                        // context
                        //     .read<AdminBloc>()
                        //     .add(BanReported(
                        //         report: report));
                      },
                      child: Text('Ban reporter')),
                  //ban reporter button
                  ElevatedButton(
                      onPressed: () {
                        // context
                        //     .read<AdminBloc>()
                        //     .add(BanReporter(
                        //         report: report));
                      },
                      child: Text('Ban reported')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
