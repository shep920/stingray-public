import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/helpers/get.dart';
import 'package:hero/models/prize_model.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/widgets/awesome_dialogs/generic_awesome_dialog.dart';
import 'package:hero/widgets/top_appBar.dart';

class PrizeShelfScreen extends StatelessWidget {
  //make a route
  static const routeName = '/prize-shelf';
  //make a route method
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => PrizeShelfScreen(),
    );
  }

  final List<Prize> prizeList = Prize.examplePrizes;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          User _user = profileState.user;

          return Scaffold(
            appBar: const TopAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    height: 40,
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          "Your Tokens",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                        ),
                        //an icon button for info
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.circleInfo,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          onPressed: () {
                            GenericAwesomeDialog.showDialog(
                              context: context,
                              title: "Tokens",
                              description:
                                  "Tokens are used to redeem prizes. You can earn tokens by becoming a Stingray. First gets a gold token, second gets a silver token, third gets a bronze token, and the rest get an iron token.",
                            ).show();
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildTokensRow(context, _user.goldTokens, _user.silverTokens,
                      _user.bronzeTokens, _user.ironTokens),
                  _buildShelf(Prize.goldValue, context),
                  _buildPrizeRow(
                      prizeList
                          .where((prize) => prize.prizeValue == Prize.goldValue)
                          .toList(),
                      _user.goldTokens),
                  _buildShelf(Prize.silverValue, context),
                  _buildPrizeRow(
                      prizeList
                          .where(
                              (prize) => prize.prizeValue == Prize.silverValue)
                          .toList(),
                      _user.silverTokens),
                  _buildShelf(Prize.bronzeValue, context),
                  _buildPrizeRow(
                      prizeList
                          .where(
                              (prize) => prize.prizeValue == Prize.bronzeValue)
                          .toList(),
                      _user.bronzeTokens),
                  _buildShelf(Prize.ironValue, context),
                  _buildPrizeRow(
                      prizeList
                          .where((prize) => prize.prizeValue == Prize.ironValue)
                          .toList(),
                      _user.ironTokens),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildShelf(String prizeValue, BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      height: 40,
      child: Row(
        children: [
          const SizedBox(width: 20),
          Text(
            prizeValue.toUpperCase(),
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrizeRow(List<Prize> prizes, int tokens) {
    return Container(
      height: 120,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 60,
              child: Center(
                child: FaIcon(
                  _getIcon(prizes[0].prizeValue),
                  color: _getColor(prizes[0].prizeValue),
                  size: 60,
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: prizes.length,
            itemBuilder: (context, index) {
              Prize prize = prizes[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: GestureDetector(
                        onTap: () {
                          // ignore: avoid_single_cascade_in_expression_statements
                          AwesomeDialog(
                            context: context,
                            headerAnimationLoop: false,
                            title: prize.name,
                            body: Column(
                              children: [
                                Text(
                                  prize.name,
                                  style: Theme.of(context).textTheme.headline2,
                                  //center
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  prize.description,
                                  style: Theme.of(context).textTheme.headline4,
                                  //center
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                CachedNetworkImage(
                                  imageUrl: prize.imageUrl,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Choosing this prize will cost you a ${prize.prizeValue} token",
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            btnOkText: "Get",
                            btnOkOnPress: () {
                              if (tokens > 0) {
                                BlocProvider.of<ProfileBloc>(context)
                                    .add(UpdateBackpack(
                                  prize: prize,
                                ));

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        '${prize.name} added to your backpack')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'You do not have enough tokens for this prize')));
                              }
                            },
                            btnCancelText: "Cancel",
                            btnCancelOnPress: () {},
                          )..show();
                        },
                        child: CachedNetworkImage(
                          imageUrl: prize.imageUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      prize.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${prize.remaining} remaining',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildTokensRow(BuildContext context, int goldtokens, int silvertokens,
    int bronzetokens, int irontokens) {
  return Container(
    height: 120,
    child: ListView(
      children: [
        //make four seperate columns. one for each token type. each column will have a row for the icon and a row for the number of tokens
        Row(
          children: [
            _buildTokenColumn(
              context,
              Prize.goldValue,
              goldtokens,
            ),
            _buildTokenColumn(
              context,
              Prize.silverValue,
              silvertokens,
            ),
            _buildTokenColumn(
              context,
              Prize.bronzeValue,
              bronzetokens,
            ),
            _buildTokenColumn(
              context,
              Prize.ironValue,
              irontokens,
            ),
          ],
        ),
      ],
    ),
  );
}

_buildTokenColumn(BuildContext context, String tokenValue, int tokens) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        FaIcon(
          //fontAwesome icon for a token
          FontAwesomeIcons.coins,
          color: _getColor(tokenValue),
          size: 60,
        ),
        const SizedBox(height: 10),
        Text(
          tokens.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
      ],
    ),
  );
}

IconData _getIcon(String prizeValue) {
  switch (prizeValue) {
    case Prize.goldValue:
      return FontAwesomeIcons.chessQueen;
    case Prize.silverValue:
      return FontAwesomeIcons.chessRook;
    case Prize.bronzeValue:
      return FontAwesomeIcons.chessKnight;
    case Prize.ironValue:
      return FontAwesomeIcons.chessPawn;
    default:
      return FontAwesomeIcons.chessPawn;
  }
}

Color _getColor(String prizeValue) {
  switch (prizeValue) {
    case Prize.goldValue:
      return ExtraColors.gold;
    case Prize.silverValue:
      return ExtraColors.silver;
    case Prize.bronzeValue:
      return ExtraColors.bronze;
    case Prize.ironValue:
      return ExtraColors.iron;
    default:
      return ExtraColors.iron;
  }
}
