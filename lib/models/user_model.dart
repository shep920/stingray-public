import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dice_bear/dice_bear.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:hero/models/stingray_model.dart';
import 'package:flutter_test/flutter_test.dart';
//import firebase

import 'chat_model.dart';
import 'team_model.dart';

class User extends Equatable {
  final String? id;
  final String name;
  final int age;
  final List<dynamic> imageUrls;

  final String bio;
  final String jobTitle;
  final String gender;
  final bool isStingray;

  final int votes;
  final int votesUsable;
  final int instigations;
  final bool isRude;
  final List<dynamic> stingrays;
  final bool finishedOnboarding;
  final String handle;

  final bool newMessages;
  final List<dynamic> goals;
  final DateTime birthDate;
  final bool isAdmin;
  final bool receivedSecretVote;
  final bool wantsToTalk;
  final int discoveriesRemaning;
  final String typsenseId;
  final int randomInt;
  final bool isBanned;
  final String banReason;
  final DateTime banExpiration;
  final bool seenWaveLikeNotification;
  final bool seenVoteNotification;
  final bool verified;
  final bool seenTutorial;
  final bool castFirstVote;
  final bool newNotifications;
  final List<dynamic> blockedBy;
  final List<dynamic> blockedUsers;
  final List<dynamic> blockedUserIds;
  final DateTime? createdAt;
  final bool isPup;
  final String firstUndergrad;
  final String secondUndergrad;
  final String thirdUndergrad;
  final String postGrad;
  final String firstStudentOrg;
  final String secondStudentOrg;
  final String thirdStudentOrg;
  final String firstStudentOrgPosition;
  final String secondStudentOrgPosition;
  final String thirdStudentOrgPosition;
  final String fraternity;
  final String fratPosition;
  final String favoriteBar;
  final String favoriteSpot;
  final String assosiatedDorm;
  final String worstDorm;
  final String intramuralSport;
  final String twitterUrl;
  final String instagramUrl;
  final String snapchatUrl;
  final String discordUrl;
  final String tiktokUrl;
  final String tinderUrl;
  final int dailyDmsRemaining;
  final DateTime? lastSeaRealTime;
  final List<dynamic> tokens;
  final List<dynamic> prizeIds;
  final int goldTokens;
  final int silverTokens;
  final int bronzeTokens;
  final int ironTokens;
  final bool sentFirstSeaReal;

