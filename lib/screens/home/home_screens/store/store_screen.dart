import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/widgets/top_appBar.dart';

class StoreScreen extends StatelessWidget {
  //make a route
  static const routeName = '/store';

  //make a route method
  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => StoreScreen(),
    );
  }

  const StoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(
        title: 'Store',
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              'Store',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Center(
            child: Text(
              '\$100',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Center(
              child: InkWell(
            child: FaIcon(
              FontAwesomeIcons.fishFins,
              size: 100,
            ),
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
                title: 'Stingray Token',
                desc:
                    'At some point I\ll sell the ability to turn someone into a stingray for \$100. Till I figure that out tho, just daydream about it.',
                showCloseIcon: true,
                btnOkOnPress: () {},
              ).show();
            },
          )),
        ],
      ),
    );
  }
}
