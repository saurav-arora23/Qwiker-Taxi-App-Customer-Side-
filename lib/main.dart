import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qwiker_customer_app/pages/homepage_screen.dart';
import 'package:qwiker_customer_app/pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userId = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBBagFDeTprXEpIrISPudKzrSenaUw9OPY',
      appId: '1:175048736544:android:730c986a13f40a88b26145',
      projectId: 'qwiker-customer-app-a8927',
      messagingSenderId: '175048736544',
    ),
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('UserID') ?? "";
    debugPrint('User Id is : $userId');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qwiker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: userId.isEmpty ? const SplashScreen() : const HomepageScreen(),
    );
  }
}