  const User({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrls,
    required this.bio,
    required this.gender,
    required this.jobTitle,
    this.isStingray = false,
    required this.instigations,
    required this.isRude,
    required this.votes,
    required this.votesUsable,
    required this.stingrays,
    required this.finishedOnboarding,
    required this.handle,
    required this.newMessages,
    required this.goals,
    required this.birthDate,
    required this.isAdmin,
    required this.receivedSecretVote,
    required this.wantsToTalk,
    required this.discoveriesRemaning,
    required this.typsenseId,
    required this.randomInt,
    required this.isBanned,
    required this.banReason,
    required this.banExpiration,
    required this.seenWaveLikeNotification,
    required this.seenVoteNotification,
    required this.verified,
    required this.seenTutorial,
    required this.castFirstVote,
    required this.newNotifications,
    required this.blockedBy,
    required this.blockedUsers,
    required this.blockedUserIds,
    required this.createdAt,
    required this.isPup,
    required this.firstUndergrad,
    required this.secondUndergrad,
    required this.thirdUndergrad,
    required this.postGrad,
    required this.firstStudentOrg,
    required this.secondStudentOrg,
    required this.thirdStudentOrg,
    required this.firstStudentOrgPosition,
    required this.secondStudentOrgPosition,
    required this.thirdStudentOrgPosition,
    required this.fraternity,
    required this.fratPosition,
    required this.favoriteBar,
    required this.favoriteSpot,
    required this.assosiatedDorm,
    required this.worstDorm,
    required this.intramuralSport,
    required this.twitterUrl,
    required this.instagramUrl,
    required this.snapchatUrl,
    required this.discordUrl,
    required this.tiktokUrl,
    required this.tinderUrl,
    required this.dailyDmsRemaining,
    required this.lastSeaRealTime,
    required this.tokens,
    required this.prizeIds,
    required this.goldTokens,
    required this.silverTokens,
    required this.bronzeTokens,
    required this.ironTokens,
    required this.sentFirstSeaReal,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        imageUrls,
        bio,
        jobTitle,
        isStingray,
        instigations,
        isRude,
        votes,
        votesUsable,
        stingrays,
        finishedOnboarding,
        instigations,
        handle,
        newMessages,
        goals,
        birthDate,
        isAdmin,
        receivedSecretVote,
        wantsToTalk,
        discoveriesRemaning,
        typsenseId,
        randomInt,
        isBanned,
        banReason,
        banExpiration,
        seenWaveLikeNotification,
        seenVoteNotification,
        verified,
        seenTutorial,
        castFirstVote,
        newNotifications,
        blockedBy,
        blockedUsers,
        blockedUserIds,
        createdAt,
        isPup,
        firstUndergrad,
        secondUndergrad,
        thirdUndergrad,
        postGrad,
        firstStudentOrg,
        secondStudentOrg,
        thirdStudentOrg,
        firstStudentOrgPosition,
        secondStudentOrgPosition,
        thirdStudentOrgPosition,
        fraternity,
        fratPosition,
        favoriteBar,
        favoriteSpot,
        assosiatedDorm,
        worstDorm,
        intramuralSport,
        twitterUrl,
        instagramUrl,
        snapchatUrl,
        discordUrl,
        tiktokUrl,
        tinderUrl,
        dailyDmsRemaining,
        lastSeaRealTime,
        tokens,
        prizeIds,
        goldTokens,
        silverTokens,
        bronzeTokens,
        ironTokens,
        sentFirstSeaReal,
      ];

  static Map<String, dynamic> toJson(User? user) => {
        'id': user?.id,
        'name': user?.name,
        'age': user?.age,
        'imageUrls': user?.imageUrls,
        'bio': user?.bio,
        'jobTitle': user?.jobTitle,
        'isStingray': user?.isStingray,
        'instigations': user?.instigations,
        'isRude': user?.isRude,
        'votes': user?.votes,
        'votesUsable': user?.votesUsable,
        'stingrays': user?.stingrays,
        'finishedOnboarding': user?.finishedOnboarding,
        'gender': user?.gender,
        'handle': user?.handle,
        'newMessages': user?.newMessages,
        'birthDate': user?.birthDate,
        'goals': user?.goals,
        'isAdmin': user?.isAdmin,
        'receivedSecretVote': user?.receivedSecretVote,
        'wantsToTalk': user?.wantsToTalk,
        'discoveriesRemaning': user?.discoveriesRemaning,
        'typsenseId': user?.typsenseId,
        'randomInt': user?.randomInt,
        'isBanned': user?.isBanned,
        'banReason': user?.banReason,
        'banExpiration': user?.banExpiration,
        'seenWaveLikeNotification': user?.seenWaveLikeNotification,
        'seenVoteNotification': user?.seenVoteNotification,
        'verified': user?.verified,
        'seenTutorial': user?.seenTutorial,
        'castFirstVote': user?.castFirstVote,
        'newNotifications': user?.newNotifications,
        'blockedBy': user?.blockedBy,
        'blockedUsers': user?.blockedUsers,
        'blockedUserIds': user?.blockedUserIds,
        'createdAt': user?.createdAt,
        'isPup': user?.isPup,
        'firstUndergrad': user?.firstUndergrad,
        'secondUndergrad': user?.secondUndergrad,
        'thirdUndergrad': user?.thirdUndergrad,
        'postGrad': user?.postGrad,
        'firstStudentOrg': user?.firstStudentOrg,
        'secondStudentOrg': user?.secondStudentOrg,
        'thirdStudentOrg': user?.thirdStudentOrg,
        'firstStudentOrgPosition': user?.firstStudentOrgPosition,
        'secondStudentOrgPosition': user?.secondStudentOrgPosition,
        'thirdStudentOrgPosition': user?.thirdStudentOrgPosition,
        'fraternity': user?.fraternity,
        'fratPosition': user?.fratPosition,
        'favoriteBar': user?.favoriteBar,
        'favoriteSpot': user?.favoriteSpot,
        'assosiatedDorm': user?.assosiatedDorm,
        'worstDorm': user?.worstDorm,
        'intramuralSport': user?.intramuralSport,
        'twitterUrl': user?.twitterUrl,
        'instagramUrl': user?.instagramUrl,
        'snapchatUrl': user?.snapchatUrl,
        'discordUrl': user?.discordUrl,
        'tiktokUrl': user?.tiktokUrl,
        'tinderUrl': user?.tinderUrl,
        'dailyDmsRemaining': user?.dailyDmsRemaining,
        'lastSeaRealTime': user?.lastSeaRealTime,
        'tokens': user?.tokens,
        'prizeIds': user?.prizeIds,
        'goldTokens': user?.goldTokens,
        'silverTokens': user?.silverTokens,
        'bronzeTokens': user?.bronzeTokens,
        'ironTokens': user?.ironTokens,
        'sentFirstSeaReal': user?.sentFirstSeaReal,
      };

  static User fromDynamic(dynamic snap) {
    User user = User(
      id: snap['id'] ?? '',
      name: snap['name'] ?? '',
      age: yearsBetween(snap['birthDate'].toDate() ?? '', DateTime.now()),
      imageUrls: snap['imageUrls'] ?? [],
      jobTitle: snap['jobTitle'] ?? '',
      bio: snap['bio'] ?? '',
      isStingray: snap['isStingray'] ?? false,
      instigations: snap['instigations'] ?? 0,
      votes: snap['votes'] ?? 0,
      votesUsable: snap['votesUsable'] ?? 0,
      isRude: snap['isRude'] ?? false,
      stingrays: snap['stingrays'] ?? [],
      finishedOnboarding: snap['finishedOnboarding'] ?? false,
      gender: snap['gender'] ?? '',
      newMessages: snap['newMessages'] ?? '',
      handle: snap['handle'] ?? '',
      goals: snap['goals'] ?? '',
      birthDate: snap['birthDate'].toDate() ?? '',
      isAdmin: snap['isAdmin'] ?? false,
      receivedSecretVote: snap['receivedSecretVote'] ?? false,
      wantsToTalk: snap['wantsToTalk'] ?? false,
      discoveriesRemaning: snap['discoveriesRemaning'] ?? 0,
      typsenseId: snap['typsenseId'] ?? '',
      randomInt: snap['randomInt'] ?? 0,
      isBanned: snap['isBanned'] ?? false,
      banReason: snap['banReason'] ?? '',
      banExpiration: snap['banExpiration'].toDate() ?? '',
      seenWaveLikeNotification: snap['seenWaveLikeNotification'] ?? false,
      seenVoteNotification: snap['seenVoteNotification'] ?? false,
      verified: snap['verified'] ?? false,
      seenTutorial: snap['seenTutorial'] ?? false,
      castFirstVote: snap['castFirstVote'] ?? false,
      newNotifications: snap['newNotifications'] ?? false,
      blockedBy: snap['blockedBy'] ?? [],
      blockedUsers: snap['blockedUsers'] ?? [],
      blockedUserIds: snap['blockedUserIds'] ?? [],
      createdAt: (snap['createdAt'] ??
              //timestamp of now
              Timestamp.fromDate(DateTime.now()))
          .toDate(),
      isPup: snap['isPup'] ?? false,
      firstUndergrad: snap['firstUndergrad'] ?? 'None',
      secondUndergrad: snap['secondUndergrad'] ?? '',
      thirdUndergrad: snap['thirdUndergrad'] ?? '',
      postGrad: snap['postGrad'] ?? '',
      firstStudentOrg: snap['firstStudentOrg'] ?? '',
      secondStudentOrg: snap['secondStudentOrg'] ?? '',
      thirdStudentOrg: snap['thirdStudentOrg'] ?? '',
      firstStudentOrgPosition: snap['firstStudentOrgPosition'] ?? '',
      secondStudentOrgPosition: snap['secondStudentOrgPosition'] ?? '',
      thirdStudentOrgPosition: snap['thirdStudentOrgPosition'] ?? '',
      fraternity: snap['fraternity'] ?? '',
      fratPosition: snap['fratPosition'] ?? '',
      favoriteBar: snap['favoriteBar'] ?? '',
      favoriteSpot: snap['favoriteSpot'] ?? '',
      assosiatedDorm: snap['assosiatedDorm'] ?? '',
      worstDorm: snap['worstDorm'] ?? '',
      intramuralSport: snap['intramuralSport'] ?? '',
      twitterUrl: snap['twitterUrl'] ?? '',
      instagramUrl: snap['instagramUrl'] ?? '',
      snapchatUrl: snap['snapchatUrl'] ?? '',
      discordUrl: snap['discordUrl'] ?? '',
      tiktokUrl: snap['tiktokUrl'] ?? '',
      tinderUrl: snap['tinderUrl'] ?? '',
      dailyDmsRemaining: snap['dailyDmsRemaining'] ?? 0,
      lastSeaRealTime: (snap['createdAt'] ??
              //timestamp of now
              Timestamp.fromDate(DateTime.now()))
          .toDate(),
      tokens: snap['tokens'] ?? [],
      prizeIds: snap['prizeIds'] ?? [],
      goldTokens: snap['goldTokens'] ?? 0,
      silverTokens: snap['silverTokens'] ?? 0,
      bronzeTokens: snap['bronzeTokens'] ?? 0,
      ironTokens: snap['ironTokens'] ?? 0,
      sentFirstSeaReal: snap['sentFirstSeaReal'] ?? false,
    );

    if (user.gender == '' || user.gender == 'business') {
      user = user.copyWith(gender: 'Male')!;
    }
    return user;
  }

  static User fromSnapshot(DocumentSnapshot snap) {
    Map<String, dynamic>? map = snap.data() as Map<String, dynamic>?;
    DateTime? banExpiration = map?['banExpiration']?.toDate();
    User user = User(
      id: map?['id'] ?? '',
      name: map?['name'] ?? '',
      age: yearsBetween(
          map?['birthDate'].toDate() ?? DateTime.now(), DateTime.now()),
      imageUrls: map?['imageUrls'] ?? [],
      jobTitle: map?['jobTitle'] ?? '',
      bio: map?['bio'] ?? '',
      isStingray: map?['isStingray'] ?? false,
      instigations: map?['instigations'] ?? 0,
      votes: map?['votes'] ?? 0,
      votesUsable: map?['votesUsable'] ?? 0,
      isRude: map?['isRude'] ?? false,
      stingrays: map?['stingrays'] ?? [],
      finishedOnboarding: map?['finishedOnboarding'] ?? false,
      gender: map?['gender'] ?? '',
      newMessages: map?['newMessages'] ?? false,
      handle: map?['handle'] ?? '',
      goals: map?['goals'] ?? [],
      birthDate: map?['birthDate'].toDate() ?? DateTime.now(),
      isAdmin: map?['isAdmin'] ?? false,
      receivedSecretVote: map?['receivedSecretVote'] ?? false,
      wantsToTalk: map?['wantsToTalk'] ?? false,
      discoveriesRemaning: map?['discoveriesRemaning'] ?? 0,
      typsenseId: map?['typsenseId'] ?? '',
      randomInt: map?['randomInt'] ?? 0,
      isBanned: map?['isBanned'] ?? false,
      banReason: map?['banReason'] ?? '',
      banExpiration: banExpiration ?? DateTime.now(),
      seenWaveLikeNotification: map?['seenWaveLikeNotification'] ?? false,
      seenVoteNotification: map?['seenVoteNotification'] ?? false,
      verified: map?['verified'] ?? false,
      seenTutorial: map?['seenTutorial'] ?? false,
      castFirstVote: map?['castFirstVote'] ?? false,
      newNotifications: map?['newNotifications'] ?? false,
      blockedBy: map?['blockedBy'] ?? [],
      blockedUsers: map?['blockedUsers'] ?? [],
      blockedUserIds: map?['blockedUserIds'] ?? [],
      createdAt:
          (map?['createdAt'] ?? Timestamp.fromDate(DateTime.now())).toDate(),
      isPup: map?['isPup'] ?? false,
      firstUndergrad: map?['firstUndergrad'] ?? 'None',
      secondUndergrad: map?['secondUndergrad'] ?? '',
      thirdUndergrad: map?['thirdUndergrad'] ?? '',
      postGrad: map?['postGrad'] ?? '',
      firstStudentOrg: map?['firstStudentOrg'] ?? '',
      secondStudentOrg: map?['secondStudentOrg'] ?? '',
      thirdStudentOrg: map?['thirdStudentOrg'] ?? '',
      firstStudentOrgPosition: map?['firstStudentOrgPosition'] ?? '',
      secondStudentOrgPosition: map?['secondStudentOrgPosition'] ?? '',
      thirdStudentOrgPosition: map?['thirdStudentOrgPosition'] ?? '',
      fraternity: map?['fraternity'] ?? '',
      fratPosition: map?['fratPosition'] ?? '',
      favoriteBar: map?['favoriteBar'] ?? '',
      favoriteSpot: map?['favoriteSpot'] ?? '',
      assosiatedDorm: map?['assosiatedDorm'] ?? '',
      worstDorm: map?['worstDorm'] ?? '',
      intramuralSport: map?['intramuralSport'] ?? '',
      twitterUrl: map?['twitterUrl'] ?? '',
      instagramUrl: map?['instagramUrl'] ?? '',
      snapchatUrl: map?['snapchatUrl'] ?? '',
      discordUrl: map?['discordUrl'] ?? '',
      tiktokUrl: map?['tiktokUrl'] ?? '',
      tinderUrl: map?['tinderUrl'] ?? '',
      dailyDmsRemaining: map?['dailyDmsRemaining'] ?? 0,
      lastSeaRealTime:
          (map?['lastSeaRealTime'] ?? Timestamp.fromDate(DateTime(2000, 1, 1)))
              .toDate(),
      tokens: map?['tokens'] ?? [],
      prizeIds: map?['prizeIds'] ?? [],
      goldTokens: map?['goldTokens'] ?? 0,
      silverTokens: map?['silverTokens'] ?? 0,
      bronzeTokens: map?['bronzeTokens'] ?? 0,
      ironTokens: map?['ironTokens'] ?? 0,
      sentFirstSeaReal: map?['sentFirstSeaReal'] ?? false,
    );
    return user;
  }

  static List<User?> userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map<User?>((doc) {
      Map map = doc.data() as Map;
      return User(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        age: yearsBetween(map['birthDate'].toDate() ?? '', DateTime.now()),
        imageUrls: map['imageUrls'] ?? [],
        jobTitle: map['jobTitle'] ?? '',
        bio: map['bio'] ?? '',
        isStingray: map['isStingray'] ?? false,
        instigations: map['instigations'] ?? 0,
        votes: map['votes'] ?? 0,
        votesUsable: map['votesUsable'] ?? 0,
        isRude: map['isRude'] ?? false,
        stingrays: map['stingrays'] ?? [],
        finishedOnboarding: map['finishedOnboarding'] ?? false,
        gender: map['gender'] ?? '',
        handle: map['handle'] ?? '',
        newMessages: map['newMessages'],
        goals: map['goals'] ?? '',
        birthDate: map['birthDate'].toDate() ?? '',
        isAdmin: map['isAdmin'] ?? false,
        receivedSecretVote: map['receivedSecretVote'] ?? false,
        wantsToTalk: map['wantsToTalk'] ?? false,
        discoveriesRemaning: map['discoveriesRemaning'] ?? 0,
        typsenseId: map['typsenseId'] ?? '',
        randomInt: map['randomInt'] ?? 0,
        isBanned: map['isBanned'] ?? false,
        banReason: map['banReason'] ?? '',
        banExpiration: map['banExpiration'].toDate() ?? '',
        seenWaveLikeNotification: map['seenWaveLikeNotification'] ?? false,
        seenVoteNotification: map['seenVoteNotification'] ?? false,
        verified: map['verified'] ?? false,
        seenTutorial: map['seenTutorial'] ?? false,
        castFirstVote: map['castFirstVote'] ?? false,
        newNotifications: map['newNotifications'] ?? false,
        blockedBy: map['blockedBy'] ?? [],
        blockedUsers: map['blockedUsers'] ?? [],
        blockedUserIds: map['blockedUserIds'] ?? [],
        createdAt: (map['createdAt'] ??
                //timestamp of now
                Timestamp.fromDate(DateTime.now()))
            .toDate(),
        isPup: map['isPup'] ?? false,
        firstUndergrad: map['firstUndergrad'] ?? 'None',
        secondUndergrad: map['secondUndergrad'] ?? '',
        thirdUndergrad: map['thirdUndergrad'] ?? '',
        postGrad: map['postGrad'] ?? '',
        firstStudentOrg: map['firstStudentOrg'] ?? '',
        secondStudentOrg: map['secondStudentOrg'] ?? '',
        thirdStudentOrg: map['thirdStudentOrg'] ?? '',
        firstStudentOrgPosition: map['firstStudentOrgPosition'] ?? '',
        secondStudentOrgPosition: map['secondStudentOrgPosition'] ?? '',
        thirdStudentOrgPosition: map['thirdStudentOrgPosition'] ?? '',
        fraternity: map['fraternity'] ?? '',
        fratPosition: map['fratPosition'] ?? '',
        favoriteBar: map['favoriteBar'] ?? '',
        favoriteSpot: map['favoriteSpot'] ?? '',
        assosiatedDorm: map['assosiatedDorm'] ?? '',
        worstDorm: map['worstDorm'] ?? '',
        intramuralSport: map['intramuralSport'] ?? '',
        twitterUrl: map['twitterUrl'] ?? '',
        instagramUrl: map['instagramUrl'] ?? '',
        snapchatUrl: map['snapchatUrl'] ?? '',
        discordUrl: map['discordUrl'] ?? '',
        tiktokUrl: map['tiktokUrl'] ?? '',
        tinderUrl: map['tinderUrl'] ?? '',
        dailyDmsRemaining: map['dailyDmsRemaining'] ?? 0,
        lastSeaRealTime: (map['lastSeaRealTime'] ??
                //timestamp of now
                Timestamp.fromDate(DateTime.now()))
            .toDate(),
        tokens: map['tokens'] ?? [],
        prizeIds: map['prizeIds'] ?? [],
        goldTokens: map['goldTokens'] ?? 0,
        silverTokens: map['silverTokens'] ?? 0,
        bronzeTokens: map['bronzeTokens'] ?? 0,
        ironTokens: map['ironTokens'] ?? 0,
        sentFirstSeaReal: map['sentFirstSeaReal'] ?? false,
      );
    }).toList();
  }

