import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/BookModel.dart';
import '../Models/AuthorDetailModel.dart';

class OpenLibraryService {
  static const String baseUrl = 'https://openlibrary.org';
  static const String coversUrl = 'https://covers.openlibrary.org/b';

  // Search books by title, author, or general query
  Future<List<BookModel>> searchBooks(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final url =
          '$baseUrl/search.json?q=${Uri.encodeComponent(query)}&page=$page&limit=$limit';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final books = <BookModel>[];

        if (data['docs'] != null) {
          for (var doc in data['docs']) {
            books.add(BookModel.fromJson(doc));
          }
        }

        return books;
      } else {
        throw Exception('Failed to search books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  // Search books by author
  Future<List<BookModel>> searchBooksByAuthor(String authorName) async {
    return searchBooks('author:"$authorName"');
  }

  // Search books by title
  Future<List<BookModel>> searchBooksByTitle(String title) async {
    return searchBooks('title:"$title"');
  }

  // Search books by ISBN
  Future<List<BookModel>> searchBooksByISBN(String isbn) async {
    return searchBooks('isbn:$isbn');
  }

  // Get popular subjects/categories
  Future<List<String>> getPopularSubjects() async {
    try {
      final subjects = [
        'fiction',
        'science_fiction',
        'fantasy',
        'mystery',
        'romance',
        'thriller',
        'history',
        'biography',
        'science',
        'technology',
        'philosophy',
        'religion',
        'art',
        'music',
        'poetry',
      ];
      return subjects;
    } catch (e) {
      throw Exception('Error getting subjects: $e');
    }
  }

  // Get books by subject/category
  Future<List<BookModel>> getBooksBySubject(
    String subject, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final url =
          '$baseUrl/subjects/$subject.json?limit=$limit&offset=${(page - 1) * limit}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final books = <BookModel>[];

        if (data['works'] != null) {
          for (var work in data['works']) {
            books.add(BookModel.fromSubjectJson(work));
          }
        }

        return books;
      } else {
        throw Exception(
          'Failed to get books by subject: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error getting books by subject: $e');
    }
  }

  // Get book details by work ID
  Future<BookModel> getBookDetails(String workId) async {
    try {
      final url = '$baseUrl/works/$workId.json';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return BookModel.fromWorkJson(data);
      } else {
        throw Exception('Failed to get book details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting book details: $e');
    }
  }

  // Get author details by author ID
  Future<AuthorDetailModel> getAuthorDetails(String authorId) async {
    try {
      final url = '$baseUrl/authors/$authorId.json';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AuthorDetailModel.fromJson(data);
      } else {
        throw Exception('Failed to get author details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting author details: $e');
    }
  }

  // Get author's works
  Future<List<BookModel>> getAuthorWorks(
    String authorId, {
    int limit = 50,
  }) async {
    try {
      final url = '$baseUrl/authors/$authorId/works.json?limit=$limit';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final books = <BookModel>[];

        if (data['entries'] != null) {
          for (var entry in data['entries']) {
            books.add(BookModel.fromWorkJson(entry));
          }
        }

        return books;
      } else {
        throw Exception('Failed to get author works: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting author works: $e');
    }
  }

  // Get book cover URL by cover ID
  String getCoverUrl(int? coverId, {String size = 'M'}) {
    if (coverId == null) return '';
    return '$coversUrl/id/$coverId-$size.jpg';
  }

  // Get book cover URL by ISBN
  String getCoverUrlByISBN(String isbn, {String size = 'M'}) {
    return '$coversUrl/isbn/$isbn-$size.jpg';
  }

  // Search trending/popular books
  Future<List<BookModel>> getTrendingBooks({int limit = 20}) async {
    // OpenLibrary doesn't have a direct trending endpoint, so we'll search for popular subjects
    final popularQueries = ['bestseller', 'award winner', 'classic', 'popular'];

    final allBooks = <BookModel>[];

    for (String query in popularQueries) {
      try {
        final books = await searchBooks(
          query,
          limit: limit ~/ popularQueries.length,
        );
        allBooks.addAll(books);
      } catch (e) {
        continue; // Continue with next query if one fails
      }
    }

    return allBooks.take(limit).toList();
  }
}
