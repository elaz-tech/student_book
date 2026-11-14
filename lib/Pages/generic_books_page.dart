// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:student_books/models/course_model.dart';
import 'package:student_books/services/data_loader.dart';
import 'package:student_books/widgets/book_card.dart';

class GenericBooksPage extends StatefulWidget {
  final int level;

  const GenericBooksPage({
    required this.level,
    super.key,
  });

  @override
  State<GenericBooksPage> createState() => _GenericBooksPageState();
}

class _GenericBooksPageState extends State<GenericBooksPage> {
  late Future<Course?> _courseFuture;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _courseFuture = DataLoader.loadCourseByLevel(widget.level);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Course?>(
      future: _courseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.teal[100],
            appBar: AppBar(
              backgroundColor: Colors.teal[200],
              title: Text('جاري التحميل...'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            backgroundColor: Colors.teal[100],
            appBar: AppBar(
              backgroundColor: Colors.teal[200],
              title: Text('خطأ'),
            ),
            body: Center(child: Text('فشل تحميل البيانات')),
          );
        }

        final course = snapshot.data!;
        final levelName = course.levelNameAr;

        final filteredBooks = course.referenceBooks.where((book) {
          return book.name.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

        return Scaffold(
          backgroundColor: Colors.teal[100],
          appBar: AppBar(
            backgroundColor: Colors.teal[200],
            elevation: 10.0,
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'الكتب المرجعية',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 4.0),
                Text(
                  levelName,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.indigo[300],
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'ابحث عن كتاب...',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredBooks.isEmpty
                      ? Center(
                          child: Text(
                            'لا يوجد كتاب بهذا الاسم',
                            style: TextStyle(color: Colors.indigo),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            return BookCard(book: filteredBooks[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
