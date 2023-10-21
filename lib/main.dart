import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_demo/storage/db_storage/db_storage.dart';

import 'navigation/app_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbStorage.instance.open(); // 打开数据库
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AppNavigation(),
    );
  }
}
