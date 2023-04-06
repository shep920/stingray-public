import 'dart:io';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter_svg/svg.dart';

import 'package:hero/blocs/auth/auth_bloc.dart';
import 'package:hero/blocs/profile/profile_bloc.dart';
import 'package:hero/config/extra_colors.dart';
import 'package:hero/cubits/edit_bio/editbio_cubit.dart';
import 'package:hero/helpers/diceroll_avatars.dart';
import 'package:hero/repository/auth_repository.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/repository/storage_repository.dart';
import 'package:hero/screens/home/home_screens/votes/vote_view.dart';
import 'package:hero/screens/profile/builders/gender/build_gender.dart';
import 'package:hero/screens/starting/starting_screen.dart';
import 'package:hero/static_data/general_profile_data/bars.dart';
import 'package:hero/static_data/general_profile_data/dorms.dart';
import 'package:hero/static_data/general_profile_data/intramurals.dart';
import 'package:hero/static_data/general_profile_data/leadership.dart';
import 'package:hero/static_data/general_profile_data/places.dart';

import 'package:hero/static_data/general_profile_data/student_organitzations.dart';
import 'package:hero/static_data/profile_data.dart';
import 'package:hero/widgets/awesome_dialogs/generic_awesome_dialog.dart';
import 'package:image_picker/image_picker.dart';

import '../../cubits/onboarding/on_boarding_cubit.dart';
import '../../helpers/compress_to_shit.dart';
import '../../models/models.dart';
import '../../static_data/general_profile_data/fraternities.dart';
import '../../widgets/dismiss_keyboard.dart';
import '../../widgets/dropdown_textfields/my_dropdown_textfield_studenOrganizations.dart';
import '../../widgets/dropdown_textfields/my_dropdown_textfield.dart';
import '../home/home_screens/votes/vote_screen.dart';
import '../onboarding/onboarding_screens/demo_screen.dart';
import '../onboarding/widgets/custom_image_container.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';
import 'builders/add_button/build_add_button.dart';

import 'builders/fraternities/build_fraternity.dart';
import 'builders/postGrad/build_postgrad.dart';
import 'builders/student_organizations/build_position.dart';

