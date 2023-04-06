import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/widgets/app_bar_chats_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../blocs/chat/chat_bloc.dart';
import '../blocs/profile/profile_bloc.dart';
import '../models/models.dart';
import '../models/report_model.dart';

class TopAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final bool hasActions;
  final bool showReport;
  final bool implyLeading;
  final bool showDrawer;
  final bool showChats;

  const TopAppBar({
    Key? key,
    this.title,
    this.hasActions = true,
    this.showReport = false,
    this.implyLeading = true,
    this.showDrawer = false,
    this.showChats = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User user = profileState.user;
          return AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            automaticallyImplyLeading: implyLeading,
            leading: implyLeading
                ? //circular avatar of profile user
                (showDrawer)
                    ? InkWell(
                        onTap: () {
                          //open drawer
                          Scaffold.of(context).openDrawer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (user.finishedOnboarding)
                              ? //if user.newNotifications or user.newMessages is true, show a red dot
                              (user.newNotifications || user.newMessages)
                                  ? Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  user.imageUrls[0]),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : CircleAvatar(
                                      radius: 20,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user.imageUrls[0],
                                          fit: BoxFit.cover,
                                          memCacheHeight: 175,
                                          memCacheWidth: 175,
                                        ),
                                      ),
                                    )
                              : //icon showing a person
                              Icon(Icons.person,
                                  //primary color
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      )
                    :
                    //show back button
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.primary),
                      )
                : null,
            elevation: 0,
            title: Image(
              image: ResizeImage(
                AssetImage('assets/stingray_logo.png'),
                height: 200,
                width: 200,
              ),
              height: 50,
            ),
            actions: (showChats) ? [AppBarChatsButton()] : null,
          );
        }
        return Container();
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class ReportStingrayDialog extends StatefulWidget {
  final Stingray stingray;
  final User user;
  const ReportStingrayDialog({
    required this.stingray,
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  State<ReportStingrayDialog> createState() => _ReportStingrayDialogState();
}

class _ReportStingrayDialogState extends State<ReportStingrayDialog> {
  TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Report Stingray'),
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            Text(
                'If a Stingray has offensive or inappropriate content, please report it here. Our moderators will review the Stingray and take appropriate action.'),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Reason for reporting',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('Report', style: TextStyle(color: Colors.amber)),
          onPressed: () {
            if (_textController.text.isNotEmpty) {
              final Report report = Report(
                reason: _textController.text,
                type: 'stingray report',
                stingray: widget.stingray,
                reportId: Uuid().v4(),
                reporterUser: widget.user,
                reportTime: DateTime.now(),
              );
              FirestoreRepository.sendReport(report);
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Your report was empty')));
            }
          },
        ),
      ],
    );
  }
}
