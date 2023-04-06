import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/static_data/general_profile_data/nothing_data.dart';
import 'package:hero/static_data/profile_data.dart';

class PostGradDropDownTextField extends StatefulWidget {
  final List<DropDownValueModel> values;
  final DropDownValueModel? currentValue;
  const PostGradDropDownTextField({
    Key? key,
    required this.values,
    required this.currentValue,
  }) : super(key: key);

  @override
  State<PostGradDropDownTextField> createState() =>
      _PostGradDropDownTextFieldState();
}

class _PostGradDropDownTextFieldState extends State<PostGradDropDownTextField> {
  final SingleValueDropDownController _controller =
      SingleValueDropDownController();

  @override
  initState() {
    if (widget.currentValue != null) {
      _controller.setDropDown(widget.currentValue!);
    } else {
      _controller.setDropDown(Nothing.nothing);
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
        BlocProvider.of<OnBoardingCubit>(context)
            .updateOnBoardingUser(postGrad: val.name);
      },
    );
  }
}
