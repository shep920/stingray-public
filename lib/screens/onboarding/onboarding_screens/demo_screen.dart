import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:hero/screens/onboarding/widgets/widgets.dart';

import '../../../cubits/onboarding/on_boarding_cubit.dart';
import '../../../models/models.dart';
import '../widgets/custom_onbaording_buttons.dart';

class Demo extends StatefulWidget {
  final TabController tabController;

  const Demo({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  FocusNode _focusNode = FocusNode();
  FocusNode _bioFocusNode = FocusNode();
  final controller = TextEditingController();
  final _bioTextController = TextEditingController();

  initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .1),
            CustomTextHeader(
              text: 'What\'s your name?',
            ),
            SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  //autocapitalize the first letter
                  textCapitalization: TextCapitalization.sentences,
                  focusNode: _focusNode,
                  onSubmitted: (value) {
                    //go to the next focus node
                    _focusNode.unfocus();
                    _bioFocusNode.requestFocus();
                  },
                  controller: controller,
                  style: Theme.of(context).textTheme.headline5,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100),
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    contentPadding: EdgeInsets.only(bottom: 12.5, top: 12.5),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                )),
            CustomTextHeader(text: 'Describe Yourself'),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .4,
                  child: TextField(
                    //capitalization: TextCapitalization.sentences,

                    textCapitalization: TextCapitalization.sentences,

                    //a keyboard with done
                    textInputAction: TextInputAction.done,
                    maxLines: 8,
                    style: Theme.of(context).textTheme.headline5,
                    focusNode: _bioFocusNode,
                    onSubmitted: (value) {
                      //go to the next focus node
                      _bioFocusNode.unfocus();

                      //if name and bio are not empty
                      if (controller.text.isNotEmpty &&
                          _bioTextController.text.isNotEmpty) {
                        BlocProvider.of<OnBoardingCubit>(context)
                            .updateOnBoardingUser(
                                name: controller.text,
                                bio: _bioTextController.text);
                        widget.tabController.animateTo(3);
                      } else {
                        //show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
                      }
                    },
                    controller: _bioTextController,

                    inputFormatters: [
                      LengthLimitingTextInputFormatter(400),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      contentPadding: EdgeInsets.only(bottom: 12.5, top: 12.5),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                )),
            Column(
              children: [
                StepProgressIndicator(
                  totalSteps: 6,
                  currentStep: 3,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  unselectedColor: Theme.of(context).scaffoldBackgroundColor,
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
                      //go to the next focus node
                      _bioFocusNode.unfocus();

                      //if name and bio are not empty
                      if (controller.text.isNotEmpty &&
                          _bioTextController.text.isNotEmpty) {
                        BlocProvider.of<OnBoardingCubit>(context)
                            .updateOnBoardingUser(
                                name: controller.text,
                                bio: _bioTextController.text);
                        widget.tabController.animateTo(3);
                      } else {
                        //show snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectButtons extends StatelessWidget {
  final Color borderColor;
  final TextStyle? textStyle;
  final Color color;
  final String? text;
  final Color backgroundColor;
  const SelectButtons({
    Key? key,
    required this.borderColor,
    this.textStyle,
    required this.color,
    required this.text,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.075,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          color,
          Theme.of(context).backgroundColor,
        ]),
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Text(text!, style: textStyle)),
    );
  }
}