  static User userFromTypsenseDoc(Map<dynamic, dynamic> e) {
    Map map = e['document'] as Map;
    return User(
      name: map['name'] as String? ?? '',
      id: map['id'] as String?,
      imageUrls: map['imageUrls'] as List<dynamic>? ?? [],
      handle: map['handle'] as String? ?? '',
      votes: map['votes'] as int? ?? 0,
      votesUsable: map['votesUsable'] as int? ?? 0,
      instigations: map['instigations'] as int? ?? 0,
      stingrays: map['stingrays'] as List<dynamic>? ?? [],
      isStingray: map['isStingray'] as bool? ?? false,
      isRude: map['isRude'] as bool? ?? false,
      isAdmin: map['isAdmin'] as bool? ?? false,
      finishedOnboarding: map['finishedOnboarding'] as bool? ?? false,
      wantsToTalk: map['wantsToTalk'] as bool? ?? false,
      receivedSecretVote: map['receivedSecretVote'] as bool? ?? false,
      newMessages: map['newMessages'] as bool? ?? false,
      birthDate: DateTime.fromMillisecondsSinceEpoch(map['birthDate'] * 1000),
      bio: map['bio'] as String? ?? '',
      age: yearsBetween(
          (DateTime.fromMillisecondsSinceEpoch(map['birthDate'] * 1000)),
          DateTime.now()),
      jobTitle: map['jobTitle'] as String,
      goals: map['goals'] as List<dynamic>,
      gender: map['gender'] as String,
      discoveriesRemaning: map['discoveriesRemaning'] as int,
      randomInt: map['randomInt'] as int,
      typsenseId: map['typsenseId'] as String,
      isBanned: (map['isBanned'] as bool?) ?? false,
      banReason: map['banReason'] as String? ?? '',
      banExpiration: DateTime.now(),
      seenVoteNotification: map['seenVoteNotification'] as bool? ?? false,
      seenWaveLikeNotification:
          map['seenWaveLikeNotification'] as bool? ?? false,
      verified: map['verified'] as bool? ?? false,
      seenTutorial: map['seenTutorial'] as bool? ?? false,
      castFirstVote: map['castFirstVote'] as bool? ?? false,
      newNotifications: map['newNotifications'] as bool? ?? false,
      blockedBy: map['blockedBy'] as List<dynamic>? ?? [],
      blockedUsers: map['blockedUsers'] as List<dynamic>? ?? [],
      blockedUserIds: map['blockedUserIds'] as List<dynamic>? ?? [],
      createdAt:
          DateTime.fromMillisecondsSinceEpoch((map['createdAt'] ?? 0) * 1000),
      isPup: map['isPup'] as bool? ?? false,
      firstUndergrad: map['firstUndergrad'] ?? 'None',
      secondUndergrad: map['secondUndergrad'] ?? '',
      thirdUndergrad: map['thirdUndergrad'] ?? '',
      postGrad: map['postGrad'] ?? '',
      firstStudentOrg: map['firstStudentOrg'] ?? '',
      secondStudentOrg: map['secondStudentOrg'] ?? '',
      thirdStudentOrg: map['thirdStudentOrg'] ?? '',
      firstStudentOrgPosition: map['firstStudentOrgPosition'] ?? '',
      secondStudentOrgPosition: map['secondStudentOrgPosition'] ?? '',
      thirdStudentOrgPosition: map['thirdStudentOrgPosition'] ?? '',
      fraternity: map['fraternity'] ?? '',
      fratPosition: map['fratPosition'] ?? '',
      favoriteBar: map['favoriteBar'] ?? '',
      favoriteSpot: map['favoriteSpot'] ?? '',
      assosiatedDorm: map['assosiatedDorm'] ?? '',
      worstDorm: map['worstDorm'] ?? '',
      intramuralSport: map['intramuralSport'] ?? '',
      twitterUrl: map['twitterUrl'] ?? '',
      instagramUrl: map['instagramUrl'] ?? '',
      snapchatUrl: map['snapchatUrl'] ?? '',
      discordUrl: map['discordUrl'] ?? '',
      tiktokUrl: map['tiktokUrl'] ?? '',
      tinderUrl: map['tinderUrl'] ?? '',
      dailyDmsRemaining: map['dailyDmsRemaining'] ?? 0,
      lastSeaRealTime: DateTime.fromMillisecondsSinceEpoch(
          (map['lastSeaRealTime'] ?? 0) * 1000),
      tokens: map['tokens'] as List<dynamic>? ?? [],
      prizeIds: map['prizeIds'] as List<dynamic>? ?? [],
      goldTokens: map['goldTokens'] as int? ?? 0,
      silverTokens: map['silverTokens'] as int? ?? 0,
      bronzeTokens: map['bronzeTokens'] as int? ?? 0,
      ironTokens: map['ironTokens'] as int? ?? 0,
      sentFirstSeaReal: map['sentFirstSeaReal'] ?? false,
    );
  }

