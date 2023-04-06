import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/static_data/general_profile_data/fraternities.dart';
import 'package:hero/static_data/general_profile_data/student_organitzations.dart';
import 'package:hero/widgets/dropdown_textfields/my_dropdown_textfield_studenOrganizations.dart';

import '../../../../widgets/dropdown_textfields/fraternity_dropdown_textfield copy.dart';

class BuildFraternity {
  static Row buildFraternity(
      {required BuildContext context, required String currentFraternity}) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: FraternityDropDownTextField(
            values: Fraternities.getFraternitydropDownValueModels(
                Fraternities.getFraternities()),
            currentValue: DropDownValueModel(
                name: currentFraternity, value: currentFraternity),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.remove_circle_outline,
            color: Colors.red,
          ),
          onPressed: () {
            BlocProvider.of<OnBoardingCubit>(context)
                .updateOnBoardingUser(fraternity: '');
          },
        ),
      ],
    );
  }
}
