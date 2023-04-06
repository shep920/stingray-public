import 'package:flutter/material.dart';
import 'package:hero/widgets/text_splitter.dart';
import 'package:hero/widgets/top_appBar.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({Key? key}) : super(key: key);

  //add the static route here
  static const String routeName = '/credits';

  //add the route
  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => const CreditsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> credits = [
      '@steve_buscemi for, alot',
      '@aog for being a true fan',
      '@theyoungpharoh for being the first official stingray',
      '@Wren. for debugging a bunch',
      '@Seth for, similarly, alot',
      '@glubking for the enthusiasm',
      '@esm00004 for the updates',
      '@blair for being an early adopter. And blonde.'
          '@adiaseigneur for asking politely'
    ];
    //return scaffold with topappBar
    return Scaffold(
      appBar: TopAppBar(),
      body: //a centered column of TextSplitters
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: credits.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextSplitter(credits[index], context,
                  Theme.of(context).textTheme.headline3!),
            );
          },
        ),
      ),
    );
  }
}
