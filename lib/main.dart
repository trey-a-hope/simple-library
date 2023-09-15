import 'package:flutter/material.dart';
import 'package:simple_library/book_model.dart';
import 'package:simple_library/graphql_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Books Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GraphQLService _graphQLService = GraphQLService();

  bool _isEdit = false;

  List<BookModel>? _books;

  BookModel? _selectedBook;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _books = null;
    _books = await _graphQLService.getBooks(limit: 3);
    setState(() {});
  }

  void _clear() {
    _titleController.clear();
    _authorController.clear();
    _yearController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: _books == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: _books!.isEmpty
                        ? const Center(
                            child: Text('No Books'),
                          )
                        : ListView.builder(
                            itemCount: _books!.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ListTile(
                              leading: const Icon(Icons.book),
                              onTap: () {
                                _selectedBook = _books![index];
                                _titleController.text = _selectedBook!.title;
                                _authorController.text = _selectedBook!.author;
                                _yearController.text =
                                    _selectedBook!.year.toString();
                              },
                              title: Text(
                                '${_books![index].title} by ${_books![index].author}',
                              ),
                              subtitle: Text(
                                'Released ${_books![index].year}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await _graphQLService.deleteBook(
                                      id: _books![index].id!);
                                  _load();
                                },
                              ),
                            ),
                          ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _isEdit = !_isEdit;
                          setState(() {});
                        },
                        icon: Icon(_isEdit ? Icons.edit : Icons.add),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: _titleController,
                                decoration: const InputDecoration(
                                  hintText: 'Title',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: _authorController,
                                decoration: const InputDecoration(
                                  hintText: 'Author',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: _yearController,
                                decoration: const InputDecoration(
                                  hintText: 'Year',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (_isEdit) {
                            await _graphQLService.updateBook(
                              id: _selectedBook!.id!,
                              title: _titleController.text,
                              author: _authorController.text,
                              year: int.parse(_yearController.text),
                            );
                          } else {
                            await _graphQLService.createBook(
                              title: _titleController.text,
                              author: _authorController.text,
                              year: int.parse(_yearController.text),
                            );
                          }

                          _clear();

                          _load();
                        },
                        icon: const Icon(Icons.send),
                      )
                    ],
                  )
                ],
              ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// git remote add origin https://github.com/trey-a-hope/simple-library.git
// git push -u origin main       