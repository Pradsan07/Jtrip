import 'package:flutter/material.dart';
import 'screens/auth_screens.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/other_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jelajahi Jember',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D6A4F)),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/booking': (context) => const BookingScreen(),
        '/kuliner': (context) => const KulinerScreen(),
        '/pesanan': (context) => const PesananScreen(),
        '/profil': (context) => const ProfilScreen(),
      },
    );
  }
}
