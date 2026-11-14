import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_books/models/course_model.dart';

class PrefsService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- Student Name ---
  static String? getStudentName() {
    return _prefs.getString('student_name');
  }

  static Future<void> setStudentName(String name) async {
    await _prefs.setString('student_name', name.trim());
  }

  // --- User Level ---
  static int? getUserLevel() {
    return _prefs.getInt('user_level');
  }

  static Future<void> setUserLevel(int level) async {
    await _prefs.setInt('user_level', level);
  }

  // --- Favorites ---
  static List<BookReference> getFavoriteBooks() {
    final List<String>? favsStr = _prefs.getStringList('favorite_books');
    if (favsStr == null) return [];

    return favsStr.map((str) {
      final Map<String, dynamic> json = jsonDecode(str);
      return BookReference.fromJson(json);
    }).toList();
  }

  static bool isFavorite(BookReference book) {
    final List<BookReference> currentFavs = getFavoriteBooks();
    return currentFavs.any((b) => b.driveId == book.driveId);
  }

  static Future<void> toggleFavoriteBook(BookReference book) async {
    final List<BookReference> currentFavs = getFavoriteBooks();
    final bool exists = currentFavs.any((b) => b.driveId == book.driveId);

    if (exists) {
      currentFavs.removeWhere((b) => b.driveId == book.driveId);
    } else {
      currentFavs.add(book);
    }

    final List<String> favsStr = currentFavs.map((b) {
      return jsonEncode({
        'name': b.name,
        'driveId': b.driveId,
        'coverImage': b.coverImage,
      });
    }).toList();

    await _prefs.setStringList('favorite_books', favsStr);
  }

  // --- Notes ---
  static List<String> getNotes() {
    return _prefs.getStringList('student_notes') ?? [];
  }

  static Future<void> saveNotes(List<String> notes) async {
    await _prefs.setStringList('student_notes', notes);
  }
}
