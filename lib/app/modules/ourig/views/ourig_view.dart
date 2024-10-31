import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ourig_controller.dart';

class OurigView extends GetView<OurigController> {
  const OurigView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OurigView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OurigView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
