// To parse this JSON data, do
//
//     final paymentAuth = paymentAuthFromJson(jsonString);

import 'dart:convert';

PaymentAuth paymentAuthFromJson(String str) =>
    PaymentAuth.fromJson(json.decode(str));

String paymentAuthToJson(PaymentAuth data) => json.encode(data.toJson());

class PaymentAuth {
  PaymentAuth({
    required this.token,
    required this.expiration,
  });

  String token;
  dynamic expiration;

  factory PaymentAuth.fromJson(Map<String, dynamic> json) => PaymentAuth(
        token: json["token"] ?? "",
        expiration: json["expiration"] == null
            ? ""
            : DateTime.parse(json["expiration"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "expiration": expiration.toIso8601String(),
      };
}


// To parse this JSON data, do
//
//     final paymentIntent = paymentIntentFromJson(jsonString);



PaymentIntent paymentIntentFromJson(String str) => PaymentIntent.fromJson(json.decode(str));

String paymentIntentToJson(PaymentIntent data) => json.encode(data.toJson());

class PaymentIntent {
    PaymentIntent({
        required this.status,
        required this.result,
        required this.message,
    });

    String status;
    List<Result> result;
    String message;

    factory PaymentIntent.fromJson(Map<String, dynamic> json) => PaymentIntent(
        status: json["status"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "message": message,
    };
}

class Result {
    Result({
        required this.status,
        required this.key,
        required this.url,
        required this.error,
    });

    String status;
    String key;
    String url;
    dynamic error;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        status: json["status"],
        key: json["key"],
        url: json["url"],
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "key": key,
        "url": url,
        "error": error,
    };
}
