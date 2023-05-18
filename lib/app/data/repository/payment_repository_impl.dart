import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../models/payment.model.dart';
import '../network/dio_interceptor.network.dart';
import 'payment_repository.dart';

class PaymentRepositoryImpl implements AuthRepository {
  final apiService = Get.find<NetworkService>();
  final baseUrl = "https://sandbox-payexapi.azurewebsites.net/";
  final secretKey = "kYFDvqHcDFUCMf9AGYSFrqJIe3NNW74P";
  final email = "smgarctictech@gmail.com";
  @override
  Future<PaymentAuth> authorize() async {
    try {
      String basicAuth =
          'Basic ${base64.encode(utf8.encode('$email:$secretKey'))}';
      dio.Response response = await Dio().post(
        "$baseUrl/api/Auth/Token",
        options: dio.Options(headers: {'Authorization': basicAuth}),
      );
      log(response.statusCode.toString());
      final bearer = paymentAuthFromJson(json.encode(response.data));
      log("${bearer.token}test");
      return bearer;
    } catch (e, stacktrace) {
      log(stacktrace.toString());
      throw UnimplementedError(e.toString());
    }
  }

  @override
  Future<PaymentIntent> paymentIntent(
      String token,fullName,emailAddress,phoneNumber,address,postcode,city,state, int total) async {
    try {
      final body = [
        {
          "amount": total,
          "currency": "MYR",
          "customer_name": fullName,
          "email": emailAddress,
          "contact_number": phoneNumber,
          "address": address,
          "postcode": postcode,
          "city": city,
          "state": state,
          "country": "MY",
          "description": "string",
          "return_url": "https://smgarctic.com/",
          "callback_url": ""
        }
      ];
      dio.Response response = await apiService.post(
          "api/v1/PaymentIntents", json.encode(body), token,
          hasLoader: false);

      log(response.statusCode.toString());
      final url = paymentIntentFromJson(json.encode(response.data));

      return url;
    } catch (e, stacktrace) {
      log(stacktrace.toString());
      throw UnimplementedError(e.toString());
    }
  }

}
