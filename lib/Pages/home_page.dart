// ignore_for_file: unnecessary_new, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:student_books/Pages/hors_connexion.dart';
import 'package:student_books/widgets/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:student_books/widgets/banner_ad_widget.dart';
import 'package:student_books/services/prefs_service.dart';
import 'package:student_books/Pages/generic_books_page.dart';
import 'package:student_books/Pages/employment_schedule_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//=================================Variables====================================
  StreamSubscription? connection;
  bool isoffline = false;
//==============================================================================

  Future conx() async {
    connection = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      final result = results.isEmpty ? ConnectivityResult.none : results.first;
      setState(() {
        isoffline = result == ConnectivityResult.none;
      });
    });
    return isoffline;
  }

  @override
  void initState() {
    super.initState();
    conx();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserLevel();
    });
  }

  void _checkUserLevel() {
    if (PrefsService.getUserLevel() == null) {
      _showLevelSelectionDialog();
    }
  }

  void _showLevelSelectionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('اختر فرقتك الدراسية'),
            content:
                Text('قم باختيار فرقتك لتخصيص التطبيق وعرض كتبك وجدولك بسرعة.'),
            actions: [
              for (int i = 1; i <= 4; i++)
                Builder(
                  builder: (dialogCtx) => TextButton(
                    onPressed: () {
                      Navigator.pop(dialogCtx);
                      PrefsService.setUserLevel(i).then((_) {
                        if (mounted) setState(() {});
                      });
                    },
                    child: Text('الفرقة ${[
                      'الأولى',
                      'الثانية',
                      'الثالثة',
                      'الرابعة'
                    ][i - 1]}'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    connection?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      bottomNavigationBar: isoffline == false
          ? const BannerAdWidget()
          : Visibility(
              visible: false,
              child: Text('Not connected to any network'),
            ),
      endDrawer: isoffline == false
          ? const AppDrawer()
          : SizedBox(
              width: 200.0,
              child: HorsConnexion(),
            ),
      appBar: AppBar(
        backgroundColor: Colors.teal[200],
        elevation: 10.0,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'كلية العلوم الشرعية والعربية',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 4.0),
            Text(
              'الموارد التعليمية',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15.0,
            ),
            Text(
              'الكتب المرجعية وتفريغات الدروس لجميع الفرق',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.indigoAccent,
              ),
            ),
            SizedBox(
              height: 300.0,
              width: double.infinity,
              child: Image.asset('assets/images/image.jpg'),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            if (PrefsService.getUserLevel() != null)
              Column(
                children: [
                  Text(
                    'الوصول السريع لفرقتك',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenericBooksPage(
                                  level: PrefsService.getUserLevel()!),
                            ),
                          );
                        },
                        icon: Icon(Icons.book, color: Colors.white),
                        label:
                            Text('كتبي', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                      ),
                      SizedBox(width: 10.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmploymentSchedulePage(
                                  level: PrefsService.getUserLevel()!),
                            ),
                          );
                        },
                        icon: Icon(Icons.schedule, color: Colors.white),
                        label: Text('جدولي',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextButton.icon(
                    onPressed: _showLevelSelectionDialog,
                    icon: Icon(Icons.edit, color: Colors.indigo),
                    label: Text('تغيير الفرقة الدراسية',
                        style: TextStyle(color: Colors.indigo, fontSize: 16)),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                ],
              ),
            Center(
                child: Directionality(
              textDirection: TextDirection.rtl,
              child: RichText(
                text: new TextSpan(
                  children: [
                    new TextSpan(
                      text: 'القناة الرسمية للكلية, على ',
                      style: new TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    new TextSpan(
                      text: 'انستغرام',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(Uri.parse('https://t.me/fosaas2'));
                        },
                    ),
                  ],
                ),
              ),
            )),
            Padding(padding: EdgeInsets.only(top: 100.0)),
            Text(
              'لا تنسونا من صلاح دعائكم \n ولكل من ساهم في هذا العمل',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.0,
            ),
            Icon(
              Icons.back_hand_outlined, //
              color: Colors.green,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