  //static method that takes a stingray and returns a user
  static User fromStingray(Stingray stingray) {
    return User(
      id: stingray.id,
      name: stingray.name,
      age: stingray.age,
      imageUrls: stingray.imageUrls,

      jobTitle: stingray.jobTitle,
      bio: stingray.bio,

      handle: stingray.handle,
      //fill in the data not in the stingray with empty values
      receivedSecretVote: false,
      isAdmin: false,
      isStingray: true,
      isRude: false,
      stingrays: [],
      birthDate: stingray.birthDate,

      newMessages: false,
      finishedOnboarding: false,
      wantsToTalk: false,
      discoveriesRemaning: 0,
      typsenseId: stingray.id!,
      randomInt: 0,
      votes: 0,
      votesUsable: 0,
      instigations: 0,
      gender: stingray.gender,
      goals: [],
      isBanned: false,
      banReason: '',
      banExpiration: DateTime.now(),
      seenVoteNotification: false,
      seenWaveLikeNotification: false,
      verified: stingray.verified,
      seenTutorial: false,
      castFirstVote: false,
      newNotifications: false,
      blockedBy: [],
      blockedUsers: [],
      blockedUserIds: [],
      createdAt: DateTime.now(),
      isPup: false,
      firstUndergrad: stingray.firstUndergrad,
      secondUndergrad: stingray.secondUndergrad,
      thirdUndergrad: stingray.thirdUndergrad,
      postGrad: stingray.postGrad,
      firstStudentOrg: stingray.firstStudentOrg,
      secondStudentOrg: stingray.secondStudentOrg,
      thirdStudentOrg: stingray.thirdStudentOrg,
      firstStudentOrgPosition: stingray.firstStudentOrgPosition,
      secondStudentOrgPosition: stingray.secondStudentOrgPosition,
      thirdStudentOrgPosition: stingray.thirdStudentOrgPosition,
      fraternity: stingray.fraternity,
      fratPosition: stingray.fratPosition,
      favoriteBar: stingray.favoriteBar,
      favoriteSpot: stingray.favoriteSpot,
      assosiatedDorm: stingray.assosiatedDorm,
      worstDorm: stingray.worstDorm,
      intramuralSport: stingray.intramuralSport,
      twitterUrl: stingray.twitterUrl,
      instagramUrl: stingray.instagramUrl,
      snapchatUrl: stingray.snapchatUrl,
      discordUrl: stingray.discordUrl,
      tiktokUrl: stingray.tiktokUrl,
      tinderUrl: stingray.tinderUrl,
      dailyDmsRemaining: 0,
      lastSeaRealTime: DateTime.now(),
      tokens: [],
      prizeIds: [],
      goldTokens: 0,
      silverTokens: 0,
      bronzeTokens: 0,
      ironTokens: 0,
      sentFirstSeaReal: false,
    );
  }

