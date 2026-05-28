import 'package:flutter/material.dart';
import 'screens/auth_screens.dart';
import 'screens/home_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/other_screens.dart';
import 'screens/order_store.dart';
import 'services/session_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _hasToken() async {
    final token = await SessionService.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return OrderStoreProvider(
      store: orderStore,
      child: MaterialApp(
        title: 'Jelajahi Jember',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2D6A4F),
          ),
          useMaterial3: true,
        ),
        home: FutureBuilder<bool>(
          future: _hasToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            final isLoggedIn = snapshot.data ?? false;

            if (isLoggedIn) {
              return const HomeScreen();
            }

            return const LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/kuliner': (context) => const KulinerScreen(),
          '/pesanan': (context) => const PesananScreen(),
          '/profil': (context) => const ProfilScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const kPrimaryGreen = Color(0xFF2D6A4F);
  static const kBgGray = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBgGray,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'J-TRIP',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: kPrimaryGreen,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 18),
            CircularProgressIndicator(
              color: kPrimaryGreen,
            ),
          ],
        ),
      ),
    );
  }
}