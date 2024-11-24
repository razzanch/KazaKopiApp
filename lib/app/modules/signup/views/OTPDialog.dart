import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';

class OTPDialog extends StatelessWidget {
  final SignUpController controller = Get.find();
  final String email;
  final String password;
  final String username;
  final String phoneNumber;

  OTPDialog({
    required this.email,
    required this.password,
    required this.username,
    required this.phoneNumber,
  });

  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
Widget build(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    child: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.all(20.0), // Pindahkan padding di sini
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Masukkan Kode OTP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Kode OTP telah dikirim ke $email. Silakan masukkan kode untuk verifikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.tealAccent, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        focusNodes[index - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Obx(() {
              return Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      minimumSize: Size(double.infinity, 50), // Lebar penuh
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            String otp = otpControllers.map((c) => c.text).join();
                            controller.verifyOTPAndRegister(
                              otp,
                              email,
                              password,
                              username,
                              phoneNumber,
                            );
                          },
                          
                    child: controller.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Verifikasi', style: TextStyle(fontSize: 16,color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.sendOTP(email);
                          },
                    child: Text(
                      'Kirim Ulang Kode OTP',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              );
            }),
            Divider(color: Colors.white, height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Get.offNamed('/login');
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

}
