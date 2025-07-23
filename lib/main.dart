import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proser/screens/wishlist_manager.dart';
import 'firebase_options.dart';  // <--- import this
import 'screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WishlistManager.init(); // 🔐 Load saved wishlist before app runs
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // <--- use generated options
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proser',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'LatoRegular',
      ),
      home: OnboardingScreen(),
    );
  }
}
