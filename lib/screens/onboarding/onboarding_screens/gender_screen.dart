import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/onboarding/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:hero/screens/profile/builders/add_button/build_add_button.dart';
import 'package:hero/screens/profile/builders/gender/build_gender.dart';
import 'package:hero/screens/profile/builders/postGrad/build_postgrad.dart';
import 'package:hero/screens/profile/builders/undergrad/build_undergrad.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../cubits/onboarding/on_boarding_cubit.dart';
import '../../../models/models.dart';
import '../widgets/custom_back_onboarding_button.dart';
import '../widgets/custom_onbaording_buttons.dart';
import 'demo_screen.dart';

class Gender extends StatefulWidget {
  final TabController tabController;

  const Gender({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
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
                    text: 'What\'s your gender?',
                  ),
                  BuildGender.buildGender(user, context),
                  const SizedBox(height: 10),

                  Divider(
                    thickness: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: CustomTextHeader(
                      text: 'What\'s your undergrad?',
                    ),
                  ),

                  BuildUndergrad.buildUndergrad(
                    value: (user.firstUndergrad == 'None' ||
                            user.firstUndergrad == '')
                        ? 'None'
                        : user.firstUndergrad,
                    context: context,
                    delete: null,
                    index: 0,
                  ),
                  const SizedBox(height: 10),
                  if (user.secondUndergrad == '' &&
                      user.firstUndergrad != 'None')
                    BuildAddButton.buildAddButton(context, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(secondUndergrad: 'None');
                    }),
                  if (user.secondUndergrad != '' &&
                      user.firstUndergrad != 'None')
                    BuildUndergrad.buildUndergrad(
                      value: user.secondUndergrad,
                      context: context,
                      delete: () {
                        BlocProvider.of<OnBoardingCubit>(context)
                            .updateOnBoardingUser(secondUndergrad: '');
                      },
                      index: 1,
                    ),
                  SizedBox(height: 10),
                  if (user.thirdUndergrad == '' &&
                      user.secondUndergrad != '' &&
                      user.secondUndergrad != 'None')
                    BuildAddButton.buildAddButton(context, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(thirdUndergrad: 'None');
                    }),
                  if (user.thirdUndergrad != '' &&
                      user.secondUndergrad != '' &&
                      user.secondUndergrad != 'None')
                    BuildUndergrad.buildUndergrad(
                      value: user.thirdUndergrad,
                      context: context,
                      delete: () {
                        BlocProvider.of<OnBoardingCubit>(context)
                            .updateOnBoardingUser(thirdUndergrad: '');
                      },
                      index: 2,
                    ),

                  //divider
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Divider(
                      thickness: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  CustomTextHeader(
                    text: 'What\'s your postgrad? (optional)',
                  ),

                  BuildPostGrad.buildPostGrad(
                    value: user.postGrad,
                    context: context,
                    index: 0,
                  ),
                  //divider
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: Divider(
                      thickness: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  StepProgressIndicator(
                    totalSteps: 6,
                    currentStep: 4,
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
                      onPressed: () async {
                        try {
                          if (user.gender == '') {
                            throw ('Please select a gender');
                          } else {
                            if (user.firstUndergrad == 'None' ||
                                user.firstUndergrad == '') {
                              throw ('Please select an undergrad');
                            } else {
                              widget.tabController.animateTo(4);
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      },
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
