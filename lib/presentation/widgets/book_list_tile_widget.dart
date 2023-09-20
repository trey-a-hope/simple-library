import 'package:flutter/material.dart';
import 'package:simple_library/domain/models/book_model.dart';
import 'package:simple_library/util/extensions/date_format_extensions.dart';

class BookListTileWidget extends StatelessWidget {
  final void Function() onTap;
  final BookModel book;
  final void Function() delete;

  const BookListTileWidget({
    required this.onTap,
    required this.book,
    required this.delete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book),
      onTap: onTap,
      title: Text('${book.title} by ${book.author}'),
      subtitle: Text('Released ${book.year.formatMMMddyyyy()}'),
      trailing: IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: delete,
      ),
    );
  }
}
