import 'package:flutter/material.dart';
import 'default_text.dart';

class LabelWidget extends StatelessWidget {
  final String name;
  final void Function()? onSeeAllClicked;
  const LabelWidget({required this.name, this.onSeeAllClicked, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textInApp(text: name, fontSize: 18),
          InkWell(
            onTap: onSeeAllClicked,
            child: textInApp(
                text: "See All", fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
