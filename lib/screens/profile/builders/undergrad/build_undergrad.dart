import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/static_data/profile_data.dart';
import 'package:hero/widgets/dropdown_textfields/my_dropdown_textfield.dart';

import '../../../../../models/user_model.dart';
import '../../../../cubits/onboarding/on_boarding_cubit.dart';

class BuildUndergrad{
 static Row buildUndergrad({required BuildContext context, required String value, required void Function()? delete, required int index}) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: MyDropDownTextField(
            index: index,
            values: ProfileData.getUndergraddropDownValueModels(
                ProfileData.getUndergrads()),
            currentValue: DropDownValueModel(
                name: value, value: value),
          ),
        ),
        if(delete != null)
        IconButton(
          icon: const Icon(
            Icons.remove_circle_outline,
            color: Colors.red,
          ),
          onPressed: () {
            // BlocProvider.of<OnBoardingCubit>(context)
            //     .updateOnBoardingUser(secondUndergrad: '');
            delete();
          },
        ),
        //green plus icon button
      ],
    );
  }
}