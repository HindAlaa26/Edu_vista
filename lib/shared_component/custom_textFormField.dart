import 'package:edu_vista/shared_component/default_text.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextFormField extends StatelessWidget {
  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.validatorText,
    required this.hintText,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.onSaved,
    this.isPassword = false,
  });
  final TextEditingController controller;
  final String validatorText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final void Function(String?)? onSaved;
  final List<TextInputFormatter>? inputFormatters;
  final String label;
  final String hintText;
  final bool isPassword;
  InputBorder get textFieldBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: ColorUtility.grey));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: textInApp(
              text: label,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            onFieldSubmitted: onSaved,
            inputFormatters: inputFormatters,
            obscureText: isPassword,
            validator: (value) {
              if (value!.isEmpty) {
                return '$validatorText must not be empty';
              }
              return null;
            },
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            cursorColor: ColorUtility.grey,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            decoration: InputDecoration(
                hintText: hintText,
                enabledBorder: textFieldBorder,
                errorBorder: textFieldBorder.copyWith(
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: textFieldBorder.copyWith(
                    borderSide: const BorderSide(color: Colors.red)),
                focusedBorder: textFieldBorder.copyWith(
                    borderSide: const BorderSide(color: ColorUtility.grey))),
          ),
        ],
      ),
    );
  }
}
