import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/static_data/general_profile_data/fraternities.dart';
import 'package:hero/static_data/profile_data.dart';

class FraternityDropDownTextField extends StatefulWidget {
  final List<DropDownValueModel> values;
  final DropDownValueModel? currentValue;
  const FraternityDropDownTextField({
    Key? key,
    required this.values,
    required this.currentValue,
  }) : super(key: key);

  @override
  State<FraternityDropDownTextField> createState() =>
      _FraternityDropDownTextFieldState();
}

class _FraternityDropDownTextFieldState
    extends State<FraternityDropDownTextField> {
  final SingleValueDropDownController _controller =
      SingleValueDropDownController();
  late IconData _icon;

  @override
  initState() {
    if (widget.currentValue != null) {
      _controller.setDropDown(widget.currentValue!);
    } else {
      _controller.setDropDown(Fraternities.getFraternities()
          .firstWhere((frat) => frat['label'] == 'None'));
    }

    _icon = Fraternities.getFraternities().firstWhere(
        (frat) => frat['label'] == widget.currentValue!.name)['icon'];

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
          _icon = Fraternities.getFraternities()
              .firstWhere((frat) => frat['label'] == val.name)['icon'];
        });

        BlocProvider.of<OnBoardingCubit>(context)
            .updateOnBoardingUser(fraternity: val.name);
      },
    );
  }
}
