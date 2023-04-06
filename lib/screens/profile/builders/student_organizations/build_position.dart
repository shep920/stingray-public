import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/static_data/general_profile_data/leadership.dart';

class BuildPostion {
  static Padding buildPositionDropdown(
      {required User user,
      required BuildContext context,
      required void Function(dynamic) onChange,
      required String placeholder,
      required List<dynamic> dropdownList,
      required double width}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: CoolDropdown(
          resultWidth: width,
          placeholderTS: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Theme.of(context).colorScheme.primary),
          placeholder: placeholder,
          dropdownHeight: 250,
          dropdownList: dropdownList,
          onChange: (val) {
            onChange(val);
          },
          resultBD: BoxDecoration(
            //add a gray border
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
          dropdownBD: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            //add a gray border
            border: Border.all(
              color: Theme.of(context).accentColor,
              width: 1,
            ),
          ),
          selectedItemTS: TextStyle(
            color: Theme.of(context).dividerColor,
          ),
          unselectedItemTS: TextStyle(
            color: Theme.of(context).accentColor,
          ),
          resultTS: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context).accentColor,
              )),
    );
  }
}
