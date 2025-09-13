import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/ChangeModeProvider.dart';
import '../../Models/AuthorsModel.dart';
import '../../Configuration/Routes.dart';
import '../Elements/CustomContainer.dart';
import '../Elements/CustomText.dart';
import '../Elements/CustomTextField.dart';

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
      body: SafeArea(
        child: MyContainer(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  openSearch
                      ? Expanded(
                          child: MyTextField(
                            controller: _searchController,
                            backgroundColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            textFieldBorder: Border.all(
                              width: 2,
                              color: themeProvider.primaryTextColor,
                            ),
                            hintText: "Search Author",
                            hintColor: themeProvider.primaryTextColor,
                            cursorColor: themeProvider.primaryTextColor,
                            textColor: themeProvider.primaryTextColor,
                            textSize: 16,
                          ),
                        )
                      : MyText(
                          text: "Authors Names",
                          size: 20,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.primaryTextColor,
                        ),
                  const SizedBox(width: 10),
                  MyIconContainer(
                    icon: openSearch ? Icons.close : Icons.search,
                    iconColor: themeProvider.primaryTextColor,
                    iconSize: 30,
                    onTap: () {
                      setState(() {
                        openSearch = !openSearch;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

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
