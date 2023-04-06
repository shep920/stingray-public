import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/message/message_bloc.dart';
import 'package:hero/widgets/custom_comment_like_button.dart';
import 'package:intl/intl.dart';

import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/cubits/comment/comment_cubit.dart';
import 'package:hero/models/models.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../blocs/comment/comment_bloc.dart';
import '../../../../blocs/profile/profile_bloc.dart';
import '../../../../blocs/vote/vote_bloc.dart';
import '../../../../repository/firestore_repository.dart';

class CommentsScreen extends StatelessWidget {
  static const String routeName = '/comments';

  CommentsScreen({Key? key}) : super(key: key);
  // final activeMatches = UserMatch.matches
  //     .where((match) => match.userId == 1 && match.chat.isNotEmpty)
  //     .toList();

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => CommentsScreen(),
      settings: RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopAppBar(
          title: 'comments',
          hasActions: false,
        ),
        body: BlocBuilder<StingrayBloc, StingrayState>(
          builder: (context, state) {
            if (state is StingrayLoading) {
              return CircularProgressIndicator();
            }
            if (state is StingrayLoaded) {
              return BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) {
                if (profileState is ProfileLoaded) {
                  User user = profileState.user;
                  return BlocBuilder<CommentBloc, CommentBlocState>(
                      builder: (context, commentState) {
                    if (commentState is CommentLoaded) {
                      final comments = commentState.comments as List<Comment>;
                      final Stingray? stingray = state.stingrays
                          .where((element) =>
                              element!.id == commentState.chat.stingrayId)
                          .first;

                      return WillPopScope(
                        onWillPop: () async {
                          Provider.of<CommentBloc>(context, listen: false)
                              .add(CloseComment(userId: user.id!));
                          return true;
                        },
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: comments.length,
                              itemBuilder:
                                  (BuildContext context, int nestedIndex) {
                                Comment? comment = comments[nestedIndex];
                                return Card(
                                  elevation: 0,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: 
                                            CachedNetworkImageProvider(
                                                comment.posterImageUrl)
                                            
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RichText(
                                            text: TextSpan(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3,
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${comment.posterName}\n',
                                                ),
                                                TextSpan(
                                                  text: '${comment.message}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      CustomCommentLikeButton(
                                        comment: comment,
                                        user: user,
                                        stingray: stingray,
                                        liked: (commentState.commentIdsLiked
                                                .contains(comment.id))
                                            ? true
                                            : false,
                                      ),
                                      // LikeButton(
                                      //   size: 40,
                                      //   likeCount: comment.likes,
                                      //   isLiked: (comment.userIdsWhoLiked
                                      //           .contains(user.id))
                                      //       ? true
                                      //       : false,
                                      //   onTap: (isLiked) async {
                                      //     FirestoreRepository()
                                      //         .updateStingrayCommentLikeCount(
                                      //             commentState
                                      //                 .comments[nestedIndex],
                                      //             stingray?.id,
                                      //             comments,
                                      //             nestedIndex,
                                      //             user.id!,
                                      //             commentState.message);
                                      //     return !isLiked;
                                      //   },
                                      // ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                );
                              },
                            )),
                            CommentForm(
                                stingray: stingray,
                                user: profileState.user,
                                message: commentState.message,
                                chatId: commentState.chat.chatId,
                                commentCount: comments.length + 1),
                          ],
                        ),
                      );
                    }
                    if (commentState is CommentLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Text('error');
                  });
                }
                if (profileState is ProfileLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Text('error');
              });
            }
            return Text('error');
          },
        ));
  }
}

class CommentForm extends StatefulWidget {
  final Message message;
  final Stingray? stingray;
  final User user;
  final String? chatId;
  final int commentCount;

  CommentForm(
      {Key? key,
      required this.user,
      required this.commentCount,
      required this.stingray,
      required this.message,
      required this.chatId})
      : super(key: key);

  @override
  State<CommentForm> createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: UserImagesSmall(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .2,
              imageUrl: widget.user.imageUrls[0]),
        ),
        SizedBox(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.8, vertical: 0),
            child: TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                textInputAction: TextInputAction.send,
                controller: commentController,
                scrollPadding: EdgeInsets.all(0),
                expands: true,
                maxLines: null,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add a comment...',
                    contentPadding: EdgeInsets.all(5.0)),
                onSubmitted: (String text) {
                  FirestoreRepository().updateStingrayComment(
                      _generateComment(
                        widget.user,
                        widget.stingray,
                        commentController.text,
                      ),
                      widget.stingray!.id,
                      widget.message.id,
                      widget.chatId!);
                  Provider.of<MessageBloc>(context, listen: false).add(
                      UpdateCommentCount(
                          stingrayId: widget.stingray!.id!,
                          message: widget.message,
                          commentCount: widget.commentCount));
                  commentController.clear();
                }),
          ),
          width: MediaQuery.of(context).size.width * .7,
          height: MediaQuery.of(context).size.height * .08,
        ),
        Container(
          child: IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              print(context.read<CommentCubit>().state.comment);

              FirestoreRepository().updateStingrayComment(
                  Comment.generateComment(
                    widget.user,
                    widget.stingray,
                    commentController.text,
                  ),
                  widget.stingray!.id,
                  widget.message.id,
                  widget.chatId!);
              Provider.of<MessageBloc>(context, listen: false).add(
                  UpdateCommentCount(
                      stingrayId: widget.stingray!.id!,
                      message: widget.message,
                      commentCount: widget.commentCount));
              commentController.clear();
            },
          ),
          width: MediaQuery.of(context).size.width * .1,
          height: MediaQuery.of(context).size.height * .08,
        )
      ],
    );
  }
}

Comment? _generateComment(User user, Stingray? stingray, String comment) {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  return Comment(
    message: comment,
    dateTime: now,
    senderId: user.id,
    likes: 0,
    timeString: formattedDate,
    id: Uuid().v4(),
    posterName: user.name,
    posterImageUrl: user.imageUrls[0],
    userIdsWhoLiked: [],
  );
}

class CommentBox extends StatelessWidget {
  final Comment? comment;
  final Stingray? stingray;
  final User user;

  CommentBox(
      {Key? key,
      required this.user,
      required this.stingray,
      required this.comment})
      : super(key: key);

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: UserImagesSmall(
              height: MediaQuery.of(context).size.height * .05,
              width: MediaQuery.of(context).size.width * .1,
              imageUrl: user.imageUrls[0]),
        ),
        Container(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.8, vertical: 0),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '${comment!.posterName}:'),
                    TextSpan(
                        text: ' ${comment!.message}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
          width: MediaQuery.of(context).size.width * .7,
          height: MediaQuery.of(context).size.height * .08,
        ),
        Container(
          child: IconButton(
            icon: Icon(Icons.heart_broken),
            onPressed: () {
              print('bruh');
            },
          ),
          width: MediaQuery.of(context).size.width * .1,
          height: MediaQuery.of(context).size.height * .08,
        )
      ],
    );
  }
}

class CommentRouteObject {
  Message message;
  int stingrayIndex;
  String? chatId;
  CommentRouteObject({
    required this.message,
    required this.stingrayIndex,
    required this.chatId,
  });
}
