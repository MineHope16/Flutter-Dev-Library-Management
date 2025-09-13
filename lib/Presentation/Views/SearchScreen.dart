import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/ChangeModeProvider.dart';
import '../../Models/BookModel.dart';
import '../../Services/OpenLibraryService.dart';
import '../Elements/CustomContainer.dart';
import '../Elements/CustomText.dart';
import '../Elements/CustomTextField.dart';

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
          content: Text('Error searching books: ${e.toString()}'),
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
          text: "Search Books",
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
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: _searchController,
                    hintText: "Search books, authors, or ISBN...",
                    hintColor: themeProvider.secondaryTextColor,
                    textColor: themeProvider.primaryTextColor,
                    backgroundColor: themeProvider.buttonBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    textSize: 16,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (_searchController.text.isNotEmpty) {
                      _performSearch(_searchController.text);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.search, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: SearchFilter.values.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_getFilterLabel(filter)),
                      selected: isSelected,
                      onSelected: (selected) => _onFilterChanged(filter),
                      selectedColor: Colors.blue.withOpacity(0.3),
                      backgroundColor: themeProvider.buttonBackgroundColor,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.blue
                            : themeProvider.primaryTextColor,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 16),

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
                            text: "Searching OpenLibrary...",
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
                ? "Search millions of books!"
                : "No books found",
            size: 18,
            fontWeight: FontWeight.bold,
            color: themeProvider.primaryTextColor,
          ),
          SizedBox(height: 8),
          MyText(
            text: _lastQuery.isEmpty
                ? "Enter a book title, author name, or ISBN to start searching"
                : "Try adjusting your search terms or filters",
            size: 14,
            color: themeProvider.secondaryTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(BookModel book, ThemeProvider themeProvider) {
    return Card(
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
                    text: "by ${book.authorNames}",
                    size: 14,
                    color: themeProvider.secondaryTextColor,
                    maxLines: 1,
                  ),
                  if (book.displayYear.isNotEmpty) ...[
                    SizedBox(height: 4),
                    MyText(
                      text: "Published: ${book.displayYear}",
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
        return 'All';
      case SearchFilter.title:
        return 'Title';
      case SearchFilter.author:
        return 'Author';
      case SearchFilter.isbn:
        return 'ISBN';
    }
  }
}
