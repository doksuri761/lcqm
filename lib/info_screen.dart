import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:lcqm/interceptors/manageInterceptor.dart';

String baseuri = "http://gongdol.ipdisk.co.kr";
double width = 70;

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
  TextEditingController note1c = TextEditingController();
  TextEditingController pricec = TextEditingController();
  TextEditingController note2c = TextEditingController();

  late Map<String, String> header;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("비엠타는 공돌이: 재고관리 시스템"), centerTitle: false),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.1, 0.0, 0.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "제조사: ",
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          brandname.toString(),
                          style: const TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "코드명: ",
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          codename.toString(),
                          style: const TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "입고: ",
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: TextFormField(
                            controller: pricec,
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "가격: ",
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          koprice.toString(),
                          style: const TextStyle(fontSize: 25),
                        ),
                        const Text(
                          "원",
                          style: TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "수량: ",
                          style: TextStyle(fontSize: 25),
                        ),
                        Text(
                          qty.toString(),
                          style: const TextStyle(fontSize: 25),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "비고1: ",
                          style: TextStyle(fontSize: 25),
                        ),
                        SizedBox(
                            width: 200,
                            height: 50,
                            child: TextFormField(
                              controller: note1c,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "비고2:",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                              width: 200,
                              height: 50,
                              child: TextFormField(
                                controller: note2c,
                              ))
                        ],
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                            onPressed: () {
                              String url = "$baseuri:443/edit/$codename/";
                              if (note1c.value.text != "") {
                                url += "${note1c.value.text}/";
                              } else {
                                url += " /";
                              }
                              if (note2c.value.text != "") {
                                url += "${note2c.value.text}/";
                              } else {
                                url += "$note2/";
                              }
                              if (pricec.value.text != "") {
                                url += pricec.value.text;
                              } else {
                                url += price;
                              }
                              debugPrint(url);
                              Dio().get(url, options: Options(headers: header));
                            },
                            child: const Text("수정")),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 70,
                            child: TextFormField(
                              controller: ipgoc,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: "수량 입력",
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width,
                                      height: 80,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color.fromRGBO(
                                                          42, 145, 205, 1.0))),
                                          onPressed: () async {
                                            final res = await dio.get(
                                                "$baseuri:443/ipgo/1/$codename/${ipgoc.value.text}/$brandname",
                                                options:
                                                    Options(headers: header));
                                            if (res.statusCode == 200) {
                                              ipgoSuccess(context);
                                              infoapi(widget.modelno);
                                            } else {
                                              ipgoError(context);
                                              ipgoc.value =
                                                  const TextEditingValue(
                                                      text: "");
                                            }
                                          },
                                          child: const Text("입고\n(세트)",
                                              textAlign: TextAlign.center)),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: width,
                                      height: 80,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      const Color.fromRGBO(
                                                          42, 145, 205, 1.0))),
                                          onPressed: () async {
                                            debugPrint(brandname);
                                            final res = await dio.get(
                                                "$baseuri:443/ipgo/0/$codename/${ipgoc.value.text}/$brandname",
                                                options:
                                                    Options(headers: header));
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width,
                                        height: 80,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        const Color.fromRGBO(
                                                            241, 27, 35, 1.0))),
                                            onPressed: () async {
                                              final res = await dio.get(
                                                  "$baseuri:443/out/1/$codename/${ipgoc.value.text}",
                                                  options:
                                                      Options(headers: header));
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
                                        width: width,
                                        height: 80,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        const Color.fromRGBO(
                                                            241, 27, 35, 1.0))),
                                            onPressed: () async {
                                              final res = await dio.get(
                                                  "$baseuri:443/out/0/$codename/${ipgoc.value.text}",
                                                  options:
                                                      Options(headers: header));
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
                                    ])
                              ],
                            ),
                          ])
                    ],
                  )
                ],
              )
            ],
          ),
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
      note1c.value = TextEditingValue(text: note1);
      note2c.value = TextEditingValue(text: note2);
      pricec.value = TextEditingValue(text: price);
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
