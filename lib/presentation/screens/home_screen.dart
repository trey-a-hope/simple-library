import 'package:flutter/material.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:simple_library/util/extensions/date_format_extensions.dart';
import 'package:simple_library/domain/models/book_model.dart';
import 'package:simple_library/data/services/graphql_service.dart';
import 'package:simple_library/presentation/widgets/full_button.dart';

enum DateSelection {
  release,
  start,
  end,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GraphQLService _graphQLService = GraphQLService();

  List<BookModel>? _books;

  BookModel? _selectedBook;

  late TabController _tabController;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _releasedController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  List<String> _ids = [];

  DateTime? _releaseDate, _startDate, _endDate;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    _load();
  }

  void _load() async {
    _books = null;

    _books = await _graphQLService.getBooks(limit: 10);
    setState(() {});
  }

  void _clear() {
    _titleController.clear();
    _authorController.clear();
    _releasedController.clear();
  }

  Future<void> _selectDate(
      {required DateSelection dateSelection,
      required BuildContext context}) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      switch (dateSelection) {
        case DateSelection.release:
          _releaseDate = selectedDate;
          _releasedController.text = selectedDate.formatMMMddyyyy();
          break;
        case DateSelection.start:
          _startDate = selectedDate;
          _startController.text = selectedDate.formatMMMddyyyy();
          break;
        case DateSelection.end:
          _endDate = selectedDate;
          _endController.text = selectedDate.formatMMMddyyyy();
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Library'),
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
                                _releasedController.text =
                                    _selectedBook!.year.formatMMMddyyyy();
                              },
                              title: Text(
                                '${_books![index].title} by ${_books![index].author}',
                              ),
                              subtitle: Text(
                                'Released ${_books![index].year.formatMMMddyyyy()}',
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
                  SizedBox(
                    height: 430,
                    child: DefaultTabController(
                      length: 3, // number of tabs
                      child: Column(
                        children: <Widget>[
                          TabBar(
                            controller: _tabController,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(text: 'Add', icon: Icon(Icons.add)),
                              Tab(text: 'Edit', icon: Icon(Icons.edit)),
                              Tab(text: 'Filter', icon: Icon(Icons.search)),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                Column(
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
                                        controller: _releasedController,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          hintText: 'Year',
                                        ),
                                        onTap: () {
                                          _selectDate(
                                            dateSelection:
                                                DateSelection.release,
                                            context: context,
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Column(
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
                                        controller: _releasedController,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          hintText: 'Year',
                                        ),
                                        onTap: () {
                                          _selectDate(
                                            dateSelection:
                                                DateSelection.release,
                                            context: context,
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ChipTags(
                                          list: _ids,
                                          createTagOnSubmit: true,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: _releasedController,
                                            decoration: const InputDecoration(
                                              hintText: 'Author',
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller: _startController,
                                                  readOnly: true,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'Start Date',
                                                  ),
                                                  onTap: () {
                                                    _selectDate(
                                                      dateSelection:
                                                          DateSelection.start,
                                                      context: context,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  controller: _endController,
                                                  readOnly: true,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: 'End Date',
                                                  ),
                                                  onTap: () {
                                                    _selectDate(
                                                      dateSelection:
                                                          DateSelection.end,
                                                      context: context,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          FullButton(
                            title: 'Submit',
                            backgroundColor: Colors.blue,
                            onPressed: () async {
                              switch (_tabController.index) {
                                case 0:
                                  await _graphQLService.createBook(
                                    title: _titleController.text,
                                    author: _authorController.text,
                                    year: _releaseDate!,
                                  );

                                  _clear();

                                  _load();
                                  break;
                                case 1:
                                  await _graphQLService.updateBook(
                                    id: _selectedBook!.id!,
                                    title: _titleController.text,
                                    author: _authorController.text,
                                    year: _releaseDate!,
                                  );

                                  _clear();

                                  _load();
                                  break;
                                case 2:
                                  //TODO: Filter content.
                                  break;
                              }
                            },
                          ),
                          FullButton(
                            title: 'Clear',
                            backgroundColor: Colors.black,
                            onPressed: () => _clear(),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



// git remote add origin https://github.com/trey-a-hope/simple-library.git
// OR
// git remote set-url origin https://github.com/trey-a-hope/simple-library.git
// git add .  
// git commit . -m 'Updated mongodb connection string.'
// git push -u origin main       