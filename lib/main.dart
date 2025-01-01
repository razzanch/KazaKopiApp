import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myapp/dependency_injection.dart';
import 'package:myapp/dependency_injection2.dart';
import 'package:myapp/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url:
        'https://riqxiybgyvxsjhooqftd.supabase.co', // Ganti dengan URL Supabase Anda
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpcXhpeWJneXZ4c2pob29xZnRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI1MTUxNTUsImV4cCI6MjA0ODA5MTE1NX0.ub8UitKVCL1k6L9wV01mVMlK8af_yGdnW0ainFSRBso', // Ganti dengan Anon Key Supabase Anda
  );
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
  DependencyInjection.init();
  DependencyInjection2.init();
}
