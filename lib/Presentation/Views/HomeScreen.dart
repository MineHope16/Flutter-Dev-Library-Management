import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openlibrary_book_explorer/Providers/ChangeModeProvider.dart';
import 'package:openlibrary_book_explorer/Providers/AuthenticationProvider.dart';
import 'package:openlibrary_book_explorer/Configuration/Routes.dart';
import 'package:openlibrary_book_explorer/Models/AuthorsModel.dart';
import 'package:openlibrary_book_explorer/Models/CategoriesModel.dart';
import 'package:openlibrary_book_explorer/Models/BookModel.dart';
import 'package:openlibrary_book_explorer/Services/OpenLibraryService.dart';
import 'package:openlibrary_book_explorer/Presentation/Elements/CustomContainer.dart';
import 'package:provider/provider.dart';

import '../../Models/FavouriteBookModel.dart';
import '../Elements/CustomText.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final OpenLibraryService _apiService = OpenLibraryService();

  List<BookModel> _featuredBooks = [];
  List<String> _popularCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    try {
      // Load featured books and categories in parallel
      final results = await Future.wait([
        _apiService.getTrendingBooks(limit: 10),
        _apiService.getPopularSubjects(),
      ]);

      setState(() {
        _featuredBooks = results[0] as List<BookModel>;
        _popularCategories = (results[1] as List<String>).take(8).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Fallback to empty lists - app will still work
    }
  }

  List<CategoriesModel> categoriesModel = [
    CategoriesModel(name: "Fiction"),
    CategoriesModel(name: "Non-Fiction"),
    CategoriesModel(name: "Science"),
    CategoriesModel(name: "History"),
    CategoriesModel(name: "Technology"),
    CategoriesModel(name: "Kids"),
    CategoriesModel(name: "Businesses"),
  ];

  List<AuthorsModel> authorsModel = [
    AuthorsModel(name: "J.K. Rowling"),
    AuthorsModel(name: "George R.R. Martin"),
    AuthorsModel(name: "Jane Austen"),
    AuthorsModel(name: "Charles Dickens"),
    AuthorsModel(name: "Mark Twain"),
    AuthorsModel(name: "Agatha Christie"),
    AuthorsModel(name: "Ernest Hemingway"),
    AuthorsModel(name: "J.R.R. Tolkien"),
    AuthorsModel(name: "Leo Tolstoy"),
    AuthorsModel(name: "Stephen King"),
  ];

  List<FavouriteBookModel> favouriteBookModel = [
    FavouriteBookModel(name: "Fiction"),
    FavouriteBookModel(name: "Non-Fiction"),
    FavouriteBookModel(name: "Science"),
    FavouriteBookModel(name: "History"),
    FavouriteBookModel(name: "Technology"),
    FavouriteBookModel(name: "Kids"),
    FavouriteBookModel(name: "Businesses"),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        elevation: 0, // remove shadow
        leading: MyIconContainer(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icons.menu,
          iconSize: 30,
          iconColor: Colors.white70,
        ),
        title: MyText(
          text: "OpenLibrary Book Explorer",
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          size: 22,
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          child: MyContainer(
            decoration: BoxDecoration(gradient: themeProvider.backgroundColor),
            child: Column(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      MyContainer(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/background.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Consumer<AuthenticationProvider>(
                        builder: (context, authProvider, child) {
                          final user = FirebaseAuth.instance.currentUser;
                          return Column(
                            children: [
                              MyText(
                                text: user?.displayName ?? "OpenLibrary User",
                                size: 16,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.primaryTextColor,
                              ),
                              MyText(
                                text: user?.email ?? "user@example.com",
                                size: 12,
                                color: themeProvider.primaryTextColor,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.library_books,
                    color: themeProvider.primaryTextColor,
                  ),
                  title: MyText(
                    text: "Categories",
                    color: themeProvider.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.categories);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_outlined,
                    color: themeProvider.primaryTextColor,
                  ),
                  title: MyText(
                    text: "Authors",
                    color: themeProvider.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.authors);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.favorite_outline,
                    color: themeProvider.primaryTextColor,
                  ),
                  title: MyText(
                    text: "Favorites",
                    color: themeProvider.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Favorites feature coming soon!")),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: themeProvider.primaryTextColor,
                  ),
                  title: MyText(
                    text: "Profile",
                    color: themeProvider.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.profile);
                  },
                ),
                ListTile(
                  leading: Icon(
                    themeProvider.isNightMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: themeProvider.primaryTextColor,
                  ),
                  title: MyText(
                    text: themeProvider.isNightMode
                        ? "Dark Mode"
                        : "Light Mode",
                    color: themeProvider.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: MyText(
                    text: "Logout",
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  onTap: () async {
                    final authProvider = Provider.of<AuthenticationProvider>(
                      context,
                      listen: false,
                    );
                    Navigator.pop(context);

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red, size: 28),
                              const SizedBox(width: 10),
                              const Text(
                                "Logout",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          content: const Text(
                            "Are you sure you want to logout from your account?",
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await authProvider.logout();
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.login,
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Logout"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "assets/images/background.jpg",
                fit: BoxFit.cover,
              ),
            ),
            MyContainer(
              color: Colors.black.withOpacity(0.6),
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.search);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey[600]),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "Search books, authors, ISBN...",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Popular Categories Section
                    _buildSectionHeader("Popular Categories", () {
                      Navigator.pushNamed(context, AppRoutes.categories);
                    }),

                    const SizedBox(height: 15),

                    _isLoading
                        ? _buildLoadingIndicator()
                        : _buildCategoriesGrid(),

                    const SizedBox(height: 40),

                    // Featured Books Section
                    _buildSectionHeader("Featured Books", () {
                      Navigator.pushNamed(context, AppRoutes.search);
                    }),

                    const SizedBox(height: 15),

                    _isLoading
                        ? _buildLoadingIndicator()
                        : _buildFeaturedBooksCarousel(),

                    const SizedBox(height: 40),

                    // Quick Actions Section
                    _buildSectionHeader("Quick Actions", null),

                    const SizedBox(height: 15),

                    _buildQuickActionsGrid(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MyText(
            text: title,
            size: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: MyText(
                text: "See All",
                color: Colors.blue,
                size: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = _popularCategories.isNotEmpty
        ? _popularCategories
        : [
            'Fiction',
            'Science',
            'History',
            'Technology',
            'Art',
            'Philosophy',
            'Religion',
            'Biography',
          ];

    return Container(
      height: 120,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final displayName = category
              .replaceAll('_', ' ')
              .split(' ')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' ');

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.search,
                  arguments: category,
                );
              },
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.8),
                      Colors.purple.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      color: Colors.white,
                      size: 30,
                    ),
                    SizedBox(height: 8),
                    Text(
                      displayName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedBooksCarousel() {
    if (_featuredBooks.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: MyText(
            text: "No featured books available",
            color: Colors.white70,
            size: 16,
          ),
        ),
      );
    }

    return Container(
      height: 200,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15),
        scrollDirection: Axis.horizontal,
        itemCount: _featuredBooks.length,
        itemBuilder: (context, index) {
          final book = _featuredBooks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                // Navigate to book details or search for this book
                Navigator.pushNamed(
                  context,
                  AppRoutes.search,
                  arguments: book.displayTitle,
                );
              },
              child: Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Book Cover
                    Container(
                      height: 120,
                      width: 80,
                      margin: EdgeInsets.all(10),
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
                                  return _buildBookPlaceholder();
                                },
                              ),
                            )
                          : _buildBookPlaceholder(),
                    ),
                    // Book Title
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Text(
                              book.displayTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              book.displayAuthor,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    final quickActions = [
      {
        'title': 'Browse Categories',
        'icon': Icons.category_outlined,
        'color': Colors.orange,
        'route': AppRoutes.categories,
      },
      {
        'title': 'Famous Authors',
        'icon': Icons.person_outline,
        'color': Colors.green,
        'route': AppRoutes.authors,
      },
      {
        'title': 'My Profile',
        'icon': Icons.account_circle_outlined,
        'color': Colors.purple,
        'route': AppRoutes.profile,
      },
      {
        'title': 'Search Books',
        'icon': Icons.search,
        'color': Colors.blue,
        'route': AppRoutes.search,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.2,
        ),
        itemCount: quickActions.length,
        itemBuilder: (context, index) {
          final action = quickActions[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, action['route'] as String);
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (action['color'] as Color).withOpacity(0.7),
                    (action['color'] as Color).withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    action['icon'] as IconData,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 12),
                  Text(
                    action['title'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[400],
      ),
      child: Icon(Icons.book, color: Colors.grey[600], size: 30),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fiction':
        return Icons.auto_stories;
      case 'science':
        return Icons.science;
      case 'history':
        return Icons.history_edu;
      case 'technology':
        return Icons.computer;
      case 'art':
        return Icons.palette;
      case 'philosophy':
        return Icons.psychology;
      case 'religion':
        return Icons.church;
      case 'biography':
        return Icons.person;
      default:
        return Icons.book;
    }
  }
}
