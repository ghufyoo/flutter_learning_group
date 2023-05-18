import '../models/payment.model.dart';

abstract class AuthRepository {
  Future<PaymentAuth> authorize();
    Future<PaymentIntent> paymentIntent(
      String token,fullName,emailAddress,phoneNumber,address,postcode,city,state, int total);

}