import 'builders/student_organizations/build_student_org.dart';
import 'builders/undergrad/build_undergrad.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) {
          return ProfileScreen();
        });
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool finishedOnboarding;
  late final User _user;
  Function eq = const ListEquality().equals;

  late final List<dynamic> _initialImages;
  @override
  initState() {
    _user = (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;

    BlocProvider.of<OnBoardingCubit>(context).onBoardingLoaded(_user);

    //for each image, add it to the list of initial images
    _initialImages = [];
    for (var image in _user.imageUrls) {
      _initialImages.add(image);
    }

    finishedOnboarding = _user.finishedOnboarding;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('initial images:' + _initialImages.length.toString());
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              BlocProvider.of<OnBoardingCubit>(context).onBoardingLoaded(_user);
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Edit", //headline 1
              style: Theme.of(context).textTheme.headline2),
          actions: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, profileState) {
                if (profileState is ProfileLoaded) {
                  return BlocBuilder<OnBoardingCubit, OnBoardingState>(
                    builder: (context, onBoardingState) {
                      if (onBoardingState is OnBoaringLoaded) {
                        User editedUser = onBoardingState.user;
                        print(_initialImages);
                        bool changesMade = getChangesMade(editedUser);
                        return Row(
                          children: [
                            (_user.finishedOnboarding)
                                ? InkWell(
                                    child: Center(
                                      child: Text("Save", //headline 1
                                          style: (changesMade)
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .headline2!
                                                  .copyWith(
                                                      color: ExtraColors
                                                          .highlightColor,
                                                      fontWeight:
                                                          FontWeight.bold)
                                              : Theme.of(context)
                                                  .textTheme
                                                  .headline4),
                                    ),
                                    onTap: () {
                                      (changesMade)
                                          ? saveChanges(context)
                                          : null;
                                    },
                                  )
                                : Container(),
                            const SizedBox(width: 20),
                          ],
                        );
                      }
                      return Container();
                    },
                  );
                }
                return Container();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }
              if (state is ProfileLoaded) {
                if (state.user.finishedOnboarding == true) {
                  return const OnboardingFinishedView();
                } else {
                  return OnbaordingNotFinishedView(user: state.user);
                }
              } else {
                return const Text('Something went wrong.');
              }
            },
          ),
        ),
      ),
    );
  }

  bool getChangesMade(User editedUser) {
    return (!eq(editedUser.imageUrls, _initialImages) ||
        (editedUser.gender != _user.gender) ||
        (editedUser.bio != _user.bio) ||
        (editedUser.name != _user.name) ||
        (editedUser.firstStudentOrg != _user.firstStudentOrg) ||
        (editedUser.secondStudentOrg != _user.secondStudentOrg) ||
        (editedUser.thirdStudentOrg != _user.thirdStudentOrg) ||
        (editedUser.firstUndergrad != _user.firstUndergrad) ||
        (editedUser.secondUndergrad != _user.secondUndergrad) ||
        (editedUser.thirdUndergrad != _user.thirdUndergrad) ||
        (editedUser.firstStudentOrgPosition != _user.firstStudentOrgPosition) ||
        (editedUser.secondStudentOrgPosition !=
            _user.secondStudentOrgPosition) ||
        (editedUser.thirdStudentOrgPosition != _user.thirdStudentOrgPosition) ||
        (editedUser.postGrad != _user.postGrad) ||
        ((editedUser.fraternity != _user.fraternity) &&
            (editedUser.fraternity != 'None') &&
            editedUser.fraternity != "") ||
        (editedUser.fratPosition != _user.fratPosition) ||
        (editedUser.assosiatedDorm != _user.assosiatedDorm) ||
        (editedUser.worstDorm != _user.worstDorm) ||
        (editedUser.intramuralSport != _user.intramuralSport) ||
        (editedUser.favoriteBar != _user.favoriteBar &&
            (editedUser.favoriteBar != 'None' &&
                editedUser.favoriteBar != "")) ||
        (editedUser.favoriteSpot != _user.favoriteSpot &&
            (editedUser.favoriteSpot != 'None' &&
                editedUser.favoriteSpot != "")) ||
        (editedUser.twitterUrl != _user.twitterUrl) ||
        (editedUser.snapchatUrl != _user.snapchatUrl) ||
        (editedUser.tiktokUrl != _user.tiktokUrl) ||
        (editedUser.tinderUrl != _user.tinderUrl) ||
        (editedUser.instagramUrl != _user.instagramUrl) ||
        (editedUser.discordUrl != _user.discordUrl));
  }

  void saveChanges(BuildContext context) {
    BlocProvider.of<ProfileBloc>(context).add(EditProfile(
        editedUser:
            (BlocProvider.of<OnBoardingCubit>(context).state as OnBoaringLoaded)
                .user));
    Navigator.of(context).pop();
  }
}

class OnbaordingNotFinishedView extends StatelessWidget {
  final User? user;
  const OnbaordingNotFinishedView({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .4,
              child: Text(
                'Looks like you havent made their profile yet.'
                ' Wanna do that now or later?',
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Later',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(color: Theme.of(context).dividerColor),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.headline5),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.popAndPushNamed(
                      context, OnboardingScreen.routeName,
                      arguments: user),
                  child: Text('Now',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).dividerColor,
                          )),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      textStyle: Theme.of(context).textTheme.headline5),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingFinishedView extends StatefulWidget {
  const OnboardingFinishedView({
    Key? key,
  }) : super(key: key);

  @override
  State<OnboardingFinishedView> createState() => _OnboardingFinishedViewState();
}

