import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/models.dart';
import 'package:hero/models/user_model.dart';


class Stingray extends Equatable {
  final String? id;
  final String name;
  final int age;
  final List<dynamic> imageUrls;

  final String bio;
  final String jobTitle;
  final String gender;

  final DateTime birthDate;
  final int redFlags;
  final String handle;
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
  final bool verified;
  final List<dynamic> stories;

  const Stingray({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrls,
    required this.bio,
    required this.jobTitle,
    required this.gender,
    required this.birthDate,
    required this.redFlags,
    required this.handle,
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
    required this.verified,
    required this.stories,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        age,
        imageUrls,
        bio,
        jobTitle,
        gender,
        birthDate,
        redFlags,
        handle,
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
        verified,
        stories,
      ];

  static Stingray? stingrayFromSnapshot(DocumentSnapshot snapshot) {
    Map map = snapshot.data() as Map;
    return Stingray(
      id: snapshot['id'],
      name: snapshot['name'],
      age: yearsBetween(snapshot['birthDate'].toDate() ?? '', DateTime.now()),
      imageUrls: snapshot['imageUrls'],
      jobTitle: snapshot['jobTitle'],
      bio: snapshot['bio'],
      gender: snapshot['gender'] ?? [],
      birthDate: snapshot['birthDate'].toDate(),
      redFlags: snapshot['redFlags'],
      handle: snapshot['handle'],
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
      postGrad: map['postGrad'] ?? '',
      firstUndergrad: map['firstUndergrad'] ?? '',
      secondUndergrad: map['secondUndergrad'] ?? '',
      thirdUndergrad: map['thirdUndergrad'] ?? '',
      twitterUrl: map['twitterUrl'] ?? '',
      instagramUrl: map['instagramUrl'] ?? '',
      snapchatUrl: map['snapchatUrl'] ?? '',
      discordUrl: map['discordUrl'] ?? '',
      tiktokUrl: map['tiktokUrl'] ?? '',
      tinderUrl: map['tinderUrl'] ?? '',
      verified: map['verified'] ?? false,
      stories: map['stories'] ?? [],
    );
  }

  static Stingray stingrayFromDynamic(dynamic stingray) {
    return Stingray(
      id: stingray['id'],
      name: stingray['name'],
      age: 22,
      // age: yearsBetween(stingray['birthDate'] ?? '', DateTime.now()),
      imageUrls: stingray['imageUrls'],

      jobTitle: stingray['jobTitle'],
      bio: stingray['bio'],

      gender: stingray['gender'] ?? [],

      birthDate: stingray['birthDate'].toDate(),

      redFlags: stingray['redFlags'],
      handle: stingray['handle'],
      firstStudentOrg: stingray['firstStudentOrg'] ?? '',
      secondStudentOrg: stingray['secondStudentOrg'] ?? '',
      thirdStudentOrg: stingray['thirdStudentOrg'] ?? '',
      firstStudentOrgPosition: stingray['firstStudentOrgPosition'] ?? '',
      secondStudentOrgPosition: stingray['secondStudentOrgPosition'] ?? '',
      thirdStudentOrgPosition: stingray['thirdStudentOrgPosition'] ?? '',
      fraternity: stingray['fraternity'] ?? '',
      fratPosition: stingray['fratPosition'] ?? '',
      favoriteBar: stingray['favoriteBar'] ?? '',
      favoriteSpot: stingray['favoriteSpot'] ?? '',
      assosiatedDorm: stingray['assosiatedDorm'] ?? '',
      worstDorm: stingray['worstDorm'] ?? '',
      intramuralSport: stingray['intramuralSport'] ?? '',
      postGrad: stingray['postGrad'] ?? '',
      firstUndergrad: stingray['firstUndergrad'] ?? '',
      secondUndergrad: stingray['secondUndergrad'] ?? '',
      thirdUndergrad: stingray['thirdUndergrad'] ?? '',
      twitterUrl: stingray['twitterUrl'] ?? '',
      instagramUrl: stingray['instagramUrl'] ?? '',
      snapchatUrl: stingray['snapchatUrl'] ?? '',
      discordUrl: stingray['discordUrl'] ?? '',
      tiktokUrl: stingray['tiktokUrl'] ?? '',
      tinderUrl: stingray['tinderUrl'] ?? '',
      verified: stingray['verified'] ?? false,
      stories: stingray['stories'] ?? [],
    );
  }

  static Map<String, dynamic> toJson(Stingray? stingray) => {
        'id': stingray?.id,
        'name': stingray?.name,
        'age': stingray?.age,
        'imageUrls': stingray?.imageUrls,
        'bio': stingray?.bio,
        'jobTitle': stingray!.jobTitle,
        'gender': stingray.gender,
        'handle': stingray.handle,
        'birthDate': stingray.birthDate,
        'redFlags': stingray.redFlags,
        'firstStudentOrg': stingray.firstStudentOrg,
        'secondStudentOrg': stingray.secondStudentOrg,
        'thirdStudentOrg': stingray.thirdStudentOrg,
        'firstStudentOrgPosition': stingray.firstStudentOrgPosition,
        'secondStudentOrgPosition': stingray.secondStudentOrgPosition,
        'thirdStudentOrgPosition': stingray.thirdStudentOrgPosition,
        'fraternity': stingray.fraternity,
        'fratPosition': stingray.fratPosition,
        'favoriteBar': stingray.favoriteBar,
        'favoriteSpot': stingray.favoriteSpot,
        'assosiatedDorm': stingray.assosiatedDorm,
        'worstDorm': stingray.worstDorm,
        'intramuralSport': stingray.intramuralSport,
        'postGrad': stingray.postGrad,
        'stories': stingray.stories,
      };

  static Stingray generateStingrayFromUser(User user) {
    return Stingray(
      id: user.id,
      name: user.name,
      age: user.age,
      imageUrls: user.imageUrls,
      jobTitle: user.jobTitle,
      bio: user.bio,
      redFlags: 0,
      handle: user.handle,
      birthDate: user.birthDate,
      gender: user.gender,
      firstStudentOrg: user.firstStudentOrg,
      secondStudentOrg: user.secondStudentOrg,
      thirdStudentOrg: user.thirdStudentOrg,
      firstStudentOrgPosition: user.firstStudentOrgPosition,
      secondStudentOrgPosition: user.secondStudentOrgPosition,
      thirdStudentOrgPosition: user.thirdStudentOrgPosition,
      fraternity: user.fraternity,
      fratPosition: user.fratPosition,
      favoriteBar: user.favoriteBar,
      favoriteSpot: user.favoriteSpot,
      assosiatedDorm: user.assosiatedDorm,
      worstDorm: user.worstDorm,
      intramuralSport: user.intramuralSport,
      postGrad: user.postGrad,
      firstUndergrad: user.firstUndergrad,
      secondUndergrad: user.secondUndergrad,
      thirdUndergrad: user.thirdUndergrad,
      twitterUrl: user.twitterUrl,
      instagramUrl: user.instagramUrl,
      snapchatUrl: user.snapchatUrl,
      discordUrl: user.discordUrl,
      tiktokUrl: user.tiktokUrl,
      tinderUrl: user.tinderUrl,
      verified: user.verified,
      stories: [],
    );
  }

  static Stingray featuredStingray() {
    User _user = User.genericUser("featured");
    Stingray _stingray = Stingray.generateStingrayFromUser(_user);
    return _stingray;
  }
}
