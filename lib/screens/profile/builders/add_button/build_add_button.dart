import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hero/cubits/onboarding/on_boarding_cubit.dart';

class BuildAddButton {
  static IconButton buildAddButton(
      BuildContext context, void Function() updateOnBoardingUser) {
    return IconButton(
      icon: const Icon(
        Icons.add_circle,
        color: Colors.green,
      ),
      onPressed: () => updateOnBoardingUser(),
    );
  }
}
