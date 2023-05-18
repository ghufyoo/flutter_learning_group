import 'package:flutter_learning/app/data/repository/payment_repository_impl.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(paymentRepositoryImpl: Get.find()),
    );
       Get.lazyPut<PaymentRepositoryImpl>(
      () => PaymentRepositoryImpl(),
    );
  }

}
