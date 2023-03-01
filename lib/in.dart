import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:motion_toast/motion_toast.dart';

class In extends StatefulWidget {
  const In({super.key});

  @override
  State<In> createState() => _InState();
}

class _InState extends State<In> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("파일 입고"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                const SizedBox(
                  width: 300,
                  child: Text("파일을 선택해주세요.",
                  style: TextStyle(
                    fontSize: 30,

                  ),),
                ),
                const SizedBox(height: 50,),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: ElevatedButton(
                  child: const Text("파일 선택",
                  style: TextStyle(fontSize: 20),),
                  onPressed: () async {
                    WidgetsFlutterBinding.ensureInitialized();
                    List<PlatformFile>? files = (await FilePicker.platform.pickFiles(allowMultiple: true))?.files;
                    for (PlatformFile file in files!) {
                      debugPrint(file.name);
                      final storageRef = FirebaseStorage.instanceFor(app: Firebase.app('lcqm')).ref();
                      String rnums = "";
                      Random r = Random();
                      for(int i=0; i<10; i++){
                        rnums += String.fromCharCode(65 + r.nextInt(25));
                      }
                      final fileRef = storageRef.child("lcqm").child("$rnums.xlsx");
                      File f = File(file.path!);
                      await fileRef.putFile(f);
                      var downloadUrl = await fileRef.getDownloadURL();
                      final String token = downloadUrl.split("%2F")[1].split("?")[1].split("=")[2];
                      final String name = fileRef.name;
                      final String apiUrl = "http://gongdol.ipdisk.co.kr:7777/ipgo/$name/$token";
                      var api = await http.post(Uri.parse(apiUrl));
                      if (api.statusCode == 200){
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
                      else {
                        MotionToast.error(
                          title: const Text(
                            'Error',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          description: const Text('오류가 발생했습니다.'),
                          barrierColor: Colors.black.withOpacity(0.3),
                          width: 300,
                          height: 80,
                          dismissable: false,
                        ).show(context);
                      }
                    }
                  }),
                ),
          ],
        ),
      ),
    );
  }
}
