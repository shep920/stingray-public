import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hero/blocs/leaderboad/leaderboard_bloc.dart';
import 'package:hero/models/backpack_item_model.dart';
import 'package:hero/models/discovery_message_document_model.dart';
import 'package:hero/models/discovery_message_model.dart';
import 'package:hero/models/models.dart';
import 'package:hero/models/posts/yip_yap_model.dart';
import 'package:hero/models/prize_model.dart';
import 'package:hero/models/stingrays/stingray_stats_doc_model.dart';
import 'package:hero/models/stories/story_model.dart';
import 'package:hero/models/user-verification/user_verification_model.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:uuid/uuid.dart';

import '../models/discovery_chat_model.dart';
import '../models/leaderboard_model.dart';
import '../models/messages_with_block.dart';
import '../models/user_notifications/user_notification_model.dart';
import '../models/report_model.dart';
import '../models/posts/wave_model.dart';

class FirestoreRepository {
  final String? id;
  final String? stingrayId;
  final String? voteId;
  final bool testing;

  late CollectionReference userCollection;
  late CollectionReference stingrayCollection;
  late CollectionReference discoveryChatCollection;
  late CollectionReference userVerificationCollection;
  late CollectionReference discoveryChatsCollection;
  late CollectionReference reportsColllection;
  late CollectionReference waveCollection;
  late CollectionReference seenVideoIdsCollection;
  late CollectionReference stingrayLeaderboardCollection;
  late CollectionReference prizeCollection;
  late CollectionReference backpackItemsCollection;
  late CollectionReference stupidTimeCollection;

  FirestoreRepository(
      {this.id, this.stingrayId, this.voteId, this.testing = false}) {
    if (testing) {
      FakeFirebaseFirestore fakeFirestore = FakeFirebaseFirestore();
      userCollection = fakeFirestore.collection('users');
      stingrayCollection = fakeFirestore.collection('stingrays');
      discoveryChatCollection = fakeFirestore.collection('discoveryChats');
      userVerificationCollection = fakeFirestore.collection('userVerification');
      discoveryChatsCollection = fakeFirestore.collection('discoveryChats');
      reportsColllection = fakeFirestore.collection('reports');
      waveCollection = fakeFirestore.collection('waves');
      seenVideoIdsCollection = fakeFirestore.collection('seenVideoIds');
      stingrayLeaderboardCollection =
          fakeFirestore.collection('stingrayLeaderboard');
      prizeCollection = fakeFirestore.collection('prizes');
      backpackItemsCollection = fakeFirestore.collection('backpackItems');
      stupidTimeCollection = fakeFirestore.collection('stupidTime');
    } else {
      userCollection = FirebaseFirestore.instance.collection('users');
      stingrayCollection = FirebaseFirestore.instance.collection('stingrays');
      discoveryChatCollection =
          FirebaseFirestore.instance.collection('discoveryChats');
      userVerificationCollection =
          FirebaseFirestore.instance.collection('userVerification');
      discoveryChatsCollection =
          FirebaseFirestore.instance.collection('discoveryChats');
      reportsColllection = FirebaseFirestore.instance.collection('reports');
      waveCollection = FirebaseFirestore.instance.collection('waves');
      seenVideoIdsCollection =
          FirebaseFirestore.instance.collection('seenVideoIds');
      stingrayLeaderboardCollection =
          FirebaseFirestore.instance.collection('stingrayLeaderboard');
      prizeCollection = FirebaseFirestore.instance.collection('prizes');
      backpackItemsCollection =
          FirebaseFirestore.instance.collection('backpackItems');
      stupidTimeCollection =
          FirebaseFirestore.instance.collection('stupidTime');
    }
  }

  Future updateUserData({
    required User user,
  }) async {
    return await userCollection.doc(user.id!).set(
          User.toJson(user),
        );
  }

  Stream<List<User?>> get differentUsers {
    return userCollection
        .where('stingrays', whereNotIn: [stingrayId])
        .snapshots()
        .map<List<User?>>((query) => User.userListFromSnapshot(query));
  }

  Stream<List<Report?>> get reports {
    return reportsColllection
        .limit(10)
        .snapshots()
        .map<List<Report?>>((query) => Report.reportListFromSnapshot(query));
  }

  Stream<List<List<ChatViewers?>>> get chatViewers {
    return FirebaseFirestore.instance
        .collection('viewers')
        .snapshots()
        .map((doc) => ChatViewers.chatViewersListFromQuerySnapshot(doc));
  }

  Stream<User> getUser(String? userId) {
    print('Getting user images from DB');
    return userCollection
        .doc(userId)
        .snapshots()
        .map((doc) => User.fromSnapshot(doc));
  }

  Stream<List<Prize>> get prizes {
    return prizeCollection
        .snapshots()
        .map((query) => Prize.prizeListFromQuerySnapshot(query));
  }

  Stream<UserVerification> getUserVerification(String? userId) {
    return userVerificationCollection
        .doc(userId)
        .snapshots()
        .map((doc) => UserVerification.fromDocSnapshot(doc.data()));
  }

  Stream<List<UserVerification>> getAdminVerification() {
    return userVerificationCollection
        .where('verificationStatus', isEqualTo: UserVerification.pending)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        //for each doc in the query snapshot, return a userVerification object
        .map((query) => query.docs
            .map((doc) => UserVerification.fromDocSnapshot(doc.data()))
            .toList());

    // .map((doc) => UserVerification.fromDocSnapshot(doc.data()));
  }

  //a functioin called verificationExists that takes a userId and returns a future bool
  Future<bool> verificationExists(String? userId) async {
    final userDoc = await userVerificationCollection.doc(userId).get();
    if (userDoc.exists) {
      return true;
    } else {
      final _verification = UserVerification.genericVerification(userId!);

      await userVerificationCollection
          .doc(userId)
          .set(UserVerification.toJson(_verification));

      return true;
    }
  }

  Future<User> getFutureUser(String? userId) async {
    final userDoc = await userCollection.doc(userId).get();
    return User.fromSnapshot(userDoc);
  }

  static Future<User> getStaticFutureUser(String? userId) async {
    print('Getting user images from DB');
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return User.fromSnapshot(userDoc);
  }

  Future<List<dynamic>> getSeenIds(String? userId) async {
    print('Getting ids from DB');
    final userDoc = await FirebaseFirestore.instance
        .collection('discoveriesSeen')
        .doc(userId)
        .get();
    final List<dynamic> seenIds = [];
    if (userDoc.exists && userDoc['seen'] != null) {
      seenIds.addAll(userDoc['seen']);
    }
    return seenIds;
  }

  //write a function to get a wave using a waveId
  Future<Wave?> getWave(String? waveId) async {
    final waveDoc = await waveCollection.doc(waveId).get();

    if (waveDoc.exists) {
      Map<String, dynamic>? _map;
      _map = waveDoc.data() as Map<String, dynamic>?;
      return Wave.waveFromMap(_map);
    } else {
      return null;
    }
  }

  static Future<Wave?> getStaticWave(String? waveId) async {
    print('Getting wave from DB');
    final waveDoc =
        await FirebaseFirestore.instance.collection('waves').doc(waveId).get();

    if (waveDoc.exists) {
      return Wave.waveFromMap(waveDoc.data() as Map);
    } else {
      return null;
    }
  }

  //a function called getNotifications that takes a userId and returns a future list of nullable Notification objects
  Future<List<UserNotification?>> getNotifications(String? userId) async {
    print('Getting notifications from DB');
    final notificationsDoc = await FirebaseFirestore.instance
        .collection('userNotifications')
        .doc(userId)
        .get();

    if (notificationsDoc.exists) {
      return UserNotification.notificationListFromMap(
          notificationsDoc['userNotifications']);
    } else {
      return [];
    }
  }

  Stream<List<UserLiked?>> getLikes(String? stingrayId) {
    print('Getting user images from DB');
    return FirebaseFirestore.instance
        .collection('stingrayLikes')
        .doc(stingrayId)
        .snapshots()
        .map(
          (doc) => UserLiked.userLikedListFromDynamic(doc['likes']),
        );
  }

  Stream<List<List<UserLiked?>>> getLikesQuery() {
    print('Getting user images from DB');
    return FirebaseFirestore.instance
        .collection('stingrayLikes')
        .snapshots()
        .map(
          (query) => UserLiked.userLikedListFromQuerySnapshot(query),
        );
  }

  Stream<List<LeaderboardUser?>> getLeaderboard() {
    print('Getting user images from DB');
    return FirebaseFirestore.instance
        .collection('leaderboard')
        .doc('leaderboard')
        .snapshots()
        .map((doc) =>
            LeaderboardUser.leaderboardUserListFromMap(doc['leaderboard']));
  }

  Stream<List<User?>> getUserHandle(String? handle) {
    print('Getting user images from DB');
    return userCollection
        .where('handle', isEqualTo: handle)
        .snapshots()
        .map((query) => User.userListFromSnapshot(query));
  }

  Future<bool> userExists(String handle) async {
    bool exist = (await userCollection.where("handle", isEqualTo: handle).get())
        .docs
        .isEmpty;

    return exist;
  }

  Future<QuerySnapshot> getWaveReplies(DocumentSnapshot? doc, String? waveId,
      List<dynamic> blockerUserIds) async {
    print('Getting wave replies from DB');
    Query<Map<String, dynamic>> initial;
    QuerySnapshot query;
    if (doc == null) {
      initial = FirebaseFirestore.instance
          .collection('waves')
          .where('replyTo', isEqualTo: waveId);
      initial = initial.orderBy('createdAt', descending: true);
      initial = initial.limit(5);
      query = await initial.get();
    } else {
      initial = FirebaseFirestore.instance
          .collection('waves')
          .where('replyTo', isEqualTo: waveId);

      initial = initial.orderBy('createdAt', descending: true);
      initial = initial.startAfterDocument(doc);
      initial = initial.limit(5);
      query = await initial.get();
    }

    return query;
  }

