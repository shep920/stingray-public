import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hero/models/models.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:intl/intl.dart';

class WavesMeta extends Equatable {
  final Stingray stingray;
  final List<Wave?> waves;
  final bool hasMore;
  final DocumentSnapshot? lastDoc;

  WavesMeta({
    required this.stingray,
    required this.waves,
    required this.hasMore,
    this.lastDoc,
  });

  @override
  List<Object?> get props => [
        stingray,
        waves,
        hasMore,
        lastDoc,
      ];
}
