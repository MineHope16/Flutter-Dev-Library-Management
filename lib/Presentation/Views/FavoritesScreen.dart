import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/ChangeModeProvider.dart';
import '../../Providers/FavoritesProvider.dart';
import '../../Services/OpenLibraryService.dart';
import '../Elements/CustomText.dart';
import '../CommonWidgets/ThemeToggleWidget.dart';
import 'BookDetailsScreen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final OpenLibraryService _apiService = OpenLibraryService();

  @override
  void initState() {
    super.initState();
    // Load favorites when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavorites();
    });
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
          text: "My Favorites",
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
            child: Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                if (favoritesProvider.isLoading) {
                  return _buildLoadingState(theme);
                }

                if (favoritesProvider.error != null) {
                  return _buildErrorState(theme, favoritesProvider.error!);
                }

                if (favoritesProvider.favorites.isEmpty) {
                  return _buildEmptyState(theme, themeProvider);
                }

                return _buildFavoritesList(
                  theme,
                  themeProvider,
                  favoritesProvider,
                );
              },
            ),
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
            text: "Loading your favorites...",
            color: theme.colorScheme.onSurface,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            MyText(
              text: "Error loading favorites",
              size: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 8),
            MyText(
              text: error,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<FavoritesProvider>().loadFavorites();
              },
              child: MyText(text: "Retry", color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ThemeProvider themeProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            MyText(
              text: "No Favorites Yet",
              size: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            const SizedBox(height: 12),
            MyText(
              text:
                  "Start exploring books and add them to your favorites by tapping the heart icon on book details.",
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
              textAlign: TextAlign.center,
              lineHeight: 1.5,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: MyText(
                text: "Explore Books",
                color: Colors.white,
                size: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(
    ThemeData theme,
    ThemeProvider themeProvider,
    FavoritesProvider favoritesProvider,
  ) {
    return Column(
      children: [
        // Header with count
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              MyText(
                text:
                    "${favoritesProvider.favoritesCount} Book${favoritesProvider.favoritesCount == 1 ? '' : 's'}",
                size: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              Spacer(),
              if (favoritesProvider.favorites.isNotEmpty)
                TextButton(
                  onPressed: () {
                    _showClearConfirmation(context, favoritesProvider);
                  },
                  child: MyText(text: "Clear All", size: 14, color: Colors.red),
                ),
            ],
          ),
        ),

        // Favorites list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: favoritesProvider.favorites.length,
            itemBuilder: (context, index) {
              final favorite = favoritesProvider.favorites[index];
              return _buildFavoriteCard(
                favorite,
                theme,
                themeProvider,
                favoritesProvider,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCard(
    favorite,
    ThemeData theme,
    ThemeProvider themeProvider,
    FavoritesProvider favoritesProvider,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(book: favorite.bookData),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface.withOpacity(0.8),
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
                child: favorite.coverId != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _apiService.getCoverUrl(favorite.coverId),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderCover();
                          },
                        ),
                      )
                    : _buildPlaceholderCover(),
              ),

              const SizedBox(width: 12),

              // Book Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: favorite.title,
                      size: 16,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    MyText(
                      text: "by ${favorite.author}",
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                      maxLines: 1,
                    ),
                    if (favorite.firstPublishYear != null) ...[
                      const SizedBox(height: 4),
                      MyText(
                        text: "Published: ${favorite.firstPublishYear}",
                        size: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                    const SizedBox(height: 8),
                    MyText(
                      text: "Added on ${_formatDate(favorite.addedAt)}",
                      size: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),

              // Remove button
              IconButton(
                onPressed: () async {
                  await favoritesProvider.removeFromFavorites(
                    favorite.bookData,
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: MyText(
                          text: "Removed from favorites",
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.favorite, color: Colors.red),
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

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showClearConfirmation(
    BuildContext context,
    FavoritesProvider favoritesProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: MyText(text: "Clear All Favorites"),
          content: MyText(
            text:
                "Are you sure you want to remove all books from your favorites? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: MyText(text: "Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await favoritesProvider.clearAllFavorites();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: MyText(
                        text: "All favorites cleared",
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: MyText(text: "Clear All", color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
