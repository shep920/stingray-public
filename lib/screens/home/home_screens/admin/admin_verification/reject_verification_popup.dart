import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/admin-verification/admin_verification_bloc.dart';
import 'package:hero/blocs/discovery_messages/discovery_message_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/blocs/user%20discovery%20swiping/user_discovery_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/discovery_message_document_model.dart';
import 'package:hero/models/discovery_message_model.dart';
import 'package:hero/models/user-verification/user_verification_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/models/user_notifications/user_notification_model.dart';
import 'package:hero/models/user_notifications/user_notification_type.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/discovery/discovery_chats_screen.dart';
import 'package:hero/screens/home/home_screens/discovery/discovery_messages_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_test/flutter_test.dart';

class RejectVerificationPopup extends StatelessWidget {
  const RejectVerificationPopup({
    Key? key,
    required this.voteTarget,
    required this.userVerification,
  }) : super(key: key);

  final User voteTarget;
  final UserVerification userVerification;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Reject ${voteTarget.name}?",
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Theme.of(context).colorScheme.primary)),
            RejectVerificationPopupTextField(
              voteTarget: voteTarget,
              userVerification: userVerification,
            ),
          ],
        ),
      ),
    );
  }
}

class RejectVerificationPopupTextField extends StatefulWidget {
  final User voteTarget;
  final UserVerification userVerification;
  const RejectVerificationPopupTextField({
    Key? key,
    required this.voteTarget,
    required this.userVerification,
  }) : super(key: key);

  @override
  State<RejectVerificationPopupTextField> createState() =>
      _RejectVerificationPopupTextFieldState();
}

class _RejectVerificationPopupTextFieldState
    extends State<RejectVerificationPopupTextField> {
  TextEditingController rejectController = TextEditingController();
  bool hasText = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(500),
        ],
        textInputAction: TextInputAction.send,
        maxLines: null,
        expands: true,
        textCapitalization: TextCapitalization.sentences,
        controller: rejectController,
        onChanged: (value) {
          setState(() {
            hasText = value.isNotEmpty;
          });
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.send),
            onPressed: (hasText)
                ? () {
                    rejectUser(context, widget.userVerification);
                  }
                : null,
          ),
          suffixIconColor: (hasText) ? Colors.grey : ExtraColors.highlightColor,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .05,
    );
  }

  void rejectUser(BuildContext context, UserVerification _userVerification) {
    BlocProvider.of<AdminVerificationBloc>(context).add(
      RejectVerification(
        verification: _userVerification,
        reason: rejectController.text,
      ),
    );

    Navigator.pop(context);
  }
}
