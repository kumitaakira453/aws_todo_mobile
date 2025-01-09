import 'package:aws_todo_mobile/pages/home.dart';
import 'package:aws_todo_mobile/pages/todo_add.dart';
import 'package:aws_todo_mobile/pages/todo_detail.dart';
import 'package:aws_todo_mobile/utils/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setupLogging();
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 50, 164, 54),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // localeに英語と日本語を登録する
      supportedLocales: const [
        Locale("en"),
        Locale("ja"),
      ],

      // アプリのlocaleを日本語に変更する
      locale: const Locale('ja'),

      initialRoute: "/home",
      routes: {
        '/home': (context) => const HomePage(),
        '/detail': (context) => const TodoDetailPage(),
        '/add': (context) => const TodoAddPage(),
      },
    );
  }
}
