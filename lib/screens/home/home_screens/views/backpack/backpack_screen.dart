import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/backpack/backpack_bloc.dart';
import 'package:hero/helpers/get.dart';
import 'package:hero/models/backpack_item_model.dart';
import 'package:hero/models/prize_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/widgets/top_appBar.dart';
import 'package:intl/intl.dart';

class BackpackScreen extends StatefulWidget {
  static const routeName = '/backpack';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const BackpackScreen(),
    );
  }

  const BackpackScreen({super.key});

  @override
  State<BackpackScreen> createState() => _BackpackScreenState();
}

class _BackpackScreenState extends State<BackpackScreen> {
  @override
  void initState() {
    if (context.read<BackpackBloc>().state is BackpackLoading) {
      context
          .read<BackpackBloc>()
          .add(LoadBackpack(id: Get.blocUser(context).id!));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(),
      body: BlocBuilder<BackpackBloc, BackpackState>(
        builder: (context, state) {
          if (state is BackpackLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BackpackLoaded) {
            List<BackpackItem> backpack = state.backpack;
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: GridView.builder(
                itemCount: backpack.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  BackpackItem item = backpack[index];
                  return GestureDetector(
                    child: _buildItem(item, context),
                    onTap: () {
                      _buildDialog(context, item);
                    },
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        },
      ),
    );
  }

  AwesomeDialog _buildDialog(BuildContext context, BackpackItem item) {
    return (!item.used)
        ? AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            title: item.name,
            body: Column(
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.headline2,
                  //center
                  textAlign: TextAlign.center,
                ),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.headline4,
                  //center
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                CachedNetworkImage(
                  imageUrl: item.imageUrl,
                ),
                const SizedBox(height: 10),
                Text(
                  "Note: using this will remove it from your backpack. It can only be used once.",
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            btnOkText: "Use",
            btnOkOnPress: () {
              BlocProvider.of<BackpackBloc>(context).add(
                UseItem(
                  userId: Get.blocUser(context).id!,
                  item: item,
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item.name} was used!'),
                ),
              );
            },
            btnCancelText: "Cancel",
            btnCancelOnPress: () {},
          )
        : AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            title: item.name,
            body: Column(
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.headline2,
                  //center
                  textAlign: TextAlign.center,
                ),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.headline4,
                  //center
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                CachedNetworkImage(
                  imageUrl: item.imageUrl,
                ),
                const SizedBox(height: 10),
                Text(
                  "${item.name} has already been used on ${DateFormat('MMMM d, yyyy').format(item.usedAt!)}",
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            btnOkText: "OK",
            btnOkOnPress: () {},
          )
      ..show();
  }

  Container _buildItem(BackpackItem item, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.withOpacity(0.5),
      ),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 8),
                (!item.used)
                    ? Text(
                        'Prize Value: ${item.prizeValue}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        'Used',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //make a method, onOkPress. It takes a string, then runs it through a switch statement
}
