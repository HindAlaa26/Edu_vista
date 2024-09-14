import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';

class ArrowIcon extends StatefulWidget {
  final PageController onBoardingController;
  final int currentPage;
  final bool isNext;
  const ArrowIcon({
    super.key,
    required this.onBoardingController,
    required this.currentPage,
    required this.isNext,
  });

  @override
  State<ArrowIcon> createState() => _ArrowIconState();
}

class _ArrowIconState extends State<ArrowIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          widget.isNext ? next() : previous();
        },
        icon: Icon(
          widget.isNext ? Icons.arrow_circle_right : Icons.arrow_circle_left,
          color: widget.isNext ? whenPageEnded() : whenPageStarted(),
          size: 70,
        ));
  }

  Color whenPageStarted() {
    return widget.currentPage == 0
        ? const Color(0xffD1D1D6)
        : ColorUtility.secondary;
  }

  Color whenPageEnded() {
    return widget.currentPage == 3
        ? const Color(0xffD1D1D6)
        : ColorUtility.secondary;
  }

  void previous() {
    widget.onBoardingController.previousPage(
        duration: const Duration(seconds: 1), curve: Curves.decelerate);
  }

  void next() {
    widget.onBoardingController.nextPage(
        duration: const Duration(seconds: 1), curve: Curves.decelerate);
  }
}
