import 'dart:convert';
import 'dart:io';
import 'package:gov_qr/Networking/post_api.dart';
import 'package:gov_qr/Pages/success_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:gov_qr/Widgets/info_widget.dart';
import 'package:gov_qr/Widgets/appbar_widget.dart';

import '../Models/QRDetails.dart';
import '../Models/User.dart';
import '../global.dart';
import 'action_page.dart';
import 'failure_page.dart';

class IncorrectInfoPage extends StatefulWidget {
  QRDetails qrDetails;
  User user;

  IncorrectInfoPage({this.qrDetails, this.user});

  @override
  _IncorrectInfoPageState createState() =>
      _IncorrectInfoPageState(qrDetails, user);
}

class _IncorrectInfoPageState extends State<IncorrectInfoPage> {
  QRDetails _qrDetails;
  User _user;
  final incorrectInfoKey = GlobalKey<FormState>();
  String _vehicleNumber = "", _remarks = "", _weight = "", _mineral = "";
  bool isLoading = true;
  Map<String, dynamic> mineralMap;
  List<String> _minerals;
  String _selectedMineral;

  void getListMinerals() {
    setState(() {
      isLoading = true;
    });
    List<String> list = new List();
    new PostApi().getMinerals(_user.userId).then((val) {
      //print(val);
      val.forEach((k, v) => list.add(v.toString()));
      _minerals = list;
      setState(() {
        mineralMap = val;
        _selectedMineral = list[0];
        _qrDetails.mineralName = _selectedMineral;
        isLoading = false;
      });
      //print(list);
    });
  }

  _IncorrectInfoPageState(QRDetails qrDetails, User user) {
    this._qrDetails = qrDetails;
    this._user = user;
  }

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListMinerals();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppbar(title: "Report issue", context: context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF49327B), Color(0xFFCB4440)],
            ),
          ),
          child: isLoading
              ? Center(
                  child: new CircularProgressIndicator(),
                )
              : ListView(
                  children: <Widget>[
                    //info(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Please enter the following details',
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ),
                    ),

                    Form(
                      key: incorrectInfoKey,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0, left: 8.0, right: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Text(
                                      "Mineral: ",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Theme(
                                    data: Theme.of(context)
                                        .copyWith(canvasColor: Colors.black),
                                    child: DropdownButton(
                                      // Not necessary for Option 1
                                      iconEnabledColor: Colors.white,
                                      value: _selectedMineral,
                                      style: TextStyle(color: Colors.white),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedMineral = newValue;
                                        });
                                      },
                                      items: _minerals.map((location) {
                                        return DropdownMenuItem(
                                          child: new Text(
                                            location,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          value: location,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter vehicle number';
                                  }
                                  _vehicleNumber = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintText: 'Enter Vehicle Number ',
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Vehicle Number'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter quantity transported';
                                  }
                                  _weight = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintText: 'Enter Quantity Transported (in MT)',
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Quantity Transported (in MT)'),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter remarks';
                                  }
                                  _remarks = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    hintText: 'Enter Remarks',
                                    hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Remarks'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, top: 16.0, right: 16.0, bottom: 16.0),
                      child: Text(
                        'Please upload challan photo',
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ),
                    ),

                    Container(
                        child: _image == null
                            ? Text(
                                'No photo uploaded',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                'Photo uploaded successfully',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              )),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: _image == null ? false : true,
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          child: _image != null ? Image.file(_image) : null,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RaisedButton(
                        color: Color(0xFFFF5733),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        onPressed: getImage,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Upload Photo',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RaisedButton(
                        color: Color(0xFFFF5733),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0)),
                        onPressed: () {
                          if (incorrectInfoKey.currentState.validate() &&
                              _image != null) {
                            setState(() {
                              isLoading = true;
                            });
                            pushInformation();
                          }
                        },
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void pushInformation() {
    new PostApi()
        .pushInformation(
      _user.userId,
      _qrDetails.activityId,
      _qrDetails.leaseId,
      _qrDetails.leaseName,
      _qrDetails.leaseAddress,
      _vehicleNumber,
      getMineralId(),
      _weight,
      _qrDetails.bookNo,
      _qrDetails.srNo,
      _qrDetails.permitNo,
      _remarks,
      base64Encode(_image.readAsBytesSync()),
      "1",
      _image.path.split(".").reversed.first,
    )
        .then((val) {
      //SHOW_SUCCESS_QR_CODE
      setState(() {
        isLoading = false;
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ActionPage(qrDetails: _qrDetails, user: _user)));
    });
  }

  String getMineralId() {
    Map<String, String> map = new Map<String, String>();
    mineralMap.forEach((k, v) => map[v] = k);
    debugPrint(map.toString());
    _qrDetails.mineralId = map[_selectedMineral];
    return _qrDetails.mineralId;
  }
}
