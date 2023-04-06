import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/static_data/profile_data.dart';
import 'package:hero/widgets/dropdown_textfields/my_dropdown_textfield.dart';

import '../../../../../models/user_model.dart';
import '../../../../cubits/onboarding/on_boarding_cubit.dart';
import '../../../../widgets/postgrad_dropdown_textfield.dart';

class BuildPostGrad {
  static Row buildPostGrad(
      {required BuildContext context,
      required String value,
      required int index}) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: PostGradDropDownTextField(
            values: ProfileData.getPostGraddropDownValueModels(
                ProfileData.getPostGrads()),
            currentValue: DropDownValueModel(name: value, value: value),
          ),
        ),
        if (value != '')
          IconButton(
            icon: const Icon(
              Icons.remove_circle_outline,
              color: Colors.red,
            ),
            onPressed: () {
              BlocProvider.of<OnBoardingCubit>(context)
                  .updateOnBoardingUser(postGrad: '');
            },
          ),
        //green plus icon button
      ],
    );
  }
}
