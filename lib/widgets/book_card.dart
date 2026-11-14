// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:student_books/models/course_model.dart';
import 'package:student_books/services/navigation_helper.dart';
import 'package:student_books/services/prefs_service.dart';

class BookCard extends StatefulWidget {
  final BookReference book;

  const BookCard({
    required this.book,
    super.key,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    isFav = PrefsService.isFavorite(widget.book);
  }

  void toggleFav() async {
    await PrefsService.toggleFavoriteBook(widget.book);
    setState(() {
      isFav = PrefsService.isFavorite(widget.book);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: () => NavigationHelper.navigateToBook(
          context,
          widget.book.name,
          widget.book.driveId,
        ),
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            color: Colors.white,
            height: 180.0,
            child: Row(
              children: [
                SizedBox(width: 8.0),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[100],
                    child: Image.asset(
                      widget.book.coverImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.name,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => NavigationHelper.navigateToBook(
                                context,
                                widget.book.name,
                                widget.book.driveId,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[200],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                              ),
                              child: Text(
                                'فتح الكتاب',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: toggleFav,
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
