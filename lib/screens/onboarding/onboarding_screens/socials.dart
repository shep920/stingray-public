import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/onboarding/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hero/screens/profile/builders/add_button/build_add_button.dart';
import 'package:hero/screens/profile/builders/gender/build_gender.dart';
import 'package:hero/screens/profile/builders/postGrad/build_postgrad.dart';
import 'package:hero/screens/profile/builders/student_organizations/build_position.dart';
import 'package:hero/screens/profile/builders/student_organizations/build_student_org.dart';
import 'package:hero/screens/profile/builders/undergrad/build_undergrad.dart';
import 'package:hero/screens/profile/profile_screen.dart';
import 'package:hero/static_data/general_profile_data/bars.dart';
import 'package:hero/static_data/general_profile_data/dorms.dart';
import 'package:hero/static_data/general_profile_data/fraternities.dart';
import 'package:hero/static_data/general_profile_data/intramurals.dart';
import 'package:hero/static_data/general_profile_data/leadership.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../cubits/onboarding/on_boarding_cubit.dart';
import '../../../models/models.dart';
import '../widgets/custom_back_onboarding_button.dart';
import '../widgets/custom_onbaording_buttons.dart';
import 'demo_screen.dart';

class Socials extends StatefulWidget {
  final TabController tabController;

  const Socials({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<Socials> createState() => _Socials();
}

class _Socials extends State<Socials> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
        builder: (context, onboardingState) {
      if (onboardingState is OnBoaringLoaded) {
        User user = onboardingState.user;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextHeader(
                    text: 'Social Media Profiles',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                    child: SubTitle(
                      title:
                          'Note: these are only links to your profiles. Just copy and paste the url, idk how to actually integrate them lmao.',
                    ),
                  ),
                  SocialMediaProfileTextField(
                    url: user.twitterUrl,
                    onDelete: () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(twitterUrl: '');
                    },
                    hint: 'Twitter Profile Url',
                    onSubmit: ((val) {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .validateTwitterUrl(url: val, context: context);
                    }),
                  ),
                  SocialMediaProfileTextField(
                    url: user.instagramUrl,
                    onDelete: () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(instagramUrl: '');
                    },
                    hint: 'Instagram profile url',
                    onSubmit: ((val) {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .validateInstagramUrl(url: val, context: context);
                    }),
                  ),
                  SocialMediaProfileTextField(
                    url: user.snapchatUrl,
                    onDelete: () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(snapchatUrl: '');
                    },
                    hint: 'Snapchat Url',
                    onSubmit: ((val) {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .validateSnapchatUrl(url: val, context: context);
                    }),
                  ),
                  SocialMediaProfileTextField(
                    url: user.tinderUrl,
                    onDelete: () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(tinderUrl: '');
                    },
                    hint: 'Tinder profile',
                    onSubmit: ((val) {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .validateTinderUrl(url: val, context: context);
                    }),
                  ),
                  SocialMediaProfileTextField(
                    url: user.tiktokUrl,
                    onDelete: () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(tiktokUrl: '');
                    },
                    hint: 'Tiktok profile',
                    onSubmit: ((val) {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .validateTiktokUrl(url: val, context: context);
                    }),
                  ),
                  SocialMediaProfileTextField(
                    url: user.discordUrl,
                    onDelete: () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(discordUrl: '');
                    },
                    hint: 'Discord Url',
                    onSubmit: ((val) {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .validateDiscordUrl(url: val, context: context);
                    }),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Divider(
                        thickness: 2,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  StepProgressIndicator(
                    totalSteps: 8,
                    currentStep: 7,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    unselectedColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  SizedBox(height: 10),
                  CustomBackOnboardingButton(
                    tabController: widget.tabController,
                  ),
                  SizedBox(height: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      gradient: LinearGradient(colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).backgroundColor,
                      ]),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.transparent,
                      ),
                      onPressed: () => widget.tabController.animateTo(7),
                      child: Container(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'NEXT',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return Container();
    });
  }
}

int _yearsBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  int i = (((to.difference(from).inHours / 24)) / 365).floor();
  print(i);
  return i;
}
