import 'package:flutter/material.dart';
import 'package:gov_qr/Pages/help_page.dart';

Widget buildAppbar({BuildContext context, String title, Color color = const Color(0xFF9791B5)}){
  return PreferredSize(
    preferredSize: Size.fromHeight(50.0),
    child: AppBar(
      title: Text(title, style: TextStyle(color: Colors.black),),
      centerTitle: true,
      backgroundColor: color,
      leading: Icon(Icons.person, color: Colors.black,),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.help,color: Colors.black,),
        ),
      ],
    ),
  );
}