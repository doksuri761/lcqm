import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:lcqm/interceptors/manageInterceptor.dart';

String baseuri = "http://gongdol.ipdisk.co.kr";

class InfoScreen extends StatefulWidget {
  final String? modelno;
  const InfoScreen({super.key, this.modelno});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  Dio dio = Dio();
  String data = '';
  String brandname = '';
  String codename = '';
  String price = '';
  String koprice = '';
  String note2 = '';
  String note1 = '';
  String qty = '';

  TextEditingController ipgoc = TextEditingController();

  late Map<String, String> header;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(title: const Text("비엠타는 공돌이: 재고관리 시스템"), centerTitle: false),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "제조사: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  brandname.toString(),
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "코드네임: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  codename.toString(),
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "가격(달러): ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  price.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "가격(한화): ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  koprice.toString(),
                  style: const TextStyle(fontSize: 20),
                ),
                const Text(
                  "원",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "수량: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  qty.toString(),
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "비고1: ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  note1.toString(),
                  style: const TextStyle(fontSize: 20),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      "비고2: ${note2.toString()}",
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      maxLines: 5,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.grey[300],
                  child: SizedBox(
                      width: 100,
                      height: 50,
                      child: TextFormField(
                        controller: ipgoc,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: "수량 입력"),
                      )),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 75,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(
                                    const Color.fromRGBO(42, 145, 205, 1.0))),
                            onPressed: () async {
                              final res = await dio.get(
                                  "$baseuri:443/ipgo/1/$codename/${ipgoc.value.text}/$brandname",
                                  options: Options(headers: header));
                              if (res.statusCode == 200) {
                                ipgoSuccess(context);
                                infoapi(widget.modelno);
                              } else {
                                ipgoError(context);
                                ipgoc.value = const TextEditingValue(text: "");
                              }
                            },
                            child: const Text("입고\n(세트)",
                                textAlign: TextAlign.center)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 75,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(
                                    const Color.fromRGBO(42, 145, 205, 1.0))),
                            onPressed: () async {
                              debugPrint(brandname);
                              final res = await dio.get(
                                  "$baseuri:443/ipgo/0/$codename/${ipgoc.value.text}/$brandname",
                                  options: Options(headers: header));
                              if (res.statusCode == 200) {
                                infoapi(widget.modelno);
                                ipgoSuccess(context);
                              } else {
                                ipgoError(context);
                              }
                            },
                            child: const Text("입고\n(개별)",
                                textAlign: TextAlign.center)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 75,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(
                                    const Color.fromRGBO(241, 27, 35, 1.0))),
                            onPressed: () async {
                              final res = await dio.get(
                                  "$baseuri:443/out/1/$codename/${ipgoc.value.text}",
                                  options: Options(headers: header));
                              if (res.statusCode == 200) {
                                infoapi(widget.modelno);
                                outSuccess(context);
                              } else {
                                outError(context);
                              }
                            },
                            child: const Text("출고\n(세트)",
                                textAlign: TextAlign.center)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 75,
                        height: 50,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(
                                    const Color.fromRGBO(241, 27, 35, 1.0))),
                            onPressed: () async {
                              final res = await dio.get(
                                  "$baseuri:443/out/0/$codename/${ipgoc.value.text}",
                                  options: Options(headers: header));
                              if (res.statusCode == 200) {
                                infoapi(widget.modelno);
                                outSuccess(context);
                              } else {
                                outError(context);
                              }
                            },
                            child: const Text(
                              "출고\n(개별)",
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ],
                  ),
                ])
              ],
            )
          ],
        ));
  }

  void infoapi(String? modelno) async {
    dio.interceptors.add(ManageInterceptor());
    await Hive.initFlutter();
    var box = await Hive.openBox('auth');
    final response = await dio.get("$baseuri:443/info/$modelno");
    debugPrint(modelno);
    setState(() {
      brandname = response.data["brand name"];
      codename = response.data["model no"];
      price = response.data["price"].toString();
      koprice = response.data["d_price"];
      note2 = response.data["model name"];
      note1 = response.data["note1"];
      qty = response.data['qty'].toString();
      if (box.get("psk", defaultValue: "null") == "null") {
        MotionToast.error(
          animationDuration: const Duration(seconds: 60),
          title: const Text(
            'PSK 추출 실패',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          description: const Text(
            'PSK가 설정되지 않았습니다.\n메인 화면으로 돌아가 톱니바퀴 아이콘을 길게 눌러\n로그아웃 후 다시 로그인해주세요.',
            style: TextStyle(fontSize: 12),
          ),
          dismissable: true,
        ).show(context);
      }
      header = {"psk": box.get('psk', defaultValue: "null")};
    });
  }

  @override
  void initState() {
    super.initState();
    infoapi(widget.modelno);
  }

  void ipgoError(BuildContext context) {
    MotionToast.error(
      title: const Text(
        '입고 실패',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        '입고에 실패하였습니다.',
        style: TextStyle(fontSize: 12),
      ),
      dismissable: true,
    ).show(context);
  }

  void ipgoSuccess(BuildContext context) {
    MotionToast.success(
      title: const Text(
        '입고 완료',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        '입고가 성공적으로 완료되었습니다.',
        style: TextStyle(fontSize: 12),
      ),
      dismissable: true,
    ).show(context);
  }

  void outError(BuildContext context) {
    MotionToast.error(
      title: const Text(
        '출고 실패',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        '출고에 실패하였습니다.',
        style: TextStyle(fontSize: 12),
      ),
      dismissable: true,
    ).show(context);
  }

  void outSuccess(BuildContext context) {
    MotionToast.success(
      title: const Text(
        '출고 완료',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      description: const Text(
        '출고가 성공적으로 완료되었습니다.',
        style: TextStyle(fontSize: 12),
      ),
      dismissable: true,
    ).show(context);
  }
}