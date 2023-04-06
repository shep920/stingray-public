import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/models.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

//make the class, StingrayStatsDoc that extends equatable. It has a string stingrayId, an int likes, an int replies, an int dislikes, an int wavesPosted
class StingrayStatsDoc extends Equatable {
  final String stingrayId;
  final int likes;
  
  final int dislikes;
  

  StingrayStatsDoc(
      {required this.stingrayId,
      required this.likes,
      
      required this.dislikes,
      });

  @override
  List<Object?> get props =>
      [stingrayId, likes, dislikes];

  static StingrayStatsDoc stingrayStatsDocFromMap(Map<String, dynamic> map) {
    return StingrayStatsDoc(
      stingrayId: map['stingrayId'],
      likes: map['likes'],
      
      dislikes: map['dislikes'],
      
    );
  }

  static List<StingrayStatsDoc> stingrayStatsDocListFromMap(
      List<dynamic> mappedStingrayStatsDocs) {
    List<StingrayStatsDoc> stingrayStatsDocList = [];
    for (Map<String, dynamic> stingrayStatsDoc in mappedStingrayStatsDocs) {
      stingrayStatsDocList
          .add(StingrayStatsDoc.stingrayStatsDocFromMap(stingrayStatsDoc));
    }
    return stingrayStatsDocList;
  }

  static List<StingrayStatsDoc> stingrayStatsDocListFromQuerySnapshot(
      QuerySnapshot querySnapshot) {
    List<StingrayStatsDoc> stingrayStatsDocList = [];
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      stingrayStatsDocList.add(StingrayStatsDoc.stingrayStatsDocFromMap(
          doc.data() as Map<String, dynamic>));
    }

    return stingrayStatsDocList;
  }

  static StingrayStatsDoc stingrayStatsDocFromTypesenseDoc(
      Map<dynamic, dynamic> e) {
    Map<String, dynamic> map = e['document'] as Map<String, dynamic>;
    return StingrayStatsDoc(
      stingrayId: map['stingrayId'],
      likes: map['likes'],
      
      dislikes: map['dislikes'],
      
    );
  }

  static StingrayStatsDoc genericStingrayStatsDoc(
      {String? stingrayId,
      int? likes,
      //continue
      
      int? dislikes,
      }) {
    final String newId = Uuid().v4();
    return StingrayStatsDoc(
      stingrayId: (stingrayId == null) ? newId : stingrayId,
      likes: likes ?? 0,
      
      dislikes: dislikes ?? 0,
      
    );
  }

  Map<String, dynamic> toJson() => {
        'stingrayId': stingrayId,
        'likes': likes,
        
        'dislikes': dislikes,
        
      };
}


// a class, Prize, that has a string id, a string name, a string description, a string imageUrl, a string prizeValue
