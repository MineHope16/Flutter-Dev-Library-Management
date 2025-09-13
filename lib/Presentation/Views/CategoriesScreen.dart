import 'package:flutter/material.dart';
import 'package:openlibrary_book_explorer/Providers/ChangeModeProvider.dart';
import 'package:openlibrary_book_explorer/Models/CategoriesModel.dart';
import 'package:openlibrary_book_explorer/Presentation/Elements/CustomText.dart';
import 'package:openlibrary_book_explorer/Services/OpenLibraryService.dart';
import 'package:openlibrary_book_explorer/utils/Routes.dart';
import 'package:openlibrary_book_explorer/utils/AppStrings.dart';
import 'package:provider/provider.dart';

import '../Elements/CustomContainer.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool openSearch = false;
  final OpenLibraryService _apiService = OpenLibraryService();
  List<String> _subjects = [];
  List<String> _filteredSubjects = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  List<CategoriesModel> categoriesModel = [
    CategoriesModel(name: "Fiction"),
    CategoriesModel(name: "Non-Fiction"),
    CategoriesModel(name: "Kids"),
    CategoriesModel(name: "Science"),
    CategoriesModel(name: "History"),
    CategoriesModel(name: "Technology"),
    CategoriesModel(name: "Kids"),
    CategoriesModel(name: "Businesses"),
    CategoriesModel(name: "History"),
  ];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
    _searchController.addListener(_filterSubjects);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    try {
      final subjects = await _apiService.getPopularSubjects();
      setState(() {
        _subjects = subjects;
        _filteredSubjects = subjects;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.errorLoadingCategories} ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterSubjects() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSubjects = _subjects
          .where((subject) => subject.toLowerCase().contains(query))
          .toList();
    });
  }

  void _navigateToSearch(String subject) {
    Navigator.pushNamed(context, AppRoutes.search, arguments: subject);
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
                  hintText: AppStrings.searchCategories,
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                autofocus: true,
              )
            : MyText(
                text: AppStrings.categoriesScreenTitle,
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
                  _filterSubjects();
                }
              });
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
        ),
      ),
      body: MyContainer(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Expanded(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blue),
                          SizedBox(height: 16),
                          MyText(
                            text: AppStrings.loadingCategories,
                            color: themeProvider.secondaryTextColor,
                            size: 16,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: openSearch
                          ? _filteredSubjects.length
                          : _subjects.length,
                      itemBuilder: (context, index) {
                        final subjectName = openSearch
                            ? _filteredSubjects[index]
                            : _subjects[index];
                        final displayName = subjectName
                            .replaceAll('_', ' ')
                            .split(' ')
                            .map(
                              (word) =>
                                  word[0].toUpperCase() + word.substring(1),
                            )
                            .join(' ');

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: GestureDetector(
                            onTap: () => _navigateToSearch(subjectName),
                            child: MyContainer(
                              height: 70,
                              width: double.infinity,
                              color: themeProvider.buttonBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.category_outlined,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: MyText(
                                      text: displayName,
                                      size: 18,
                                      fontWeight: FontWeight.bold,
                                      color: themeProvider.primaryTextColor,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: themeProvider.secondaryTextColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
