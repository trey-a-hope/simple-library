import 'package:flutter/material.dart';

class BookModel {
  final String? id;
  final String author;
  final String title;
  final DateTime year;

  BookModel({
    this.id,
    required this.author,
    required this.title,
    required this.year,
  });

  static BookModel fromMap({required Map map}) {
    return BookModel(
      id: map['_id'],
      author: map['author'],
      title: map['title'],
      year: DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['year']),
      ),
    );
  }
}
