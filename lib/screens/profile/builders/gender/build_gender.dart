import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/static_data/profile_data.dart';

class BuildGender {
  static Padding buildGender(User user, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: CoolDropdown(
            placeholder: '${user.gender}',
            dropdownHeight: 350,
            dropdownList: ProfileData.genders(context),
            onChange: (val) {
              String _gender = val['value'];
              BlocProvider.of<OnBoardingCubit>(context)
                  .updateOnBoardingUser(gender: _gender);
            },
            resultBD: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
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
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
            ),
            placeholderTS: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            selectedItemTS: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            unselectedItemTS: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            resultTS: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                )));
  }
}
