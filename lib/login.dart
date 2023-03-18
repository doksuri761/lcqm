// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:motion_toast/motion_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import './hwid.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? userNameController = TextEditingController();
  TextEditingController? pskController = TextEditingController();
  bool passwordVisibility = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: "gamjaflower"),
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 0x73, 0xde, 0xe2),
                  title: const Center(
                      child: Text('비엠타는 공돌이: 재고관리 시스템',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontFamily: 'gamjaflower')))),
              body: SingleChildScrollView(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Column(children: [
                    const SizedBox(
                      height: 200,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '이름과 공유된 PSK를 입력해주세요',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'PSK는 대소문자를 구분합니다.',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: userNameController,
                        autofocus: false,
                        obscureText: false,
                        decoration: const InputDecoration(
                            hintText: "이름을 입력하세요",
                            hintStyle: TextStyle(color: Colors.black54)),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                          controller: pskController,
                          autofocus: false,
                          obscureText: !passwordVisibility,
                          decoration: InputDecoration(
                              hintText: 'PSK를 입력해주세요',
                              suffixIcon: InkWell(
                                onTap: () => setState(
                                  () =>
                                      passwordVisibility = !passwordVisibility,
                                ),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  passwordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: passwordVisibility
                                      ? const Color(0xFF73DEE2)
                                      : const Color(0xFFAAAAAA),
                                  size: 22,
                                ),
                              ),
                              hintStyle:
                                  const TextStyle(color: Colors.black54))),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextButton(
                      onPressed: () async {
                        var psk = pskController?.value.text;
                        var username = userNameController?.value.text;
                        if (psk != "" && username != "") {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.orangeAccent),
                                ),
                              ));
                          var box = Hive.box('auth');
                          final dio = Dio();
                          String uri = "http://happyllama.sytes.net:8787";
                          final res = await dio.post("$uri/auth/register/nap",
                              queryParameters: {
                                "psk": pskController?.value.text,
                                "name": userNameController?.value.text
                              });
                          String salt = res.data["salt"];
                          String encodedId = sha256
                              .convert(utf8.encode(await getMobileId() + salt))
                              .toString();
                          await dio.post("$uri/auth/register/hwid",
                              queryParameters: {
                                "psk": pskController?.value.text,
                                "hardwareid": encodedId
                              });
                          box.put("salt", salt);
                          box.put("auth", "true");
                          box.put("psk", psk);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyApp()),
                              (route) => false);
                        } else {
                          MotionToast.error(
                            title: const Text(
                              '오류',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            description: const Text('이름또는 PSK가 작성되지 않았습니다.'),
                            barrierColor: Colors.black.withOpacity(0.3),
                            width: 300,
                            height: 80,
                            dismissable: true,
                          ).show(context);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF73DEE2)),
                          minimumSize:
                              MaterialStateProperty.all(const Size(130, 40))),
                      child: const Text(
                        "로그인",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ]),
                ]),
              ),
            );
          },
        ));
  }
}
