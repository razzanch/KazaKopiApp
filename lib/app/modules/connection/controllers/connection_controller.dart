import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  RxBool isDialogVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      _updateConnectionStatus(connectivityResults.first);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      if (!isDialogVisible.value) {
        isDialogVisible.value = true;
        _showNoConnectionDialog();
      }
    } else {
      if (isDialogVisible.value) {
        isDialogVisible.value = false;
        Get.back();
      }
    }
  }

  void _showNoConnectionDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.teal.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  color: Colors.white,
                  size: 70,
                ),
                SizedBox(height: 20),
                Text(
                  'No Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please check your Wi-Fi or mobile data settings to restore connectivity.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30),
                // Animated Coffee Cup
                SizedBox(
                  height: 100,
                  width: 100,
                  child: CoffeeLoadingAnimation(),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

class CoffeeLoadingAnimation extends StatefulWidget {
  @override
  _CoffeeLoadingAnimationState createState() => _CoffeeLoadingAnimationState();
}

class _CoffeeLoadingAnimationState extends State<CoffeeLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _fillAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: CoffeeCupPainter(fillLevel: _fillAnimation.value),
          size: Size(60, 60),
        );
      },
    );
  }
}

class CoffeeCupPainter extends CustomPainter {
  final double fillLevel;

  CoffeeCupPainter({required this.fillLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint cupPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint coffeePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final Paint handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw cup body
    final RRect cupShape = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.2, 
                    size.width * 0.6, size.height * 0.6),
      Radius.circular(5),
    );
    canvas.drawRRect(cupShape, cupPaint);

    // Draw handle
    final Path handlePath = Path()
      ..moveTo(size.width * 0.8, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.5,
        size.width * 0.8,
        size.height * 0.65,
      );
    canvas.drawPath(handlePath, handlePaint);

    // Draw coffee fill
    if (fillLevel > 0) {
      final double fillHeight = size.height * 0.6 * (1 - fillLevel);
      final RRect fillShape = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.2,
          size.height * 0.2 + fillHeight,
          size.width * 0.6,
          size.height * 0.6 - fillHeight,
        ),
        Radius.circular(5),
      );
      canvas.drawRRect(fillShape, coffeePaint);
    }
  }

  @override
  bool shouldRepaint(CoffeeCupPainter oldDelegate) =>
      oldDelegate.fillLevel != fillLevel;
}