import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hint;

  final String? initialValue;
  final Function(String)? onChanged;
  final double height;

  CustomTextField({
    Key? key,
    required this.height,
    required this.hint,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: hint,
          contentPadding:  EdgeInsets.only(bottom: height, top: 12.5),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        initialValue: initialValue,
        onChanged: onChanged,
      ),
    );
  }
}
