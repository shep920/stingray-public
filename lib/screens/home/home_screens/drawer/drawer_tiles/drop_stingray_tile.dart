import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/screens/home/home_screens/drawer/drawer_tiles/whats_missing_screen.dart';
import 'package:hero/screens/home/home_screens/views/backpack/backpack_screen.dart';
import 'package:hero/screens/home/home_screens/views/prizes_screen/prize_shelf_screen.dart';

class DopStingrayTile extends StatelessWidget {
  const DopStingrayTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          FaIcon(FontAwesomeIcons.triangleExclamation, color: Colors.amber),
      title: Text('Stop being a Stingray',
          style: Theme.of(context).textTheme.headline4!),
      onTap: () {
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
                title: "Stop being a Stingray",
                desc:
                    "Pressing this button will remove you from the Stingrays. That means you will no longer be seen on the home screen, nor will your waves.",
                showCloseIcon: true,
                btnOkText: "Remove me",
                btnOkOnPress: () {
                  BlocProvider.of<ProfileBloc>(context).add(DropStingray());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Removed from Stingrays!'),
                    ),
                  );
                },
                btnCancelOnPress: () {})
            .show();
      },
    );
  }
}
