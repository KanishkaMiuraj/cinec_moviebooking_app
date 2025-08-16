import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveBooking(Booking booking) async {
    final showtimeId = booking.showtime.replaceAll(':', '_');
    final bookingRef = _db
        .collection('movies')
        .doc(booking.movieId)
        .collection('showtimes')
        .doc(showtimeId)
        .collection('bookings')
        .doc(); // Use .doc() to create a new unique ID

    await bookingRef.set(booking.toMap());

    // Also save a reference under the user's collection for history
    await _db
        .collection('users')
        .doc(booking.userId)
        .collection('bookings')
        .doc(bookingRef.id) // Use the same ID
        .set(booking.toMap());

    notifyListeners();
  }

  // New method to fetch booked seats and their users
  Future<Map<String, String>> getBookedSeatsAndUsers(
      String movieId, String showtime) async {
    final showtimeId = showtime.replaceAll(':', '_');
    final querySnapshot = await _db
        .collection('movies')
        .doc(movieId)
        .collection('showtimes')
        .doc(showtimeId)
        .collection('bookings')
        .get();

    final Map<String, String> bookedSeatsWithUsers = {};
    for (var doc in querySnapshot.docs) {
      final seats = List<String>.from(doc['seats'] ?? []);
      final userName = doc['userName'] as String;
      for (var seat in seats) {
        bookedSeatsWithUsers[seat] = userName;
      }
    }
    return bookedSeatsWithUsers;
  }

  Stream<List<Booking>> getUserBookingsStream() {
    final uid = _auth.currentUser!.uid;
    return _db
        .collection('users')
        .doc(uid)
        .collection('bookings')
        .orderBy('bookingDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Booking.fromFirestore(doc.data(), doc.id))
        .toList());
  }
}