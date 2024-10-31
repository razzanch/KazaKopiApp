import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/myorder_controller.dart';

class MyorderView extends GetView<MyorderController> {
  const MyorderView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyorderView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyorderView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