  //copywith method that takes all the values of a user and returns a new user with the new values

  User? copyWith({
    String? id,
    String? name,
    int? age,
    List<dynamic>? imageUrls,
    String? bio,
    String? jobTitle,
    String? gender,
    bool? isStingray,
    String? email,
    Team? team,
    int? votes,
    int? votesUsable,
    int? instigations,
    bool? isRude,
    List<dynamic>? stingrays,
    bool? finishedOnboarding,
    String? handle,
    List<Chat?>? chats,
    bool? newMessages,
    List<dynamic>? goals,
    DateTime? birthDate,
    bool? isAdmin,
    bool? receivedSecretVote,
    bool? wantsToTalk,
    int? discoveriesRemaning,
    String? typsenseId,
    int? randomInt,
    bool? isBanned,
    String? banReason,
    DateTime? banExpiration,
    bool? seenWaveLikeNotification,
    bool? seenVoteNotification,
    bool? verified,
    bool? seenTutorial,
    bool? castFirstVote,
    bool? newNotifications,
    List<dynamic>? blockedBy,
    List<dynamic>? blockedUsers,
    List<dynamic>? blockedUserIds,
    DateTime? createdAt,
    bool? isPup,
    String? firstUndergrad,
    String? secondUndergrad,
    String? thirdUndergrad,
    String? postGrad,
    String? firstStudentOrg,
    String? secondStudentOrg,
    String? thirdStudentOrg,
    String? firstStudentOrgPosition,
    String? secondStudentOrgPosition,
    String? thirdStudentOrgPosition,
    String? fraternity,
    String? fratPosition,
    String? favoriteBar,
    String? favoriteSpot,
    String? assosiatedDorm,
    String? worstDorm,
    String? intramuralSport,
    String? twitterUrl,
    String? instagramUrl,
    String? snapchatUrl,
    String? discordUrl,
    String? tiktokUrl,
    String? tinderUrl,
    int? dailyDmsRemaining,
    DateTime? lastSeaRealTime,
    List<dynamic>? tokens,
    List<dynamic>? prizeIds,
    int? goldTokens,
    int? silverTokens,
    int? bronzeTokens,
    int? ironTokens,
    bool? sentFirstSeaReal,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      imageUrls: imageUrls ?? this.imageUrls,
      bio: bio ?? this.bio,
      typsenseId: typsenseId ?? this.typsenseId,
      finishedOnboarding: finishedOnboarding ?? this.finishedOnboarding,
      isAdmin: isAdmin ?? this.isAdmin,
      isStingray: isStingray ?? this.isStingray,
      isRude: isRude ?? this.isRude,
      stingrays: stingrays ?? this.stingrays,
      receivedSecretVote: receivedSecretVote ?? this.receivedSecretVote,
      wantsToTalk: wantsToTalk ?? this.wantsToTalk,
      discoveriesRemaning: discoveriesRemaning ?? this.discoveriesRemaning,
      birthDate: birthDate ?? this.birthDate,
      newMessages: newMessages ?? this.newMessages,
      handle: handle ?? this.handle,
      votes: votes ?? this.votes,
      votesUsable: votesUsable ?? this.votesUsable,
      instigations: instigations ?? this.instigations,
      randomInt: randomInt ?? this.randomInt,
      goals: goals ?? this.goals,
      gender: gender ?? this.gender,
      jobTitle: jobTitle ?? this.jobTitle,
      isBanned: isBanned ?? this.isBanned,
      banReason: banReason ?? this.banReason,
      banExpiration: banExpiration ?? this.banExpiration,
      seenVoteNotification: seenVoteNotification ?? this.seenVoteNotification,
      seenWaveLikeNotification:
          seenWaveLikeNotification ?? this.seenWaveLikeNotification,
      verified: verified ?? this.verified,
      seenTutorial: seenTutorial ?? this.seenTutorial,
      castFirstVote: castFirstVote ?? this.castFirstVote,
      newNotifications: newNotifications ?? this.newNotifications,
      blockedBy: blockedBy ?? this.blockedBy,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      createdAt: createdAt ?? this.createdAt,
      isPup: isPup ?? this.isPup,
      firstUndergrad: firstUndergrad ?? this.firstUndergrad,
      secondUndergrad: secondUndergrad ?? this.secondUndergrad,
      thirdUndergrad: thirdUndergrad ?? this.thirdUndergrad,
      postGrad: postGrad ?? this.postGrad,
      fraternity: fraternity ?? this.fraternity,
      fratPosition: fratPosition ?? this.fratPosition,
      firstStudentOrg: firstStudentOrg ?? this.firstStudentOrg,
      secondStudentOrg: secondStudentOrg ?? this.secondStudentOrg,
      thirdStudentOrg: thirdStudentOrg ?? this.thirdStudentOrg,
      firstStudentOrgPosition:
          firstStudentOrgPosition ?? this.firstStudentOrgPosition,
      secondStudentOrgPosition:
          secondStudentOrgPosition ?? this.secondStudentOrgPosition,
      thirdStudentOrgPosition:
          thirdStudentOrgPosition ?? this.thirdStudentOrgPosition,
      favoriteBar: favoriteBar ?? this.favoriteBar,
      favoriteSpot: favoriteSpot ?? this.favoriteSpot,
      intramuralSport: intramuralSport ?? this.intramuralSport,
      worstDorm: worstDorm ?? this.worstDorm,
      assosiatedDorm: assosiatedDorm ?? this.assosiatedDorm,
      twitterUrl: twitterUrl ?? this.twitterUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      snapchatUrl: snapchatUrl ?? this.snapchatUrl,
      discordUrl: discordUrl ?? this.discordUrl,
      tiktokUrl: tiktokUrl ?? this.tiktokUrl,
      tinderUrl: tinderUrl ?? this.tinderUrl,
      dailyDmsRemaining: dailyDmsRemaining ?? this.dailyDmsRemaining,
      lastSeaRealTime: lastSeaRealTime ?? this.lastSeaRealTime,
      tokens: tokens ?? this.tokens,
      prizeIds: prizeIds ?? this.prizeIds,
      goldTokens: goldTokens ?? this.goldTokens,
      silverTokens: silverTokens ?? this.silverTokens,
      bronzeTokens: bronzeTokens ?? this.bronzeTokens,
      ironTokens: ironTokens ?? this.ironTokens,
      sentFirstSeaReal: sentFirstSeaReal ?? this.sentFirstSeaReal,
    );
  }

