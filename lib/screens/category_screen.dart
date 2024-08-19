import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_vista/utils/color_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/category_model.dart';
import '../shared_component/default_text_component .dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var futureCall = FirebaseFirestore.instance.collection('categories').get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: textInApp(text: "Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
          future: futureCall,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: ColorUtility.secondary),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: textInApp(text: 'Error occurred'),
              );
            }

            if (!snapshot.hasData || (snapshot.data?.docs.isEmpty ?? false)) {
              return Center(
                child: textInApp(text: 'No categories found'),
              );
            }

            var categories = List<Category>.from(snapshot.data?.docs
                    .map((e) => Category.fromJson({'id': e.id, ...e.data()}))
                    .toList() ??
                []);

            return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: categories.length,
              separatorBuilder: (context, index) => SizedBox(
                width: 10.w,
              ),
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: textInApp(
                      text: categories[index].name ?? 'No Name',
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            );
          }),
    );
  }
}
