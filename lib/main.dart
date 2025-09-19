import 'package:flutter/material.dart';
import 'package:voalis_teste/core/constants/colors.dart';
import 'package:voalis_teste/presentation/pages/circles_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBackground,
        body: const SafeArea(
          child: CirclesPage(),
        ),
      ),
    );
  }
}