class _OnboardingFinishedViewState extends State<OnboardingFinishedView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  int? selectedIndex;
  bool editing = true;

  String? goal;
  List<dynamic> selectedGoals = [];

  @override
  void initState() {
    User _user =
        (BlocProvider.of<ProfileBloc>(context).state as ProfileLoaded).user;

    nameController.text = _user.name;
    bioController.text = _user.bio;
    selectedGoals = _user.goals;

    super.initState();
  }

  dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingCubit, OnBoardingState>(
      builder: (context, onboardingState) {
        if (onboardingState is OnBoaringLoaded) {
          User user = onboardingState.user;
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
                child: Row(
                  //space between
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      child: Text('Edit',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  color: (editing)
                                      ? Colors.red
                                      : Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .color)),
                      onTap: () => setState(() {
                        editing = true;
                      }),
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () => setState(() {
                        editing = false;
                      }),
                      child: Text('Preview',
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  color: (!editing)
                                      ? Colors.red
                                      : Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .color)),
                    )
                  ],
                ),
              ),
              (editing)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            height: onboardingState.user.imageUrls.isNotEmpty
                                ? 350
                                : 0,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.66,
                              ),
                              itemCount: 6,
                              itemBuilder: (BuildContext context, int index) {
                                return (onboardingState.user.imageUrls.length >
                                        index)
                                    ? CustomImageContainer(
                                        imageUrl: onboardingState
                                            .user.imageUrls[index],
                                        deletable: (onboardingState
                                                    .user.imageUrls.length >
                                                1)
                                            ? true
                                            : false,
                                      )
                                    : CustomImageContainer(
                                        uploadable: (index ==
                                            onboardingState
                                                .user.imageUrls.length),
                                      );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                              child: Center(
                                  child: DiceRollAvatars.getAvatar(
                                      size: 100,
                                      context: context,
                                      userId: user.id!)),
                              onTap: () {
                                GenericAwesomeDialog.showDialog(
                                        context: context,
                                        title: 'Your Bay Bot',
                                        description:
                                            'So, you\'ve got yourself a Bay Bot. This little guy is going to be your representation when you post a secret wave. Just so you know, your Bay Bot is a randomly generated icon and can\'t be changed. It\'s kind of like your secret identity on The Bay. Cool, right?')
                                    .show();
                              }),

                          const Title(
                            title: 'Name',
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5.0),
                              child: TextField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(100),
                                  ],
                                  maxLength: 100,
                                  minLines: null,
                                  controller: nameController,
                                  textInputAction: TextInputAction.send,
                                  maxLines: null,
                                  style: Theme.of(context).textTheme.headline5,
                                  expands: true,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: user.name,
                                      contentPadding:
                                          const EdgeInsets.all(5.0)),
                                  onChanged: (name) {
                                    BlocProvider.of<OnBoardingCubit>(context)
                                        .updateOnBoardingUser(
                                            name: nameController.text);
                                  }),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 75,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Title(
                            title: 'Bio',
                          ),
                          SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5.0),
                              child: TextField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(400),
                                  ],
                                  minLines: 1,
                                  controller: bioController,
                                  //multiline keyboard
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 8,
                                  maxLength: 400,
                                  style: Theme.of(context).textTheme.headline5,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: user.bio,
                                      contentPadding:
                                          const EdgeInsets.all(5.0)),
                                  onChanged: (bio) {
                                    BlocProvider.of<OnBoardingCubit>(context)
                                        .updateOnBoardingUser(
                                            bio: bioController.text);
                                  }),
                            ),
                            width: MediaQuery.of(context).size.width,
                          ),

                          const Title(
                            title: 'Gender',
                          ),
                          BuildGender.buildGender(user, context),
                          const SizedBox(height: 10),
                          //divider
                          Divider(
                            thickness: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                            child: const Title(
                              title: 'Undergrad',
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
                                  .updateOnBoardingUser(
                                      secondUndergrad: 'None');
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
                          const Title(
                            title: 'Postgrad',
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
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                            child: Title(
                              title: 'Student Orgs',
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
                                  .updateOnBoardingUser(
                                      firstStudentOrganization: '');
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
                                          firstStudentOrgPosition:
                                              val['value']);
                                },
                                placeholder:
                                    (user.firstStudentOrgPosition == '')
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
                                  .updateOnBoardingUser(
                                      secondStudentOrganization: '');
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
                                          secondStudentOrgPosition:
                                              val['value']);
                                },
                                placeholder:
                                    (user.secondStudentOrgPosition == '')
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
                                  .updateOnBoardingUser(
                                      thirdStudentOrganization: '');
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
                                          firstStudentOrgPosition:
                                              val['value']);
                                },
                                placeholder:
                                    (user.firstStudentOrgPosition == '')
                                        ? 'Position'
                                        : user.firstStudentOrgPosition),
                          SizedBox(height: 10),
                          if (user.thirdStudentOrg != '' &&
                              user.thirdStudentOrg != 'None')
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8),
                              child: Divider(
                                thickness: 2,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          Title(title: 'Sororities and Fraternities'),
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
                                    dropdownList:
                                        Fraternities.getFraternities(),
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
                          if (user.fraternity != '' &&
                              user.fraternity != 'None')
                            BuildPostion.buildPositionDropdown(
                                width: 220,
                                dropdownList: Leadership.fratLeaders,
                                user: user,
                                context: context,
                                onChange: (val) {
                                  BlocProvider.of<OnBoardingCubit>(context)
                                      .updateOnBoardingUser(
                                          fratPosition: val['value']);
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
                          Title(title: 'Whats the ideal going out spot?'),
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
                                      .updateOnBoardingUser(
                                          favoriteBar: val['value']);
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
                          Title(title: 'Top Spot in Town'),
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
                                      .updateOnBoardingUser(
                                          favoriteSpot: val['value']);
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
                          Title(title: 'Dorms'),
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
                                    .updateOnBoardingUser(
                                        associatedDorm: val['value']);
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
                                    .updateOnBoardingUser(
                                        worstDorm: val['value']);
                              },
                              placeholder: (user.worstDorm == '')
                                  ? 'Dorms'
                                  : user.worstDorm),
                          Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8),
                              child: Divider(
                                thickness: 2,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                          Title(title: 'Are you in any intra-mural sports?'),
                          if (user.intramuralSport == '')
                            BuildAddButton.buildAddButton(context, () {
                              BlocProvider.of<OnBoardingCubit>(context)
                                  .updateOnBoardingUser(
                                      intramuralSport: 'None');
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
                                        .updateOnBoardingUser(
                                            intramuralSport: '');
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
                          Title(title: 'Social Media Profiles'),

                          SocialMediaProfileTextField(
                            url: user.twitterUrl,
                            onDelete: () {
                              BlocProvider.of<OnBoardingCubit>(context)
                                  .updateOnBoardingUser(twitterUrl: '');
                            },
                            hint: 'Twitter Profile Url',
                            onSubmit: ((val) {
                              BlocProvider.of<OnBoardingCubit>(context)
                                  .validateTwitterUrl(
                                      url: val, context: context);
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
                                  .validateInstagramUrl(
                                      url: val, context: context);
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
                                  .validateSnapchatUrl(
                                      url: val, context: context);
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
                                  .validateTinderUrl(
                                      url: val, context: context);
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
                                  .validateTiktokUrl(
                                      url: val, context: context);
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
                                  .validateDiscordUrl(
                                      url: val, context: context);
                            }),
                          ),

                          Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 8),
                              child: Divider(
                                thickness: 2,
                                color: Theme.of(context).colorScheme.primary,
                              )),

                          SizedBox(height: 40),
                        ],
                      ),
                    )
                  : VoteView(
                      waves: [],
                      imageUrlIndex: 0,
                      user: user,
                      voteUser: user,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class SocialMediaProfileTextField extends StatefulWidget {
  final String url;
  final void Function() onDelete;
  final String hint;
  final void Function(String) onSubmit;
  const SocialMediaProfileTextField({
    Key? key,
    required this.url,
    required this.onDelete,
    required this.hint,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<SocialMediaProfileTextField> createState() =>
      _SocialMediaProfileTextFieldState();
}

class _SocialMediaProfileTextFieldState
    extends State<SocialMediaProfileTextField> {
  late TextEditingController _controller;

  initState() {
    super.initState();

    _controller = TextEditingController(text: widget.url);
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              style: Theme.of(context).textTheme.headline4,
              //make this very pretty
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: widget.hint,
              ),
              keyboardType: TextInputType.url,
              onSubmitted: (val) {
                widget.onSubmit(val);
              },
            ),
          ),
          //center subtraction button
          if (widget.url != '')
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outline,
                color: Colors.red,
              ),
              onPressed: () {
                _controller.clear();
                widget.onDelete();
              },
            ),
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  final String title;

  const Title({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ],
    );
  }
}

class SubTitle extends StatelessWidget {
  final String title;

  const SubTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ],
    );
  }
}
