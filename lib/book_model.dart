class BookModel {
  final String? id;
  final String author;
  final String title;
  final int year;

  BookModel({
    this.id,
    required this.author,
    required this.title,
    required this.year,
  });

  static BookModel fromMap({required Map map}) => BookModel(
        id: map['_id'],
        author: map['author'],
        title: map['title'],
        year: map['year'],
      );
}
