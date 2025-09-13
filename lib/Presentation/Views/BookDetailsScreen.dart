import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Models/BookModel.dart';
import '../../Providers/ChangeModeProvider.dart';
import '../../Providers/FavoritesProvider.dart';
import '../../Services/OpenLibraryService.dart';
import '../Elements/CustomText.dart';
import '../Elements/CustomContainer.dart';
import '../Elements/CustomBottom.dart';
import '../CommonWidgets/ThemeToggleWidget.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookModel book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _bookDetails;
  String? _description;
  List<String> _subjects = [];
  Map<String, dynamic>? _authorDetails;
  final OpenLibraryService _apiService = OpenLibraryService();

  @override
  void initState() {
    super.initState();
    _loadBookDetails();
  }

  Future<void> _loadBookDetails() async {
    try {
      // Load detailed book information from OpenLibrary
      await Future.wait([_loadBookInfo(), _loadAuthorInfo()]);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading book details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBookInfo() async {
    try {
      // Get work details if available
      if (widget.book.key != null && widget.book.key!.startsWith('/works/')) {
        final workResponse = await http.get(
          Uri.parse('https://openlibrary.org${widget.book.key}.json'),
        );

        if (workResponse.statusCode == 200) {
          _bookDetails = json.decode(workResponse.body);

          // Extract description
          if (_bookDetails!['description'] != null) {
            if (_bookDetails!['description'] is Map) {
              _description = _bookDetails!['description']['value'];
            } else {
              _description = _bookDetails!['description'].toString();
            }
          }

          // Extract subjects
          if (_bookDetails!['subjects'] != null) {
            _subjects = List<String>.from(_bookDetails!['subjects']);
          }
        }
      }
    } catch (e) {
      print('Error loading book info: $e');
    }
  }

  Future<void> _loadAuthorInfo() async {
    try {
      if (widget.book.authorKeys != null &&
          widget.book.authorKeys!.isNotEmpty) {
        final authorKey = widget.book.authorKeys!.first;
        final authorResponse = await http.get(
          Uri.parse('https://openlibrary.org$authorKey.json'),
        );

        if (authorResponse.statusCode == 200) {
          _authorDetails = json.decode(authorResponse.body);
        }
      }
    } catch (e) {
      print('Error loading author info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withOpacity(0.85),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: MyText(
          text: "Book Details",
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          size: 20,
        ),
        actions: [
          ThemeToggleWidget(style: ThemeToggleStyle.iconButton, iconSize: 24),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: themeProvider.backgroundColor,
              ),
            ),
          ),
          // Content
          SafeArea(
            child: _isLoading
                ? _buildLoadingState(theme)
                : _buildBookContent(theme, themeProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          MyText(
            text: "Loading book details...",
            color: theme.colorScheme.onSurface,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildBookContent(ThemeData theme, ThemeProvider themeProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Hero Section
          _buildBookHeroSection(theme, themeProvider),

          const SizedBox(height: 24),

          // Book Information
          _buildBookInformation(theme, themeProvider),

          const SizedBox(height: 24),

          // Description Section
          if (_description != null && _description!.isNotEmpty)
            _buildDescriptionSection(theme, themeProvider),

          const SizedBox(height: 24),

          // Subjects/Tags
          if (_subjects.isNotEmpty) _buildSubjectsSection(theme, themeProvider),

          const SizedBox(height: 24),

          // Author Information
          if (_authorDetails != null) _buildAuthorSection(theme, themeProvider),

          const SizedBox(height: 24),

          // Action Buttons
          _buildActionButtons(theme, themeProvider),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildBookHeroSection(ThemeData theme, ThemeProvider themeProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book Cover
        MyContainer(
          width: 120,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: widget.book.coverId != null
                ? Image.network(
                    _apiService.getCoverUrl(widget.book.coverId),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildBookPlaceholder(theme),
                  )
                : _buildBookPlaceholder(theme),
          ),
        ),

        const SizedBox(width: 16),

        // Book Basic Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: widget.book.displayTitle,
                size: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                maxLines: 3,
              ),

              const SizedBox(height: 8),

              if (widget.book.authorNames.isNotEmpty)
                MyText(
                  text: "by ${widget.book.authorNames}",
                  size: 16,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),

              const SizedBox(height: 12),

              // Rating and Publication Year
              Row(
                children: [
                  if (widget.book.averageRating != null &&
                      widget.book.averageRating! > 0) ...[
                    Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    MyText(
                      text: widget.book.averageRating!.toStringAsFixed(1),
                      size: 14,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    const SizedBox(width: 16),
                  ],

                  if (widget.book.displayYear.isNotEmpty)
                    MyText(
                      text: widget.book.displayYear,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: Center(
        child: Icon(
          Icons.book,
          size: 40,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildBookInformation(ThemeData theme, ThemeProvider themeProvider) {
    return MyContainer(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: "Book Information",
            size: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),

          const SizedBox(height: 16),

          if (widget.book.isbn != null && widget.book.isbn!.isNotEmpty) ...[
            _buildInfoRow("ISBN", widget.book.isbn!.first, theme),
            const SizedBox(height: 8),
          ],

          if (widget.book.displayYear.isNotEmpty) ...[
            _buildInfoRow("Published Year", widget.book.displayYear, theme),
            const SizedBox(height: 8),
          ],

          if (widget.book.pageCount != null) ...[
            _buildInfoRow("Pages", "${widget.book.pageCount} pages", theme),
            const SizedBox(height: 8),
          ],

          if (widget.book.language != null &&
              widget.book.language!.isNotEmpty) ...[
            _buildInfoRow("Language", widget.book.language!, theme),
            const SizedBox(height: 8),
          ],

          if (widget.book.ratingsCount != null &&
              widget.book.ratingsCount! > 0) ...[
            _buildInfoRow(
              "Ratings Count",
              "${widget.book.ratingsCount} ratings",
              theme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: MyText(
            text: "$label:",
            size: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: MyText(
            text: value,
            size: 14,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(
    ThemeData theme,
    ThemeProvider themeProvider,
  ) {
    return MyContainer(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: "Description",
            size: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),

          const SizedBox(height: 12),

          MyText(
            text: _description!,
            size: 14,
            color: theme.colorScheme.onSurface,
            lineHeight: 1.5,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsSection(ThemeData theme, ThemeProvider themeProvider) {
    return MyContainer(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: "Subjects & Categories",
            size: 18,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _subjects.take(10).map((subject) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: MyText(
                  text: subject,
                  size: 12,
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorSection(ThemeData theme, ThemeProvider themeProvider) {
    final authorName = _authorDetails!['name'] ?? widget.book.authorNames;
    final authorBio = _authorDetails!['bio'] is Map
        ? _authorDetails!['bio']['value']
        : _authorDetails!['bio']?.toString();
    final birthDate = _authorDetails!['birth_date'];
    final deathDate = _authorDetails!['death_date'];

    return MyContainer(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              MyText(
                text: "About the Author",
                size: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ],
          ),

          const SizedBox(height: 12),

          MyText(
            text: authorName,
            size: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),

          if (birthDate != null || deathDate != null) ...[
            const SizedBox(height: 4),
            MyText(
              text: "${birthDate ?? '?'} - ${deathDate ?? 'Present'}",
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],

          if (authorBio != null && authorBio.isNotEmpty) ...[
            const SizedBox(height: 12),
            MyText(
              text: authorBio,
              size: 14,
              color: theme.colorScheme.onSurface,
              lineHeight: 1.5,
              maxLines: 5,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(
          child: MyButton(
            btnLabel: "Find Similar Books",
            onPressed: () {
              // Navigate to search with the first subject or author
              final searchQuery = _subjects.isNotEmpty
                  ? _subjects.first
                  : widget.book.authorNames;
              Navigator.pushNamed(
                context,
                '/search',
                arguments: {'query': searchQuery},
              );
            },
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Consumer<FavoritesProvider>(
            builder: (context, favoritesProvider, child) {
              final isFavorited = favoritesProvider.isFavorited(widget.book);

              return OutlinedButton.icon(
                onPressed: () async {
                  // Toggle favorite status with Firebase
                  final success = await favoritesProvider.toggleFavorite(
                    widget.book,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: MyText(
                          text: isFavorited
                              ? "Removed from favorites!"
                              : "Added to favorites!",
                          color: Colors.white,
                        ),
                        backgroundColor: success
                            ? theme.colorScheme.primary
                            : Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Icon(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: isFavorited ? Colors.red : theme.colorScheme.primary,
                ),
                label: MyText(
                  text: isFavorited
                      ? "Remove from Favorites"
                      : "Add to Favorites",
                  size: 14,
                  color: isFavorited ? Colors.red : theme.colorScheme.primary,
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isFavorited ? Colors.red : theme.colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
