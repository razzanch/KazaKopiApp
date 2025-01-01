import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/app/modules/createbubuk/views/createbubuk_view.dart';
import 'package:myapp/app/modules/createminuman/views/createminuman_view.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AdminhomeView extends StatefulWidget {
  @override
  _AdminhomeViewState createState() => _AdminhomeViewState();
}

class _AdminhomeViewState extends State<AdminhomeView> {
  final PageController pageController = PageController();
  bool isMinumanSelected = true; // Menentukan tab yang aktif
  String selectedLocation = 'Pasar Tambak Rejo, Surabaya'; // Variabel untuk lokasi yang dipilih
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  late stt.SpeechToText _speech; // Instance SpeechToText
  bool _isListening = false;

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Fungsi untuk memulai speech-to-text
  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech Status: $status'),
      onError: (error) => print('Speech Error: $error'),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            searchQuery = result.recognizedWords.toLowerCase();
            searchController.text = searchQuery; // Masukkan hasil ke TextField
          });
        },
      );
    } else {
      print("Speech recognition not available");
    }
  }

  // Fungsi untuk menghentikan speech-to-text
  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Location",
              style: TextStyle(fontSize: 14, color: Colors.white70, height: 0.8),
            ),
            DropdownButton<String>(
              value: selectedLocation,
              dropdownColor: Colors.teal,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              underline: SizedBox(),
              isDense: true,
              items: [
                DropdownMenuItem(
                  value: 'Pasar Tambak Rejo, Surabaya',
                  child: Text('Pasar Tambak Rejo, Surabaya'),
                ),
                DropdownMenuItem(
                  value: 'CitraLand CBD Boulevard, Surabaya',
                  child: Text('CitraLand CBD Boulevard, Surabaya'),
                ),
              ],
              onChanged: (newLocation) {
                setState(() {
                  selectedLocation = newLocation!;
                });
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/LOGO.png', height: 40),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           Padding(
  padding: const EdgeInsets.all(8.0),
  child: TextField(
    controller: searchController,
    onChanged: (value) {
      setState(() {
        searchQuery = value.toLowerCase();
      });
    },
    decoration: InputDecoration(
      hintText: 'Search',
      prefixIcon: Icon(Icons.search),
      suffixIcon: IconButton(
        icon: Icon(
          _isListening ? Icons.mic : Icons.mic_none,
          color: _isListening ? Colors.red : Colors.grey,
        ),
        onPressed: () {
          if (_isListening) {
            _stopListening();
          } else {
            _startListening();
          }
        },
      ),
      filled: true,
      fillColor: Colors.white, // Latar belakang putih
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey), // Border default grey
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.teal, width: 2), // Border teal saat fokus
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey), // Border grey saat tidak fokus
      ),
    ),
  ),
),
            // Carousel section
           Container(
  margin: const EdgeInsets.all(8.0),
  padding: const EdgeInsets.all(8.0),
  decoration: BoxDecoration(
    color: Colors.white, // Latar belakang putih
    borderRadius: BorderRadius.circular(10), // Radius sudut
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3), // Bayangan
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child:Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Header dengan Text dan Icon
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0), // Menggeser teks ke kanan
          child: GestureDetector(
  onTap: () {
    // Navigasi ke halaman ADMINVOUCHER
    Get.toNamed(Routes.ADMINVOUCHER);
  },
  child: Text(
    'Voucher Management',
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.teal,
    ),
  ),
)

        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios, color: Colors.teal),
          iconSize: 16, // Mengecilkan ukuran ikon
          onPressed: () {
            Get.toNamed(Routes.ADMINVOUCHER);
          },
        ),
      ],
    ),
    // Container untuk PageView dan indikator
    StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('voucher').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final documents = snapshot.data!.docs;
        final images = documents
            .map((doc) => doc['imageUrl'])
            .where((url) => url != null)
            .toList();

        if (images.isEmpty) {
          return Center(child: Text('No vouchers available'));
        }

        return Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.teal, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                height: 150,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      images[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentPage == index ? Colors.teal : Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    ),
  ],
),
),


            Container(
  margin: const EdgeInsets.all(8.0), // Margin untuk memberikan jarak dari elemen lain
  padding: const EdgeInsets.all(8.0), // Padding untuk konten di dalamnya
  decoration: BoxDecoration(
    color: Colors.white, // Latar belakang putih
    borderRadius: BorderRadius.circular(12), // Radius sudut
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3), // Efek bayangan
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3), // Arah bayangan
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    GestureDetector(
      onTap: () {
        setState(() {
          isMinumanSelected = true; // Set Minuman aktif
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Padding agar teks tidak terlalu mentok
        decoration: isMinumanSelected
            ? BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.teal, width: 2),
              )
            : null,
        child: Text(
          "Minuman",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isMinumanSelected ? Colors.teal : Colors.grey,
          ),
        ),
      ),
    ),
    SizedBox(width: 50), // Memberikan gap yang bisa diatur
    GestureDetector(
      onTap: () {
        setState(() {
          isMinumanSelected = false; // Set Bubuk Kopi aktif
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: !isMinumanSelected
            ? BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.teal, width: 2),
              )
            : null,
        child: Text(
          "Bubuk Kopi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: !isMinumanSelected ? Colors.teal : Colors.grey,
          ),
        ),
      ),
    ),
  ],
),

  ),
),
            // Kartu Minuman atau Bubuk Kopi
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: isMinumanSelected ? buildMinumanCards() : buildBubukKopiCards(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[800],
                  ),
                  width: 50,
                  height: 50,
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.ADMINHOME);
                  },
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  tooltip: 'Home',
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CREATEMINUMAN);
              },
              icon: Icon(
                Icons.local_cafe,
                color: Colors.grey[800],
              ),
              tooltip: 'Add Minuman',
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.CREATEBUBUK);
              },
              icon: Icon(
                Icons.grain,
                color: Colors.grey[800],
              ),
              tooltip: 'Add Bubuk Kopi',
            ),
             IconButton(
              onPressed: () {
               Get.toNamed(Routes.ADMINHELPCENTER);
              },
              icon: Icon(
                Icons.support_agent,
                color: Colors.grey[800],
              ),
              tooltip: 'Help Center',
            ),
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.ADMINORDER);
              },
              icon: Icon(
                Icons.assignment,
                color: Colors.grey[800],
              ),
              tooltip: 'Management Order',
            ),
          ],
        ),
      ),
    );
  }

