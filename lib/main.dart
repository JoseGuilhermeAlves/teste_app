import 'package:flutter/material.dart';
import 'package:voalis_teste/core/constants/colors.dart';
import 'package:voalis_teste/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cluster Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackground,
      ),
      home: const HomePage(),
    );
  }
}
