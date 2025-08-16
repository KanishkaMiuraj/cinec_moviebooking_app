import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Add this import
import '../models/movie.dart';

class MovieService extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Movie>> getMovies() async {
    final snapshot = await _db.collection('movies').get();
    return snapshot.docs
        .map((doc) => Movie.fromFirestore(doc.data(), doc.id))
        .toList();
  }
}