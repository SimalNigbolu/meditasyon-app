import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meditationapp/anasayfa.dart';
import 'package:meditationapp/giris_ekrani.dart';
import 'package:meditationapp/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MentalHealthApp());
}

class MentalHealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
      routes: {
        '/giris': (context) => GirisEkrani(),
        '/anasayfa': (context) => Anasayfa(),
      },
    );
  }
}
