import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String userId;
  final String userName;
  final String movieId;
  final String movieTitle;
  final String showtime;
  final List<String> seats;
  final DateTime bookingDate;

  Booking({
    required this.id,
    required this.userId,
    required this.userName,
    required this.movieId,
    required this.movieTitle,
    required this.showtime,
    required this.seats,
    required this.bookingDate,
  });

  factory Booking.fromFirestore(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      movieId: data['movieId'] ?? '',
      movieTitle: data['movieTitle'] ?? '',
      showtime: data['showtime'] ?? '',
      seats: List<String>.from(data['seats'] ?? []),
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'showtime': showtime,
      'seats': seats,
      'bookingDate': FieldValue.serverTimestamp(),
    };
  }
}