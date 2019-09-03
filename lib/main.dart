import 'package:flutter/material.dart';
import 'package:gov_qr/Pages/login_page.dart';
import 'package:gov_qr/Pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:gov_qr/Pages/report_issue_page.dart';
import 'package:gov_qr/Pages/success_page.dart';
import 'package:gov_qr/Pages/failure_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      routes: {
        '/login': (context) => LoginPage()
      },
      theme: ThemeData(
        unselectedWidgetColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      title: 'QR3CMS',
      home: LoginPage(),
    );
  }
}
