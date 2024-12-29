import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:myapp/app/modules/adminreport/controllers/adminreport_controller.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:mailer/mailer.dart' as mailer;

class AdminreportView extends StatefulWidget {
  @override
  _AdminreportViewState createState() => _AdminreportViewState();
}

class _AdminreportViewState extends State<AdminreportView> {
  final AdminreportController controller = Get.put(AdminreportController());
  final TextEditingController searchController = TextEditingController();

  RxList<Map<String, dynamic>> filteredReportData =
      <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();

    // Update filteredReportData saat pertama kali halaman dimuat
  filteredReportData.value = controller.reportData;

    // Filter data based on search input
    searchController.addListener(() {
      filterReportData();
    });
    

    // Initialize filtered data
    controller.reportData.listen((data) {
      filteredReportData.value = data;
    });
  }

  void filterReportData() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredReportData.value = controller.reportData;
    } else {
      filteredReportData.value = controller.reportData
          .where((item) =>
              item['username']?.toLowerCase().contains(query) ?? false)
          .toList();
    }
  }

  void handleDelete(String docId) async {
    try {
      await controller.deleteReport(docId);
      Get.snackbar('Success', 'Report deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete report');
    }
  }

  Future<void> sendReportByEmail({
  required String email,
  required String title,
  required String content,
  required String imageUrl,
  required String answer,
}) async {
  try {
    // SMTP configuration
    String username = 'appkazakopi@gmail.com'; // Replace with the sender email
    String password = 'gqku tvmm qqdg fmem'; // Replace with app password

    final smtpServer = gmail(username, password);

    // Create the email message
    final message = mailer.Message()
      ..from = mailer.Address(username, 'Kaza Kopi Nusantara')
      ..recipients.add(email)
      ..subject = 'Report Answer: $title'
      ..text = '''
      Title: $title

      Content: $content

      Image URL: $imageUrl

      Answer: $answer
      ''';

    // If image is to be attached, we add the image as an attachment
    if (imageUrl.isNotEmpty) {
      message.attachments.add(mailer.FileAttachment(File(imageUrl)));
    }

    // Send the email
    await mailer.send(message, smtpServer);

    Get.snackbar(
      'Success',
      'Report answer has been sent to $email',
      backgroundColor: Colors.green,
    );
  } catch (e) {
    Get.snackbar('Error', 'Failed to send report: $e', backgroundColor: Colors.red);
    print('Error sending report: $e');
  }
}

