import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/repository/firestore_repository.dart';
import 'package:hero/screens/onboarding/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:flutter_test/flutter_test.dart';

import '../../../cubits/onboarding/on_boarding_cubit.dart';
import '../../../models/models.dart';
import '../widgets/custom_back_onboarding_button.dart';
import '../widgets/custom_onbaording_buttons.dart';

class Handle extends StatefulWidget {
  final TabController tabController;
  final bool testing;

  const Handle({
    Key? key,
    required this.tabController,
    required this.testing,
  }) : super(key: key);

  @override
  State<Handle> createState() => _HandleState();
}

class _HandleState extends State<Handle> {
  String handle = '@';
  bool isValid = false;

  //focus node
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String handleAvailableMessage = (handle == '@') ? '' : 'Handle available';
    String handleUnavailableMessage =
        (handle == '@') ? '' : 'Handle unavailable';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 18.0),
            child: CustomTextHeader(
              text: 'What do you want your handle to be?',
            ),
          ),
          Column(
            children: [
              TextFormField(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  hintText: handle,
                  contentPadding: const EdgeInsets.only(bottom: 5.0, top: 12.5),
                  focusedBorder: OutlineInputBorder(
                    borderSide: (isValid == true)
                        ? BorderSide(
                            color: Theme.of(context).scaffoldBackgroundColor)
                        : BorderSide(color: Colors.red),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                initialValue: handle,
                onChanged: (val) async {
                  setState(() => handle = val);
                  isValid = await FirestoreRepository().userExists(handle);
                  setState(() => isValid);
                },
                onFieldSubmitted: (submit) {
                  if (isValid) {
                    widget.tabController
                        .animateTo(widget.tabController.index + 1);
                    //firestore repo set handle
                    FirestoreRepository().updateHandle(
                        id: (BlocProvider.of<OnBoardingCubit>(context).state
                                as OnBoaringLoaded)
                            .user
                            .id!,
                        handle: handle,
                        testing: widget.testing);

                    //unfocus
                    _focusNode.unfocus();
                  }
                },
              ),
              Text(
                isValid == true
                    ? handleAvailableMessage
                    : handleUnavailableMessage,
                style: TextStyle(
                  fontSize: 25,
                  color: isValid == true ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 400.0),
            child: Text(
                'Your handle is how users will search for you. Your display name will be created later and can be changed, but your handle will never change.',
                style: Theme.of(context).textTheme.headline4),
          ),
          Column(
            children: [
              StepProgressIndicator(
                totalSteps: 6,
                currentStep: 1,
                selectedColor: Theme.of(context).colorScheme.primary,
                unselectedColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleErrors() {
    if (handle[0] != '@') {
      throw ('Your handle needs to start with @');
    }
    if (handle == '@') {
      throw ('Your handle needs to be more than the @');
    }
    if (handle.substring(0, handle.length) == '') {
      throw (Exception('Your Handle cannot be empty'));
    }
    if (handle.length > 30) {
      throw (Exception('Your Handle cannot be more than 30 characters'));
    }
    if (isValid == false) {
      throw ('Your Handle is already in use.');
    }
  }
}

//write a test for this. have a user click the text field, enter the value 'bruh, then press enter.
//then check if the user exists in the database. if it does, then the test passes. if it doesn't, then the test fails.

//write a test for this. have a user click the text field, enter the value 'bruh, then press enter.
void main() {
  testWidgets('Handle test', (WidgetTester tester) async {
    tester.enterText(find.byType(TextFormField), '');
    //press done
    tester.testTextInput.receiveAction(TextInputAction.done);

    //this should throw an error
    expect(tester.takeException(), isNotNull);

    tester.enterText(find.byType(TextFormField), '@');
    tester.testTextInput.receiveAction(TextInputAction.done);
    expect(tester.takeException(), isNotNull);

    tester.enterText(find.byType(TextFormField),
        '@aaaaàfbuabfhbajhfawhjfjafjajfajfajkfnjkanf');
    tester.testTextInput.receiveAction(TextInputAction.done);
    expect(tester.takeException(), isNotNull);

    tester.enterText(find.byType(TextFormField), '@bruh');
    tester.testTextInput.receiveAction(TextInputAction.done);

    //press enter

    // Verify that our counter has incremented.
  });
}
