import 'package:flutter/material.dart';

Widget info(){
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('GATE ID : XXXXXXXXXXXXX',style: TextStyle(fontSize: 20.0),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Registered number : XXXXXXXXXX',style: TextStyle(fontSize: 20.0),),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: (){},
                color: Color(0xFF571845),
                child: Text('Update'),
                textColor: Colors.white,
              ),
              RaisedButton(
                onPressed: (){},
                color: Color(0xFF571845),
                child: Text('Log Out'),
                textColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}