void showAnswerDialog({
  required String uid,
  required String username,
  required String email,
  required String title,
  required String content,
  required String imageUrl,
  Timestamp? timestamp,
}) {
  TextEditingController answerController = TextEditingController();

  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,  // Transparansi untuk latar belakang
      insetPadding: EdgeInsets.symmetric(horizontal: 24.0), // Padding sisi
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal.shade50,  // Background teal yang lembut
          borderRadius: BorderRadius.circular(20.0),  // Sudut lebih melengkung
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),  // Bayangan lembut
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(24.0),
        child: SingleChildScrollView(  // Membuat konten bisa digulir
          child: Column(
            mainAxisSize: MainAxisSize.min,  // Agar ukuran dialog fleksibel
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Answer Report',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade900,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.teal.shade900),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(color: Colors.teal.shade300),
              SizedBox(height: 16),
              Text('UID: $uid', style: TextStyle(color: Colors.teal.shade800)),
              SizedBox(height: 5),
              Text('Username: $username', style: TextStyle(color: Colors.teal.shade800)),
              SizedBox(height: 5),
              Text('Email: $email', style: TextStyle(color: Colors.teal.shade800)),
              SizedBox(height: 5),
              Text('Title: $title', style: TextStyle(color: Colors.teal.shade800)),
              SizedBox(height: 5),
              Text('Content: $content', style: TextStyle(color: Colors.teal.shade800)),
              SizedBox(height: 5),
              if (imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error_outline, color: Colors.red);
                      },
                    ),
                  ),
                ),
              SizedBox(height: 16),
              if (timestamp != null)
                Text(
                  'Timestamp: ${timestamp.toDate()}',
                  style: TextStyle(color: Colors.teal.shade700),
                ),
              SizedBox(height: 16),
              TextField(
                controller: answerController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Write your answer here...',
                  hintStyle: TextStyle(color: Colors.teal.shade500),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      color: Colors.teal.shade300,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: BorderSide(
                      color: Colors.teal.shade600,
                      width: 2.0,
                    ),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9.\n\r\s]')),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (answerController.text.isNotEmpty) {
                        try {
                          String docid = '${uid}_${title}';
                          await FirebaseFirestore.instance
                              .collection('report')
                              .doc(docid)
                              .delete();

                          // Send the report via email
                          await sendReportByEmail(
                            email: email,
                            title: title,
                            content: content,
                            imageUrl: imageUrl,
                            answer: answerController.text,
                          );

                          Get.snackbar('Success', 'Answer sent and report deleted.',
                              backgroundColor: Colors.green.shade200, colorText: Colors.white);
                          Navigator.pop(context);
                        } catch (e) {
                          Get.snackbar('Error', 'Failed to delete report or send email.',
                              backgroundColor: Colors.red.shade200, colorText: Colors.white);
                        }
                      } else {
                        Get.snackbar('Error', 'Answer cannot be empty.',
                            backgroundColor: Colors.red.shade200, colorText: Colors.white);
                      }
                    },
                    child: Text(
                      'Send Answer',
                      style: TextStyle(
                        color: Colors.white,  // Teks berwarna putih
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,  // Latar belakang hitam
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false, // Mencegah menutup dialog dengan tap di luar
  );
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          "Customer Report",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.toNamed(Routes.ADMINHELPCENTER);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Let\'s Help Your Customers Today!',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Find a Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Obx(() {
                      return Column(
                        children: filteredReportData.map((item) {
                          return Accordion(
                            uid: item['uid'] ?? 'No UID',
                            username: item['username'] ?? 'No Username',
                            email: item['email'] ?? 'No Email',
                            title: item['title'] ?? 'No Title',
                            content: item['content'] ?? 'No Content',
                            imageUrl: item['imageUrl'] ?? '',
                            timestamp: item['timestamp'],
                            isOpen: controller.openedIndex.value ==
                                    filteredReportData.indexOf(item) &&
                                controller.isAccordionOpen.value,
                            onTap: () => controller.toggleAccordion(
                                filteredReportData.indexOf(item)),
                            onDelete: () {
                              String docId = '${item['uid']}_${item['title']}';
                              if (docId.isEmpty) {
                                Get.snackbar('Error',
                                    'Invalid document ID for deletion');
                              } else {
                                handleDelete(docId);
                              }
                            },
                            onInfo: () {
                              showAnswerDialog(
                                uid: item['uid'] ?? 'No UID',
                                username: item['username'] ?? 'No Username',
                                email: item['email'] ?? 'No Email',
                                title: item['title'] ?? 'No Title',
                                content: item['content'] ?? 'No Content',
                                imageUrl: item['imageUrl'] ?? '',
                                timestamp: item['timestamp'],
                              );
                            },
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Accordion extends StatelessWidget {
  final String uid; // Tambahkan uid
  final String username;
  final String email;
  final String title;
  final String content;
  final String imageUrl;
  final Timestamp? timestamp;
  final bool isOpen;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onInfo;

  Accordion({
    required this.uid, // Tambahkan uid sebagai parameter
    required this.username,
    required this.email,
    required this.title,
    required this.content,
    required this.imageUrl,
    this.timestamp,
    required this.isOpen,
    required this.onTap,
    required this.onDelete,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    username,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox.shrink(),
          secondChild: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UID: $uid', // Tambahkan informasi UID di sini
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  'Email: $email', // Tambahkan informasi UID di sini
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  'Title: $title',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  'Content: $content',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 10),
                if (imageUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            'Failed to load image',
                            style: TextStyle(color: Colors.red),
                          );
                        },
                      ),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timestamp != null
                          ? '${timestamp!.toDate()}'
                          : 'No Timestamp',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    IconButton(
                      icon: Icon(Icons.question_answer, color: Colors.blue),
                      onPressed: onInfo,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
          crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