  //create a method that returns a generic user where all the values are empty or low
  static User genericUser(String uid) {
    return User(
      isAdmin: false,
      id: uid,
      name: '',
      age: 0,
      imageUrls: [],
      jobTitle: '',
      bio: '',
      isRude: false,
      instigations: 0,
      votes: 0,
      votesUsable: 0,
      stingrays: [],
      finishedOnboarding: false,
      gender: '',
      handle: '',
      newMessages: false,
      goals: [],
      birthDate: DateTime.now(),
      receivedSecretVote: false,
      wantsToTalk: false,
      discoveriesRemaning: 15,
      typsenseId: uid,
      randomInt: //random int here to make sure the user is unique
          0,
      isBanned: false,
      banReason: '',
      banExpiration: DateTime.now(),
      seenVoteNotification: false,
      seenWaveLikeNotification: false,
      verified: false,
      seenTutorial: false,
      castFirstVote: false,
      blockedBy: [],
      blockedUsers: [],
      newNotifications: false,
      createdAt: DateTime.now(),
      blockedUserIds: [],
      isPup: false,
      firstStudentOrg: '',
      secondStudentOrg: '',
      thirdStudentOrg: '',
      postGrad: '',
      favoriteBar: '',
      favoriteSpot: '',
      assosiatedDorm: '',
      worstDorm: '',
      fratPosition: '',
      secondStudentOrgPosition: '',
      thirdStudentOrgPosition: '',
      firstStudentOrgPosition: '',
      fraternity: '',
      intramuralSport: '',
      thirdUndergrad: '',
      firstUndergrad: '',
      secondUndergrad: '',
      instagramUrl: '',
      tiktokUrl: '',
      snapchatUrl: '',
      twitterUrl: '',
      tinderUrl: '',
      discordUrl: '',
      dailyDmsRemaining: 1,
      lastSeaRealTime: DateTime.now(),
      tokens: [],
      prizeIds: [],
      goldTokens: 0,
      silverTokens: 0,
      bronzeTokens: 0,
      ironTokens: 0,
      sentFirstSeaReal: false,
    );
  }

