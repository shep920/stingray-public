import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';
import 'package:hero/models/user_model.dart';
import 'package:hero/static_data/general_profile_data/student_organitzations.dart';
import 'package:hero/widgets/dropdown_textfields/my_dropdown_textfield_studenOrganizations.dart';

class BuildStudentOrg {
  static Row buildStudentOrg(BuildContext context, String currentOrg,
      void Function() delete, int index) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .5,
          child: MyDropDownTextFieldStudentOrganizations(
            index: index,
            values: StudentOrganizations.getOrganizationdropDownValueModels(
                StudentOrganizations.getOrganizations()),
            currentValue:
                DropDownValueModel(name: currentOrg, value: currentOrg),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.remove_circle_outline,
            color: Colors.red,
          ),
          onPressed: () {
            delete();
          },
        ),
      ],
    );
  }
}
