class AppEnvironment {
  // OpenLibrary API Configuration
  static const String openLibraryBaseUrl = "https://openlibrary.org";
  static const String openLibrarySearchUrl =
      "https://openlibrary.org/search.json";
  static const String openLibrarySubjectsUrl =
      "https://openlibrary.org/subjects";
  static const String openLibraryTrendingUrl =
      "https://openlibrary.org/trending";
  static const String openLibraryCoversUrl = "https://covers.openlibrary.org/b";
  static const String openLibraryAuthorUrl = "https://openlibrary.org/authors";
  static const String openLibraryWorksUrl = "https://openlibrary.org/works";
  static const String openLibraryBooksUrl = "https://openlibrary.org/books";

  // API Endpoints
  static const String searchEndpoint = "/search.json";
  static const String subjectsEndpoint = "/subjects";
  static const String authorsEndpoint = "/authors";
  static const String worksEndpoint = "/works";
  static const String booksEndpoint = "/books";
  static const String trendingEndpoint = "/trending";

  // Cover Image Sizes
  static const String coverSizeSmall = "S"; // 90px width
  static const String coverSizeMedium = "M"; // 180px width
  static const String coverSizeLarge = "L"; // 360px width

  // API Parameters
  static const int defaultPageSize = 20;
  static const int maxRetries = 3;
  static const int timeoutSeconds = 10;
  static const int cacheExpiryHours = 2;

  // Popular Subjects (most commonly searched categories)
  static const List<String> popularSubjects = [
    "fiction",
    "non_fiction",
    "science",
    "history",
    "technology",
    "business",
    "romance",
    "mystery",
    "fantasy",
    "biography",
    "philosophy",
    "psychology",
    "art",
    "music",
    "sports",
    "health",
    "cooking",
    "travel",
    "religion",
    "education",
    "children",
    "young_adult",
    "horror",
    "thriller",
    "adventure",
  ];

  // Default Authors (fallback when API fails)
  static const List<String> defaultAuthors = [
    "J.K. Rowling",
    "George R.R. Martin",
    "Jane Austen",
    "Charles Dickens",
    "Mark Twain",
    "Agatha Christie",
    "Ernest Hemingway",
    "J.R.R. Tolkien",
    "Leo Tolstoy",
    "Stephen King",
    "William Shakespeare",
    "Harper Lee",
    "F. Scott Fitzgerald",
    "George Orwell",
    "Virginia Woolf",
  ];

  // Error Messages
  static const String networkError = "Network connection failed";
  static const String serverError = "Server error occurred";
  static const String timeoutError = "Request timeout";
  static const String parseError = "Failed to parse response";
  static const String notFoundError = "Resource not found";

  // Debug Settings
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
  static const bool enableCaching = true;

  // App Version
  static const String appVersion = "1.0.0";
  static const String apiVersion = "v1";

  // Firebase Configuration (if needed)
  static const String firebaseProjectId = "openlibrary-book-explorer";

  // Local Storage Keys
  static const String userPreferencesKey = "user_preferences";
  static const String favoriteBooksKey = "favorite_books";
  static const String readingListKey = "reading_list";
  static const String searchHistoryKey = "search_history";
  static const String themePreferenceKey = "theme_preference";

  // Pagination
  static const int defaultOffset = 0;
  static const int maxBooksPerPage = 100;
  static const int minBooksPerPage = 10;

  // Search Configuration
  static const int minSearchLength = 2;
  static const int maxSearchLength = 100;
  static const int searchDebounceMs = 500;

  // Image Configuration
  static const String defaultBookCover = "assets/images/default_book_cover.png";
  static const String defaultAuthorAvatar = "assets/images/default_author.png";
  static const double coverAspectRatio = 0.67; // width/height

  // UI Configuration
  static const double defaultBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;
  static const double defaultElevation = 4.0;
}
