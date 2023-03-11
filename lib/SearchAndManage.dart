import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:motion_toast/motion_toast.dart';

String baseuri = "http://gongdol.ipdisk.co.kr";

class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  String? _selectedValue = "BMW";
  List<String> _items = [];
  String? _selectedValue2 = "코드명(비고)";
  List<String> _items2 = ["코드명(비고)"];

  void fetchItems() async {
    final response = await Dio().get('$baseuri:7777/brands');
    if (response.statusCode == 200) {
      setState(() {
        _items = List<String>.from(response.data["brands"]);
        debugPrint(List<String>.from(response.data["brands"]).toString());
      });
    } else {
      throw Exception('Failed to fetch items');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  TextEditingController modelNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("검색 / 관리"),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            height: 200,
          ),
          const Text(
            "검색을 위해 아래 항목을 선택해주세요.",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "제조사: ",
              style: TextStyle(fontSize: 20),
            ),
            DropdownButton(
                icon: const Icon(Icons.arrow_downward),
                underline: Container(
                  height: 2,
                  color: const Color.fromRGBO(0, 0, 0, 1),
                ),
                items: _items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue;
                  });
                }),
          ]),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 300,
            child: TextField(
              controller: modelNo,
              decoration: const InputDecoration(hintText: "코드명을 입력하세요."),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () async {
                    String model = modelNo.value.text.toUpperCase();
                    if (model == "") {
                      model = "all";
                    }
                    debugPrint(model);
                    final res = await Dio().get(
                        "$baseuri:443/search.query/$_selectedValue/$model");
                    List<String> datas = ["검색결과"];
                    for (Map i in res.data) {
                      datas.add("${i['model no']}(${i['note1']}) ${i['qty']}개");
                    }
                    setState(() {
                      _selectedValue2 = "검색결과";
                      _items2 = List<String>.from(datas);
                    });
                  },
                  child: const Text("검색"))),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "코드명: ",
              style: TextStyle(fontSize: 20),
            ),
            DropdownButton(
              icon: const Icon(Icons.arrow_downward),
              underline: Container(
                height: 2,
                color: const Color.fromRGBO(0, 0, 0, 1),
              ),
              items: _items2.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: _selectedValue2,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValue2 = newValue;
                });
              },
            ),
          ]),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (BuildContext context) => infoScreen(
                            modelno: _selectedValue2?.split("(").first,
                          )));
                },
                child: const Text("선택"),
              ))
        ]),
      ),
    );
  }
}

class infoScreen extends StatefulWidget {
  final String? modelno;
  const infoScreen({super.key, this.modelno});

  @override
  State<infoScreen> createState() => _infoScreenState();
}

class _infoScreenState extends State<infoScreen> {
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

  void infoapi(String? modelno) async {
    await Hive.initFlutter();
    var box = await Hive.openBox('auth');
    final response =
        await Dio().get("$baseuri:443/info/$modelno");
    debugPrint(modelno);
    setState(() {
      brandname = response.data["brand name"];
      codename = response.data["model no"];
      price = response.data["price"].toString();
      koprice = response.data["d_price"];
      note2 = response.data["model name"];
      note1 = response.data["note1"];
      qty = response.data['qty'].toString();
      header = {"psk": box.get('psk')};
    });
  }

  @override
  void initState() {
    super.initState();
    infoapi(widget.modelno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
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
                      width: 200,
                      height: 50,
                      child: TextFormField(
                        controller: ipgoc,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(hintText: "수량을 입력해주세요."),
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
                            onPressed: () async {
                              final res = await Dio().get(
                                  "$baseuri:443/ipgo/1/$codename/${ipgoc.value.text}/$brandname",
                                  options: Options(headers: header));
                              if (res.statusCode == 200) {
                                MotionToast.success(
                                  title: const Text(
                                    '입고 완료',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  description: const Text(
                                    '입고가 성공적으로 완료되었습니다.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  dismissable: true,
                                ).show(context);
                              } else {
                                MotionToast.error(
                                  title: const Text(
                                    '입고 실패',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  description: const Text(
                                    '입고에 실패하였습니다.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  dismissable: true,
                                ).show(context);
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
                            onPressed: () async {
                              debugPrint(brandname);
                              final res = await Dio().get(
                                  "$baseuri:443/ipgo/0/$codename/${ipgoc.value.text}/$brandname",
                                  options: Options(headers: header));
                              if (res.statusCode == 200) {
                                MotionToast.success(
                                  title: const Text(
                                    '입고 완료',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  description: const Text(
                                    '입고가 성공적으로 완료되었습니다.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  dismissable: true,
                                ).show(context);
                              } else {
                                MotionToast.error(
                                  title: const Text(
                                    '입고 실패',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  description: const Text(
                                    '입고에 실패하였습니다.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  dismissable: true,
                                ).show(context);
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
                            onPressed: () async {
                              final res = await Dio().get(
                                  "$baseuri:443/out/1/$codename/${ipgoc.value.text}",
                                  options: Options(headers: header));
                              if (res.statusCode == 200) {
                                MotionToast.success(
                                  title: const Text(
                                    '출고 완료',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  description: const Text(
                                    '출고가 성공적으로 완료되었습니다.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  dismissable: true,
                                ).show(context);
                              } else {
                                MotionToast.error(
                                  title: const Text(
                                    '출고 실패',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  description: const Text(
                                    '출고에 실패하였습니다.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  dismissable: true,
                                ).show(context);
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
                            onPressed: () async {
                              final res = await Dio().get(
                                  "$baseuri:443/out/0/$codename/${ipgoc.value.text}",
                                  options: Options(headers: header));
                              if (res.statusCode == 200) {
                                MotionToast.success(
                                  title: const Text(
                                    '출고 완료',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  description: const Text(
                                    '출고가 성공적으로 완료되었습니다.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  dismissable: true,
                                ).show(context);
                              } else {
                                MotionToast.error(
                                  title: const Text(
                                    '출고 실패',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  description: const Text(
                                    '출고에 실패하였습니다.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  dismissable: true,
                                ).show(context);
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
}
