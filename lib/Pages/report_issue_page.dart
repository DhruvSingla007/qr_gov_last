import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gov_qr/Widgets/appbar_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:gov_qr/Pages/action_page.dart';

import '../Models/QRDetails.dart';
import '../Models/User.dart';
import '../Networking/post_api.dart';
import '../global.dart';
import 'package:intl/intl.dart';

class ReportIssuePage extends StatefulWidget {
  QRDetails qrDetails;
  User user;
  var infoStatus;
  ReportIssuePage({this.qrDetails, this.user, this.infoStatus});

  @override
  _ReportIssuePageState createState() =>
      _ReportIssuePageState(this.qrDetails, this.user, this.infoStatus);
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  QRDetails _qrDetails;
  User _user;
  String _remarks;
  String _vehicleNumber;
  int infoStatus;
  Map<String, dynamic> mineral;
  String errorMessage = "This field can't be empty";
  bool isSubmitting = false;

  _ReportIssuePageState(QRDetails input, User user, int infoStatus) {
    this._qrDetails = input;
    this._user = user;
    this.infoStatus = infoStatus;
  }

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  final issueGlobalKey = GlobalKey<FormState>();
  List<String> _minerals;
  bool isLoading = true;
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
        mineral = val;
        _selectedMineral = list[0];
        _qrDetails.mineralName = _selectedMineral;
        isLoading = false;
      });
      //print(list);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListMinerals();
    _qrDetails.leaseId = "";
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppbar(
            title: "Report Issue", context: context),
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
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: <Widget>[
                    //info(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Text(
                        _qrDetails.message,
                        style: TextStyle(
                            color: Color(0xFFFF5733),
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Form(
                        key: issueGlobalKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'Select Mineral : ',
                                    style: TextStyle(fontSize: 15.0,color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16.0, left: 16.0, right: 16.0),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(canvasColor: Colors.black),
                                    child: DropdownButton(
                                      iconEnabledColor: Colors.white,
                                      hint: Text('Please choose the mineral',style: TextStyle(color: Colors.white),),
                                      // Not necessary for Option 1
                                      value: _selectedMineral,
                                      style: TextStyle(color: Colors.white),
                                      onChanged: (newValue) {
                                        setState(() {
                                          _selectedMineral = newValue;
                                          _qrDetails.mineralName = newValue;
                                        });
                                      },
                                      items: _minerals.map((location) {
                                        return DropdownMenuItem(
                                          child: new Text(location),
                                          value: location,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter Holder Name';
                                  }
                                  _qrDetails.leaseName = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.yellowAccent),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(color: Colors.white)
                                  ),
                                  hintText: 'Enter Lease Holder Name',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  labelText: 'Enter Lease Holder Name',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter Address';
                                  }
                                  _qrDetails.leaseAddress = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    hintText: 'Enter Address',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Address',

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter Vehicle number';
                                  }
                                  _vehicleNumber = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    hintText: 'Enter Vehicle Number',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Vehicle Number'
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16.0, left: 16.0, right: 16.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return errorMessage;
                                  }
                                  _qrDetails.weight = value;
                                  return null;
                                },
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    hintText: 'Enter Quantity Transported',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Quantity Transported'
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter a valid Book Number';
                                  }
                                  _qrDetails.bookNo = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    hintText: 'Enter Book Number',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Book Number'
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter a valid Serial Number';
                                  }
                                  _qrDetails.srNo = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    hintText: 'Enter Serial Number',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Serial Number'
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter a valid Permit Number';
                                  }
                                  _qrDetails.permitNo = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    hintText: 'Enter Permit Number',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Permit Number'
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, bottom: 16.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return errorMessage;
                                  }
                                  _remarks = value;
                                  return null;
                                },
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.white)
                                    ),
                                    hintText: 'Enter Remarks',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                    labelText: 'Enter Remarks'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Please upload image of Challan',
                        style: TextStyle(fontSize: 22.0,color: Colors.white),
                      ),
                    ),

                    Container(
                        child: _image == null
                            ? Text(
                                'No photo uploaded',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                              )
                            : Text(
                                'Photo uploaded successfully',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
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
                          _image == null ? 'Upload Photo' : 'Change Photo',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
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
                          if (issueGlobalKey.currentState.validate()){
                            if ( _image != null) {
                              setState(() {
                                isLoading = true;
                              });
                              pushInformation();
                            }
                          }
                        },
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Reported on ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now())}',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
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
      _qrDetails.weight,
      _qrDetails.bookNo,
      _qrDetails.srNo,
      _qrDetails.permitNo,
      _remarks,
      base64Encode(_image.readAsBytesSync()),
      infoStatus.toString(),
      _image.path.split(".").reversed.first,
    )
        .then((val) {
          debugPrint(_image.lengthSync().toString());
      //SHOW_SUCCESS_QR_CODE
      if (val.containsKey(QRSTATUS)) {
        // MISMATCH of WEIGHT
        _qrDetails.status = val[QRSTATUS];
        _qrDetails.message = val[QRSTATUSNAME];
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ActionPage(user: _user, qrDetails: _qrDetails)));
    }, onError: (error) {
          setState(() {
            isLoading = false;
          });
          debugPrint(error);
    });
  }

  String getMineralId() {
    Map<String, String> map = new Map<String, String>();
    mineral.forEach((k,v) => map[v] = k);
    debugPrint(map.toString());
    _qrDetails.mineralId = map[_selectedMineral];
    return _qrDetails.mineralId;
  }
}