  Future<QuerySnapshot> getThreadWaves(
    Wave wave,
  ) async {
    print('Getting wave replies from DB');
    Query<Map<String, dynamic>> initial;
    QuerySnapshot query;

    initial = FirebaseFirestore.instance
        .collection('waves')
        .where('threadId', isEqualTo: wave.threadId);
    initial = initial.where('id', isNotEqualTo: wave.id);

    initial = initial.limit(10);
    query = await initial.get();

    return query;
  }

  Stream<List<Stingray?>> stingrays(List<dynamic> blockedHandles) {
    return (blockedHandles.isEmpty)
        ? stingrayCollection
            .snapshots()
            .map<List<Stingray?>>(_stingrayListFromSnapshot)
        : stingrayCollection
            .where('handle', whereNotIn: blockedHandles)
            .snapshots()
            .map<List<Stingray?>>(_stingrayListFromSnapshot);
  }

  Stream<List<List<Chat?>>> get chats {
    return FirebaseFirestore.instance
        .collection('stingrayChats')
        .snapshots()
        .map<List<List<Chat?>>>(
            (query) => Chat.chatListListFromSnapshot(query));
  }

  Stream<List<DiscoveryChat?>> discoveryChats(String uid) {
    return FirebaseFirestore.instance
        .collection('discoveryChats')
        .doc(uid)
        .snapshots()
        .map<List<DiscoveryChat?>>(
            (doc) => DiscoveryChat.chatListFromSnapshot(doc));
  }

  Stream<MessagesWithBlock> messages(String chatId) {
    return FirebaseFirestore.instance
        .collection('stingrayMessages')
        .doc(chatId)
        .snapshots()
        .map<MessagesWithBlock>((doc) => MessagesWithBlock.fromSnapshot(doc));
    // (doc) => Message.messageListFromMap(doc['messages']));
  }

  Stream<DiscoveryMessageDocument> discoveryMessages(String chatId) {
    return FirebaseFirestore.instance
        .collection('discoveryMessages')
        .doc(chatId)
        .snapshots()
        .map<DiscoveryMessageDocument>(
            (doc) => DiscoveryMessageDocument.fromSnapshot(doc));
    // (doc) => Message.messageListFromMap(doc['messages']));
  }

  Stream<List<Comment?>> comments(String? messageId) {
    return FirebaseFirestore.instance
        .collection('stingrayMessageComments')
        .doc(messageId)
        .snapshots()
        .map<List<Comment?>>(
            (doc) => Comment.commentListFromMap(doc['comments']));
  }

  // List<Message?> messageListFromDoc(DocumentSnapshot doc){
  //   return
  // }

