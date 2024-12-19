
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

typedef UnitBListCallback = Function(Uint8List data);
typedef DynamicCallback = Function(dynamic data);
class Server {
  UnitBListCallback? onData;
  DynamicCallback? onError;

  Server(this.onData, this.onError);

  ServerSocket? server;
  bool running = false;
  List<Socket> sockets = [];

  Future<void> start() async{
    runZoned(()async{
      server = await ServerSocket.bind("192.168.0.110",9000);
      running = true;
      server!.listen(onRequest);
      final messege = "Server is in port 9000";
      onData!(Uint8List.fromList(messege.codeUnits));
    },onError: onError);
  }
  void onRequest(Socket Socket){
      if(!sockets.contains(Socket)){
        sockets.add(Socket);

      }
      Socket.listen((event){
        onData!(event);
      });

  }

   Future<void> close() async{
    await server!.close();
    server = null;
    running = false;
      
    }

    void broadcast(String data){
      onData!(Uint8List.fromList("Broadcast message : $data".codeUnits));
      for (final soket in sockets) {
        soket.write(data);
      }
    }
}