import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class GenericAwesomeDialog{
  static AwesomeDialog showDialog({required BuildContext context,required String title, required String description}) {
    return AwesomeDialog(
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
      title: title,
      desc:
          description,
      showCloseIcon: true,
      btnOkOnPress: () {},
    );
  }
}