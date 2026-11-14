// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:student_books/models/course_model.dart';
import 'package:student_books/services/data_loader.dart';
import 'package:student_books/widgets/subject_card.dart';

class GenericLevelPage extends StatefulWidget {
  final int level;
  final int semester;

  const GenericLevelPage({
    required this.level,
    required this.semester,
    super.key,
  });

  @override
  State<GenericLevelPage> createState() => _GenericLevelPageState();
}

class _GenericLevelPageState extends State<GenericLevelPage> {
  late Future<Semester?> _semesterFuture;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _semesterFuture =
        DataLoader.loadSemesterByLevelAndNumber(widget.level, widget.semester);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Semester?>(
      future: _semesterFuture,
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

        final semester = snapshot.data!;

        final filteredSubjects = semester.subjects.where((sub) {
          return sub.name.toLowerCase().contains(_searchQuery.toLowerCase());
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
                  semester.title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 4.0),
                Text(
                  'تفريغات الدروس',
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
                      hintText: 'ابحث عن مادة...',
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
                  child: filteredSubjects.isEmpty
                      ? Center(
                          child: Text(
                            'لا توجد مادة بهذا الاسم',
                            style: TextStyle(color: Colors.indigo),
                          ),
                        )
                      : GridView.count(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          crossAxisCount: 2,
                          children: filteredSubjects
                              .map((subject) => SubjectCard(subject: subject))
                              .toList(),
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
