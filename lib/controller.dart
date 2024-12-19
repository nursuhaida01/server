import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:serve/server.dart';

class ServerController extends GetxController {
  Server? server;
  List<String> serverLogs = [];
  TextEditingController messegeController = TextEditingController();

  Future<void> startOrStopServer() async{
    if(server!.running){
      await server!.close();
      serverLogs.clear();
    }else{
     await server!.start();
    }
    update();
   
  }

  @override
  void onInit() {
    server = Server(onData, onError);
    startOrStopServer();
    super.onInit();
  }

  void onData(Uint8List data) {
    // แปลงข้อมูลที่ได้รับเป็น String
    final receivedData = String.fromCharCodes(data);
    serverLogs.add(receivedData);
    update();
    print('Data received: $receivedData');
  }

  void onError(dynamic error) {
    update();
    // จัดการข้อผิดพลาด
    print('Error occurred: $error');
  }

  void handleMessege(){
    
    debugPrint(messegeController.text);
    server!.broadcast(messegeController.text);
    
    // serverLogs.add(messegeController.text);
    messegeController.clear();
    update();
  }
}
