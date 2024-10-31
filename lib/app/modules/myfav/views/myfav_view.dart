import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/myfav_controller.dart';

class MyfavView extends GetView<MyfavController> {
  const MyfavView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyfavView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MyfavView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
