import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_movie/pages/main_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.openBox('movies');
  await Hive.openBox('ai');

  await dotenv.load();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent, // removes tap highlight
        splashColor: Colors.transparent,    // removes ripple splash
        primaryColor: Colors.deepOrange[200], // Main app color
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF222222), // affects progress indicator, buttons, etc.
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Color(0xFF222222)// For CircularProgressIndicator
        ),
      ), 
    );
  }
}
