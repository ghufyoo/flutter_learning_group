import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';



class LoaderWidget {
  final loading = Get.dialog(
      Align(
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
          child:  SizedBox(
              width: 40.w,
              height: 20.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 30.sp,
                      height: 30.sp,
                      child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.blue, size: 40)),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("loading...",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600))),
                    ],
                  )
                ],
              ),
            ),
         
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false);
}