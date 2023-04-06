import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/static_data/profile_data.dart';

class MyDropDownTextField extends StatefulWidget {
  final List<DropDownValueModel> values;
  final DropDownValueModel? currentValue;
  final List<dynamic> staticData;
  final void Function() onChange;
  const MyDropDownTextField(
      {Key? key,
      required this.values,
      required this.currentValue,
      required this.staticData,
      required this.onChange})
      : super(key: key);

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
      _controller.setDropDown(widget.staticData
          .firstWhere((undergrad) => undergrad['label'] == 'None'));
    }

    _icon = widget.staticData.firstWhere(
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
      textStyle: Theme.of(context).textTheme.headline4,
      dropDownIconProperty: IconProperty(
        color: Theme.of(context).colorScheme.primary,
        icon:
            //from the getundergrads method, set the icon where the value of label is equal to the value of the current value
            _icon,
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
          _icon = widget.staticData.firstWhere(
              (undergrad) => undergrad['label'] == val.name)['icon'];
        });
        widget.onChange();

        // BlocProvider.of<OnBoardingCubit>(context)
        //     .updateOnBoardingUser(firstUndergrad: val.name);
      },
    );
  }
}
