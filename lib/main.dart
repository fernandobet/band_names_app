import 'package:bands/src/pages/home_page.dart';
import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     initialRoute: HomePage.route,
     routes: {
       HomePage.route :(_)=>HomePage()
     },
    );
  }
}