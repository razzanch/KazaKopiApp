import 'package:get/get.dart';

class HelpCenterController extends GetxController {
  // Accordion data
  final faqData = [
    {
      'title': 'Cara memesan kopi atau bubuk kopi',
      'content':
          '- buka pada homepage \n- Pilih menu yang akan dipilih pada tab atas "Kopi" atau "Bubuk kopi" \n- Pilih menu yang akan dipesan \n- setelah itu pilih opsi (Small/Medium/Large) untuk kopi dan pilih berat untuk bubuk kopi. setelah itu masuk ke cart selesaikn pembayaran'
    },
    {
      'title': 'Cara update profil',
      'content':
          '- Pada main profil tekan tombol "update profile" \n - Ganti lah profil e'
    },
    {
      'title': 'Cara reset pass?',
      'content':
          '- Pada Main profil (sebelumnya skrol bwh ada reset password) \n- Lalu ketikan \n- pass sudah terganti'
    },
    // Add more FAQ items here
  ].obs;

  // Accordion state
  final isAccordionOpen = false.obs;
  final openedIndex = (-1).obs;

  void toggleAccordion(int index) {
    if (openedIndex.value == index) {
      isAccordionOpen.value = !isAccordionOpen.value;
    } else {
      isAccordionOpen.value = true;
      openedIndex.value = index;
    }
  }
}
