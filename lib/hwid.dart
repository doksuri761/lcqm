import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'dart:math';

Future<String> getMobileId() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String id = '';
  try {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidData = await deviceInfoPlugin.androidInfo;
      id = androidData.androidId;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosData = await deviceInfoPlugin.iosInfo;
      id = iosData.identifierForVendor;
    }
  } on PlatformException {
    id = 'UnknownOS-${Random().nextInt(999999).toString().padRight(6, "0")}';
  }
  debugPrint('id: $id');
  return id;
}
