import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/sea_real/sea_real_bloc.dart';
import 'package:hero/helpers/get.dart';
import 'package:hero/models/posts/wave_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/home_screens/views/waves/sea_real/compose_sea_real_screen.dart';
import 'package:hero/screens/home/home_screens/votes/sea_real_list.dart';

class SeaRealScreen extends StatefulWidget {
  const SeaRealScreen({super.key});

  @override
  State<SeaRealScreen> createState() => _SeaRealScreenState();
}

class _SeaRealScreenState extends State<SeaRealScreen> {
  late ScrollController _scrollController;
  initState() {
    super.initState();
    //if searealState is not loaded, then load it
    if (context.read<SeaRealBloc>().state is SeaRealLoading) {
      context.read<SeaRealBloc>().add(LoadSeaReal(user: Get.blocUser(context)));
    }

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * .75) {
        if (BlocProvider.of<SeaRealBloc>(context, listen: false).state
            is SeaRealLoaded) {
          SeaRealLoaded state =
              BlocProvider.of<SeaRealBloc>(context, listen: false).state
                  as SeaRealLoaded;
          if (!state.loading && state.hasMore) {
            print('reached end of list');

            BlocProvider.of<SeaRealBloc>(context, listen: false)
                .add((PaginateWaves(user: Get.blocUser(context))));
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<SeaRealBloc>(context, listen: false)
            .add((LoadSeaReal(user: Get.blocUser(context))));
      },
      child: ListView(
        cacheExtent: 1000,
        controller: _scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sea Real',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
                Flexible(
                  child: IconButton(
                    onPressed: () {
                      AwesomeDialog(
                        titleTextStyle: Theme.of(context).textTheme.headline2,
                        descTextStyle: Theme.of(context).textTheme.headline5,
                        context: context,
                        dialogType: DialogType.info,
                        borderSide: const BorderSide(
                          color: Colors.green,
                          width: 2,
                        ),
                        width: 680,
                        buttonsBorderRadius: const BorderRadius.all(
                          Radius.circular(2),
                        ),
                        dismissOnTouchOutside: true,
                        dismissOnBackKeyPress: false,
                        headerAnimationLoop: false,
                        animType: AnimType.bottomSlide,
                        title: 'SeaReal',
                        desc:
                            'This is SeaReal. You can post once a day here. Posting posting from 10-10:02pm gets you an extra vote!',
                        showCloseIcon: true,
                        btnOkOnPress: () {},
                      ).show();
                    },
                    icon: const Icon(Icons.help),
                  ),
                ),
              ],
            ),
          ),
          //an elevatedButton that takes you to the seaRealPostScreen
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ComposeSeaRealScreen.routeName);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Make a Sea Real!',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Theme.of(context).accentColor,
                          )),
                  Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).accentColor,
                  )
                ],
              ),
              //color it green
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),

          SeaRealsList(),
        ],
      ),
    );
  }
}
