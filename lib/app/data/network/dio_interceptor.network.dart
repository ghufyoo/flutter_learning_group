import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'network_service.network.dart';

class NetworkService extends GetxService {
  final String _baseURL = "https://sandbox-payexapi.azurewebsites.net/";

  late dio.Dio _dio;

  NetworkService() {
    dio.BaseOptions options = dio.BaseOptions(
      receiveTimeout: 200000,
      connectTimeout: 200000,
      sendTimeout: 200000,
      headers: {},
      // validateStatus: (status) {
      //   log('Status: $status');
      //   return status! <= 500;
      // });
    );
    _dio = dio.Dio(options);
    _dio.interceptors.add(LoggingInterceptor());
  }

  Future get(String endpoint, {Map<String, dynamic> data = const {}}) async {
    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    dio.Response response;
    try {
      response = await _dio.get(endpoint,
          queryParameters: data,
          options: dio.Options(headers: {
            'Authorization': "Bearer $_baseURL",
          }));
      return response;
    } on dio.DioError catch (error) {
      if (Get.isDialogOpen!) {
        Get.back();
      }

      String er = _handleError(error);
      log(er);
      await _dialogResponse(error);
    }
  }

  Future post(String endpoint, var data, String bearer,
      {bool? hasLoader, Function(int, int)? onsendProgress}) async {
    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    dio.Response response;
    if (hasLoader == null) {
      //  ConstantWidget().loading;
    } else if (hasLoader == false) {}
    try {
      response = await _dio.post(_baseURL + endpoint,
          options: dio.Options(headers: {
            "Content-Type": "application/json",
            'Authorization': "Bearer $bearer",
          }),
          data: data,
          onSendProgress: onsendProgress);
      return response;
    } on dio.DioError catch (error) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
      String er = _handleError(error);
      log(er);
      await _dialogResponse(error);
    }
  }

  // Future put(String endpoint, var data) async {
  //   if (Get.isSnackbarOpen) {
  //     await Get.closeCurrentSnackbar();
  //   }
  //   dio.Response response;
  //   ConstantWidget().loading;
  //   try {
  //     response = await _dio.put(_baseURL + endpoint,
  //         options: dio.Options(headers: {
  //           'Authorization':
  //               "Bearer ${Get.find<LocalDbService>().getUser().token}"
  //         }),
  //         data: data);
  //     return response;
  //   } on dio.DioError catch (error) {
  //     if (Get.isDialogOpen!) {
  //       Get.back();
  //     }
  //     String er = _handleError(error);
  //     log(er);
  //     await _dialogResponse(error);
  //   }
  // }

  Future delete(String endpoint, var data) async {
    if (Get.isSnackbarOpen) {
      await Get.closeCurrentSnackbar();
    }
    dio.Response response;
    try {
      response = await _dio.delete(_baseURL + endpoint,
          options: dio.Options(headers: {
            'Authorization': "Bearer ",
          }),
          data: data);
      return response;
    } on dio.DioError catch (error) {
      String er = _handleError(error);
      log(er);
      await _dialogResponse(error);
    }
  }

  String _handleError(dio.DioError error) {
    String errorDescription = "";
    // ignore: unnecessary_type_check
    if (error is dio.DioError) {
      switch (error.type) {
        case dio.DioErrorType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case dio.DioErrorType.connectTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case dio.DioErrorType.other:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case dio.DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case dio.DioErrorType.response:
          errorDescription =
              "Received invalid status code: ${error.response!.statusCode}";
          break;
        case dio.DioErrorType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }

  _dialogResponse(dio.DioError error) {
    // log(error.response.toString());
    if (error.response?.statusCode == 400) {
      return Get.dialog(
          ErrorResponseDialog(errorText: error.response.toString()),
          barrierColor: Colors.black.withOpacity(0.5));
    } else if (error.response?.statusCode == 500) {
      return Get.dialog(
          ErrorResponseDialog(errorText: error.response.toString()),
          barrierColor: Colors.black.withOpacity(0.5));
    } else if (error.response?.statusCode == null) {
      return Get.dialog(const NoInternetConnectionDialog(),
          barrierColor: Colors.black.withOpacity(0.5));
    } else {}
  }
}

class ErrorResponseDialog extends StatelessWidget {
  const ErrorResponseDialog({
    Key? key,
    required this.errorText,
  }) : super(key: key);

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: Get.width * 0.9,
                constraints: BoxConstraints(minHeight: Get.height * 0.25),
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Padding(
                      padding: EdgeInsets.all(20.0.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: constraints.minHeight * 0.05),
                              Text("Uh Oh!",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.grey[850],
                                          fontSize: 22.0.sp,
                                          fontWeight: FontWeight.w500))),
                              SizedBox(height: constraints.minHeight * 0.05),
                              Text(errorText,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      textStyle: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 15.0.sp,
                                              height: 1.5,
                                              fontWeight: FontWeight.w400)))),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: Get.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 15.sp),
                                    Expanded(
                                      child: SizedBox(
                                        height: 55.sp,
                                        child: ElevatedButton(
                                            onPressed: () => Get.back(),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.amber),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)))),
                                            child: Text(
                                              "Got it",
                                              style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            )),
                                      ),
                                    ),
                                    SizedBox(width: 15.sp),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 5.sp),
            Text("Tap anywhere to dismiss",
                style:
                    GoogleFonts.montserrat(color: Colors.white, fontSize: 11))
          ],
        ),
      ),
    );
  }
}

class NoInternetConnectionDialog extends StatelessWidget {
  const NoInternetConnectionDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: Get.width * 0.9,
                constraints: BoxConstraints(minHeight: Get.height * 0.25),
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Padding(
                      padding: EdgeInsets.all(20.0.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: constraints.minHeight * 0.05),
                              Text("Uh Oh!",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.grey[850],
                                          fontSize: 22.0.sp,
                                          fontWeight: FontWeight.w500))),
                              SizedBox(height: constraints.minHeight * 0.05),
                              Text(
                                  "Please make sure you have an active internet connection.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      textStyle: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 15.0.sp,
                                              height: 1.5,
                                              fontWeight: FontWeight.w400)))),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: Get.width,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 15.sp),
                                    Expanded(
                                      child: SizedBox(
                                        height: 55.sp,
                                        child: ElevatedButton(
                                            onPressed: () => Get.back(),
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.yellow),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5)))),
                                            child: Text(
                                              "Got it",
                                              style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            )),
                                      ),
                                    ),
                                    SizedBox(width: 15.sp),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 5.sp),
            Text("Tap anywhere to dismiss",
                style:
                    GoogleFonts.montserrat(color: Colors.white, fontSize: 11))
          ],
        ),
      ),
    );
  }
}
