import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

// MyApp bây giờ là StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Container(),
    );
  }
}

