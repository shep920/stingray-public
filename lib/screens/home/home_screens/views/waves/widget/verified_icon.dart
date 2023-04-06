import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hero/config/extra_colors.dart';

class VerifiedIcon extends StatelessWidget {
  final double size;
  //final margin
  final EdgeInsets margin;
  const VerifiedIcon({
    Key? key,
    this.margin = const EdgeInsets.only(left: 5.0),
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          margin: margin,
          child: Stack(
            children: [
              //a small circle
              Container(
                //make so that is is centered horizontally and vertically
                margin: const EdgeInsets.only(left: 5.0, top: 5.0),
                width: size - 9,
                height: size - 9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                Icons.verified,
                color: ExtraColors.highlightColor,
                size: size,
              ),
            ],
          )),
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
          title: 'Verified Minnow',
          desc:
              'Verified minnows are users guaranteed to be who they claim to be. You can get verified too by sending a request found under your profile.',
          showCloseIcon: true,
          btnOkOnPress: () {},
        ).show();
      },
    );
  }
}
