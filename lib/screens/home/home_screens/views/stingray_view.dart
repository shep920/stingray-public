import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../blocs/swipe/swipe_bloc.dart';
import '../../../../blocs/typesense/bloc/search_bloc.dart';
import '../../../../models/models.dart';
import '../../../../widgets/action_button.dart';
import '../../../../widgets/expandable_fab.dart';
import '../../../../widgets/top_appBar.dart';
import '../../../../widgets/user_card.dart';
import 'generic_view.dart';

class StingrayView extends StatefulWidget {
  const StingrayView({
    Key? key,
    this.localUser,
  }) : super(key: key);

  final User? localUser;

  @override
  State<StingrayView> createState() => _StingrayViewState();
}

class _StingrayViewState extends State<StingrayView> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ExpandableFab(
              distance: 150,
              children: [
                ActionButton(
                  icon: const Icon(
                    //an icon that shows a pen
                    Icons.edit,

                    color: Colors.white,
                  ),
                  onPressed: () {
                    //push named route of bitch
                    Navigator.pushNamed(context, '/compose-wave');
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: //padding to the left
                const EdgeInsets.only(left: 30.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  onPressed: () {},
                  child: Switch(
                    value: isSwitched,
                    onChanged: (val) {
                      setState(() {
                        isSwitched = val;
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: Theme.of(context).secondaryHeaderColor,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: (!isSwitched)
          ? BlocBuilder<SwipeBloc, SwipeState>(
              builder: (context, state) {
                if (state is SwipeLoading) {
                  Provider.of<SearchBloc>(context, listen: false).add(
                      QuerySwipeUsers(
                          user: widget.localUser!, context: context));
                  return Center(child: CircularProgressIndicator());
                } else if (state is SwipeLoaded) {
                  return (state.users.isEmpty)
                      ? Center(
                          child: Text("No users found"),
                        )
                      : Column(
                          children: [
                            InkWell(
                              onDoubleTap: () {
                                Navigator.pushNamed(context, '/users',
                                    arguments: state.users[0]);
                              },
                              child: Draggable(
                                child: UserCard(
                                  user: state.users[0],
                                  imageUrlIndex: state.imageUrlIndex,
                                ),
                                feedback: UserCard(
                                  user: state.users[0],
                                  imageUrlIndex: state.imageUrlIndex,
                                ),
                                childWhenDragging: (state.users.length > 1)
                                    ? UserCard(
                                        user: state.users[1],
                                        imageUrlIndex: 0,
                                      )
                                    : Center(
                                        child: Text("No users found"),
                                      ),
                                onDragEnd: (drag) {
                                  if (drag.velocity.pixelsPerSecond.dx < 0 &&
                                      drag.offset.distance >
                                          MediaQuery.of(context).size.width *
                                              .3) {
                                    context.read<SwipeBloc>()
                                      ..add(SwipeLeft(
                                          user: state.users[0],
                                          stingrayId: widget.localUser!.id!,
                                          context: context,
                                          swiper: widget.localUser!));
                                    print('Swiped left');
                                  } else if (drag.velocity.pixelsPerSecond.dx >
                                          0 &&
                                      drag.offset.distance >
                                          MediaQuery.of(context).size.width *
                                              .3) {
                                    context.read<SwipeBloc>()
                                      ..add(SwipeRight(
                                          user: state.users[0],
                                          id: widget.localUser!.id,
                                          stingrayImageUrl:
                                              widget.localUser!.imageUrls[0],
                                          context: context,
                                          swiper: widget.localUser!,
                                          stingrayId: widget.localUser!.id!));
                                    print('swiped right');
                                  }
                                },
                              ),
                            ),
                          ],
                        );
                } else if (state is SwipeError) {
                  return Center(
                    child: Text("No users found"),
                  );
                } else {
                  return Text('Somethings wrong, yo');
                }
              },
            )
          : GenericView(),
    );
  }
}