  List<Stingray?> _stingrayListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map<Stingray?>((doc) {
      return Stingray.stingrayFromSnapshot(doc);
    }).toList();
  }

  Future updateStingrayData(
    String? id,
    String name,
    int age,
    String bio,
    List<dynamic> imageUrls,
    List<dynamic> interests,
    String jobTitle,
    bool isStingray,
    Team? team,
    String? email,
    List<User?> likes,
    List<dynamic> dislikes,
    String gender,
    List<dynamic> comments,
    List<dynamic> messages,
    List<dynamic> chats,
  ) async {
    return await FirebaseFirestore.instance
        .collection('stingrays')
        .doc(id)
        .set({
      'id': id,
      'name': name,
      'age': age,
      'imageUrls': imageUrls,
      'interests': interests,
      'bio': bio,
      'jobTitle': jobTitle,
      'isStingray': isStingray,
      'email': email,
      'team': team,
      'likes': likes,
      'dislikes': dislikes,
      'gender': gender,
      'comments': comments,
      'messages': messages,
      'chats': chats
    });
  }

  Future<void> addStingray(
    Stingray stingray,
  ) async {
    userCollection.doc(stingray.id).update({'isStingray': true});
    stingrayCollection
        .doc(stingray.id)
        .set(Stingray.toJson(stingray))
        .then((value) => print("Stingray added"))
        .catchError((error) => print("Failed to update stingray: $error"));
  }

  //future Stingray getStingray that takes in a string
  //returns a Stingray object
  Future<Stingray?> getStingray(String id) async {
    DocumentSnapshot doc = await stingrayCollection.doc(id).get();
    if (doc.exists) {
      return Stingray.stingrayFromSnapshot(doc);
    } else {
      return null;
    }
  }

  Future deleteViewer(
    String id,
  ) async {
    var collection = FirebaseFirestore.instance.collection('users');

    return await FirebaseFirestore.instance
        .collection('viewers')
        .doc(id)
        .delete()
        .then((value) => print("Stingray deleted"))
        .catchError((error) => print("Failed to update stingray: $error"));
  }

  Future deleteStingray(
    User user,
  ) async {
    userCollection.doc(user.id).update({'isStingray': false});

    return stingrayCollection
        .doc(user.id)
        .delete()
        .then((value) => print("Stingray deleted"))
        .catchError((error) => print("Failed to update stingray: $error"));
  }

  List<UserLiked?> _userFromMap(List<dynamic> mappedUsers) {
    List<UserLiked?> userList = [];
    for (Map<String, dynamic> user in mappedUsers) {
      userList.add(UserLiked(
        chatId: user['chatId'],
        name: user['name'],
        imageUrl: user['imageUrl'],
        userMatchId: user['userMatchedId'],
        docExists: user['docExists'],
        stingrayImageUrl: user['stingrayImageUrl'],
        stingrayId: user['stingrayId'],
      ));
    }
    return userList;
  }

  Future<void> updateDiscoveryLikes(User user, User discoveryUser) async {
    return userCollection
        .doc(user.id)
        .update({
          'discoverLikes': FieldValue.arrayUnion([discoveryUser.id]),
        })
        .then((value) => print("User Updated"))
        .catchError((error) {
          print("Failed to update user: $error");
        });
  }

  Future<void> updateStingrayLikes(String? id, User? user,
      String stingrayImageUrl, String stingrayId) async {
    return FirebaseFirestore.instance
        .collection('stingrayLikes')
        .doc(id)
        .update({
          'likes': FieldValue.arrayUnion(
              [UserLiked.toJson(user, stingrayImageUrl, stingrayId)])
        })
        .then((value) => print("User Updated"))
        .catchError((error) {
          if (error.code == 'not-found') {
            return FirebaseFirestore.instance
                .collection('stingrayLikes')
                .doc(id)
                .set({
              'likes': FieldValue.arrayUnion(
                  [UserLiked.toJson(user, stingrayImageUrl, stingrayId)])
            });
          }
        });
  }

  Future<void> updateUserStinrayArray(
      String? userId, List<dynamic> stingrays) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'stingrays': stingrays})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateSeenTutorial(
    String? userId,
  ) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'seenTutorial': true})
        .then((value) => print("tutorial Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> removeStingrayLikes(
      Stingray? stingray, String chatId, List<UserLiked?> oldLikes) async {
    List<UserLiked?> likes = oldLikes;
    likes.removeWhere((element) => element!.chatId == chatId);

    return FirebaseFirestore.instance
        .collection('stingrayLikes')
        .doc(stingray!.id)
        .set({'likes': UserLiked.likesListToJson(likes)},
            SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateBio(User? user, String bio) {
    if (user!.isStingray) {
      userCollection
          .doc(user.id)
          .update({'bio': bio})
          .then((value) => print("Bio Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      return FirebaseFirestore.instance
          .collection('stingrays')
          .doc(user.id)
          .update({'bio': bio})
          .then((value) => print("Bio Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'bio': bio})
          .then((value) => print("Bio Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<void> updateDiscoveriesUsable(User? user) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.id)
        .update({'discoveriesRemaning': user.discoveriesRemaning - 1})
        .then((value) => print("Bio Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updatedailyDmsRemaining(User? user) {
    return userCollection
        .doc(user!.id)
        .update({
          'dailyDmsRemaining': FieldValue.increment(-1),
          'dmsSent': FieldValue.increment(1)
        })
        .then((value) => print("daily dms Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //a function that takes a wave and uploads it to the database
  Future<void> uploadWave(Wave? wave) async {
    return waveCollection
        .doc(wave!.id)
        .set(Wave.toJson(wave))
        .then((value) => print("Wave Added"))
        .catchError((error) => print("Failed to add wave: $error"));
  }

  Future<void> incrementWaveReplies(String waveId) async {
    //increment popularity of wave by a timestamp value of 10 minutes

    return await waveCollection
        .doc(waveId)
        //increment the field comments by 1
        .update({
          'comments': FieldValue.increment(1),
          'popularity': FieldValue.increment(600)
        })
        .then((value) => print("Wave Added"))
        .catchError((error) => print("Failed to add wave: $error"));
  }

  Future<void> updateNamefromProfile(User? user, String name) {
    if (user!.isStingray) {
      userCollection
          .doc(user.id)
          .update({'name': name})
          .then((value) => print("Bio Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      return FirebaseFirestore.instance
          .collection('stingrays')
          .doc(user.id)
          .update({'name': name})
          .then((value) => print("Bio Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'name': name})
          .then((value) => print("Bio Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<void> updateWantsToTalk(User? user, bool wantsToTalk) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.id)
        .update({'wantsToTalk': wantsToTalk})
        .then((value) => print("wantsToTalk Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateGoals(User? user, List<dynamic> goals) {
    if (user!.isStingray) {
      userCollection
          .doc(user.id)
          .update({'goals': goals})
          .then((value) => print("goals Updated"))
          .catchError((error) => print("Failed to update user: $error"));
      return FirebaseFirestore.instance
          .collection('stingrays')
          .doc(user.id)
          .update({'goals': goals})
          .then((value) => print("goals Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'goals': goals})
          .then((value) => print("Goals Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<void> updateAge(String? id, int age) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'age': age})
        .then((value) => print("Age Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateDeviceToken(String? id, String? token) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({
          'token': token,
          'seenWaveLikeNotification': true,
          'seenVoteNotification': true
        })
        .then((value) => print("Token Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateGender(String? id, String gender) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'gender': gender})
        .then((value) => print("Gender Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateInterest(String? id, String interest) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({
          'interests': FieldValue.arrayUnion([interest])
        })
        .then((value) => print("Bio Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Object? voteEvent(String? voteId, int votesUsable) {
    try {
      if (votesUsable < 1) {
        throw Exception('You have no votes left!');
      }
      userCollection.doc(id).update(
          {'votesUsable': FieldValue.increment(-1), 'castFirstVote': true});
      userCollection.doc(voteId).update({'votes': FieldValue.increment(1)});
      return null;
    } catch (e) {
      print(e);
      return e;
    }
  }

  //future void updateSentFirstSeaReal(id: event.sender.id!). It updates the value of sentFirstSeaReal to true
  Future<void> updateSentFirstSeaReal(String userId) {
    return userCollection.doc(userId).update({'sentFirstSeaReal': true});
  }

  //future void that takes in a user who votes and a user who is voted on, then update the voteListener
  Future<void> updateVoteListener(User user, User votedOn) {
    return FirebaseFirestore.instance
        .collection('listeners')
        .doc('voteListener')
        .set({
          'receiverId': votedOn.id,
          'voterName': user.name,
        })
        .then((value) => print("Vote Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateVerificationListener(String userId) {
    return FirebaseFirestore.instance
        .collection('listeners')
        .doc('verification')
        .set({
          'receiverId': userId,
        })
        .then((value) => print("Vote Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateWaveLikeListener(String waveId) {
    return FirebaseFirestore.instance
        .collection('listeners')
        .doc('waveLikeListener')
        .set({
          'waveId': waveId,
        })
        .then((value) => print("Vote Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateWaveReplyListener(
      User user, Wave wave, String receiverId) {
    return FirebaseFirestore.instance
        .collection('listeners')
        .doc('waveReplyListener')
        .set({
          'receiverId': receiverId,
          'replyerName':
              (wave.type == Wave.default_type) ? user.name : "A minnow",
          'replyerId': user.id,
          'senderId': wave.senderId,
          'message': wave.message,
          'waveId': wave.id,
          'createdAt': wave.createdAt,
          'likes': wave.likes,
          'comments': wave.comments,
          'imageUrl': wave.imageUrl,
          'typesenseId': wave.typesenseId,
        })
        .then((value) => print("Vote Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateMentionListener(
      Wave wave, String receiverId, User sender) {
    String _senderName =
        (wave.type == Wave.default_type) ? sender.name : "A minnow";
    return FirebaseFirestore.instance
        .collection('listeners')
        .doc('mention')
        .set({
          'waveId': wave.id,
          'receiverId': receiverId,
          'senderId': sender.id,
          'senderName': _senderName,
          'message': wave.message,
        })
        .then((value) => print("Vote Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateUserPictures(
    User user,
    String imageName,
  ) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);

    return userCollection.doc(user.id).update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl])
    });
  }

  Future<void> updateStingrayPictures(User user, String imageName) async {
    String downloadUrl =
        await StorageRepository().getDownloadURL(user, imageName);

    return FirebaseFirestore.instance
        .collection('stingrays')
        .doc(user.id)
        .update({
      'imageUrls': FieldValue.arrayUnion([downloadUrl])
    });
  }

  Future<void> deleterUserImagurl(User user, String imageUrl) async {
    if (user.isStingray) {
      FirebaseFirestore.instance.collection('stingrays').doc(user.id).update({
        'imageUrls': FieldValue.arrayRemove([imageUrl])
      });
    }

    return FirebaseFirestore.instance.collection('users').doc(user.id).update({
      'imageUrls': FieldValue.arrayRemove([imageUrl])
    });
  }

  //a method, sendUserNotification, that takes in a userId and a userNotification object, and stores in in the path userNotifications/userId
  static Future<void> sendUserNotification(
      String userId, UserNotification userNotification) async {
    return FirebaseFirestore.instance
        .collection('userNotifications')
        .doc(userId)
        .set({
      'userNotifications': [UserNotification.toJson(userNotification)]
    });
  }

  //function that takes a wave id and returns a nullable wave object

  static Future<void> initializeUserNotification(
      String userId, UserNotification userNotification) async {
    return FirebaseFirestore.instance
        .collection('userNotifications')
        .doc(userId)
        .set({
      'userNotifications': [UserNotification.toJson(userNotification)]
    });
  }

  //method to update the userNotification object with arrayunion
  static Future<void> updateUserNotification(
      String userId, UserNotification userNotification) async {
    return FirebaseFirestore.instance
        .collection('userNotifications')
        .doc(userId)
        .update({
          'userNotifications':
              FieldValue.arrayUnion([UserNotification.toJson(userNotification)])
        })
        .then((value) => print("User Notification Updated"))
        .catchError((error) {
          if (error is FirebaseException && error.code == 'not-found') {
            initializeUserNotification(userId, userNotification);
          }
        });
  }

  // a future void method that takes in a user id and sets with merge true the falue newMessage to true

  // a future void method that takes in a user id and bool and sets with merge true the falue newNotifications to the bool
  Future<void> setNewNotifications(String userId, bool value) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'newNotifications': value}, SetOptions(merge: true));
  }

  //set new messages
  Future<void> setNewMessages(String userId, bool value) async {
    return userCollection
        .doc(userId)
        .set({'newMessages': value}, SetOptions(merge: true));
  }

  Future<void> updateUserNonStaticNotification(
      String userId, UserNotification userNotification) async {
    return FirebaseFirestore.instance
        .collection('userNotifications')
        .doc(userId)
        .update({
          'userNotifications':
              FieldValue.arrayUnion([UserNotification.toJson(userNotification)])
        })
        .then((value) => print("User Notification Updated"))
        .catchError((error) {
          if (error is FirebaseException && error.code == 'not-found') {
            initializeUserNotification(userId, userNotification);
          }
        });
  }

  Future<void> updateListUserNotification(
      String userId, List<UserNotification> userNotification) async {
    return FirebaseFirestore.instance
        .collection('userNotifications')
        .doc(userId)
        .update({
      'userNotifications': FieldValue.arrayUnion(
          [UserNotification.notificationListToJson(userNotification)])
    });
  }

  //a future void method that sets the user's vale of newNotifications to true with a merge of true

  @override
  Future<void> removeUserImageUrl(
      User user, String imageName, int? index) async {
    String url = user.imageUrls[index!];

    return userCollection.doc(user.id).update({
      'imageUrls': FieldValue.arrayRemove([url])
    });
  }

  @override
  Future<void> deleteStingrayPictures(
      User user, String imageName, int? index) async {
    String url = user.imageUrls[index!];

    return FirebaseFirestore.instance
        .collection('stingrays')
        .doc(user.id)
        .update({
      'imageUrls': FieldValue.arrayRemove([url])
    });
  }

  @override
  Future<void> updateUser(User user) async {
    return userCollection.doc(user.id).update(User.toJson(user)).then(
          (value) => print('User document updated.'),
        );
  }

  Future<void> editUser(User user) async {
    userCollection.doc(user.id).update({
      'birthDate': user.birthDate,
      'name': user.name,
      'bio': user.bio,
      'imageUrls': user.imageUrls,
      'wantsToTalk': user.wantsToTalk,
      'gender': user.gender,
      'firstStudentOrg': user.firstStudentOrg,
      'secondStudentOrg': user.secondStudentOrg,
      'thirdStudentOrg': user.thirdStudentOrg,
      'firstUndergrad': user.firstUndergrad,
      'secondUndergrad': user.secondUndergrad,
      'thirdUndergrad': user.thirdUndergrad,
      'firstStudentOrgPosition': user.firstStudentOrgPosition,
      'secondStudentOrgPosition': user.secondStudentOrgPosition,
      'thirdStudentOrgPosition': user.thirdStudentOrgPosition,
      'postGrad': user.postGrad,
      'favoriteBar': user.favoriteBar,
      'favoriteSpot': user.favoriteSpot,
      'assosiatedDorm': user.assosiatedDorm,
      'worstDorm': user.worstDorm,
      'fraternity': user.fraternity,
      'fratPosition': user.fratPosition,
      'intramuralSport': user.intramuralSport,
      'twitterUrl': user.twitterUrl,
      'instagramUrl': user.instagramUrl,
      'snapchatUrl': user.snapchatUrl,
      'tiktokUrl': user.tiktokUrl,
      'tinderUrl': user.tinderUrl,
      'discordUrl': user.discordUrl,
      'finishedOnboarding': true,
      'isStingray': user.isStingray,
    });
    if (user.isStingray) {
      stingrayCollection.doc(user.id).update({
        'name': user.name,
        'bio': user.bio,
        'imageUrls': user.imageUrls,
        'wantsToTalk': user.wantsToTalk,
        'gender': user.gender,
        'firstStudentOrg': user.firstStudentOrg,
        'secondStudentOrg': user.secondStudentOrg,
        'thirdStudentOrg': user.thirdStudentOrg,
        'firstUndergrad': user.firstUndergrad,
        'secondUndergrad': user.secondUndergrad,
        'thirdUndergrad': user.thirdUndergrad,
        'firstStudentOrgPosition': user.firstStudentOrgPosition,
        'secondStudentOrgPosition': user.secondStudentOrgPosition,
        'thirdStudentOrgPosition': user.thirdStudentOrgPosition,
        'postGrad': user.postGrad,
        'favoriteBar': user.favoriteBar,
        'favoriteSpot': user.favoriteSpot,
        'assosiatedDorm': user.assosiatedDorm,
        'worstDorm': user.worstDorm,
        'fraternity': user.fraternity,
        'fratPosition': user.fratPosition,
        'intramuralSport': user.intramuralSport,
        'discordUrl': user.discordUrl,
        'twitterUrl': user.twitterUrl,
        'instagramUrl': user.instagramUrl,
        'snapchatUrl': user.snapchatUrl,
        'tiktokUrl': user.tiktokUrl,
        'tinderUrl': user.tinderUrl,
      }).then(
        (value) => print('User document updated.'),
      );
    }
  }

  Stream<List<User>> getUsers(
    String userId,
  ) {
    Query<Object?> query =
        userCollection.where('finishedOnboarding', isEqualTo: true).limit(10);

    Query<Object?> query2 = query.where('id', isNotEqualTo: userId);
    Query<Object?> query3 = query2.where('wantsToTalk', isEqualTo: true);

    return query3
        .where('stingrays', arrayContains: userId)
        .limit(10)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  Future<List<User>> getDiscoveryUsers(
    String userId,
  ) async {
    List<dynamic> ids = [
      '16m1SP25UQSoMDxRj9bhtbFmkfv2',
      '4ySuM3n76fVnugKUviIEghFPxO53'
    ];
    Query<Object?> query =
        userCollection.where('finishedOnboarding', isEqualTo: true).limit(10);

    Query<Object?> query2 = query.where('id', isNotEqualTo: userId);

    Query<Object?> query3 = query.where('id', whereNotIn: ids);

    var collection = await query3.get();
    //get the users list from query snapshot
    var users = collection.docs.map((doc) => User.fromSnapshot(doc)).toList();

    return users;
  }

  Stream<List<Stingray?>> getStingrays() {
    return FirebaseFirestore.instance
        .collection('stingrays')
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) => Stingray.stingrayFromSnapshot(doc))
          .toList();
    });
  }

  Future<void> updateOnboarding(String? id, List<String> stingrayIds) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'finishedOnboarding': true, 'stingrays': stingrayIds})
        .then((value) => print("Bio Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> finishOnboarding(List<String> stingrayIds, User user) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({
          'finishedOnboarding': true,
          'stingrays': stingrayIds,
          'name': user.name,
          'bio': user.bio,
          'gender': user.gender,
          'birthDate': user.birthDate,
          'imageUrls': user.imageUrls,
        })
        .then((value) => print("Bio Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateName(String? id, String name) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'name': name})
        .then((value) => print("Name Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateHandle(
      {required String id, required String handle, bool testing = false}) {
    return userCollection.doc(id).update({'handle': handle}).then((value) {
      print("Handle Updated");
    }).catchError((error) {
      print("Failed to update user: $error");
    });
  }

  // a future void method, updateBan, that takes a user updates the user's isBanned property to the opposite of what it was before
  Future<void> ban(User user, String? reason, DateTime? banExpiration) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({
          'isBanned': true,
          'banReason': reason,
          'banExpiration': banExpiration
        })
        .then((value) => print("Ban updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> unban(User user) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({'isBanned': false})
        .then((value) => print("Name Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> setPup(User user) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({'isPup': true})
        .then((value) => print("Pup Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> disablePup(User user) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({'isPup': false})
        .then((value) => print("Pup Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> addSecretDailyVote(User user) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update(
            {'votesUsable': user.votesUsable + 1, 'receivedSecretVote': true})
        .then((value) => print("Name Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> removeSecretDailyVote(User user) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update(
            {'votesUsable': user.votesUsable - 1, 'receivedSecretVote': true})
        .then((value) => print("Name Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateLeaderBoard(List<LeaderboardUser?> leaderboard) {
    return FirebaseFirestore.instance
        .collection('leaderboard')
        .doc('leaderboard')
        .update({'leaderboard': LeaderboardUser.leaderboardToJson(leaderboard)})
        .then((value) => print("Name Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updatebirthDate(String? id, DateTime birthDate) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'birthDate': birthDate})
        .then((value) => print("Name Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateStingrayComment(Comment? comment, String? stingrayid,
      String messageId, String chatId) async {
    return FirebaseFirestore.instance
        .collection('stingrayMessageComments')
        .doc(messageId)
        .set({
          'comments': FieldValue.arrayUnion([Comment.toJson(comment)]),
        }, SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> intializeDiscoveryMessages(
    DiscoveryMessageDocument messageDoc,
  ) async {
    return FirebaseFirestore.instance
        .collection('discoveryMessages')
        .doc(messageDoc.chatId)
        .set(DiscoveryMessageDocument.toJson(messageDoc),
            SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateWaveLikes(String? waveDocId, String userId) async {
    return waveCollection
        .doc(waveDocId)
        .update({
          'likes': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([userId]),
          'popularity': FieldValue.increment(100),
        })
        .then((value) => print("Wave likes Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateWaveDislikes(String? waveDocId, String userId) async {
    return FirebaseFirestore.instance
        .collection('waves')
        .doc(waveDocId)
        .update({
          'likes': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([userId]),
          'popularity': FieldValue.increment(-100),
        })
        .then((value) => print("Wave likes Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> dislikeWave(String? waveDocId, String userId) async {
    return waveCollection
        .doc(waveDocId)
        .update({
          'dislikes': FieldValue.increment(1),
          'dislikedBy': FieldValue.arrayUnion([userId]),
          'popularity': FieldValue.increment(-100),
        })
        .then((value) => print("Wave likes Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> removeWaveDislike(String? waveDocId, String userId) async {
    return waveCollection
        .doc(waveDocId)
        .update({
          'dislikes': FieldValue.increment(-1),
          'dislikedBy': FieldValue.arrayRemove([userId]),
          'popularity': FieldValue.increment(100),
        })
        .then((value) => print("Wave likes Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateStingrayMessage(
      Message? message, String? stingrayid) async {
    return FirebaseFirestore.instance
        .collection('stingrayMessages')
        .doc(message!.chatId)
        .set({
          'messages': FieldValue.arrayUnion([Message.toJson(message)]),
        }, SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateDiscoveryMessage(DiscoveryMessage? message) async {
    return FirebaseFirestore.instance
        .collection('discoveryMessages')
        .doc(message!.chatId)
        .set({
          'messages': FieldValue.arrayUnion([DiscoveryMessage.toJson(message)]),
        }, SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> acceptDiscoveryMessage(DiscoveryMessage? message) async {
    return FirebaseFirestore.instance
        .collection('discoveryMessages')
        .doc(message!.chatId)
        .set({
          'pending': false,
        }, SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteDiscoveryMessage(DiscoveryMessage? message) async {
    return FirebaseFirestore.instance
        .collection('discoveryMessages')
        .doc(message!.chatId)
        .delete()
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateStingrayChats(List<Chat?> chats, Stingray stingray) async {
    //messy? yes. Blame firesbase.
    FirebaseFirestore.instance
        .collection('stingrays')
        .doc(stingray.id)
        .set({'chats': Chat.chatListToJson(chats)}, SetOptions(merge: true))
        .then((value) => print("Chat Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> removeUserFromStingrayChats(User user) async {
    //messy? yes. Blame firesbase.

    //run a collection query to get all stingray chats that the user is in
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('stingrayChats').get();

    //map each document to a list of stingray chats
    // List<StingrayChat> stingrayChats = querySnapshot.docs.map((doc) => StingrayChat.fromJson(doc.data())).toList();

    // FirebaseFirestore.instance
    //     .collection('stingrays')
    //     .doc(stingray.id)
    //     .set({'chats': Chat.chatListToJson(chats)}, SetOptions(merge: true))
    //     .then((value) => print("Chat Updated"))
    //     .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> blockStingrayMessage(
      Chat? chat, User? blocker, Stingray stingray) async {
    final commentRef =
        FirebaseFirestore.instance.collection('stingrayChats').doc(stingray.id);

    final DocumentSnapshot doc = await commentRef.get();
    List<Chat?> chats = Chat.chatListFromMap(doc['chats']);

    int redFlags = (blocker!.id == stingray.id)
        ? stingray.redFlags
        : stingray.redFlags + 1;

    int chatIndex =
        chats.indexWhere((snapChat) => snapChat!.chatId == chat!.chatId);

    Chat? newChat = Chat(
      chatId: chat!.chatId,
      matchedUserId: chat.matchedUserId,
      stingrayId: chat.stingrayId,
      lastMessageSent: '!!!BLOCKED!!!',
      lastMessageSentDateTime: DateTime.now(),
      matchedUserImageUrl: chat.matchedUserImageUrl,
      matchedUserName: chat.matchedUserName,
      views: chat.views,
    );
    chats[chatIndex] = newChat;
    //messy? yes. Blame firesbase.
    FirebaseFirestore.instance
        .collection('stingrayChats')
        .doc(stingray.id)
        .set({'chats': Chat.chatListToJson(chats), 'redFlags': redFlags},
            SetOptions(merge: true))
        .then((value) => print("Chat Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    return FirebaseFirestore.instance
        .collection('stingrayMessages')
        .doc(chat.chatId)
        .set({
          'blocked': true,
          'blockerName': blocker.name,
          'blockerId': blocker.id
        }, SetOptions(merge: true))
        .then((value) => print("User Blocked"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> unblockStingrayMessage(
      Chat? chat, User blocker, Stingray stingray) async {
    int redFlags =
        (blocker.id == stingray.id) ? stingray.redFlags : stingray.redFlags - 1;

    final chatRef =
        FirebaseFirestore.instance.collection('stingrayChats').doc(stingray.id);
    final DocumentSnapshot doc = await chatRef.get();
    List<Chat?> chats = Chat.chatListFromMap(doc['chats']);
    int chatIndex =
        chats.indexWhere((stingChat) => stingChat!.chatId == chat!.chatId);

    Chat? newChat = Chat(
      chatId: chat!.chatId,
      matchedUserId: chat.matchedUserId,
      stingrayId: chat.stingrayId,
      lastMessageSent: 'Unblocked :]',
      lastMessageSentDateTime: DateTime.now(),
      matchedUserImageUrl: chat.matchedUserImageUrl,
      matchedUserName: chat.matchedUserName,
      views: chat.views,
    );
    chats[chatIndex] = newChat;
    //messy? yes. Blame firesbase.
    FirebaseFirestore.instance
        .collection('stingrayChats')
        .doc(stingray.id)
        .set({'chats': Chat.chatListToJson(chats), 'redFlags': redFlags},
            SetOptions(merge: true))
        .then((value) => print("Chat Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    return FirebaseFirestore.instance
        .collection('stingrayMessages')
        .doc(chat.chatId)
        .set({'blocked': false, 'blockerName': '', 'blockerId': ''},
            SetOptions(merge: true))
        .then((value) => print("User unblocked"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> removeStingrayChat(Chat? chat, Stingray stingray) async {
    final chatRef =
        FirebaseFirestore.instance.collection('stingrayChats').doc(stingray.id);
    final DocumentSnapshot doc = await chatRef.get();
    List<Chat?> chats = Chat.chatListFromMap(doc['chats']);
    //remove chat from chats list
    chats.removeWhere((snapChat) => snapChat!.chatId == chat!.chatId);

    //messy? yes. Blame firesbase.
    return FirebaseFirestore.instance
        .collection('stingrayChats')
        .doc(stingray.id)
        .set({'chats': Chat.chatListToJson(chats)}, SetOptions(merge: true))
        .then((value) => print("Chat Removed"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateStingrayChat(Chat? chat, String? stingrayid) async {
    return FirebaseFirestore.instance
        .collection('stingrayChats')
        .doc(stingrayid)
        .set({
          'chats': FieldValue.arrayUnion([Chat.toJson(chat)]),
        }, SetOptions(merge: true))
        .then((value) => print("Chat Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> initializeStingrayMessage(String chatId, Chat chat) async {
    final messagesRef =
        FirebaseFirestore.instance.collection('stingrayMessages').doc(chatId);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(messagesRef);

      if (snapshot.exists == false) {
        final ChatViewers chatViewers = ChatViewers(
          chatId: chatId,
          viewerIds: [],
        );

        messagesRef
            .set({
              'messages': [],
              'blockerName': '',
              'blocked': false,
              'blockerId': ''
            }, SetOptions(merge: true))
            .then((value) => print(" Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    });
  }

  Future<void> updateDiscoverysSeen(
    User receiver,
    User sender,
  ) async {
    final receiverSeenRef = FirebaseFirestore.instance
        .collection('discoveriesSeen')
        .doc(receiver.id);

    final senderSeenRef =
        FirebaseFirestore.instance.collection('discoveriesSeen').doc(sender.id);

    final receiverSnap = await receiverSeenRef.get();

    if (receiverSnap.exists == false) {
      receiverSeenRef
          .set({
            'seen': [sender.id!]
          }, SetOptions(merge: true))
          .then((value) => print("receiver Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      receiverSeenRef
          .set({
            'seen': FieldValue.arrayUnion([sender.id!])
          }, SetOptions(merge: true))
          .then((value) => print("receiver Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    final senderSnap = await senderSeenRef.get();

    if (senderSnap.exists == false) {
      senderSeenRef
          .set({
            'seen': [receiver.id!]
          }, SetOptions(merge: true))
          .then((value) => print(" Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      senderSeenRef
          .set({
            'seen': FieldValue.arrayUnion([receiver.id!])
          }, SetOptions(merge: true))
          .then((value) => print(" Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<void> initializeDiscoveryReceiverChats(
    User receiver,
    DiscoveryChat receiverChat,
  ) async {
    final receiverChatsRef = FirebaseFirestore.instance
        .collection('discoveryChats')
        .doc(receiver.id);

    final snapshot = await receiverChatsRef.get();

    if (snapshot.exists == false) {
      receiverChatsRef
          .set({
            'chats': [DiscoveryChat.toJson(receiverChat)]
          }, SetOptions(merge: true))
          .then((value) => print("receiver Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    } else {
      receiverChatsRef
          .set({
            'chats': FieldValue.arrayUnion([DiscoveryChat.toJson(receiverChat)])
          }, SetOptions(merge: true))
          .then((value) => print("receiver Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<void> initializeDiscoveryChats(
    DiscoveryChat chat,
  ) async {
    final senderChatsRef = discoveryChatsCollection.doc(chat.chatId);
    senderChatsRef
        .set(
          {
            'chatId': chat.chatId,
            'judgeId': chat.judgeId,
            'senderId': chat.senderId,
            'receiverId': chat.receiverId,
            'lastMessageSent': chat.lastMessageSent,
            'lastMessageSentDateTime': chat.lastMessageSentDateTime,
            'pending': chat.pending,
          },
        )
        .then((value) => print(" Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  static Future<void> initializesDiscoveryChats(
    DiscoveryChat chat,
  ) async {
    final senderChatsRef = FirebaseFirestore.instance
        .collection('discoveryChats')
        .doc(chat.chatId);

    senderChatsRef
        .set(
          {
            'chatId': chat.chatId,
            'judgeId': chat.judgeId,
            'senderId': chat.senderId,
            'receiverId': chat.receiverId,
            'lastMessageSent': chat.lastMessageSent,
            'lastMessageSentDateTime': chat.lastMessageSentDateTime,
            'pending': chat.pending,
          },
        )
        .then((value) => print(" Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> initializeStingrayComment(
      String? chatId, String? stingrayid, String? messageId) async {
    final commentRef = FirebaseFirestore.instance
        .collection('stingrayMessageComments')
        .doc(messageId);

    commentRef.get().then(
      (DocumentSnapshot doc) {
        if (doc.exists) {
          print("Document data exists");
        } else {
          // doc.data() will be undefined in this case
          print("No such document!");
          commentRef
              .set({'comments': []}, SetOptions(merge: true))
              .then((value) => print("Comments Updated"))
              .catchError((error) => print("Failed to update user: $error"));
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    // FirebaseFirestore.instance.runTransaction((transaction) async {
    //   final snapshot = await transaction.get(commentRef);

    //   if (snapshot.exists == false) {
    //     commentRef
    //         .set({'comments': []}, SetOptions(merge: true))
    //         .then((value) => print("Comments Updated"))
    //         .catchError((error) => print("Failed to update user: $error"));
    //   }
    // });
  }

  Future<void> updateStingrayMessageLikeCount(
      Chat chat, List<Message?> messages) async {
    //messy? yes. Blame firesbase.
    return FirebaseFirestore.instance
        .collection('stingrayMessages')
        .doc(chat.chatId)
        .set({'messages': Message.messageListToJson(messages)},
            SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateStingrayComments(
      Message message, List<Comment?> comments) async {
    return FirebaseFirestore.instance
        .collection('stingrayMessageComments')
        .doc(message.id)
        .set({'comments': Comment.commentListToJson(comments)},
            SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateStingrayCommentLikeCount(
      Comment? comment,
      String? stingrayid,
      List<Comment> comments,
      int commentIndex,
      String userId,
      Message message) async {
    if (comment!.userIdsWhoLiked.contains(userId)) {
      int newLikes = comment.likes - 1;
      List<dynamic> newUserIdsWhoLiked = comment.userIdsWhoLiked;
      newUserIdsWhoLiked.remove(userId);

      Comment? newComment = Comment(
          id: comment.id,
          senderId: comment.senderId,
          posterImageUrl: comment.posterImageUrl,
          message: comment.message,
          posterName: comment.posterName,
          dateTime: comment.dateTime,
          timeString: comment.timeString,
          likes: newLikes,
          userIdsWhoLiked: newUserIdsWhoLiked);
      comments[commentIndex] = newComment;
    } else {
      int newLikes = comment.likes + 1;
      List<dynamic> newUserIdsWhoLiked = comment.userIdsWhoLiked;
      newUserIdsWhoLiked.add(userId);

      Comment? newComment = Comment(
          id: comment.id,
          senderId: comment.senderId,
          posterImageUrl: comment.posterImageUrl,
          message: comment.message,
          posterName: comment.posterName,
          dateTime: comment.dateTime,
          timeString: comment.timeString,
          likes: newLikes,
          userIdsWhoLiked: newUserIdsWhoLiked);
      comments[commentIndex] = newComment;
    }
    //messy? yes. Blame firesbase.
    return FirebaseFirestore.instance
        .collection('stingrayMessageComments')
        .doc(message.id)
        .update(
          {'comments': Comment.commentListToJson(comments)},
        )
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateStingrayMessageListener(
    Message? message,
    String senderName,
  ) async {
    //messy? yes. Blame firesbase.
    return FirebaseFirestore.instance
        .collection('stingrayMessageListener')
        .doc('stingrayMessageListener')
        .set({'receiverId': message!.receiverId, 'senderName': senderName},
            SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updatePendingListener(
    User sender,
    User receiver,
    String chatId,
  ) async {
    //messy? yes. Blame firesbase.
    return FirebaseFirestore.instance
        .collection('listeners')
        .doc('discoveryPending')
        .set({
          'imageUrl': sender.imageUrls[0],
          'senderName': sender.name,
          'receiverId': receiver.id,
          'userId': sender.id,
          'chatId': chatId,
        }, SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateDiscoveryMessageListener(
    User sender,
    User receiver,
    String message,
    String chatId,
  ) async {
    //messy? yes. Blame firesbase.
    return FirebaseFirestore.instance
        .collection('listeners')
        .doc('discoveryMessage')
        .set({
          'imageUrl': sender.imageUrls[0],
          'senderName': sender.name,
          'receiverId': receiver.id,
          'message': message,
          'chatId': chatId,
          'userId': sender.id,
        }, SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateStingrayMessageCommentCount(
    Message message,
    String? stingrayid,
    List<Message?> messages,
  ) async {
    //messy? yes. Blame firesbase.
    return FirebaseFirestore.instance
        .collection('stingrayMessages')
        .doc(message.chatId)
        .set({'messages': Message.messageListToJson(messages)},
            SetOptions(merge: true))
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //void method viewDiscoveryChat that takes a User Id and a disvoeryChatId and appends the userid to the document's seenBy list
  Future<void> viewDiscoveryChat(
      {required String userId, required String discoveryChatId}) {
    return discoveryChatCollection.doc(discoveryChatId).update({
      'seenBy': FieldValue.arrayUnion([userId])
    });
  }

  Future<void> updateStingrayChatLastMessage(
      Message? message,
      String? stingrayid,
      String matchedUserId,
      String userId,
      String chatId) async {
    final chatsRef =
        FirebaseFirestore.instance.collection('stingrayChats').doc(stingrayid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      //create a List of chats from the transaction
      DocumentSnapshot snapshot = await transaction.get(chatsRef);
      //map snapshot to a list of chats
      List<Chat?> chats = Chat.chatListFromSnapshot(snapshot);

      int chatIndex = chats.indexWhere((chat) => chat!.chatId == chatId);
      Chat? chat = chats[chatIndex];

      Chat? newChat = Chat(
        chatId: chat!.chatId,
        matchedUserId: chat.matchedUserId,
        stingrayId: chat.stingrayId,
        lastMessageSent: message!.message,
        lastMessageSentDateTime: message.dateTime,
        matchedUserImageUrl: chat.matchedUserImageUrl,
        matchedUserName: chat.matchedUserName,
        views: chat.views,
      );
      chats[chatIndex] = newChat;
      //messy? yes. Blame firesbase.
      return FirebaseFirestore.instance
          .collection('stingrayChats')
          .doc(stingrayid)
          .set({'chats': Chat.chatListToJson(chats)}, SetOptions(merge: true))
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    });
  }

  Future<void> updateDiscoveryChatLastMessage(
    DiscoveryMessage? message,
  ) async {
    discoveryChatCollection
        .doc(message!.chatId)
        .update(
          {
            'pending': false,
            'lastMessageSent': message.message,
            'lastMessageSentDateTime': message.dateTime,
            'seenBy': [message.senderId]
          },
        )
        .then((value) => print("receiver Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> removeDiscoveryChat(
    DiscoveryMessage? message,
  ) async {
    final receiverRef = FirebaseFirestore.instance
        .collection('discoveryChats')
        .doc(message!.chatId);

    //delete the chat
    return receiverRef.delete();
  }

  Future<void> deleteUser(User user) async {
    //messy? yes. Blame firesbase.
    if (user.isStingray) {
      stingrayCollection
          .doc(user.id)
          .delete()
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }

    return userCollection
        .doc(user.id)
        .delete()
        .then((value) => print("User deleted"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //a future void method that takes in a user id, and deletes all waves from the collection 'waves' where a senderId is equal to the user id
  Future<void> deleteWaves(String userId) async {
    QuerySnapshot q = await FirebaseFirestore.instance
        .collection('waves')
        .where('senderId', isEqualTo: userId)
        .get();

    q.docs.forEach((result) {
      result.reference.delete();
    });
  }

  //a future void method that takes in a user id, and deletes all discoveryChats from the collection 'discoveryChats' where a senderId is equal to the user id or a receiverId is equal to the user id
  Future<void> deleteDiscoveryChats(String userId) async {
    FirebaseFirestore.instance
        .collection('discoveryChats')
        .where('senderId', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        result.reference.delete();
      });
    });

    return FirebaseFirestore.instance
        .collection('discoveryChats')
        .where('receiverId', isEqualTo: userId)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        result.reference.delete();
      });
    });
  }

  //future void method that takes in a blocked  user handle and a userId, then adds the handle to 'blockedUsers' in the user collection,
  Future<void> blockUserHandle(User blockedUser, String blockerId) async {
    //add the blockerId to the blocked user's blockedBy array
    FirebaseFirestore.instance
        .collection('users')
        .doc(blockedUser.id)
        .update({
          'blockedBy': FieldValue.arrayUnion([blockerId])
        })
        .then((value) => print("block Updated"))
        .catchError((error) {
          //set the blockedBy array to the blockerId with merge true
          return FirebaseFirestore.instance
              .collection('users')
              .doc(blockedUser.id)
              .set({
            'blockedBy': [blockerId]
          }, SetOptions(merge: true));
        });

    return FirebaseFirestore.instance
        .collection('users')
        .doc(blockerId)
        .update({
          'blockedUsers': FieldValue.arrayUnion([blockedUser.handle]),
          'blockedUserIds': FieldValue.arrayUnion([blockedUser.id])
        })
        .then((value) => print("block Updated"))
        .catchError((error) {
          //set the blockedUsers array to the blockedUser.handle with merge true
          return FirebaseFirestore.instance
              .collection('users')
              .doc(blockerId)
              .set({
            'blockedUsers': [blockedUser.handle],
            'blockedUserIds': [blockedUser.id]
          }, SetOptions(merge: true));
        });
  }

  Future<void> unblockUserHandle(
      String blockedUserHandle, String blockerId) async {
    //get the blocked user from the handle
    User? blockedUser = await getUserFromHandle(blockedUserHandle);

    FirebaseFirestore.instance
        .collection('users')
        .doc(blockedUser!.id)
        .update({
          'blockedBy': FieldValue.arrayRemove([blockerId])
        })
        .then((value) => print("block Updated"))
        .catchError((error) {
          //set the blockedBy array to the blockerId with merge true
          print("Failed to update user: $error");
        });

    FirebaseFirestore.instance
        .collection('users')
        .doc(blockerId)
        .update({
          'blockedUsers': FieldValue.arrayRemove([blockedUserHandle]),
          'blockedUserIds': FieldValue.arrayRemove([blockedUser.id])
        })
        .then((value) => print("block Updated"))
        .catchError((error) {
          print("Failed to update user: $error");
        });
  }

  //future void moethod deecrementWaveReplies that takes in a waveId parameter and decrements the waveReplies field in the wave collection
  Future<void> decrementWaveReplies(String waveId) async {
    return waveCollection
        .doc(waveId)
        .update({
          'comments': FieldValue.increment(-1),
          'popularity': FieldValue.increment(-600)
        })
        .then((value) => print("comments decremented"))
        .catchError(
            (error) => print("Failed to decrement waveReplies: $error"));
  }

  Future<void> updateStingrayChatViewers(
    String stingrayId,
    User user,
    List<ChatViewers?> chatViewers,
    ChatViewers chatViewer,
  ) async {
    if (!chatViewer.viewerIds.contains(user.id)) {
      final List<dynamic> newViewerIds = chatViewer.viewerIds;
      newViewerIds.add(user.id);
      final ChatViewers newChatViewer = ChatViewers(
        chatId: chatViewer.chatId,
        viewerIds: newViewerIds,
      );

      //replace old chatViewer with new one
      chatViewers[chatViewers.indexOf(chatViewer)] = newChatViewer;

      return FirebaseFirestore.instance
          .collection('viewers')
          .doc(stingrayId)
          .set({'viewers': ChatViewers.chatListToJson(chatViewers)},
              SetOptions(merge: false))
          .then((value) => print("Viewers Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<void> updateStingrayChatViews(
    String? stingrayid,
    String matchedUserId,
    List<Chat?>? chats,
  ) async {
    int chatIndex = chats!.indexWhere((chat) =>
        chat!.matchedUserId == matchedUserId && chat.stingrayId == stingrayid);
    Chat? chat = chats[chatIndex];

    Chat? newChat = Chat(
      chatId: chat!.chatId,
      matchedUserId: chat.matchedUserId,
      stingrayId: chat.stingrayId,
      lastMessageSent: chat.lastMessageSent,
      lastMessageSentDateTime: chat.lastMessageSentDateTime,
      matchedUserImageUrl: chat.matchedUserImageUrl,
      matchedUserName: chat.matchedUserName,
      views: chat.views + 1,
    );
    chats[chatIndex] = newChat;
    //messy? yes. Blame firesbase.
    return FirebaseFirestore.instance
        .collection('stingrayChats')
        .doc(stingrayid)
        .set({'chats': Chat.chatListToJson(chats)}, SetOptions(merge: true))
        .then((value) => print("Views Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  static Future<void> reportChat(
    Chat chat,
    Stingray stingray,
    User user,
    String reason,
  ) async {
    final commentRef = FirebaseFirestore.instance.collection('reports');
    return commentRef.doc().set({
      'reason': reason,
      'type': 'chat report',
      'chat': Chat.toJson(chat),
      'stingray': Stingray.toJson(stingray),
      'reportId': Uuid().v4(),
      'reporterUser': User.toJson(user),
      'reportTime': DateTime.now(),
    });
  }

  static Future<void> sendReport(
    Report report,
  ) async {
    return FirebaseFirestore.instance
        .collection('reports')
        .doc(report.reportId)
        .set(Report.toJson(report), SetOptions(merge: true))
        .then((value) => print("Report Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> sendReportNonstatic(
    Report report,
  ) async {
    return FirebaseFirestore.instance
        .collection('reports')
        .doc(report.reportId)
        .set(Report.toJson(report), SetOptions(merge: true))
        .then((value) => print("Report Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //method ignoreReport
  Future<void> ignoreReport(Report report) async {
    return reportsColllection
        .doc(report.reportId)
        .delete()
        .then((value) => print("Report Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> deleteWave(Wave wave) async {
    return waveCollection
        .doc(wave.id)
        .delete()
        .then((value) => print("Report Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<User?> getUserFromHandle(String handle) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('handle', isEqualTo: handle)
        .get();
    List<User?> userList = User.userListFromSnapshot(result);
    if (userList.length > 0) {
      return userList[0];
    } else {
      return null;
    }
  }

  //Future<List<DiscoveryChat?>> that takes in a user and a nullable DocumentSnapshot lastDocument where senderId is equal to the user.id pending is true and order by lastMessageSentDateTime descending
  Future<QuerySnapshot<Object?>> getPendingDiscoveryChats(
      String userId, DocumentSnapshot? lastDocument) async {
    QuerySnapshot result;
    if (lastDocument == null) {
      result = await FirebaseFirestore.instance
          .collection('discoveryChats')
          .where('senderId', isEqualTo: userId)
          .where('pending', isEqualTo: true)
          .orderBy('lastMessageSentDateTime', descending: true)
          .limit(10)
          .get();
    } else {
      result = await FirebaseFirestore.instance
          .collection('discoveryChats')
          .where('senderId', isEqualTo: userId)
          .where('pending', isEqualTo: true)
          .orderBy('lastMessageSentDateTime', descending: true)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return result;
  }

  Future<QuerySnapshot<Object?>> getJudgeableDiscoveryChats(
      String userId, DocumentSnapshot? lastDocument) async {
    QuerySnapshot result;
    if (lastDocument == null) {
      result = await discoveryChatCollection
          .where('judgeId', isEqualTo: userId)
          .where('pending', isEqualTo: true)
          .orderBy('lastMessageSentDateTime', descending: true)
          .limit(10)
          .get();
    } else {
      result = await discoveryChatCollection
          .where('judgeId', isEqualTo: userId)
          .where('pending', isEqualTo: true)
          .orderBy('lastMessageSentDateTime', descending: true)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return result;
  }

  Future<QuerySnapshot<Object?>> getMyWaves(
      String userId, DocumentSnapshot? lastDocument) async {
    QuerySnapshot result;
    if (lastDocument == null) {
      result = await waveCollection
          .where('senderId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
    } else {
      result = await waveCollection
          .where('senderId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return result;
  }

  Future<QuerySnapshot<Object?>> getAllWaves(
      String userId, DocumentSnapshot? lastDocument) async {
    QuerySnapshot result;
    if (lastDocument == null) {
      result = await waveCollection
          .where('senderId', isEqualTo: userId)
          .where('type', isEqualTo: Wave.default_type)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
    } else {
      result = await waveCollection
          .where('senderId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .where('type', isEqualTo: Wave.default_type)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return result;
  }

  Future<QuerySnapshot<Object?>> getLikedWaves(
      String userId, DocumentSnapshot? lastDocument) async {
    QuerySnapshot result;
    if (lastDocument == null) {
      result = await waveCollection
          .where('likedBy', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
    } else {
      result = await waveCollection
          .where('likedBy', arrayContains: userId)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(lastDocument)
          .limit(10)
          .get();
    }
    return result;
  }

  //future void delete discovery chat
  Future<void> deleteDiscoveryChat(DiscoveryChat chat) async {
    return discoveryChatCollection
        .doc(chat.chatId)
        .delete()
        .then((value) => print("Chat deleted"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //Future<DiscoveryChat> getTestJudgeable the gets the most recent discovery chat where judgeId is equal to userId and pending is true
  Future<DiscoveryChat?> getTestJudgeable(String userId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('discoveryChats')
        .where('judgeId', isEqualTo: userId)
        .where('pending', isEqualTo: true)
        .orderBy('lastMessageSentDateTime', descending: true)
        .limit(1)
        .get();
    List<DiscoveryChat?> discoveryChatList =
        DiscoveryChat.discoveryChatListFromSnapshot(result);
    if (discoveryChatList.length > 0) {
      return discoveryChatList[0];
    } else {
      return null;
    }
  }

  Future<Wave?> getTestWave(String userId) async {
    final QuerySnapshot result = await waveCollection
        .where('senderId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    List<Wave?> discoveryChatList = Wave.waveListFromQuerySnapshot(result);
    if (discoveryChatList.length > 0) {
      return discoveryChatList[0];
    } else {
      return null;
    }
  }

  Future<Wave?> getTestSeaReal() async {
    final QuerySnapshot result = await waveCollection
        .where('frontImageUrl', isNotEqualTo: '')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    List<Wave?> discoveryChatList = Wave.waveListFromQuerySnapshot(result);
    if (discoveryChatList.length > 0) {
      return discoveryChatList[0];
    } else {
      return null;
    }
  }

  //testPending
  Future<DiscoveryChat?> getTestPending(String userId) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('discoveryChats')
        .where('senderId', isEqualTo: userId)
        .where('pending', isEqualTo: true)
        .orderBy('lastMessageSentDateTime', descending: true)
        .limit(1)
        .get();
    List<DiscoveryChat?> discoveryChatList =
        DiscoveryChat.discoveryChatListFromSnapshot(result);
    if (discoveryChatList.length > 0) {
      return discoveryChatList[0];
    } else {
      return null;
    }
  }

  //a future<List<Wave?>> that takes in a Stingray and returns all waves where the senderId is equal to the stingray.id, replyTo is null, and order by popularity descending
  Future<QuerySnapshot<Object?>> getWavesByStingray(
      Stingray stingray, DocumentSnapshot? lastDocument) async {
    QuerySnapshot result;
    if (lastDocument == null) {
      final q = waveCollection.where('senderId', isEqualTo: stingray.id);

      result = await q
          .where('replyTo', isEqualTo: 'null')
          .where('type', isEqualTo: Wave.default_type)
          .orderBy('popularity', descending: true)
          .limit(1)
          .get();
    } else {
      final q = waveCollection.where('senderId', isEqualTo: stingray.id);

      result = await q
          .where('replyTo', isEqualTo: 'null')
          .where('type', isEqualTo: Wave.default_type)
          .orderBy('popularity', descending: true)
          .startAfterDocument(lastDocument)
          .limit(5)
          .get();
    }
    return result;
  }

  Future<QuerySnapshot<Object?>> getWaveVideos(
      DocumentSnapshot? lastDocument) async {
    QuerySnapshot result;
    if (lastDocument == null) {
      result = await waveCollection
          .where('videoUrl', isNotEqualTo: 'null')
          .limit(5)
          .get();
    } else {
      result = await waveCollection
          .where('videoUrl', isNotEqualTo: 'null')
          .startAfterDocument(lastDocument)
          .limit(5)
          .get();
    }
    return result;
  }

  //the method, get chainedWave, which returns a Future<Wave?> that takes in a Wave and returns the wave where the id is equal to the wave.replyTo sorted by popularity descending. Limit to 1.
  Future<Wave?> getChainedWave(Wave wave) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('waves')
        .where('replyTo', isEqualTo: wave.id)
        .orderBy('popularity', descending: true)
        .limit(1)
        .get();
    List<Wave?> waveList = Wave.waveListFromQuerySnapshot(result);
    if (waveList.length > 0) {
      return waveList[0];
    } else {
      return null;
    }
  }

  Future<void> sendVerification(
      {required User user, required String imageUrl}) async {
    userVerificationCollection.doc(user.id).update({
      'verificationStatus': UserVerification.pending,
      'imageUrl': imageUrl,
      'createdAt': DateTime.now()
    });
  }

  Future<void> updateVerification({
    required UserVerification userVerification,
  }) async {
    userVerificationCollection
        .doc(userVerification.id)
        .set(UserVerification.toJson(userVerification));
  }

  //future void deleteVerification that takes in an id and deletes the userVerification where the id is equal to the id
  Future<void> deleteVerification(String id) async {
    userVerificationCollection.doc(id).delete();
  }

  //a future userVerification that takes in a user and returns the userVerification where the id is equal to the user.id
  Future<UserVerification?> getFutureUserVerification(
      String verificationId) async {
    final DocumentSnapshot result =
        await userVerificationCollection.doc(verificationId).get();
    if (result.exists) {
      return UserVerification.fromDocSnapshot(result.data()!);
    } else {
      return null;
    }
  }

  //vuture void verifyUser that takes in a string id and updates the userVerification where the id is equal to the id and sets the verificationStatus to verified
  Future<void> verifyUser(String id) async {
    userCollection.doc(id).update({
      'verified': true,
    });
    stingrayCollection.doc(id).update({
      'verified': true,
    });
  }

  Future<void> setStingray(Stingray stingray) async {
    stingrayCollection.doc(stingray.id).set(Stingray.toJson(stingray));
  }

  //future void method, uploadStory, which takes in a String combine, and then FieldValue.arrayUnion it to the field 'stories'. In the error where the field does not exist, create it.
  Future<void> uploadStory(
      {required String combine, required String stingrayId}) async {
    stingrayCollection
        .doc(stingrayId)
        .update({
          'stories': FieldValue.arrayUnion([combine])
        })
        .then((value) => print('ye'))
        .onError((error, stackTrace) {
          stingrayCollection.doc(stingrayId).set({
            'stories': ([combine])
          }, SetOptions(merge: true));
          print('no');
        });
  }

  //future void reportStory
  Future<void> reportStory({required Report report}) async {
    reportsColllection.doc(report.reportId).set(Report.toJson(report));
  }

  //future void deleteStory that array removes the story from the stingray's stories
  Future<void> deleteStory({
    required Story story,
  }) async {
    String _storyString = story.storyToString();
    stingrayCollection.doc(story.posterId).update({
      'stories': FieldValue.arrayRemove([_storyString])
    });
  }

  //delete all waves
  Future<void> deleteAllWaves() async {
    final QuerySnapshot result = await waveCollection.get();
    List<Wave?> waveList = Wave.waveListFromQuerySnapshot(result);
    for (Wave? wave in waveList) {
      waveCollection.doc(wave!.id).delete();
    }
  }

  //Future list users getLeaderboardUsers. Gets the top 5 users by vote

  Future<List<User?>> getLeaderboardUsers() async {
    final QuerySnapshot result = await userCollection
        .where('votes', isGreaterThan: 0)
        .orderBy('votes', descending: true)
        .limit(5)
        .get();
    List<User?> userList = User.userListFromSnapshot(result);
    return userList;
  }

  //future discoveryChat getDiscoveryChatSent that takes in a user id and looks for where senderId is equal to the id and order by lastMessageSentDateTime descending. Limit to 1
  Future<DiscoveryChat?> getDiscoveryChatForSender(
      {required String id, required String matchedUserId}) async {
    final QuerySnapshot result = await discoveryChatCollection
        .where('senderId', isEqualTo: id)
        .where('receiverId', isEqualTo: matchedUserId)
        .orderBy('lastMessageSentDateTime', descending: true)
        .limit(1)
        .get();
    List<DiscoveryChat?> discoveryChatList =
        DiscoveryChat.discoveryChatListFromSnapshot(result);
    if (discoveryChatList.length > 0) {
      return discoveryChatList[0];
    } else {
      return null;
    }
  }

  Future<DiscoveryChat?> getDiscoveryChatForReceiver(
      {required String id, required String matchedUserId}) async {
    final QuerySnapshot result = await discoveryChatCollection
        .where('receiverId', isEqualTo: id)
        .where('senderId', isEqualTo: matchedUserId)
        .orderBy('lastMessageSentDateTime', descending: true)
        .limit(1)
        .get();
    List<DiscoveryChat?> discoveryChatList =
        DiscoveryChat.discoveryChatListFromSnapshot(result);
    if (discoveryChatList.length > 0) {
      return discoveryChatList[0];
    } else {
      return null;
    }
  }

  //future method getYipWaves. Gets a future list of YipYap objects, which comes from the waveCollection. Take in a nullable documentSnapshot, and if it is null, get the first 10 waves. If it is not null, get the next 10 waves. Order by popularity descending
  Future<QuerySnapshot> getYipYaps({DocumentSnapshot? lastDocument}) async {
    Query query = waveCollection
        .where('type', isEqualTo: Wave.yip_yap_type)
        .where('replyTo', isEqualTo: 'null')
        .orderBy('popularity', descending: true);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    final QuerySnapshot result = await query.limit(10).get();

    return result;
  }

  //future list<dynamic> getSeenVideoIds, it takes a user id and returns a list of strings of the seen video ids. In the case that the document does not exist, create a document at 'seenVideoIds/userId' and set it to an empty list, then  return an empty list
  Future<List<String>> getSeenVideoIds(String userId) async {
    final DocumentSnapshot result =
        await seenVideoIdsCollection.doc(userId).get();
    if (result.exists) {
      List<dynamic> seenVideoIds = result['seenVideoIds'];
      return seenVideoIds.map((e) => e.toString()).toList();
    } else {
      seenVideoIdsCollection.doc(userId).set({'seenVideoIds': []});
      return [];
    }
  }

  //future void method, setSeenVideoIds, which takes in a user id and a list of strings of video ids, and then sets the seenVideoIds field to the list of strings
  Future<void> setSeenVideoIds(
      {required String userId, required List<dynamic> waveIds}) async {
    seenVideoIdsCollection
        .doc(userId)
        .update({'seenVideoIds': FieldValue.arrayUnion(waveIds)});
  }

  //futureVoid function update votesUsable that takes in an int and userId, and then updates the votesUsable field to the int
  Future<void> updateVotesUsable(
      {required int votesUsable, required String id}) {
    return userCollection.doc(id).update({
      'votesUsable': FieldValue.increment(votesUsable),
      'lastSeaRealTime': DateTime.now()
    });
  }

  Future<StingrayStatsDoc> getStingrayStats(
      {required String stingrayId}) async {
    final DocumentSnapshot result =
        await stingrayLeaderboardCollection.doc(stingrayId).get();
    if (result.exists) {
      return StingrayStatsDoc.stingrayStatsDocFromMap(
          result.data() as Map<String, dynamic>);
    } else {
      stingrayLeaderboardCollection.doc(stingrayId).set(
          StingrayStatsDoc.genericStingrayStatsDoc(stingrayId: stingrayId)
              .toJson());
      return StingrayStatsDoc.genericStingrayStatsDoc(stingrayId: stingrayId);
    }
  }

  Future<QuerySnapshot> getStingrayLeaderboard(
      {DocumentSnapshot? lastDocument}) async {
    Query query =
        stingrayLeaderboardCollection.orderBy('totalScore', descending: true);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    final QuerySnapshot result = await query.limit(10).get();

    return result;
  }

  //future void method, likeStingray stats, that increments the likes field by 1
  Future<void> likeStingrayStats({required String stingrayId}) async {
    stingrayLeaderboardCollection.doc(stingrayId).update({
      'likes': FieldValue.increment(1),
      'totalScore': FieldValue.increment(1)
    });
  }

  //dislike stingray stats
  Future<void> dislikeStingrayStats({required String stingrayId}) async {
    stingrayLeaderboardCollection.doc(stingrayId).update({
      'dislikes': FieldValue.increment(1),
      'totalScore': FieldValue.increment(-1)
    });
  }

  //a future int, comments, that gets the count of waves where the replyTo field is equal to the stingrayId, and createdAt is greater than the last occurance of Sunday at 10pm
  Future<int> getStingrayLeaderboardReplies(
      {required String stingrayId}) async {
    DateTime lastSunday = DateTime.now().subtract(Duration(days: 7));
    DateTime lastSundayAt10 = DateTime(
        lastSunday.year, lastSunday.month, lastSunday.day, 22, 0, 0, 0, 0);
    final AggregateQuerySnapshot result = await waveCollection
        .where('replyTo', isEqualTo: stingrayId)
        .where('createdAt', isGreaterThan: lastSundayAt10)
        .count()
        .get();
    return result.count;
  }

  Future<int> getStingrayLeaderboardWavesCount(
      {required String stingrayId}) async {
    DateTime lastSunday = DateTime.now().subtract(Duration(days: 7));
    DateTime lastSundayAt10 = DateTime(
        lastSunday.year, lastSunday.month, lastSunday.day, 22, 0, 0, 0, 0);
    final AggregateQuerySnapshot result = await waveCollection
        .where('senderId', isEqualTo: stingrayId)
        .where('createdAt', isGreaterThan: lastSundayAt10)
        .count()
        .get();
    return result.count;
  }

  //future void, createPrize, that takes in a prize object and then creates a document at 'prizes/prize.id' and sets it to the prize object
  Future<void> createPrize({required Prize prize}) async {
    return prizeCollection.doc(prize.id).set(prize.toJson());
  }

  //delete prize
  Future<void> deletePrize({required String prizeId}) async {
    return prizeCollection.doc(prizeId).delete();
  }

  //future void change remaining, takes an int and a prizeId, and then updates the remaining field to the int
  Future<void> changePrizeRemaining(
      {required int remaining, required String prizeId}) {
    return prizeCollection
        .doc(prizeId)
        .update({'remaining': FieldValue.increment(remaining)});
  }

  Future<void> setBackPack({required BackpackItem item}) {
    return backpackItemsCollection.doc(item.id).set(
          item.toJson(),
        );
  }

  Future<List<BackpackItem>> getBackPackItems(String userId) async {
    final QuerySnapshot result =
        await backpackItemsCollection.where('ownerId', isEqualTo: userId).get();

    if (result.docs.isNotEmpty) {
      return result.docs
          .map((e) => BackpackItem.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

  Stream<List<BackpackItem>> getBackPackItemsStream(String userId) {
    return backpackItemsCollection
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((doc) =>
                BackpackItem.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  //future void addVotesUsable that takes in an int and a userId, and then increments the votesUsable field by the int
  Future<void> addVotesUsable({required int votesUsable, required String id}) {
    return userCollection.doc(id).update({
      'votesUsable': FieldValue.increment(votesUsable),
    });
  }

  Future<void> useItem({required BackpackItem item, required String userId}) {
    return backpackItemsCollection.doc(item.id).update({
      'usedAt': DateTime.now(),
      'used': true,
    });

    //future void method addGoldCoin that takes in a userId, then increments the goldCoin field by 1.
  }

  Future<void> adjustTokenCount(
      {required String userId,
      required String tokenType,
      required int amount}) {
    return userCollection.doc(userId).update({
      tokenType: FieldValue.increment(amount),
    });
  }

  //future bool stupidTime. It just returns the value from the stupidTime collection at the id 'stupidTime' from field stupidTime
  Future<bool> stupidTime() async {
    final DocumentSnapshot result =
        await stupidTimeCollection.doc('stupidTime').get();
    if (result.exists) {
      return result['stupidTime'];
    } else {
      return false;
    }
  }
  
  Future<void> dropStingray({required String userId}) async {
    return stingrayCollection.doc(userId).delete();
  }

  //future void disableStingrayStatus that takes in a userId, and then sets the stingrayStatus field to false
  Future<void> disableStingrayStatus({required String userId}) {
    return userCollection.doc(userId).update({
      'isStingray': false,
    });
  }
}

int yearsBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  int i = (((to.difference(from).inHours / 24)) / 365).floor();
  print(i);
  return i;
}
