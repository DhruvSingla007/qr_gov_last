import 'package:flutter/material.dart';
import 'package:gov_qr/Widgets/appbar_widget.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Models/QRDetails.dart';
import '../Models/User.dart';
import '../Networking/post_api.dart';
import '../global.dart';
import 'home_page.dart';

class ActionPage extends StatefulWidget {
  QRDetails qrDetails;
  User user;

  ActionPage({this.qrDetails, this.user});

  @override
  _ActionPageState createState() => _ActionPageState(qrDetails, user);
}

class _ActionPageState extends State<ActionPage> {

  User _user;
  QRDetails _qrDetails;
  int _truckStatus;
  TextEditingController remarksController = new TextEditingController();
  bool isLoading = true;

  _ActionPageState(QRDetails qrDetails, User user) {
    _qrDetails = qrDetails;
    _user = user;
  }

  static List<String> _actions;

  static Map<String, dynamic> _mappedActions;
  String _selectedAction;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getActions();
    _truckStatus = 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppbar(
            title: "Action", context: context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF49327B), Color(0xFFCB4440)],
            ),
          ),
          child: isLoading ? Center(child: new CircularProgressIndicator(),) : ListView(
            children: <Widget>[

              SizedBox(height: 20.0,),

          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  new Radio(
                    activeColor: Colors.white,
                    value: 0,
                    groupValue: _truckStatus,
                    onChanged: (val) {
                      setState(() {
                        _truckStatus = val;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _truckStatus = 0;
                        });
                      },
                      child: new Text(
                        'Vehicle not allowed to pass',
                        style: new TextStyle(fontSize: 16.0,color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Radio(
                    activeColor: Colors.white,
                    value: 1,
                    groupValue: _truckStatus,
                    onChanged: (val) {
                      setState(() {
                        _truckStatus = val;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          _truckStatus = 1;
                        });
                      },
                      child: new Text(
                        'Vehicle allowed to pass',
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),



            ],
          ),
              SizedBox(height: 20.0,),


              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Text(
                  'Reason for Action taken', style: TextStyle(fontSize: 20.0, color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0, left: 16.0, right: 16.0),
                child: Theme(
                  data: Theme.of(context).copyWith(canvasColor: Colors.black),
                  child: DropdownButton(
                    iconEnabledColor: Colors.white,
                    value: _selectedAction,
                    style: TextStyle(color: Colors.white),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedAction = newValue;
                      });
                    },
                    items: _actions.map((location) {
                      return DropdownMenuItem(
                        child: new Text(location,style: TextStyle(color: Colors.white, fontSize: 15.0, ),),
                        value: location,
                      );
                    }).toList(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                child: TextFormField(
                  controller: remarksController,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Remarks';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.white)
                      ),
                      hintText: 'Enter Remarks',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                      labelText: 'Enter Remarks',
                    errorStyle: TextStyle(color: Colors.yellowAccent),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  color: Color(0xFFFF5733),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  onPressed: () {
                    _handleOnPressed();
                  },
                  padding: EdgeInsets.all(10.0),
                  child: Text('Submit',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                  textColor: Colors.white,
                ),
              ),
      ],),
        )),
    );
  }

  void getActions() {
    setState(() {
      isLoading = true;
    });
    List<String> list = new List();
    new PostApi().getReasons(_user.userId, _qrDetails.status).then((val) {
      //print(val);
      val.forEach((k, v) => list.add(v.toString()));
      _actions = list;
      _mappedActions = val;
      setState(() {
        _selectedAction = list[0];
        _qrDetails.mineralName = _selectedAction;
        isLoading = false;
      });
      //print(list);
    });
  }

  String getReasonId() {
    Map<String, String> map = new Map<String, String>();
    _mappedActions.forEach((k,v) => map[v] = k );
    return map[_selectedAction];
  }
  _onAlertButtonPressed(
      context, String message,String title) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
    );

    Alert(
      style: alertStyle,
      context: context,
      title: title,
      desc: "$message",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            //Send to home page
            Navigator.of(context).pop();

            Navigator.pushNamedAndRemoveUntil(
                context,'/login',ModalRoute.withName('/fake'));
          },
          width: 120,
        )
      ],
    ).show();
  }

  void _handleOnPressed() {
    setState(() {
      isLoading = true;
    });
    new PostApi().truckPass(_qrDetails.activityId,
        _truckStatus.toString(), getReasonId(), remarksController
        .text, _user.userId).then((val) {
          setState(() {
            isLoading = false;
          });
       if(!val) {
         _onAlertButtonPressed(context, "Operation Failed","Failure");
       } else {
         _onAlertButtonPressed(context, "Operation Success", "Success");
       }
    });
  }
}


