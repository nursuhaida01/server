import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:serve/controller.dart'; // Import ServerController

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // ใช้ GetMaterialApp สำหรับ GetX
      title: 'Server',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Server"),
      ),
      body: GetBuilder<ServerController>(
        init: ServerController(), // กำหนด Controller
        builder: (controller) {
          return Column(
            children: [
              Expanded(
                  child: Padding(
                padding: EdgeInsetsDirectional.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "server",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: controller.server!.running
                                  ? Colors.green[400]
                                  : Colors.red[400],
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            controller.server!.running ? "on" : "off",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                    TextButton(
                        onPressed: () async {
                          await controller.startOrStopServer();
                        },
                        child: Text(controller.server!.running
                            ? "Stop server"
                            : "star Server")),
                    Divider(
                      height: 30,
                      thickness: 1,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.serverLogs.length,
                        itemBuilder: (context, index) {
                          final message = controller.serverLogs[index];
                          final isServerMessage = message.startsWith("Server:");
                          

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: Align(
                              alignment: isServerMessage
                                  ? Alignment.centerLeft
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isServerMessage
                                      ? Colors.blue[100]
                                      : const Color.fromARGB(255, 200, 221, 230),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  message,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
              Container(
                height: 80,
                color: Colors.grey[200],
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.messegeController,
                        decoration: InputDecoration(labelText: "Enter Message"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: () {
                          controller.messegeController.clear();
                        },
                        icon: Icon(Icons.clear)),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        onPressed: controller.handleMessege,
                        icon: Icon(Icons.send)),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
