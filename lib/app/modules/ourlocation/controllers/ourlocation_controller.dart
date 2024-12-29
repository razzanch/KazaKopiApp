import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class OurlocationController extends GetxController {

var latitude = 0.0.obs;
var longitude = 0.0.obs;
var address = ''.obs;

 Future<void> getCoordinatesFromAddress(String addressInput) async {
    final apiKey =
        '91e7d00b582d4ce38b35d467821bb487'; // Ganti dengan API Key Anda
    final url = Uri.parse(
        'https://api.opencagedata.com/geocode/v1/json?q=$addressInput&key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          latitude.value = data['results'][0]['geometry']['lat'];
          longitude.value = data['results'][0]['geometry']['lng'];

          // Menampilkan hasil latitude dan longitude di debug console
          print('Latitude: ${latitude.value}');
          print('Longitude: ${longitude.value}');

          // Menampilkan Snackbar jika koordinat berhasil ditemukan
          Get.snackbar(
            'Target Location Found',
            'Latitude: ${latitude.value}\nLongitude: ${longitude.value}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          print("Alamat tidak ditemukan");
          // Menampilkan Snackbar jika alamat tidak ditemukan
          Get.snackbar(
            'Koordinat Tidak Ditemukan',
            'Alamat yang Anda masukkan tidak ditemukan.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        print("Error fetching data");
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      // Menampilkan Snackbar jika terjadi kesalahan
      Get.snackbar(
        'Terjadi Kesalahan',
        'Tidak dapat menghubungi server geocoding.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}