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
import 'package:hero/static_data/general_profile_data/places.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../cubits/onboarding/on_boarding_cubit.dart';
import '../../../models/models.dart';
import '../widgets/custom_back_onboarding_button.dart';
import '../widgets/custom_onbaording_buttons.dart';
import 'demo_screen.dart';

class EvenMoreSchoolData extends StatefulWidget {
  final TabController tabController;

  const EvenMoreSchoolData({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<EvenMoreSchoolData> createState() => _EvenMoreSchoolData();
}

class _EvenMoreSchoolData extends State<EvenMoreSchoolData> {
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
                    text: 'This stuff is still optional.',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                    child: CustomTextHeader(
                      text: 'Best place for the weekend',
                    ),
                  ),
                  if (user.favoriteBar == '')
                    BuildAddButton.buildAddButton(context, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(favoriteBar: 'None');
                    }),
                  if (user.favoriteBar != '')
                    BuildPostion.buildPositionDropdown(
                        width: MediaQuery.of(context).size.width * .7,
                        dropdownList: Bars.bars(),
                        user: user,
                        context: context,
                        onChange: (val) {
                          BlocProvider.of<OnBoardingCubit>(context)
                              .updateOnBoardingUser(favoriteBar: val['value']);
                        },
                        placeholder: (user.favoriteBar == '')
                            ? 'Bar'
                            : user.favoriteBar),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Divider(
                        thickness: 2,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                    child: CustomTextHeader(
                      text: 'Top Spot in Town',
                    ),
                  ),
                  if (user.favoriteSpot == '')
                    BuildAddButton.buildAddButton(context, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(favoriteSpot: 'None');
                    }),
                  if (user.favoriteSpot != '')
                    BuildPostion.buildPositionDropdown(
                        width: MediaQuery.of(context).size.width * .7,
                        dropdownList: Places.places(),
                        user: user,
                        context: context,
                        onChange: (val) {
                          BlocProvider.of<OnBoardingCubit>(context)
                              .updateOnBoardingUser(favoriteSpot: val['value']);
                        },
                        placeholder: (user.favoriteSpot == '')
                            ? 'Spot'
                            : user.favoriteSpot),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Divider(
                        thickness: 2,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                    child: CustomTextHeader(
                      text: 'Do you play intramural sports?',
                    ),
                  ),
                  if (user.intramuralSport == '')
                    BuildAddButton.buildAddButton(context, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(intramuralSport: 'None');
                    }),
                  if (user.intramuralSport != '')
                    Row(
                      children: [
                        BuildPostion.buildPositionDropdown(
                            width: 200,
                            dropdownList: Intramurals.intramurals(),
                            user: user,
                            context: context,
                            onChange: (val) {
                              BlocProvider.of<OnBoardingCubit>(context)
                                  .updateOnBoardingUser(
                                      intramuralSport: val['value']);
                            },
                            placeholder: (user.intramuralSport == '')
                                ? 'Sports'
                                : user.intramuralSport),
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            BlocProvider.of<OnBoardingCubit>(context)
                                .updateOnBoardingUser(intramuralSport: '');
                          },
                        ),
                      ],
                    ),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Divider(
                        thickness: 2,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  StepProgressIndicator(
                    totalSteps: 8,
                    currentStep: 6,
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
                      onPressed: () => widget.tabController.animateTo(6),
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
