import 'package:flutter/material.dart';
import 'package:gov_qr/Pages/home_page.dart';

import '../Models/User.dart';
import 'package:gov_qr/Widgets/appbar_widget.dart';

//-------------------------------------
//Add user while navigating to Homepage
//--------------------------------------

class SuccessPage extends StatelessWidget {

  User user;

  SuccessPage ({this.user});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppbar(title: 'Success', context: context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF49327B), Color(0xFFCB4440)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.asset('assets/images/empty_qr.png',height: 200.0,width: 200.0,),
                    Image.asset('assets/images/success.jpg',height: 200.0,width: 200.0,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RaisedButton(
                    color: Color(0xFFFF5733),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(
                          context,'/login',ModalRoute.withName('/fake'));
                    },
                    padding: EdgeInsets.all(10.0),
                    child: Text('Home',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                    textColor: Colors.white,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
