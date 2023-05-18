import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter learning group'),
        centerTitle: true,
      ),
      body: Center(
          child: InkWell(
        onTap: () => controller.makePayment(),
        child: Container(
          width: Get.width * 0.8,
          height: Get.height * 0.1,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
              ),
              color: Colors.lightBlueAccent),
          child: Center(
            child: Text(
              "Make Payment",
              style: GoogleFonts.aBeeZee(),
            ),
          ),
        ),
      )),
    );
  }
}
