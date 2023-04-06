import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/wave/wave_bloc.dart';
import 'package:hero/repository/typesense_repo.dart';

class HotAndRecentSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaveBloc, WaveState>(
      builder: (context, waveState) {
        if (waveState is WaveLoaded) {
          String featureSortParam = waveState.featureSortParam;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: 50,
                color: Colors.grey.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton(
                      context,
                      icon: FontAwesomeIcons.clock,
                      label: 'Recent',
                      color: (featureSortParam == TsKeywords.newParam)
                          ? Colors.blue
                          : Colors.grey.withOpacity(0.5),
                      onPressed: () {
                        if (featureSortParam != TsKeywords.newParam) {
                          BlocProvider.of<WaveBloc>(context).add(
                            UpdateSortParam(
                              sortParam: TsKeywords.newParam,
                            ),
                          );
                        }
                      },
                    ),
                    buildButton(
                      context,
                      icon: FontAwesomeIcons.fire,
                      label: 'Hot',
                      color: (featureSortParam == TsKeywords.hotParam)
                          ? Colors.red
                          : Colors.grey.withOpacity(0.5),
                      onPressed: () {
                        if (featureSortParam != TsKeywords.hotParam) {
                          BlocProvider.of<WaveBloc>(context).add(
                            UpdateSortParam(
                              sortParam: TsKeywords.hotParam,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        children: [
          FaIcon(icon, color: color, size: 25),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 25),
          ),
        ],
      ),
    );
  }
}
