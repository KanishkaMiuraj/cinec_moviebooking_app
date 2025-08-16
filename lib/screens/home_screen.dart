import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:google_fonts/google_fonts.dart';


import '../services/auth_service.dart';
import 'movie_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        final user = authService.currentUser;
        final displayName = user?.displayName ?? "Guest User";
        final email = user?.email ?? "";

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cinec Movie Booking',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            elevation: 0,
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(displayName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  accountEmail: Text(email),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.black),
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFF140B34),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.movie, color: Colors.black),
                  title: const Text('Now Showing'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.black),
                  title: const Text('My Bookings'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/booking-history');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black),
                  title: const Text('Logout'),
                  onTap: () async {
                    // Updated: Use Provider to access AuthService
                    await Provider.of<AuthService>(context, listen: false)
                        .logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ),
          body: const MovieListScreen(),
        );
      },
    );
  }
}