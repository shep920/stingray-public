import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';
import 'package:hero/widgets/top_appBar.dart';

class AllWavesScreen extends StatefulWidget {
  final User voteUser;

  //add a routename and route method
  static const String routeName = '/all-waves';
  static Route route({required User voteUser}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => AllWavesScreen(voteUser: voteUser));
  }

  AllWavesScreen({required this.voteUser});

  @override
  _WavesListState createState() => _WavesListState();
}

class _WavesListState extends State<AllWavesScreen> {
  late List<Wave?> _waves;
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _waves = [];
    _fetchWaves();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset /
            (_scrollController.position.maxScrollExtent) >
        0.95) {
      _fetchWaves();
    }
  }

  void _fetchWaves() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      QuerySnapshot<Object?> querySnapshot = await FirestoreRepository()
          .getAllWaves(widget.voteUser.id!, _lastDocument);

      List<Wave?> newWaves = querySnapshot.docs
          .map((doc) => Wave.waveFromMap(doc.data() as Map<String, dynamic>))
          .toList();

      setState(() {
        _waves.addAll(newWaves);
        _isLoading = false;
        _lastDocument = querySnapshot.docs.last;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      body: _waves.isEmpty
          ? Center(
              child: Text('No waves yet'),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _waves.length,
              itemBuilder: (context, index) {
                Wave _wave = _waves[index]!;
                return WaveTile(
                  wave: _wave,
                  poster: widget.voteUser,
                );
              },
            ),
    );
  }
}
