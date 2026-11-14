import 'package:flutter/material.dart';
import 'package:student_books/models/course_model.dart';
import 'package:student_books/services/prefs_service.dart';
import 'package:student_books/widgets/book_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<BookReference> favoriteBooks = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      favoriteBooks = PrefsService.getFavoriteBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        elevation: 10.0,
        centerTitle: true,
        title: Text(
          'مفضلتي',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: favoriteBooks.isEmpty
            ? Center(
                child: Text(
                  'لا توجد كتب في المفضلة حالياً.',
                  style: TextStyle(fontSize: 18, color: Colors.indigo),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: favoriteBooks.length,
                itemBuilder: (context, index) {
                  return BookCard(book: favoriteBooks[index]);
                },
              ),
      ),
    );
  }
}
