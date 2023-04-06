import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/onboarding/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../../cubits/onboarding/on_boarding_cubit.dart';
import '../../../models/models.dart';
import '../widgets/custom_back_onboarding_button.dart';
import '../widgets/custom_onbaording_buttons.dart';

class BirthDate extends StatefulWidget {
  final TabController tabController;

  const BirthDate({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<BirthDate> createState() => _BirthDateState();
}

class _BirthDateState extends State<BirthDate> {
  DateTime? birthDate;
  String days = '';

  String months = '';

  String years = '';

  bool isValid = false;
  final controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextHeader(
                text: 'Your Birthday',
              ),
              SizedBox(height: 10),
              //make a row of three textfields that are verey tall and use headline 1 theme
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildDays(context),
                  buildMonths(context),
                  buildYears(context),
                ],
              ),
              Column(
                children: [
                  StepProgressIndicator(
                    totalSteps: 6,
                    currentStep: 2,
                    selectedColor: Theme.of(context).colorScheme.primary,
                    unselectedColor: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  SizedBox(height: 10),
                  CustomBackOnboardingButton(
                    tabController: widget.tabController,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox buildYears(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.5,
      child: TextField(
        style: //headline theme 1
            Theme.of(context).textTheme.headline1,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: "",
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.length == 4) {
            setState(() {
              years = value;
            });
            FocusScope.of(context).unfocus();

            //get the date from days, months, and years
            birthDate =
                DateTime.parse('${years}-${months}-${days} 00:00:00.000');

            setState(() {
              birthDate = birthDate;
              isValid = (yearsBetween(birthDate!, DateTime.now()) >= 18 &&
                  //months are longer than 12 and days are longer than 31
                  int.parse(months) <= 12 &&
                  int.parse(days) <= 31);
            });
            checkAnswer(context);
          }
        },
        //set the character limit to 4
        maxLength: 4,
      ),
    );
  }

  void checkAnswer(BuildContext context) {
    if (isValid) {
      BlocProvider.of<OnBoardingCubit>(context)
          .updateOnBoardingUser(birthDate: birthDate);
      widget.tabController.animateTo(2);
    } else {
      //if months is greater than 12 or days greater than 31, then set the error message
      if (int.parse(months) > 12 || int.parse(days) > 31) {
        //show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a valid date of birth'),
        ));
      } else {
        //show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('You must be at least 18 years old to use Stingray'),
        ));
      }
    }
  }

  SizedBox buildDays(BuildContext context) {
    return SizedBox(
      //height of the container
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.5,
      child: TextField(
        focusNode: _focusNode,
        maxLength: 2,
        style: //headline theme 1
            Theme.of(context).textTheme.headline1,

        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: "",
          //if days is invalid, then set the border to red
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.length == 2) {
            FocusScope.of(context).nextFocus();
            setState(() {
              months = value;
            });

            //add a slash
          }
        },
        //set a character limit of 2
      ),
    );
  }

  SizedBox buildMonths(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      height: MediaQuery.of(context).size.height * 0.5,
      child: TextField(
        maxLength: 2,
        style: //headline theme 1
            Theme.of(context).textTheme.headline1,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          counterText: "",
        ),
        keyboardType: TextInputType.number,
        onChanged: (value) {
          if (value.length == 2) {
            //add a / to the controller

            FocusScope.of(context).nextFocus();
            setState(() {
              days = value;
            });
          }
        },
      ),
    );
  }
}

int yearsBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  int i = (((to.difference(from).inHours / 24)) / 365).floor();
  print(i);
  return i;
}
