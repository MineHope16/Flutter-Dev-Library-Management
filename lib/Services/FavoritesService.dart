import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/FavouriteBookModel.dart';
import '../Models/BookModel.dart';

class FavoritesService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _collection = 'user_favorites';

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Add book to favorites
  static Future<void> addToFavorites(BookModel book) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final favorite = FavouriteBookModel.fromBook(book, currentUserId!);

    await _firestore
        .collection(_collection)
        .doc(favorite.id)
        .set(favorite.toFirestore());
  }

  // Remove book from favorites
  static Future<void> removeFromFavorites(String bookKey) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final favoriteId = '${currentUserId!}_${bookKey.replaceAll('/', '_')}';

    await _firestore.collection(_collection).doc(favoriteId).delete();
  }

  // Check if book is favorited
  static Future<bool> isFavorited(String bookKey) async {
    if (currentUserId == null) return false;

    final favoriteId = '${currentUserId!}_${bookKey.replaceAll('/', '_')}';

    final doc = await _firestore.collection(_collection).doc(favoriteId).get();

    return doc.exists;
  }

  // Get all user favorites
  static Future<List<FavouriteBookModel>> getUserFavorites() async {
    if (currentUserId == null) return [];

    final querySnapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: currentUserId)
        .get();

    // Sort manually by addedAt in Dart to avoid index requirement
    final favorites = querySnapshot.docs
        .map((doc) => FavouriteBookModel.fromFirestore(doc))
        .toList();

    // Sort by addedAt in descending order (newest first)
    favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));

    return favorites;
  }

  // Stream of user favorites for real-time updates
  static Stream<List<FavouriteBookModel>> getUserFavoritesStream() {
    if (currentUserId == null) return Stream.value([]);

    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          // Convert documents to models and sort manually
          final favorites = snapshot.docs
              .map((doc) => FavouriteBookModel.fromFirestore(doc))
              .toList();

          // Sort by addedAt in descending order (newest first)
          favorites.sort((a, b) => b.addedAt.compareTo(a.addedAt));

          return favorites;
        });
  }

  // Get favorites count for user
  static Future<int> getFavoritesCount() async {
    if (currentUserId == null) return 0;

    final querySnapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: currentUserId)
        .get();

    return querySnapshot.docs.length;
  }

  // Toggle favorite status
  static Future<bool> toggleFavorite(BookModel book) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final bookKey = book.key ?? book.title?.replaceAll(' ', '_') ?? '';
    final isCurrentlyFavorited = await isFavorited(bookKey);

    if (isCurrentlyFavorited) {
      await removeFromFavorites(bookKey);
      return false; // Now unfavorited
    } else {
      await addToFavorites(book);
      return true; // Now favorited
    }
  }

  // Batch operations for multiple books
  static Future<void> addMultipleToFavorites(List<BookModel> books) async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final batch = _firestore.batch();

    for (final book in books) {
      final favorite = FavouriteBookModel.fromBook(book, currentUserId!);
      final docRef = _firestore.collection(_collection).doc(favorite.id);
      batch.set(docRef, favorite.toFirestore());
    }

    await batch.commit();
  }

  // Clear all favorites for user
  static Future<void> clearAllFavorites() async {
    if (currentUserId == null) throw Exception('User not authenticated');

    final querySnapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: currentUserId)
        .get();

    final batch = _firestore.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }
}
