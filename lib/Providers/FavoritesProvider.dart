import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/FavouriteBookModel.dart';
import '../Models/BookModel.dart';
import '../Services/FavoritesService.dart';

class FavoritesProvider extends ChangeNotifier {
  List<FavouriteBookModel> _favorites = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<FavouriteBookModel> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get favoritesCount => _favorites.length;

  // Check if a book is favorited
  bool isFavorited(BookModel book) {
    final bookKey = book.key ?? book.title?.replaceAll(' ', '_') ?? '';
    return _favorites.any(
      (fav) =>
          fav.bookKey == bookKey ||
          fav.bookKey == bookKey.replaceAll('/', '_') ||
          fav.title == book.displayTitle,
    );
  }

  // Initialize favorites on app start or user login
  Future<void> initializeFavorites() async {
    if (FirebaseAuth.instance.currentUser == null) {
      _favorites = [];
      notifyListeners();
      return;
    }

    await loadFavorites();
  }

  // Load user favorites from Firestore
  Future<void> loadFavorites() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _favorites = await FavoritesService.getUserFavorites();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to load favorites: ${e.toString()}';
      notifyListeners();
      debugPrint('Error loading favorites: $e');
    }
  }

  // Add book to favorites
  Future<bool> addToFavorites(BookModel book) async {
    try {
      _error = null;

      await FavoritesService.addToFavorites(book);

      // Add to local list immediately for better UX
      final favorite = FavouriteBookModel.fromBook(
        book,
        FirebaseAuth.instance.currentUser!.uid,
      );
      _favorites.insert(0, favorite); // Add at beginning
      notifyListeners();

      return true;
    } catch (e) {
      _error = 'Failed to add to favorites: ${e.toString()}';
      notifyListeners();
      debugPrint('Error adding to favorites: $e');
      return false;
    }
  }

  // Remove book from favorites
  Future<bool> removeFromFavorites(BookModel book) async {
    try {
      _error = null;

      final bookKey = book.key ?? book.title?.replaceAll(' ', '_') ?? '';
      await FavoritesService.removeFromFavorites(bookKey);

      // Remove from local list immediately for better UX
      _favorites.removeWhere(
        (fav) =>
            fav.bookKey == bookKey ||
            fav.bookKey == bookKey.replaceAll('/', '_') ||
            fav.title == book.displayTitle,
      );
      notifyListeners();

      return true;
    } catch (e) {
      _error = 'Failed to remove from favorites: ${e.toString()}';
      notifyListeners();
      debugPrint('Error removing from favorites: $e');
      return false;
    }
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(BookModel book) async {
    if (isFavorited(book)) {
      final success = await removeFromFavorites(book);
      return !success; // If successfully removed, return false (not favorited)
    } else {
      return await addToFavorites(book);
    }
  }

  // Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      _error = null;

      await FavoritesService.clearAllFavorites();
      _favorites.clear();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to clear favorites: ${e.toString()}';
      notifyListeners();
      debugPrint('Error clearing favorites: $e');
    }
  }

  // Get favorite by book key
  FavouriteBookModel? getFavoriteByBookKey(String bookKey) {
    try {
      return _favorites.firstWhere(
        (fav) =>
            fav.bookKey == bookKey ||
            fav.bookKey == bookKey.replaceAll('/', '_'),
      );
    } catch (e) {
      return null;
    }
  }

  // Search favorites
  List<FavouriteBookModel> searchFavorites(String query) {
    if (query.isEmpty) return _favorites;

    final lowercaseQuery = query.toLowerCase();
    return _favorites
        .where(
          (fav) =>
              fav.title.toLowerCase().contains(lowercaseQuery) ||
              fav.author.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }

  // Get favorites by genre/subject
  List<FavouriteBookModel> getFavoritesBySubject(String subject) {
    return _favorites
        .where(
          (fav) =>
              fav.bookData.subjects?.any(
                (bookSubject) =>
                    bookSubject.toLowerCase().contains(subject.toLowerCase()),
              ) ??
              false,
        )
        .toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Reset provider (for logout)
  void reset() {
    _favorites.clear();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
