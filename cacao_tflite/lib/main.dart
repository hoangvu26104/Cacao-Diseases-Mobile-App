import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/detection_page.dart'; // 👈 tách ra file riêng

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cacao Disease Detection',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const DiseaseDetectionPage(),
    );
  }
}
