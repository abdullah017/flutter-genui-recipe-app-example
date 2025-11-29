import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:genui/genui.dart';
import 'package:recipe_genui_app_example/screens/chat_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // GenUI logging'i aktif et (debug için)
  final logger = configureGenUiLogging(level: Level.ALL);
  logger.onRecord.listen((record) {
    debugPrint('${record.loggerName}: ${record.message}');
  });

  runApp(const RecipeGenUIApp());
}

class RecipeGenUIApp extends StatelessWidget {
  const RecipeGenUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Tarif Asistanı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const ChatScreen(),
    );
  }
}
