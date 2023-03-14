import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lcqm/SearchAndManage.dart';
import 'package:lcqm/login.dart';
import 'package:motion_toast/motion_toast.dart';
import 'firebase_options.dart';
import 'in.dart';

void main() async {
  islogin();
}

const double height = 0.125;
const double width = 0.60;

void islogin() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('auth');
  if (box.get("auth", defaultValue: "") == "") {
    runApp(const LoginScreen());
  } else {
    runApp(const MyApp());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return FutureBuilder(
      future: Firebase.initializeApp(
        name: "lcqm",
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("firebase load fail"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return const MaterialApp(home: HomePage());
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Screen 4"),
      ),
      body: const Center(
        child: Text("This is Screen 4"),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("비엠타는 공돌이: 재고관리 시스템"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * width,
                  height: MediaQuery.of(context).size.height * height,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(42, 145, 205, 1.0))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const In()),
                      );
                    },
                    child: Text("파일 입고",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: (((MediaQuery.of(context).size.width +
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        0.001) *
                                    20)
                                .roundToDouble())),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * width,
                  height: MediaQuery.of(context).size.height * height,
                  child: ElevatedButton(
                    onPressed: () {
                      MotionToast.info(
                        title: const Text(
                          '현재 개발중',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        description: const Text('현재 개발중인 피쳐입니다.🛠'),
                      ).show(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(2, 24, 104, 1.0))),
                    child: Text("QR 출고",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: (((MediaQuery.of(context).size.width +
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        0.001) *
                                    20)
                                .roundToDouble())),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * width,
                  height: MediaQuery.of(context).size.height * height,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(241, 27, 35, 1.0))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Screen3()),
                      );
                    },
                    child: Text("검색및 관리",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: (((MediaQuery.of(context).size.width +
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        0.001) *
                                    20)
                                .roundToDouble())),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * width,
                  height: MediaQuery.of(context).size.height * height,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(127, 127, 127, 1.0))),
                      onPressed: () {
                        exit(0);
                      },
                      child: Text(
                        "종료",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: (((MediaQuery.of(context).size.width +
                                            MediaQuery.of(context)
                                                .size
                                                .height) *
                                        0.001) *
                                    20)
                                .roundToDouble()),
                      )),
                ),
              ],
            ),
          ),
          Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onLongPress: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text("로그아웃 하시겠습니까?"),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                }, child: const Text("취소")),
                            TextButton(
                                onPressed: () {
                                  final box = Hive.box("auth");
                                  box.delete("auth");
                                  toast("로그아웃 되었습니다.\n종료 버튼을 눌러 종료후 재시작 해주세요.");
                                  Navigator.pop(context);
                                },
                                child: const Text("로그아웃"))
                          ],
                        );
                      });
                },
                child: IconButton(
                  onPressed: () {
                    toast("로그아웃 하시려면 길게 눌러주세요");
                  },
                  icon: const Icon(Icons.settings),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(50, 50, 50, 1.0)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(50, 50, 50, 1.0)),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
