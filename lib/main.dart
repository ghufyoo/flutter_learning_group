import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'app/data/network/dio_interceptor.network.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await Get.putAsync(() async => NetworkService());
  runApp(
    Sizer(builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: "Application",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      }
    ),
  );
}
