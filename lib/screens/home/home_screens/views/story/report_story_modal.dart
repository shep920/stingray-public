import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/stingrays/stingray_bloc.dart';
import 'package:hero/models/stories/story_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/screens/home/main_page.dart';

class ReportStoryModal extends StatelessWidget {
  const ReportStoryModal({
    super.key,
    required User user,
    required User stingrayUser,
    required Story currentStory,
  })  : _user = user,
        _stingrayUser = stingrayUser,
        _currentStory = currentStory;

  final User _user;
  final User _stingrayUser;
  final Story _currentStory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.report),
            title: Text(
              'Report',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Roboto',
              ),
            ),
            onTap: () {
              BlocProvider.of<StingrayBloc>(context).add(ReportStory(
                reporter: _user,
                reportedUser: _stingrayUser,
                story: _currentStory,
              ));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Story reported',
                  ),
                ),
              );
              Navigator.of(context).pop();
            },
          ),
          if (_user.id == _stingrayUser.id)
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.trash,
                color: Colors.red,
              ),
              title: Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                BlocProvider.of<StingrayBloc>(context).add(DeleteStory(
                  story: _currentStory,
                ));
                //pop until named route
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(MainPage.routeName));
              },
            ),
        ],
      ),
    );
  }
}
