import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/discovery_messages/discovery_message_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user%20discovery%20swiping/user_discovery_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/discovery_message_document_model.dart';
import 'package:hero/models/discovery_message_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/models/user_notifications/user_notification_model.dart';
import 'package:hero/models/user_notifications/user_notification_type.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/direct_message/direct_message_textfield.dart';
import 'package:hero/screens/home/home_screens/discovery/discovery_chats_screen.dart';
import 'package:hero/screens/home/home_screens/discovery/discovery_messages_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DirectMessagePopup extends StatefulWidget {
  const DirectMessagePopup({
    Key? key,
    required this.voteTarget,
    this.secret = false,
  }) : super(key: key);

  final User voteTarget;
  final bool secret;

  @override
  State<DirectMessagePopup> createState() => _DirectMessagePopupState();
}

class _DirectMessagePopupState extends State<DirectMessagePopup> {
  bool visible = false;

  initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User user =
        (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        color: Theme.of(context).scaffoldBackgroundColor,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.secret)
                  AnimatedOpacity(
                    opacity: (visible) ? .75 : 0,
                    duration: Duration(milliseconds: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'This DM will be sent secretly',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Flexible(
                          child: IconButton(
                            onPressed: () {
                              explainSecretMessage(context).show();
                            },
                            icon: Icon(Icons.help),
                          ),
                        ),
                      ],
                    ),
                  ),
                Flexible(
                  child: Text(
                      (!widget.secret)
                          ? "Send a dm to ${widget.voteTarget.name}?"
                          : 'Send a DM?',
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
                DirectMessagePopupTextField(
                    voteTarget: widget.voteTarget, user: user),
                Flexible(
                  child: Text('Votes remaining: ${user.dailyDmsRemaining}',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

AwesomeDialog explainSecretMessage(BuildContext context) {
  return AwesomeDialog(
    titleTextStyle: Theme.of(context).textTheme.headline2,
    descTextStyle: Theme.of(context).textTheme.headline5,
    context: context,
    dialogType: DialogType.info,
    borderSide: const BorderSide(
      color: Colors.green,
      width: 2,
    ),
    width: 680,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(2),
    ),
    dismissOnTouchOutside: true,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: 'Secret DM',
    desc:
        'When you send this, both you an the receiver will be secret. You can reveal yourself at any time during the chat.',
    showCloseIcon: true,
    btnOkOnPress: () {},
  );
}
