import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/models.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Wave extends Equatable {
  final String id;
  final String typesenseId;
  final String senderId;
  final String? imageUrl;
  final String message;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final List<dynamic> likedBy;
  final String? replyTo;
  final int popularity;
  final String? threadId;
  final List<dynamic>? replyToHandles;
  final String type;
  final int dislikes;
  final List<dynamic> dislikedBy;
  final String? videoUrl;
  final String style;
  final List<dynamic>? bubbleImageUrls;
  final String frontImageUrl;
  final String backImageUrl;
  final bool retaken;

  const Wave({
    required this.id,
    required this.senderId,
    required this.message,
    required this.createdAt,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.likedBy,
    required this.typesenseId,
    this.replyTo,
    required this.popularity,
    required this.threadId,
    required this.replyToHandles,
    required this.type,
    required this.dislikes,
    required this.dislikedBy,
    required this.videoUrl,
    required this.style,
    required this.bubbleImageUrls,
    required this.frontImageUrl,
    required this.backImageUrl,
    required this.retaken,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        message,
        createdAt,
        imageUrl,
        likes,
        comments,
        likedBy,
        typesenseId,
        replyTo,
        popularity,
        threadId,
        replyToHandles,
        type,
        dislikes,
        dislikedBy,
        videoUrl,
        style,
        bubbleImageUrls,
        frontImageUrl,
        backImageUrl,
        retaken,
      ];

  static Map<String, dynamic> toJson(Wave? wave) => {
        'id': wave?.id,
        'senderId': wave?.senderId,
        'message': wave?.message,
        'createdAt': wave?.createdAt,
        'imageUrl': //if imageUrl is null, return null, else return imageUrl
            wave?.imageUrl == null ? null : wave?.imageUrl,
        'likes': wave?.likes,
        'comments': wave?.comments,
        'likedBy': wave?.likedBy,
        'typesenseId': wave?.typesenseId,
        'replyTo': wave?.replyTo == null ? 'null' : wave?.replyTo,
        'popularity': wave?.popularity,
        'threadId': wave?.threadId,
        'replyToHandles': wave?.replyToHandles,
        'type': wave?.type,
        'dislikes': wave?.dislikes,
        'dislikedBy': wave?.dislikedBy,
        'videoUrl': wave?.videoUrl ?? 'noVideo',
        'style': wave?.style ?? 'default',
        'bubbleImageUrls': wave?.bubbleImageUrls,
        'frontImageUrl': wave?.frontImageUrl ?? '',
        'backImageUrl': wave?.backImageUrl ?? '',
        'retaken': wave?.retaken ?? false,
      };

  static List<Map<String, dynamic>> waveListToJson(List<Wave?> waves) {
    List<Map<String, dynamic>> waveList = [];
    for (Wave? wave in waves) {
      waveList.add(Wave.toJson(wave));
    }
    return waveList;
  }

  static Wave waveFromMap(dynamic wave) {
    return Wave(
      id: wave['id'],
      senderId: wave['senderId'],
      message: wave['message'],
      createdAt: wave['createdAt'].toDate(),
      imageUrl: wave['imageUrl'],
      likes: wave['likes'],
      comments: wave['comments'],
      likedBy: wave['likedBy'],
      typesenseId: wave['typesenseId'],
      replyTo: wave['replyTo'],
      popularity: //if the popularity is null or a Timestamp, return 0, else return popularity
          (wave['popularity'] == null || wave['popularity'] is Timestamp)
              ? 0
              : wave['popularity'],
      threadId: wave['threadId'],
      replyToHandles: wave['replyToHandles'] ?? [],
      type: wave['type'] ?? default_type,
      dislikes: wave['dislikes'] ?? 0,
      dislikedBy: wave['dislikedBy'] ?? [],
      videoUrl: wave['videoUrl'],
      style: wave['style'] ?? 'default',
      bubbleImageUrls: wave['bubbleImageUrls'],
      frontImageUrl: wave['frontImageUrl'] ?? '',
      backImageUrl: wave['backImageUrl'] ?? '',
      retaken: wave['retaken'] ?? false,
    );
  }

  static List<Wave?> waveListFromMap(dynamic mappedWaves) {
    List<Wave> waveList = [];
    for (Map<String, dynamic> wave in mappedWaves) {
      waveList.add(Wave.waveFromMap(wave));
    }
    return waveList;
  }

  static List<Wave?> waveListFromQuerySnapshot(QuerySnapshot querySnapshot) {
    List<Wave> waveList = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      waveList.add(Wave.waveFromMap(doc.data()));
    }

    return waveList;
  }

  static Wave waveFromTypesenseDoc(Map<dynamic, dynamic> e) {
    Map<String, dynamic> map = e['document'] as Map<String, dynamic>;
    return Wave(
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          ((e['document'] as Map)['createdAt'] as int) * 1000),
      id: (e['document'] as Map)['id'] as String,
      imageUrl: (e['document'] as Map)['imageUrl'] as String?,
      likes: (e['document'] as Map)['likes'] as int,
      comments: (e['document'] as Map)['comments'] as int,
      likedBy: (e['document'] as Map)['likedBy'] as List<dynamic>,
      message: (e['document'] as Map)['message'] as String,
      senderId: (e['document'] as Map)['senderId'] as String,
      typesenseId: (e['document'] as Map)['id'] as String,
      replyTo: (e['document'] as Map)['replyTo'] as String?,
      popularity: (Timestamp.now().seconds),
      threadId: map['threadId'],
      replyToHandles: map['replyToHandles'] ?? [],
      type: map['type'] ?? default_type,
      dislikes: map['dislikes'] ?? 0,
      dislikedBy: map['dislikedBy'] ?? [],
      videoUrl: map['videoUrl'],
      style: map['style'] ?? 'default',
      bubbleImageUrls: map['bubbleImageUrls'],
      frontImageUrl: map['frontImageUrl'] ?? '',
      backImageUrl: map['backImageUrl'] ?? '',
      retaken: map['retaken'] ?? false,
    );
  }

  static Wave genericWave(
      {String? threadId,
      String? replyTo,
      List<dynamic>? replyToHandles,
      String? id,
      String? imageUrl,
      String? type,
      String? videoUrl,
      required String message,
      required String senderId,
      String? style,
      List<dynamic>? bubbleImageUrls,
      int comments = 0,
      String? frontImageUrl,
      String? backImageUrl,
      bool? retaken}) {
    final String newId = Uuid().v4();
    return Wave(
      id: (id == null) ? newId : id,
      senderId: senderId,
      message: message,
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
      likes: 0,
      comments: comments,
      likedBy: [],
      typesenseId: (id == null) ? newId : id,
      replyTo: replyTo,
      popularity: //convert timestamp.now to an int
          Timestamp.now().seconds,
      threadId: threadId,
      replyToHandles: replyToHandles ?? [],
      type: type ?? default_type,
      dislikes: 0,
      dislikedBy: [],
      videoUrl: videoUrl,
      style: style ?? 'default',
      bubbleImageUrls: bubbleImageUrls ?? [],
      frontImageUrl: frontImageUrl ?? '',
      backImageUrl: backImageUrl ?? '',
      retaken: retaken ?? false,
    );
  }

  //make a copyWith method that returns a new Wave object with the same properties as the original Wave object, but with the properties that are passed in as arguments changed to the new values
  Wave copyWith({
    String? id,
    String? senderId,
    String? message,
    DateTime? createdAt,
    String? imageUrl,
    int? likes,
    int? comments,
    List<dynamic>? likedBy,
    String? typesenseId,
    String? replyTo,
    int? popularity,
    String? threadId,
    List<dynamic>? replyToHandles,
    String? type,
    int? dislikes,
    List<dynamic>? dislikedBy,
    String? videoUrl,
    String? style,
    List<dynamic>? bubbleImageUrls,
    String? frontImageUrl,
    String? backImageUrl,
    bool? retaken,
  }) {
    return Wave(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      likedBy: likedBy ?? this.likedBy,
      typesenseId: typesenseId ?? this.typesenseId,
      replyTo: replyTo ?? this.replyTo,
      popularity: popularity ?? this.popularity,
      threadId: threadId ?? this.threadId,
      replyToHandles: replyToHandles ?? this.replyToHandles,
      type: type ?? this.type,
      dislikes: dislikes ?? this.dislikes,
      dislikedBy: dislikedBy ?? this.dislikedBy,
      videoUrl: videoUrl ?? this.videoUrl,
      style: style ?? this.style,
      bubbleImageUrls: bubbleImageUrls ?? this.bubbleImageUrls,
      frontImageUrl: frontImageUrl ?? this.frontImageUrl,
      backImageUrl: backImageUrl ?? this.backImageUrl,
      retaken: retaken ?? this.retaken,
    );
  }

  static String default_type = 'default';
  static String yip_yap_type = 'yip_yap';

  static String defaultStyle = 'default';
  static String bubbleStyle = 'bubble';
  static String seaRealStyle = 'seaReal';
}

//make the class, YipYap, that extends Wave

