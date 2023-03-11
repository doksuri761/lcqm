import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lcqm/login.dart';
import 'package:motion_toast/motion_toast.dart';
import 'in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:lcqm/SearchAndManage.dart';

const double width = 0.60;
const double height = 0.125;

void main() async {
  // runApp(MyApp());
  islogin();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return FutureBuilder(future: Firebase.initializeApp(name: "lcqm", options: DefaultFirebaseOptions.currentPlatform,),
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
    );}
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("비엠타는 공돌이: 재고관리 시스템"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * width,
              height: MediaQuery.of(context).size.height * height,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(
                    42, 145, 205, 1.0))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const In()),
                  );
                },
                child: Text("파일 입고", style: TextStyle(color: Colors.white, fontSize: (((MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) * 0.001) * 20).roundToDouble())),
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
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(
                    2, 24, 104, 1.0))),
                child: Text("QR 출고", style: TextStyle(color: Colors.white, fontSize: (((MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) * 0.001) * 20).roundToDouble())),

              ),
            ),
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * width,
              height: MediaQuery.of(context).size.height * height,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(
                    241, 27, 35, 1.0))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Screen3()),
                  );
                },
                child: Text("검색및 관리", style: TextStyle(color: Colors.white, fontSize: (((MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) * 0.001) * 20).roundToDouble())),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * width,
              height: MediaQuery.of(context).size.height * height,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(
                    127, 127, 127, 1.0))),
                onPressed: () {
                  exit(0);
                },
                child: Text("종료", style: TextStyle(color: Colors.white, fontSize: (((MediaQuery.of(context).size.width + MediaQuery.of(context).size.height) * 0.001) * 20).roundToDouble()),)
              ),
            ),
          ],
        ),
      ),
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

void islogin() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('auth');
  if (box.get("auth", defaultValue: "") == "") {
    runApp(const LoginScreen());
  } else {
    runApp(const MyApp());
  }
}