import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/models/posts/wave_model.dart';

class WaveTilePopup extends StatelessWidget {
  const WaveTilePopup({
    Key? key,
    required this.poster,
    required this.onDeleted,
    required this.wave,
    required this.user,
    this.size,
    this.color,
  }) : super(key: key);

  final User poster;
  final Wave wave;
  final User user;
  final VoidCallback? onDeleted;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      child: Container(
        margin: EdgeInsets.only(right: 15),
        child: Icon(Icons.more_horiz, size: size, color: color),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                          'Are you sure you want to report this wave?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            BlocProvider.of<WaveBloc>(context).add(ReportWave(
                                reported: poster, wave: wave, reporter: user));
                            Navigator.pop(context);
                          },
                          child: Text('Report'),
                        ),
                      ],
                    );
                  });
            },
            child: Text('Report'),
          ),
        ),
        //a popup menu item to delete the wave
        if (user.id == poster.id)
          PopupMenuItem(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                            Text('Are you sure you want to delete this wave?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              onDeleted!();
                            },
                            child: Text(
                              'Delete',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Text(
                'Delete',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.red),
              ),
            ),
          ),
      ],
    );
  }
}
