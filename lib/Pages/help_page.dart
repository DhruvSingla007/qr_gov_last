import 'package:flutter/material.dart';
import 'package:gov_qr/Widgets/info_widget.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {

  bool _visibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        centerTitle: true,
        backgroundColor: Color(0xFF571845),
        actions: <Widget>[
          IconButton(
            tooltip: 'User Info',
            onPressed: (){
              if(_visibility){
                setState(() {
                  _visibility = false;
                });
              } else {
                setState(() {
                  _visibility = true;
                });
              }
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          Visibility(
            visible: _visibility,
            child: info(),
          ),

          Expanded(
            child: Container(
              child: Center(
                child: Text('Please contact .....'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
