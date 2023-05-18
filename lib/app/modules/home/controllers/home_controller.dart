import 'dart:developer';

import 'package:flutter_learning/app/helper/loading.widget.dart';
import 'package:get/get.dart';

import '../../../data/repository/payment_repository_impl.dart';
import '../../payment/views/payment_view.dart';

class HomeController extends GetxController {
  HomeController({required this.paymentRepositoryImpl});
  final PaymentRepositoryImpl paymentRepositoryImpl;

  final count = 0.obs;

  makePayment() async {
    try {
      LoaderWidget();
      final token = await paymentRepositoryImpl.authorize();
      //total payment you must convert to integer
      //example:
      // RM 1.00 is equivalent to 100, RM 20.00 is equivalent to 2000,
      // to convert your value to integer use the following
      // final totalPrice = int.parse(price.replaceAll("RM", "").replaceAll(".", ""));
      final paymentUrl = await paymentRepositoryImpl.paymentIntent(
          token.token,
          "customer name",
          "customer@gmail.com",
          "012345678",
          "customer address",
          "63000",
          "Cyberjaya",
          "Selangor",
          100);
      final success = await Get.to(
          () => PaymentView(paymentUrl: paymentUrl.result.first.url));
      if (Get.isDialogOpen!) {
        Get.close(1);
      }
      if (success) {
        print("payment successful");
      } else {
        print("payment failed");
      }

      if (Get.isDialogOpen!) {
        Get.close(1);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
