import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tddcourse/features/number_trivia/presentation/pages/number_trivia_page.dart';

import 'injection_container.dart' as di;
import 'injection_container.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Number trivia",
      theme: ThemeData(
          primaryColor: Colors.green.shade800,
          accentColor: Colors.green.shade600),
      home: NumberTriviaPage(),
    );
  }
}

class TestClass {
  String print() {
    return "Ahmed shaban";
  }
}
