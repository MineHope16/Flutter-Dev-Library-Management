import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/ChangeModeProvider.dart';
import '../../Models/BookModel.dart';
import '../../Services/OpenLibraryService.dart';
import '../../utils/AppStrings.dart';
import '../Elements/CustomContainer.dart';
import '../Elements/CustomText.dart';
import '../Elements/CustomTextField.dart';
import 'BookDetailsScreen.dart';

enum SearchFilter { all, title, author, isbn }

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final OpenLibraryService _apiService = OpenLibraryService();
  final ScrollController _scrollController = ScrollController();

  List<BookModel> _books = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  SearchFilter _selectedFilter = SearchFilter.all;
  String _lastQuery = '';
  int _currentPage = 1;
  bool _hasMoreResults = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Handle navigation arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      String? queryToSearch;

      if (args is String) {
        queryToSearch = args;
      } else if (args is Map<String, dynamic> && args['query'] != null) {
        queryToSearch = args['query'] as String;
        // Handle filter if provided
        if (args['filter'] != null) {
          final filterString = args['filter'] as String;
          if (filterString.toLowerCase() == 'author') {
            _selectedFilter = SearchFilter.author;
          } else if (filterString.toLowerCase() == 'title') {
            _selectedFilter = SearchFilter.title;
          }
        }
      } else if (widget.initialQuery != null) {
        queryToSearch = widget.initialQuery!;
      }

      if (queryToSearch != null) {
        _searchController.text = queryToSearch;
        _performSearch(queryToSearch);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore && _hasMoreResults) {
        _loadMoreResults();
      }
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _books.clear();
      _currentPage = 1;
      _hasMoreResults = true;
    });

    try {
      List<BookModel> results;

      switch (_selectedFilter) {
        case SearchFilter.title:
          results = await _apiService.searchBooksByTitle(query);
          break;
        case SearchFilter.author:
          results = await _apiService.searchBooksByAuthor(query);
          break;
        case SearchFilter.isbn:
          results = await _apiService.searchBooksByISBN(query);
          break;
        case SearchFilter.all:
          results = await _apiService.searchBooks(query, page: _currentPage);
          break;
      }

      setState(() {
        _books = results;
        _lastQuery = query;
        _isLoading = false;
        _hasMoreResults = results.length >= 20;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppStrings.errorSearchingBooks}: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadMoreResults() async {
    if (_lastQuery.isEmpty || !_hasMoreResults) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      _currentPage++;
      final newResults = await _apiService.searchBooks(
        _lastQuery,
        page: _currentPage,
      );

      setState(() {
        _books.addAll(newResults);
        _isLoadingMore = false;
        _hasMoreResults = newResults.length >= 20;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _currentPage--;
      });
    }
  }

  void _onFilterChanged(SearchFilter? filter) {
    if (filter != null && filter != _selectedFilter) {
      setState(() {
        _selectedFilter = filter;
      });

      if (_searchController.text.isNotEmpty) {
        _performSearch(_searchController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: MyText(
          text: AppStrings.searchScreenTitle,
          color: Colors.white,
          size: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: themeProvider.buttonBackgroundColor,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
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
          children: [
            const SizedBox(height: 10),

            // Search Bar with improved styling
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: _searchController,
                      hintText: AppStrings.searchBooks,
                      hintColor: themeProvider.secondaryTextColor,
                      textColor: themeProvider.primaryTextColor,
                      backgroundColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      textSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_searchController.text.isNotEmpty) {
                        _performSearch(_searchController.text);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Filter Chips with improved styling
            Container(
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: SearchFilter.values.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () => _onFilterChanged(filter),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: isSelected
                                ? null
                                : Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                          ),
                          child: Text(
                            _getFilterLabel(filter),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : themeProvider.primaryTextColor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Search Results
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blue),
                          SizedBox(height: 16),
                          MyText(
                            text: AppStrings.searchingOpenLibrary,
                            color: themeProvider.secondaryTextColor,
                            size: 16,
                          ),
                        ],
                      ),
                    )
                  : _books.isEmpty
                  ? _buildEmptyState(themeProvider)
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _books.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _books.length) {
                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                          );
                        }

                        final book = _books[index];
                        return _buildBookCard(book, themeProvider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeProvider themeProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: themeProvider.secondaryTextColor,
          ),
          SizedBox(height: 16),
          MyText(
            text: _lastQuery.isEmpty
                ? AppStrings.searchMillionsOfBooks
                : AppStrings.noBooksFound,
            size: 18,
            fontWeight: FontWeight.bold,
            color: themeProvider.primaryTextColor,
          ),
          SizedBox(height: 8),
          MyText(
            text: _lastQuery.isEmpty
                ? AppStrings.enterSearchTerms
                : AppStrings.adjustSearchTerms,
            size: 14,
            color: themeProvider.secondaryTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(BookModel book, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () {
        // Navigate to book details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: book),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: themeProvider.buttonBackgroundColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Cover
              Container(
                width: 60,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[300],
                ),
                child: book.coverId != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _apiService.getCoverUrl(book.coverId),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderCover();
                          },
                        ),
                      )
                    : _buildPlaceholderCover(),
              ),

              SizedBox(width: 12),

              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: book.displayTitle,
                      size: 16,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.primaryTextColor,
                      maxLines: 2,
                    ),
                    SizedBox(height: 4),
                    MyText(
                      text: "${AppStrings.by} ${book.authorNames}",
                      size: 14,
                      color: themeProvider.secondaryTextColor,
                      maxLines: 1,
                    ),
                    if (book.displayYear.isNotEmpty) ...[
                      SizedBox(height: 4),
                      MyText(
                        text: "${AppStrings.published}: ${book.displayYear}",
                        size: 12,
                        color: themeProvider.secondaryTextColor,
                      ),
                    ],
                    if (book.subjects != null && book.subjects!.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: book.subjects!.take(3).map((subject) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              subject,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderCover() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
      ),
      child: Icon(Icons.book, color: Colors.grey[600], size: 30),
    );
  }

  String _getFilterLabel(SearchFilter filter) {
    switch (filter) {
      case SearchFilter.all:
        return AppStrings.all;
      case SearchFilter.title:
        return AppStrings.title;
      case SearchFilter.author:
        return AppStrings.author;
      case SearchFilter.isbn:
        return AppStrings.isbn;
    }
  }
}
