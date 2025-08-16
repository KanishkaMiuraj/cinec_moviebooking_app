import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/movie.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/seat_selection_screen.dart';
import 'screens/booking_history_screen.dart';

import 'services/auth_service.dart';
import 'services/movie_service.dart';
import 'services/booking_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => MovieService()),
        ChangeNotifierProvider(create: (_) => BookingService()),
      ],
      child: MaterialApp(
        title: 'Cinec Movie Booking',
        theme: ThemeData(
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF140B34),
            foregroundColor: Colors.white,
          ),
          fontFamily: GoogleFonts.poppins().fontFamily,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasData) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/booking-history': (context) => const BookingHistoryScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/movie-detail') {
            final movie = settings.arguments as Movie;
            return MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movie),
            );
          }
          if (settings.name == '/seat-selection') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => SeatSelectionScreen(
                movie: args['movie'] as Movie,
                showtime: args['showtime'],
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}