import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hero/models/user_model.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/onboarding/onboarding_screens/even_more_school_data.dart';

import 'package:hero/screens/onboarding/onboarding_screens/gender_screen.dart';
import 'package:hero/screens/onboarding/onboarding_screens/handle_screen.dart';
import 'package:hero/screens/onboarding/onboarding_screens/more_school_data.dart';
import 'package:hero/screens/onboarding/onboarding_screens/socials.dart';
import 'package:hero/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../blocs/stingrays/stingray_bloc.dart';
import '../../cubits/onboarding/on_boarding_cubit.dart';
import 'onboarding_screens/birthdate_screen.dart';
import 'onboarding_screens/screens.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({Key? key, required this.user, this.showAppBar = true, this.testing = true})
      : super(key: key);

  static Route route({required User user}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => OnboardingScreen(user: user),
    );
  }

  final User user;
  final bool showAppBar;
  final bool testing;

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'birthDate'),
    Tab(text: 'Demo'),
    Tab(text: 'Gender'),
    Tab(text: 'Pictures'),
    Tab(text: 'Bio'),
    Tab(text: 'Goals'),
    Tab(text: 'School'),
    Tab(text: 'More School'),
  ];

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  initState() {
    super.initState();
    //blocprovider of OnBoarding cubit add onOnboarding event
    BlocProvider.of<OnBoardingCubit>(context).onBoardingLoaded(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: OnboardingScreen.tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });

        return BlocBuilder<OnBoardingCubit, OnBoardingState>(
          builder: (context, cubitState) {
            if (cubitState is OnBoardingInitial) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: (widget.showAppBar)
                    ? TopAppBar(
                        hasActions: false,
                        implyLeading: false,
                      )
                    : null,
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Handle(
                      tabController: tabController,
                      testing: widget.testing,
                    ),
                    BirthDate(
                      tabController: tabController,
                    ),
                    Demo(
                      tabController: tabController,
                    ),
                    Gender(
                      tabController: tabController,
                    ),
                    SchoolData(
                      tabController: tabController,
                    ),
                    EvenMoreSchoolData(
                      tabController: tabController,
                    ),
                    Socials(
                      tabController: tabController,
                    ),
                    Pictures(
                      tabController: tabController,
                      user: widget.user,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

//write test
void main() {
  //create a mock user from generated user model
  final User _user = User.genericUser('testId');
  //pump the widget with a blocprovider of the onboarding cubit
  testWidgets('OnboardingScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          BlocProvider<OnBoardingCubit>(
            create: (context) => OnBoardingCubit(),
          ),
        ],
        child: MaterialApp(
          home: OnboardingScreen(user: _user),
        ),
      ),
    );

    //the widget should be visible
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