  static User testUser(String uid) {
    return User(
      isAdmin: false,
      id: uid,
      name: 'Test',
      age: 0,
      imageUrls: [
        //give me a random stock image
        'https://images.unsplash.com/photo-1589989369979-7e7b0f2e1b1c?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c3RvY2slMjBpbWFnZXN8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80'
      ],
      jobTitle: '',
      bio: 'test',
      isRude: false,
      instigations: 0,
      votes: 0,
      votesUsable: 0,
      stingrays: [],
      finishedOnboarding: false,
      gender: 'Male',
      handle: '@test',
      newMessages: false,
      goals: [],
      birthDate: DateTime.now(),
      receivedSecretVote: false,
      wantsToTalk: false,
      discoveriesRemaning: 15,
      typsenseId: uid,
      randomInt: //random int here to make sure the user is unique
          0,
      isBanned: false,
      banReason: '',
      banExpiration: DateTime.now(),
      seenVoteNotification: false,
      seenWaveLikeNotification: false,
      verified: false,
      seenTutorial: false,
      castFirstVote: false,
      blockedBy: [],
      blockedUsers: [],
      newNotifications: false,
      createdAt: DateTime.now(),
      blockedUserIds: [],
      isPup: false,
      firstStudentOrg: 'Adventure WV',
      secondStudentOrg: 'Adventure WV',
      thirdStudentOrg: 'Adventure WV',
      postGrad: '',
      favoriteBar: '',
      favoriteSpot: '',
      assosiatedDorm: '',
      worstDorm: '',
      fratPosition: '',
      secondStudentOrgPosition: '',
      thirdStudentOrgPosition: '',
      firstStudentOrgPosition: '',
      fraternity: '',
      intramuralSport: '',
      thirdUndergrad: '',
      firstUndergrad: '',
      secondUndergrad: '',
      instagramUrl: '',
      tiktokUrl: '',
      snapchatUrl: '',
      twitterUrl: '',
      tinderUrl: '',
      discordUrl: '',
      dailyDmsRemaining: 1,
      lastSeaRealTime: DateTime.now(),
      tokens: [],
      prizeIds: [],
      goldTokens: 0,
      silverTokens: 0,
      bronzeTokens: 0,
      ironTokens: 0,
      sentFirstSeaReal: false,
    );
  }

  static User anon(String id) {
    User _user = User.genericUser(id);

    Avatar _avatar = DiceBearBuilder(
      sprite: DiceBearSprite.bottts,
      seed: id,
    ).build();

    String _avatarUrl = _avatar.svgUri.toString();
    return _user.copyWith(imageUrls: [_avatarUrl])!;
  }
}

int yearsBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  int i = (((to.difference(from).inHours / 24)) / 365).floor();

  print(i);
  return i;
}