// Method untuk membangun kartu dari koleksi 'minuman'
Widget buildMinumanCards() {
  return StreamBuilder<QuerySnapshot>(
     stream: firestore.collection('minuman').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      final documents = snapshot.data!.docs;

      final filteredDocuments = documents.where((doc) {
  final data = doc.data() as Map<String, dynamic>;
  final name = data['name'].toString().toLowerCase();
  return data['status'] == true &&
      data['location'] == selectedLocation &&
      (searchQuery.isEmpty || name.contains(searchQuery));
}).toList();

      if (filteredDocuments.isEmpty) {
        return Center(
          child: Text(
            'Tidak ada minuman tersedia di lokasi ini.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredDocuments.length,
        itemBuilder: (context, index) {
          final data = filteredDocuments[index].data() as Map<String, dynamic>;
          return Container(
            height: 250,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: Image(
    image: (data['imageUrl'] ?? '').startsWith('http')
        ? NetworkImage(data['imageUrl']) // Gunakan NetworkImage untuk URL
        : AssetImage('assets/default.png') as ImageProvider, // Gunakan AssetImage jika bukan URL
    height: 140,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset('assets/default.png'); // Fallback image jika gagal
    },
  ),
),

                SizedBox(height: 8),
                Text(
                  data['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.teal),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                             builder: (context) => CreateminumanView(isEdit: true, documentId: filteredDocuments[index].id),
                          ),
                        );
                      },
                      iconSize: 30,
                    ),
                    IconButton(
  icon: Icon(Icons.delete, color: Colors.red),
  onPressed: () {
    // Confirmation dialog before deletion
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus item ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                
                try {
  final supabaseClient = Supabase.instance.client;
  final bucketName = 'minuman_pictures';
  
  // Ambil semua file dari bucket
  final response = await supabaseClient.storage.from(bucketName).list();

  // Filter file yang sesuai dengan pola
  final fileName = response
      .map((item) => item.name)
      .firstWhere(
        (name) => name.startsWith('${data['name']}-') && name.endsWith('.jpg'),
        orElse: () => throw Exception('File tidak ditemukan'),
      );

  // Hapus file
  await supabaseClient.storage.from(bucketName).remove([fileName]);

  // Hapus dokumen dari Firestore
  await firestore.collection('minuman').doc(documents[index].id).delete();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Berhasil menghapus item dan file gambar')),
  );
} catch (error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Gagal menghapus item: $error')),
  );
}

              },
            ),
          ],
        );
      },
    );
  },
  iconSize: 30,
),
                    IconButton(
                      icon: Icon(Icons.info, color: Colors.blue),
                     onPressed: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.teal,
        title: Center(
          child: Text(
            data['name'] ?? 'Item Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image with rounded corners
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child:ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: Image(
    image: (data['imageUrl'] ?? '').startsWith('http')
        ? NetworkImage(data['imageUrl']) // Gunakan NetworkImage untuk URL
        : AssetImage('assets/default.png') as ImageProvider, // Gunakan AssetImage jika bukan URL
    height: 150,
    width: 250,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset('assets/default.png'); // Fallback image jika gagal
    },
  ),
),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.white),
              SizedBox(height: 10),
              // Description text with larger font size
              Text(
                'Description: ${data['description'] ?? 'No description available.'}',
                style: TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              // Price details with larger font size
              Text(
                'Price (Large): Rp ${data['hargalarge'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Text(
                'Price (Small): Rp ${data['hargasmall'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              // Location with larger font size
              Text(
                'Location: ${data['location'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              Divider(color: Colors.white),
              SizedBox(height: 10),
              // Status with full-width background
              Container(
                width: double.infinity, // Full width
                padding: EdgeInsets.symmetric(vertical: 10),
                color: data['status'] == true ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    data['status'] == true ? 'Tersedia' : 'Habis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
},

                      iconSize: 30,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// Method untuk membangun kartu dari koleksi 'bubukkopi'
Widget buildBubukKopiCards() {
  return StreamBuilder<QuerySnapshot>(
    stream: firestore.collection('bubukkopi').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      final documents = snapshot.data!.docs;

final filteredDocuments = documents.where((doc) {
  final data = doc.data() as Map<String, dynamic>;
  final name = data['name'].toString().toLowerCase();
  return data['status'] == true &&
      data['location'] == selectedLocation &&
      (searchQuery.isEmpty || name.contains(searchQuery));
}).toList();

      if (filteredDocuments.isEmpty) {
        return Center(
          child: Text(
            'Tidak ada bubuk kopi tersedia di lokasi ini.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: filteredDocuments.length,
        itemBuilder: (context, index) {
          final data = filteredDocuments[index].data() as Map<String, dynamic>;
          return Container(
            height: 250,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: Image(
    image: (data['imageUrl'] ?? '').startsWith('http')
        ? NetworkImage(data['imageUrl']) // Gunakan NetworkImage untuk URL
        : AssetImage('assets/default.png') as ImageProvider, // Gunakan AssetImage jika bukan URL
    height: 140,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset('assets/default.png'); // Fallback image jika gagal
    },
  ),
),
                SizedBox(height: 8),
                Text(
                  data['name'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.teal),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreatebubukView(isEdit: true, documentId: filteredDocuments[index].id),
                          ),
                        );
                      },
                      iconSize: 30,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Confirmation dialog before deletion
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Konfirmasi Hapus'),
                              content: Text('Apakah Anda yakin ingin menghapus item ini?'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Batal'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () async {
                                    Navigator.of(context).pop(); // Close the dialog
                
                try {
  final supabaseClient = Supabase.instance.client;
  final bucketName = 'bubuk_pictures';
  
  // Ambil semua file dari bucket
  final response = await supabaseClient.storage.from(bucketName).list();

  // Filter file yang sesuai dengan pola
  final fileName = response
      .map((item) => item.name)
      .firstWhere(
        (name) => name.startsWith('${data['name']}-') && name.endsWith('.jpg'),
        orElse: () => throw Exception('File tidak ditemukan'),
      );

  // Hapus file
  await supabaseClient.storage.from(bucketName).remove([fileName]);

  // Hapus dokumen dari Firestore
  await firestore.collection('bubukkopi').doc(documents[index].id).delete();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Berhasil menghapus item dan file gambar')),
  );
} catch (error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Gagal menghapus item: $error')),
  );
} // Close the dialog
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      iconSize: 30,
                    ),
                    IconButton(
                      icon: Icon(Icons.info, color: Colors.blue),
                      onPressed: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.teal,
        title: Center(
          child: Text(
            data['name'] ?? 'Item Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with rounded corners
              Center(
                child:  ClipRRect(
  borderRadius: BorderRadius.circular(15),
  child: Image(
    image: (data['imageUrl'] ?? '').startsWith('http')
        ? NetworkImage(data['imageUrl']) // Gunakan NetworkImage untuk URL
        : AssetImage('assets/default.png') as ImageProvider, // Gunakan AssetImage jika bukan URL
    height: 150,
    width: 250,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset('assets/default.png'); // Fallback image jika gagal
    },
  ),
),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.white),
              SizedBox(height: 10),
              // Description
              Text(
                'Description:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                data['description'] ?? 'No description available.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 15),
              // Price Details
              Text(
                'Price List:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '100g: Rp ${data['harga100gr'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '200g: Rp ${data['harga200gr'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '300g: Rp ${data['harga300gr'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '500g: Rp ${data['harga500gr'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '1000g: Rp ${data['harga1000gr'] ?? 'N/A'}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 15),
              // Location
              Text(
                'Location:',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                data['location'] ?? 'N/A',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              
              SizedBox(height: 15),
              Divider(color: Colors.white),
              SizedBox(height: 15),
              // Status with colored background
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10),
                color: data['status'] == true ? Colors.green : Colors.red,
                child: Center(
                  child: Text(
                    data['status'] == true ? 'Tersedia' : 'Habis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
},

                      iconSize: 30,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
}