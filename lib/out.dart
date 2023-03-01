import 'package:flutter/material.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({Key? key}) : super(key: key);

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  String _output = 'Empty Scan Code';
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Text("asdf");
  }

}
