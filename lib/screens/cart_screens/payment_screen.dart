import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/cart_bloc/cart_event.dart';
import '../../models/course_model.dart';
import '../../shared_component/default_text.dart';

class PaymentScreen extends StatefulWidget {
  final price;
  final Course course;

  const PaymentScreen({super.key, required this.price, required this.course});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isSelected = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textInApp(text: "Payment Method"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorUtility.main,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textInApp(
                  text: "Select Your Payment Method",
                  fontSize: 11,
                  fontWeight: FontWeight.w500),
            ],
          ),
          InkWell(
            onTap: () {
              context
                  .read<CartBloc>()
                  .add(CheckoutCart(context: context, course: widget.course));
              setState(() {
                isSelected = true;
              });
              setState(() {
                isLoading = true;
              });
            },
            child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: isSelected ? Colors.white : ColorUtility.grey,
                    border: Border.all(
                      color: isSelected
                          ? ColorUtility.secondary
                          : ColorUtility.grey,
                    ),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textInApp(
                      text: 'Card',
                      fontSize: 15,
                      color: isSelected
                          ? ColorUtility.secondary
                          : ColorUtility.black,
                    ),
                    Icon(
                      Icons.album_outlined,
                      color: isSelected ? ColorUtility.secondary : Colors.white,
                    ),
                  ],
                )),
          ),
          isLoading
              ? const CircularProgressIndicator(
                  color: ColorUtility.secondary,
                )
              : const SizedBox()
        ]),
      ),
    );
  }
}
