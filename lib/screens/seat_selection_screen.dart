import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/booking.dart';
import '../models/movie.dart';
import '../services/auth_service.dart';
import '../services/booking_service.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Movie movie;
  final String showtime;

  const SeatSelectionScreen({
    super.key,
    required this.movie,
    required this.showtime,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<String> selectedSeats = [];
  Map<String, String> bookedSeatsAndUsers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookedSeats();
  }

  Future<void> _fetchBookedSeats() async {
    final bookingService = context.read<BookingService>();
    final fetchedData = await bookingService.getBookedSeatsAndUsers(
      widget.movie.id,
      widget.showtime,
    );
    setState(() {
      bookedSeatsAndUsers = fetchedData;
      _isLoading = false;
    });
  }

  void _toggleSeat(String seat) {
    if (bookedSeatsAndUsers.containsKey(seat)) {
      return;
    }
    setState(() {
      if (selectedSeats.contains(seat)) {
        selectedSeats.remove(seat);
      } else {
        selectedSeats.add(seat);
      }
    });
  }

  Future<void> _confirmBooking() async {
    if (selectedSeats.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one seat')),
      );
      return;
    }

    final bookingService = context.read<BookingService>();
    final authService = context.read<AuthService>();
    final user = authService.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to book seats.')),
      );
      return;
    }

    try {
      final newBooking = Booking(
        id: '',
        userId: user.uid,
        userName: user.displayName ?? 'Anonymous',
        movieId: widget.movie.id,
        movieTitle: widget.movie.title,
        showtime: widget.showtime,
        seats: selectedSeats,
        bookingDate: DateTime.now(),
      );

      await bookingService.saveBooking(newBooking);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking successful!'),
            backgroundColor: const Color(0xFF0B8ADC),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSeat(String seat) {
    bool isBooked = bookedSeatsAndUsers.containsKey(seat);
    bool isSelected = selectedSeats.contains(seat);

    Color seatColor;
    if (isBooked) {
      seatColor = Colors.blue;
    } else if (isSelected) {
      seatColor = Colors.green;
    } else {
      seatColor = Colors.white24;
    }

    return GestureDetector(
      onTap: () => _toggleSeat(seat),
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            seat,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final seatsInRow = (screenWidth - 32) ~/ 38; // 38 is the seat width + margin

    return Scaffold(
      backgroundColor: const Color(0xFF140B34),
      appBar: AppBar(
        title: Text(
          'Select Seats',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Screen',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
            Container(
              height: 5,
              width: screenWidth * 0.8,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 80, // A,B,C,D,E,F,G,H rows of 10 seats
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: seatsInRow,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                final row = String.fromCharCode('A'.codeUnitAt(0) + (index ~/ 10));
                final seatNumber = index % 10 + 1;
                final seatId = '$row$seatNumber';
                return _buildSeat(seatId);
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Colors.white24, 'Available'),
                _buildLegendItem(Colors.green, 'Selected'),
                _buildLegendItem(Colors.blue, 'Booked'),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0CA507),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Confirm Booking (${selectedSeats.length})',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}