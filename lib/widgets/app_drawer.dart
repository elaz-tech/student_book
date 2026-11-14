import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:student_books/Pages/generic_level_page.dart';
import 'package:student_books/Pages/generic_books_page.dart';
import 'package:student_books/Pages/employment_schedule_page.dart';
import 'package:student_books/widgets/about.dart' show showAboutMe;
import 'package:student_books/services/navigation_helper.dart';
import 'package:student_books/Pages/favorites_page.dart';
import 'package:student_books/Pages/notes_page.dart';
import 'package:student_books/services/prefs_service.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _studentName = '';

  @override
  void initState() {
    super.initState();
    _studentName = PrefsService.getStudentName() ?? '';
  }

  void _showEditNameDialog() {
    final controller = TextEditingController(text: _studentName);
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Center(
            child: Text(
              'اسم الطالب(ة)',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'أدخل(ي) اسمك هنا',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  filled: true,
                  fillColor: Colors.teal.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.teal[300]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  ),
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 10.0,
                ),
              ),
              onPressed: () async {
                final newName = controller.text.trim();
                await PrefsService.setStudentName(newName);
                if (mounted) {
                  setState(() {
                    _studentName = newName;
                  });
                }
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
              },
              child: const Text(
                'حفظ',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentHeader() {
    final hasName = _studentName.isNotEmpty;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
        child: InkWell(
          onTap: _showEditNameDialog,
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 14.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.teal[400]?.withValues(alpha: 0.5) ?? Colors.teal,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.white30, width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 34.0,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 31.0,
                    backgroundColor: Colors.teal[700],
                    child: const Icon(
                      Icons.person,
                      size: 38.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        hasName ? _studentName : 'إضافة اسم الطالب(ة)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: hasName ? 18.0 : 15.0,
                          fontWeight: FontWeight.bold,
                          color: hasName ? Colors.white : Colors.amberAccent,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    const Icon(
                      Icons.edit,
                      size: 16.0,
                      color: Colors.white70,
                    ),
                  ],
                ),
                if (!hasName) ...[
                  const SizedBox(height: 4.0),
                  const Text(
                    'اضغط(ي) هنا لحفظ اسمك',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.teal[300],
      width: 270.0,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildStudentHeader(),
              const SizedBox(height: 8.0),
              const Divider(
                color: Colors.white24,
                thickness: 1,
                indent: 24,
                endIndent: 24,
              ),
              const SizedBox(height: 8.0),
              levelTile('الفرقة الأولى', 1, context),
              levelTile('الفرقة الثانية', 2, context),
              levelTile('الفرقة الثالثة', 3, context),
              levelTile('الفرقة الرابعة', 4, context),
              const SizedBox(height: 20.0),
              _DrawerButton(
                label: 'مفضلتي',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoritesPage()),
                  );
                },
              ),
              const SizedBox(height: 12.0),
              _DrawerButton(
                label: 'مفكرتي',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotesPage()),
                  );
                },
              ),
              const SizedBox(height: 12.0),
              _DrawerButton(
                label: 'ادعمنا',
                onPressed: () => NavigationHelper.launchPaymentLink(context),
              ),
              const SizedBox(height: 12.0),
              _DrawerButton(
                label: 'شارك التطبيق',
                onPressed: () => _shareApp(),
              ),
              const SizedBox(height: 12.0),
              _DrawerButton(
                label: 'حول التطبيق',
                onPressed: () => _showAboutDialog(context),
              ),
              const SizedBox(height: 12.0),
              _DrawerButton(
                label: 'الخروج',
                onPressed: () => SystemNavigator.pop(),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  void _shareApp() {
    const playStoreUrl =
        'https://play.google.com/store/apps/details?id=com.eafmicroservice.student_books';
    const message = 'حمل تطبيق كتاب الطالب من متجر جوجل بلاي:\n\n'
        'تطبيق يحتوي على كل ما يحتاجه الطالب في جامعة صفوة من كتب لتعلم\n\n'
        '⬇️ حمّل التطبيق الآن مجاناً:\n$playStoreUrl';

    SharePlus.instance.share(
      ShareParams(subject: 'شارك تطبيق كتاب الطالب', text: message),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutMe(
      context,
      "assets/icon/icon.png",
      'كتاب الطالب',
      'تطبيق يحتوي على كل ما يحتاجه الطالب في جامعة صفوة من كتب لتعلم',
    );
  }

  Widget levelTile(String level, int levelNum, BuildContext context) {
    return ExpansionTile(
      collapsedIconColor: Colors.white70,
      iconColor: Colors.lightGreenAccent,
      title: Center(
        child: Text(
          level,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.lightGreenAccent,
          ),
        ),
      ),
      children: [
        _DrawerMenuItem(
          label: 'استعمال الزمن للحصص',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmploymentSchedulePage(level: levelNum),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        _DrawerMenuItem(
          label: 'الكتب المرجعية',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GenericBooksPage(level: levelNum),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        _DrawerMenuItem(
          label: 'تفريغات الفصل الأول',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  GenericLevelPage(level: levelNum, semester: 1),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        _DrawerMenuItem(
          label: 'تفريغات الفصل الثاني',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  GenericLevelPage(level: levelNum, semester: 2),
            ),
          ),
        ),
        const SizedBox(height: 6.0),
      ],
    );
  }
}

class _DrawerButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _DrawerButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.lightGreenAccent,
          ),
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _DrawerMenuItem({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}
