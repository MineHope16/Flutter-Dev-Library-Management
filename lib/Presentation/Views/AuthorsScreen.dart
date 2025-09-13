import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/ChangeModeProvider.dart';
import '../../Models/AuthorsModel.dart';
import '../../Configuration/Routes.dart';
import '../Elements/CustomContainer.dart';
import '../Elements/CustomText.dart';

class AuthorsScreen extends StatefulWidget {
  const AuthorsScreen({super.key});

  @override
  State<AuthorsScreen> createState() => _AuthorsScreenState();
}

class _AuthorsScreenState extends State<AuthorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AuthorsModel> _filteredAuthors = [];
  bool openSearch = false;

  List<AuthorsModel> authorsModel = [
    AuthorsModel(name: "J.K. Rowling"),
    AuthorsModel(name: "George R.R. Martin"),
    AuthorsModel(name: "Jane Austen"),
    AuthorsModel(name: "Charles Dickens"),
    AuthorsModel(name: "Mark Twain"),
    AuthorsModel(name: "Agatha Christie"),
    AuthorsModel(name: "Ernest Hemingway"),
    AuthorsModel(name: "J.R.R. Tolkien"),
    AuthorsModel(name: "Leo Tolstoy"),
    AuthorsModel(name: "Stephen King"),
    AuthorsModel(name: "William Shakespeare"),
    AuthorsModel(name: "Harper Lee"),
    AuthorsModel(name: "F. Scott Fitzgerald"),
    AuthorsModel(name: "George Orwell"),
    AuthorsModel(name: "Virginia Woolf"),
  ];

  @override
  void initState() {
    super.initState();
    _filteredAuthors = List.from(authorsModel);
    _searchController.addListener(() {
      _filterAuthors();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAuthors() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredAuthors = List.from(authorsModel);
      } else {
        _filteredAuthors = authorsModel
            .where(
              (author) => author.name.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
            )
            .toList();
      }
    });
  }

  void _searchAuthorBooks(String authorName) {
    Navigator.pushNamed(
      context,
      AppRoutes.search,
      arguments: {'query': authorName, 'filter': 'Author'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: openSearch
            ? TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: const InputDecoration(
                  hintText: "Search Author",
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                autofocus: true,
              )
            : MyText(
                text: "Authors Names",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.bold,
              ),
        backgroundColor: themeProvider.buttonBackgroundColor,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              openSearch ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                openSearch = !openSearch;
                if (!openSearch) {
                  _searchController.clear();
                  _filterAuthors();
                }
              });
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
        ),
      ),
      body: SafeArea(
        child: MyContainer(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Expanded(
                child: _filteredAuthors.isEmpty
                    ? const Center(
                        child: Text(
                          "No authors found",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredAuthors.length,
                        itemBuilder: (context, index) {
                          final author = _filteredAuthors[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: MyContainer(
                              height: 70,
                              width: double.infinity,
                              color: themeProvider.buttonBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 10,
                              ),
                              onTap: () => _searchAuthorBooks(author.name),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        themeProvider.buttonBackgroundColor,
                                    child: Text(
                                      author.name.isNotEmpty
                                          ? author.name[0].toUpperCase()
                                          : 'A',
                                      style: TextStyle(
                                        color: themeProvider.primaryTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MyText(
                                          text: author.name,
                                          size: 18,
                                          fontWeight: FontWeight.bold,
                                          color: themeProvider.primaryTextColor,
                                        ),
                                        MyText(
                                          text: "Click to search books",
                                          size: 14,
                                          color: themeProvider.primaryTextColor
                                              .withOpacity(0.7),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: themeProvider.primaryTextColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
