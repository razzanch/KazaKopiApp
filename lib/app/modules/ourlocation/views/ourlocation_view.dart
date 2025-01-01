import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latlong2;
import 'package:myapp/app/modules/ourlocation/controllers/ourlocation_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class OurlocationView extends StatefulWidget {
  const OurlocationView({Key? key}) : super(key: key);

  @override
  _OurlocationViewState createState() => _OurlocationViewState();
}

class _OurlocationViewState extends State<OurlocationView> {
  final RxString selectedLocation = 'KAZA MALL'.obs;

  final List<Map<String, String>> locations = [
    {'name': 'Pasar Tambak Rejo, Surabaya', 'url': 'KAZA MALL'},
    {'name': 'CitraLand CBD Boulevard, Surabaya', 'url': 'UNIVERSITAS CIPUTRA'},
  ];

  final OurlocationController controllerConvert =
      Get.put(OurlocationController());

  latlong2.LatLng currentLocation = latlong2.LatLng(0, 0);

  bool isMapLoading = true;
  final distanceInKm = 0.0.obs;
  final distanceInMeters = 0.0.obs;
  final MapController mapController = MapController();

  @override
@override
void initState() {
  super.initState();
  _initializeLocation();
}

Future<void> _initializeLocation() async {
  await _getCurrentLocation(); // Tunggu lokasi pengguna diperbarui
  await controllerConvert.getCoordinatesFromAddress(selectedLocation.value);

  print("Debugging after _initializeLocation:");
  print("Current Location Latitude: ${currentLocation.latitude}");
  print("Current Location Longitude: ${currentLocation.longitude}");
  print("Controller Latitude: ${controllerConvert.latitude.value}");
  print("Controller Longitude: ${controllerConvert.longitude.value}");

  if (currentLocation.latitude != 0.0 &&
      currentLocation.longitude != 0.0 &&
      controllerConvert.latitude.value != 0.0 &&
      controllerConvert.longitude.value != 0.0) {
    _calculateDistance(); // Hitung jarak hanya jika semua koordinat valid
  }
}



  void _calculateDistance() {
    final distanceCalculator = latlong2.Distance();
    final double distance = distanceCalculator.as(
      latlong2.LengthUnit.Meter,
      latlong2.LatLng(currentLocation.latitude, currentLocation.longitude),
      latlong2.LatLng(
          controllerConvert.latitude.value, controllerConvert.longitude.value),
    );
    setState(() {
      distanceInKm.value = distance / 1000;
      distanceInMeters.value = distance;
    });
    print("Distance Calculated: $distance meters");
  }

  Future<void> _getCurrentLocation() async {
    try {
      var status = await Permission.location.request();

      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          currentLocation =
              latlong2.LatLng(position.latitude, position.longitude);
          isMapLoading = false;
          print(
              "Latitude: ${position.latitude}, Longitude: ${position.longitude}");
          _showSnackBarMessageCL(
              "Your Current Location: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
        });
      } else if (status.isDenied) {
        _showSnackBarMessage(
            "Location permission denied. Please enable it in settings.");
      } else if (status.isPermanentlyDenied) {
        _showSnackBarMessage(
            "Location permission permanently denied. Please enable it in app settings.");
        openAppSettings();
      }
    } catch (e) {
      print("Error getting location: $e");
      _showSnackBarMessage("Failed to get current location.");
    }
  }

  void _showSnackBarMessageCL(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Location',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Obx(() {
                  return DropdownButton<String>(
                    isExpanded: true,
                    value: selectedLocation.value,
                    onChanged: (String? newValue) {
  if (newValue != null) {
    selectedLocation.value = newValue;
    controllerConvert.getCoordinatesFromAddress(selectedLocation.value).then((_) {
      _calculateDistance(); // Hitung jarak ulang setelah koordinat berubah
    });
  }
},

                    items: locations.map<DropdownMenuItem<String>>((location) {
                      return DropdownMenuItem<String>(
                        value: location['url'],
                        child: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.teal[700]),
                            const SizedBox(width: 8),
                            Text(
                              location['name']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.teal[700],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.teal[700],
                    ),
                    underline: Container(),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16), // Jarak antara dropdown dan map
            SizedBox(
              height: 340,
              width: 360,
              child: isMapLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20.0), // Border radius untuk map
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: mapController,
                            options: MapOptions(
                              center: currentLocation,
                              zoom: 13.0,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: ['a', 'b', 'c'],
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: currentLocation,
                                    builder: (ctx) => const Icon(
                                      Icons.person_pin,
                                      color: Colors.red,
                                      size: 40.0,
                                    ),
                                  ),
                                  Marker(
                                    point: latlong2.LatLng(
                                      controllerConvert.latitude.value,
                                      controllerConvert.longitude.value,
                                    ),
                                    builder: (ctx) => const Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                      size: 40.0,
                                    ),
                                  ),
                                ],
                              ),
                              PolylineLayer(
                                polylines: controllerConvert.latitude.value !=
                                            0 &&
                                        controllerConvert.longitude.value != 0
                                    ? [
                                        Polyline(
                                          points: [
                                            currentLocation,
                                            latlong2.LatLng(
                                              controllerConvert.latitude.value,
                                              controllerConvert.longitude.value,
                                            ),
                                          ],
                                          strokeWidth: 4.0,
                                          color: Colors.black,
                                        ),
                                      ]
                                    : [],
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 16, // Posisi tombol melayang dari bawah
                            right: 16, // Posisi tombol melayang dari kanan
                            child: FloatingActionButton(
                              backgroundColor: Colors.red,
                              onPressed: () {
                                // Logika untuk memindahkan peta ke currentLocation
                                mapController.move(currentLocation, 13.0);
                              },
                              child: const Icon(
                                Icons.person_pin,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 8.0), // Spasi kecil
            Obx(() => Container(
  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  margin: const EdgeInsets.only(top: 16.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8.0,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: Row(
    children: [
      Icon(
        Icons.route, // Ikon jarak
        color: Colors.teal,
        size: 24.0,
      ),
      const SizedBox(width: 12.0), // Jarak antara ikon dan teks
      Expanded(
        child: Text(
          'Distance: ${distanceInKm.value.toStringAsFixed(2)} km (${distanceInMeters.value.toStringAsFixed(2)} m)',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.teal,
          ),
        ),
      ),
    ],
  ),
)),
          ],
        ),
      ),
    );
  }
}
