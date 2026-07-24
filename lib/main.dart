import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_capitals/navbar.dart';
import 'package:flutter_capitals/notifiers.dart';

List<Widget> pages = [];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun with Flags',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(182, 133, 28, 1),
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: selectedPageNotifier,
          builder: (context, value, child) {
            return pages.elementAt(value);
          },
        ),
        bottomNavigationBar: NavBarWidget(),
      ),
    );
  }
}
