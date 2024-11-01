import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/adminhistory_controller.dart';

class AdminhistoryView extends GetView<AdminhistoryController> {
  const AdminhistoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdminhistoryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AdminhistoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
