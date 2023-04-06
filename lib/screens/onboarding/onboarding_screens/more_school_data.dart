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
import 'package:hero/static_data/general_profile_data/dorms.dart';
import 'package:hero/static_data/general_profile_data/fraternities.dart';
import 'package:hero/static_data/general_profile_data/leadership.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../cubits/onboarding/on_boarding_cubit.dart';
import '../../../models/models.dart';
import '../widgets/custom_back_onboarding_button.dart';
import '../widgets/custom_onbaording_buttons.dart';
import 'demo_screen.dart';

class SchoolData extends StatefulWidget {
  final TabController tabController;

  const SchoolData({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<SchoolData> createState() => _SchoolData();
}

class _SchoolData extends State<SchoolData> {
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
                    text: 'This stuff is optional.',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                    child: CustomTextHeader(
                      text: 'Student Orgs',
                    ),
                  ),
                  if (user.firstStudentOrg == '')
                    BuildAddButton.buildAddButton(context, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(
                              firstStudentOrganization: 'None',
                              firstStudentOrgPosition: 'Member');
                    }),
                  if (user.firstStudentOrg != '')
                    BuildStudentOrg.buildStudentOrg(
                        context, user.firstStudentOrg, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(firstStudentOrganization: '');
                    }, 0),
                  SizedBox(height: 5),
                  if (user.firstStudentOrg != '' &&
                      user.firstStudentOrgPosition != 'None')
                    BuildPostion.buildPositionDropdown(
                        width: 220,
                        dropdownList: Leadership.leadership,
                        user: user,
                        context: context,
                        onChange: (val) {
                          BlocProvider.of<OnBoardingCubit>(context)
                              .updateOnBoardingUser(
                                  firstStudentOrgPosition: val['value']);
                        },
                        placeholder: (user.firstStudentOrgPosition == '')
                            ? 'Position'
                            : user.firstStudentOrgPosition),
                  const SizedBox(height: 10),
                  if (user.secondStudentOrg == '' &&
                      user.firstStudentOrg != 'None' &&
                      user.firstStudentOrg != '')
                    BuildAddButton.buildAddButton(context, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(
                              secondStudentOrganization: 'None');
                    }),
                  if (user.secondStudentOrg != '' &&
                      user.firstStudentOrg != 'None')
                    BuildStudentOrg.buildStudentOrg(
                        context, user.secondStudentOrg, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(secondStudentOrganization: '');
                    }, 1),
                  if (user.secondStudentOrg != '' &&
                      user.firstStudentOrg != 'None' &&
                      user.secondStudentOrg != 'None')
                    BuildPostion.buildPositionDropdown(
                        width: 220,
                        dropdownList: Leadership.leadership,
                        user: user,
                        context: context,
                        onChange: (val) {
                          BlocProvider.of<OnBoardingCubit>(context)
                              .updateOnBoardingUser(
                                  secondStudentOrgPosition: val['value']);
                        },
                        placeholder: (user.secondStudentOrgPosition == '')
                            ? 'Position'
                            : user.secondStudentOrgPosition),
                  SizedBox(height: 10),
                  if (user.thirdStudentOrg == '' &&
                      user.secondStudentOrg != '' &&
                      user.secondStudentOrg != 'None')
                    BuildAddButton.buildAddButton(context, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(
                              thirdStudentOrganization: 'None');
                    }),
                  if (user.thirdStudentOrg != '' &&
                      user.secondStudentOrg != '' &&
                      user.secondStudentOrg != 'None')
                    BuildStudentOrg.buildStudentOrg(
                        context, user.thirdStudentOrg, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(thirdStudentOrganization: '');
                    }, 2),
                  if (user.thirdStudentOrg != '' &&
                      user.secondStudentOrg != '' &&
                      user.secondStudentOrg != 'None')
                    const SizedBox(height: 10),
                  if (user.thirdStudentOrg != '' &&
                      user.secondStudentOrg != '' &&
                      user.thirdStudentOrg != 'None')
                    BuildPostion.buildPositionDropdown(
                        width: 220,
                        dropdownList: Leadership.leadership,
                        user: user,
                        context: context,
                        onChange: (val) {
                          BlocProvider.of<OnBoardingCubit>(context)
                              .updateOnBoardingUser(
                                  firstStudentOrgPosition: val['value']);
                        },
                        placeholder: (user.firstStudentOrgPosition == '')
                            ? 'Position'
                            : user.firstStudentOrgPosition),
                  SizedBox(height: 10),
                  if (user.thirdStudentOrg != '' &&
                      user.thirdStudentOrg != 'None')
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Divider(
                        thickness: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  CustomTextHeader(
                    text: 'Are you in a fraternity or sorority?',
                  ),
                  if (user.fraternity == '')
                    BuildAddButton.buildAddButton(context, () {
                      BlocProvider.of<OnBoardingCubit>(context)
                          .updateOnBoardingUser(fraternity: 'None');
                    }),
                  if (user.fraternity != '')
                    Row(
                      children: [
                        BuildPostion.buildPositionDropdown(
                            width: 210,
                            dropdownList: Fraternities.getFraternities(),
                            user: user,
                            context: context,
                            onChange: (val) {
                              BlocProvider.of<OnBoardingCubit>(context)
                                  .updateOnBoardingUser(
                                      fraternity: val['value'],
                                      fratPosition: 'Member');
                            },
                            placeholder: (user.fraternity == '')
                                ? 'Dorms'
                                : user.fraternity),

                        //red subtract button
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            BlocProvider.of<OnBoardingCubit>(context)
                                .updateOnBoardingUser(
                                    fraternity: '', fratPosition: '');
                          },
                        ),
                      ],
                    ),
                  if (user.fraternity != '' && user.fraternity != 'None')
                    BuildPostion.buildPositionDropdown(
                        width: 220,
                        dropdownList: Leadership.fratLeaders,
                        user: user,
                        context: context,
                        onChange: (val) {
                          BlocProvider.of<OnBoardingCubit>(context)
                              .updateOnBoardingUser(fratPosition: val['value']);
                        },
                        placeholder: (user.fratPosition == '')
                            ? 'Position'
                            : user.fratPosition),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Divider(
                        thickness: 2,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  CustomTextHeader(text: 'Dorms'),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: SubTitle(title: 'What dorm where you in?'),
                  ),
                  BuildPostion.buildPositionDropdown(
                      width: 210,
                      dropdownList: Dorms.dorms(),
                      user: user,
                      context: context,
                      onChange: (val) {
                        BlocProvider.of<OnBoardingCubit>(context)
                            .updateOnBoardingUser(associatedDorm: val['value']);
                      },
                      placeholder: (user.assosiatedDorm == '')
                          ? 'Dorms'
                          : user.assosiatedDorm),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                    child: SubTitle(title: 'Which dorm is the worst?'),
                  ),
                  BuildPostion.buildPositionDropdown(
                      width: 210,
                      dropdownList: Dorms.dorms(),
                      user: user,
                      context: context,
                      onChange: (val) {
                        BlocProvider.of<OnBoardingCubit>(context)
                            .updateOnBoardingUser(worstDorm: val['value']);
                      },
                      placeholder:
                          (user.worstDorm == '') ? 'Dorms' : user.worstDorm),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Divider(
                        thickness: 2,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                  StepProgressIndicator(
                    totalSteps: 8,
                    currentStep: 5,
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
                      onPressed: () => widget.tabController.animateTo(5),
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
