import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/static_data/profile_data.dart';

class MyDropDownTextField extends StatefulWidget {
  final int index;
  final List<DropDownValueModel> values;
  final DropDownValueModel? currentValue;
  const MyDropDownTextField({
    Key? key,
    required this.values,
    required this.currentValue,
    required this.index,
  }) : super(key: key);

  @override
  State<MyDropDownTextField> createState() => _MyDropDownTextFieldState();
}

class _MyDropDownTextFieldState extends State<MyDropDownTextField> {
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

    _icon = ProfileData.getUndergrads().firstWhere(
        (undergrad) => undergrad['label'] == widget.currentValue!.name)['icon'];

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
      textStyle: Theme.of(context).textTheme.headline4!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
      dropDownIconProperty: IconProperty(
        color: Theme.of(context).colorScheme.primary,
        icon: _icon,
      ),
      controller: _controller,
      enableSearch: true,
      clearIconProperty: IconProperty(
          color: Theme.of(context).colorScheme.primary, icon: _icon),
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
        setState(() {
          _icon = ProfileData.getUndergrads().firstWhere(
              (undergrad) => undergrad['label'] == val.name)['icon'];
        });
        if (widget.index == 0) {
          BlocProvider.of<OnBoardingCubit>(context)
              .updateOnBoardingUser(firstUndergrad: val.name);
        } else if (widget.index == 1) {
          BlocProvider.of<OnBoardingCubit>(context)
              .updateOnBoardingUser(secondUndergrad: val.name);
        } else if (widget.index == 2) {
          BlocProvider.of<OnBoardingCubit>(context)
              .updateOnBoardingUser(thirdUndergrad: val.name);
        }
      },
    );
  }
}
