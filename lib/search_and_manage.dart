import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lcqm/interceptors/manageInterceptor.dart';
import 'package:lcqm/info_screen.dart';

const double height = 0.125;
const double width = 0.60;

String baseuri = "http://gongdol.ipdisk.co.kr";


class Screen3 extends StatefulWidget {
  const Screen3({super.key});

  @override
  State<Screen3> createState() => _Screen3State();
}

class WidgetListView extends StatefulWidget {
  final String? modelno;
  final String? brandname;
  const WidgetListView({super.key, this.modelno, this.brandname});

  @override
  State<WidgetListView> createState() => _WidgetListViewState();
}



class _Screen3State extends State<Screen3> {
  String? _selectedValue = "BMW";
  List<String> _items = [];
  Dio dio = Dio();

  TextEditingController modelNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("검색 / 관리"),
      ),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3,),
          Text(
            "검색을 위해 아래 항목을 선택해주세요.",
            style: TextStyle(fontSize: (((MediaQuery.of(context).size.width +
                MediaQuery.of(context)
                    .size
                    .height) *
                0.001) *
                20)
                .roundToDouble()),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "제조사: ",
              style: TextStyle(fontSize: (((MediaQuery.of(context).size.width +
                  MediaQuery.of(context)
                      .size
                      .height) *
                  0.001) *
                  20)
                  .roundToDouble(),
            )),
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
            width:  MediaQuery.of(context).size.width * width,
            child: TextField(
              controller: modelNo,
              decoration: const InputDecoration(hintText: "코드명을 입력하세요."),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * (width - 0.2),
              child: ElevatedButton(
                  onPressed: () async {
                    String model = modelNo.value.text.toUpperCase();
                    if (model == "") {
                      model = "all";
                    }
                    debugPrint(model);
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) => WidgetListView(
                          modelno: model,
                          brandname: _selectedValue,
                        )));
                  },
                  child: const Text("검색"))),
        ]),
      ),
    );
  }

  void fetchItems() async {
    dio.interceptors.add(ManageInterceptor());
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
}

class _WidgetListViewState extends State<WidgetListView> {
  List<Row> list = [Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        children: [
          SizedBox(height: 20, child: GestureDetector(child: const Text("Loading..."))),
        ],
      ),
    ],
  )];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("모델명을 선택해주세요."),
      ),
      body: ListView(children: list),
    );
  }

  void infoapi(String? modelno) async {
    Dio dio = Dio();

    final res = await dio
        .get("$baseuri:443/search.query/${widget.brandname}/${widget.modelno}");
    List<Row> datas = [];
    for (Map i in res.data) {
      datas.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                height: 30,
                child: ElevatedButton(
                    child: Text("${i['model no']}(${i['note1']}) ${i['qty']}개", style: const TextStyle(fontSize: 20),),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (BuildContext context) => InfoScreen(
                            modelno: i['model no'],
                          )));
                    }),
              ),
            ],
          ),
        ],
      ),);
        datas.add(Row(children: const [SizedBox(height: 10,)],));

    }
    setState(() {
      list = datas;
    });
  }

  @override
  void initState() {
    super.initState();
    infoapi(widget.modelno);
  }
}
