import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/discovery_chat_pending/discovery_chat_pending_bloc.dart';
import 'package:hero/blocs/discovery_messages/discovery_message_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/models/discovery_chat_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/discovery/discovery_chats_screen.dart';
import 'package:hero/screens/home/home_screens/discovery/discovery_messages_screen.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DirectMessagePopupTextField extends StatefulWidget {
  final User user;
  final User voteTarget;
  final String imageurl;
  const DirectMessagePopupTextField({
    Key? key,
    required this.user,
    required this.voteTarget,
    this.imageurl = '',
  }) : super(key: key);

  @override
  State<DirectMessagePopupTextField> createState() =>
      _DirectMessagePopupTextFieldState();
}

class _DirectMessagePopupTextFieldState
    extends State<DirectMessagePopupTextField> {
  TextEditingController messageController = TextEditingController();
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
        controller: messageController,
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
                    String _chatId = Uuid().v4();
                    BlocProvider.of<DiscoveryChatPendingBloc>(context).add(
                        SendDirectMessage(
                            chatId: _chatId,
                            user: widget.user,
                            message: messageController.text,
                            matchedUser: widget.voteTarget,
                            imageUrl: widget.imageurl));
                    Navigator.of(context).pop();
                    Provider.of<DiscoveryMessageBloc>(context, listen: false)
                        .add(LoadDiscoveryMessage(
                            chatId: _chatId, matchedUser: widget.voteTarget));

                            

                    Navigator.pushNamed(
                      context,
                      DiscoveryChatsScreen.routeName,
                    );
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
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .05,
    );
  }
}
