import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/screens/home/main_page.dart';
import 'package:hero/screens/onboarding/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../cubits/onboarding/on_boarding_cubit.dart';
import '../../../models/models.dart';
import '../../../repository/firestore_repository.dart';
import '../../wrapper/wrapper.dart';
import '../widgets/custom_onbaording_buttons.dart';

class Pictures extends StatelessWidget {
  final TabController tabController;
  final User user;

  const Pictures({
    Key? key,
    required this.tabController,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        if (state is OnBoaringLoaded) {
          var images = state.user.imageUrls;
          var imageCount = images.length;
          return ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextHeader(
                          text: 'Add 2 or More Pictures',
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 350,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.66,
                            ),
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              return (imageCount > index)
                                  ? CustomImageContainer(
                                      imageUrl: images[index],
                                    )
                                  : CustomImageContainer(
                                      uploadable: (index == imageCount),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        StepProgressIndicator(
                          totalSteps: 8,
                          currentStep: 8,
                          selectedColor: Theme.of(context).colorScheme.primary,
                          unselectedColor:
                              Theme.of(context).scaffoldBackgroundColor,
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
                              if ((BlocProvider.of<OnBoardingCubit>(context)
                                          .state as OnBoaringLoaded)
                                      .user
                                      .imageUrls
                                      .length >
                                  1) {
                                BlocProvider.of<ProfileBloc>(context).add(
                                    EditProfile(
                                        editedUser:
                                            (BlocProvider.of<OnBoardingCubit>(
                                                        context)
                                                    .state as OnBoaringLoaded)
                                                .user));

                                // Navigator.pushReplacementNamed(
                                //     context, MainPage.routeName);
                                AwesomeDialog(
                                  titleTextStyle:
                                      Theme.of(context).textTheme.headline2,
                                  descTextStyle:
                                      Theme.of(context).textTheme.headline5,
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
                                  dismissOnTouchOutside: false,
                                  dismissOnBackKeyPress: false,
                                  headerAnimationLoop: false,
                                  animType: AnimType.bottomSlide,
                                  title: "Sea Real Unlocked!",
                                  desc:
                                      "Congrats! Now that you made an account, you use Sea Real!",
                                  showCloseIcon: false,
                                  btnOkOnPress: () {
                                    Navigator.pushReplacementNamed(
                                        context, MainPage.routeName);
                                  },
                                ).show();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Please add at least 2 pictures'),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  'FINISH',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Text('data');
      },
    );
  }
}
