import 'package:cloud_firestore/cloud_firestore.dart';
import 'BookModel.dart';

class FavouriteBookModel {
  final String id;
  final String userId;
  final String bookKey;
  final String title;
  final String author;
  final String? coverUrl;
  final int? coverId;
  final String? firstPublishYear;
  final DateTime addedAt;
  final BookModel bookData;

  FavouriteBookModel({
    required this.id,
    required this.userId,
    required this.bookKey,
    required this.title,
    required this.author,
    this.coverUrl,
    this.coverId,
    this.firstPublishYear,
    required this.addedAt,
    required this.bookData,
  });

  // Create from BookModel
  factory FavouriteBookModel.fromBook(BookModel book, String userId) {
    return FavouriteBookModel(
      id: '${userId}_${book.key?.replaceAll('/', '_') ?? book.title?.replaceAll(' ', '_') ?? DateTime.now().millisecondsSinceEpoch.toString()}',
      userId: userId,
      bookKey: book.key ?? '',
      title: book.displayTitle,
      author: book.authorNames,
      coverId: book.coverId,
      firstPublishYear: book.firstPublishYear,
      addedAt: DateTime.now(),
      bookData: book,
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'bookKey': bookKey,
      'title': title,
      'author': author,
      'coverId': coverId,
      'firstPublishYear': firstPublishYear,
      'addedAt': Timestamp.fromDate(addedAt),
      'bookData': {
        'key': bookData.key,
        'title': bookData.title,
        'authors': bookData.authors,
        'authorKeys': bookData.authorKeys,
        'firstPublishYear': bookData.firstPublishYear,
        'isbn': bookData.isbn,
        'coverId': bookData.coverId,
        'description': bookData.description,
        'subjects': bookData.subjects,
        'averageRating': bookData.averageRating,
        'ratingsCount': bookData.ratingsCount,
        'language': bookData.language,
        'pageCount': bookData.pageCount,
      },
    };
  }

  // Create from Firestore document
  factory FavouriteBookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final bookData = data['bookData'] as Map<String, dynamic>;

    return FavouriteBookModel(
      id: data['id'] ?? doc.id,
      userId: data['userId'] ?? '',
      bookKey: data['bookKey'] ?? '',
      title: data['title'] ?? 'Unknown Title',
      author: data['author'] ?? 'Unknown Author',
      coverId: data['coverId'],
      firstPublishYear: data['firstPublishYear'],
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      bookData: BookModel(
        key: bookData['key'],
        title: bookData['title'],
        authors: List<String>.from(bookData['authors'] ?? []),
        authorKeys: List<String>.from(bookData['authorKeys'] ?? []),
        firstPublishYear: bookData['firstPublishYear'],
        isbn: List<String>.from(bookData['isbn'] ?? []),
        coverId: bookData['coverId'],
        description: bookData['description'],
        subjects: List<String>.from(bookData['subjects'] ?? []),
        averageRating: bookData['averageRating']?.toDouble(),
        ratingsCount: bookData['ratingsCount'],
        language: bookData['language'],
        pageCount: bookData['pageCount'],
      ),
    );
  }

  @override
  String toString() {
    return 'FavouriteBookModel(title: $title, author: $author, addedAt: $addedAt)';
  }
}
