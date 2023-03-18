import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class ManageInterceptor extends Interceptor {
  late BuildContext context;

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    final isStatus500 = err.response?.statusCode == 500;
    final isStatus401 = err.response?.statusCode == 401;
    final isStatus404 = err.response?.statusCode == 404;
    if (isStatus500) {
      MotionToast.error(
        title: const Text("Error"),
        description: const Text(
            "내부 서버 오류\n정의되지 않은 오류입니다.\n개발자에게 문의해주세요.\nErrorCode: 500"),
        toastDuration: const Duration(seconds: 2),
      ).show(context);
    }
    if (isStatus401) {
      MotionToast.error(
        title: const Text("Error"),
        description: const Text("인증 오류\n로그인이 필요합니다.\nErrorCode: 401"),
        toastDuration: const Duration(seconds: 2),
      ).show(context);
    }
    if (isStatus404) {
      MotionToast.error(
        title: const Text("Error"),
        description: Text(
            "오류가 발생했습니다.\n${err.response?.data["error"]}\nErrorCode: 404"),
        toastDuration: const Duration(seconds: 2),
      ).show(context);
    }
    handler.resolve(err.response!);
  }
}