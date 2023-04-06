import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/sea_real/sea_real_bloc.dart';
import 'package:hero/blocs/wave/wave_bloc.dart' as wave;
import 'package:hero/helpers/get.dart';
import 'package:hero/helpers/go_to_replies.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/waves/widget/wave_tile.dart';

class SeaRealsList extends StatefulWidget {
  const SeaRealsList({
    super.key,
  });

  @override
  State<SeaRealsList> createState() => _SeaRealsListState();
}

class _SeaRealsListState extends State<SeaRealsList> {
  late ScrollController _scrollController;
  initState() {
    super.initState();
    //if searealState is not loaded, then load it
    if (context.read<SeaRealBloc>().state is SeaRealLoading) {
      context.read<SeaRealBloc>().add(LoadSeaReal(user: Get.blocUser(context)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeaRealBloc, SeaRealState>(
      builder: (context, seaRealState) {
        if (seaRealState is SeaRealLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seaRealState.waves.length,
            cacheExtent: 1000,
            itemBuilder: (context, index) {
              Wave _wave = seaRealState.waves[index]!;
              User? _poster = seaRealState.userPool
                  .firstWhereOrNull((user) => user!.id == _wave.senderId)!;
              WaveTile? _waveTile = (_poster == null)
                  ? null
                  : WaveTile(
                      wave: _wave,
                      poster: _poster,
                      onDeleted: () {
                        BlocProvider.of<wave.WaveBloc>(context)
                            .add(wave.DeleteWave(wave: _wave));

                        Navigator.pop(context);
                      },
                    );
              return (_waveTile == null)
                  ? Container()
                  : GestureDetector(
                      child: _waveTile,
                      onTap: () => GoTo.replies(_waveTile, context));
            },
          );
        }
        return Container();
      },
    );
  }
}
