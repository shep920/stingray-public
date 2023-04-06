import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/static_data/profile_data.dart';

import '../../static_data/general_profile_data/student_organitzations.dart';

class MyDropDownTextFieldStudentOrganizations extends StatefulWidget {
  final int index;
  final List<DropDownValueModel> values;
  final DropDownValueModel? currentValue;
  const MyDropDownTextFieldStudentOrganizations({
    Key? key,
    required this.values,
    required this.currentValue,
    required this.index,
  }) : super(key: key);

  @override
  State<MyDropDownTextFieldStudentOrganizations> createState() =>
      _MyDropDownTextFieldStudentOrganizationsState();
}

class _MyDropDownTextFieldStudentOrganizationsState
    extends State<MyDropDownTextFieldStudentOrganizations> {
  final SingleValueDropDownController _controller =
      SingleValueDropDownController();
  late IconData _icon;

  initState() {
    if (widget.currentValue != null) {
      _controller.setDropDown(widget.currentValue!);
    } else {
      _controller.setDropDown(ProfileData.getUndergrads()
          .firstWhere((undergrad) => undergrad['label'] == 'None'));
    }

    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropDownTextField(
      listTextStyle: Theme.of(context).textTheme.headline4!.copyWith(
            color: Colors.black,
          ),
      textStyle: Theme.of(context).textTheme.headline4,
      dropDownIconProperty: IconProperty(
        color: Theme.of(context).colorScheme.primary,
      ),
      clearOption: false,
      controller: _controller,
      enableSearch: true,
      searchDecoration:
          const InputDecoration(hintText: "Search for your major here..."),
      validator: (value) {
        if (value == null) {
          return "Required field";
        } else {
          return null;
        }
      },
      dropDownItemCount: 6,
      dropDownList: widget.values,
      onChanged: (val) {
        if (widget.index == 0) {
          BlocProvider.of<OnBoardingCubit>(context).updateOnBoardingUser(
              firstStudentOrganization: val.name,
              firstStudentOrgPosition: 'Member');
        } else if (widget.index == 1) {
          BlocProvider.of<OnBoardingCubit>(context).updateOnBoardingUser(
              secondStudentOrganization: val.name,
              secondStudentOrgPosition: 'Member');
        } else if (widget.index == 2) {
          BlocProvider.of<OnBoardingCubit>(context).updateOnBoardingUser(
              thirdStudentOrganization: val.name,
              thirdStudentOrgPosition: 'Member');
        }
      },
    );
  }
}
