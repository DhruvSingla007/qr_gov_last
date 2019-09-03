import 'dart:convert';
import 'dart:io';
import 'package:gov_qr/Models/QRDetails.dart';
import 'package:gov_qr/Models/User.dart';
import 'package:gov_qr/Networking/post_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:gov_qr/Widgets/info_widget.dart';
import 'package:gov_qr/Widgets/appbar_widget.dart';
import 'package:gov_qr/global.dart';
import 'failure_page.dart';
import 'success_page.dart';

class YesForm extends StatefulWidget {
  QRDetails qrDetails;
  User user;

  YesForm({this.qrDetails, this.user});

  @override
  _YesFormState createState() => _YesFormState(qrDetails, user);
}

class _YesFormState extends State<YesForm> {
  File _image;
  QRDetails _qrDetails;
  User _user;
  String _remarks = "";
  String _vehicleNumber = "";
  String _quantity = "";
  final correctFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  _YesFormState(QRDetails qrDetails, User user) {
    this._qrDetails = qrDetails;
    this._user = user;
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppbar(title: "Details", context: context),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF49327B), Color(0xFFCB4440)],
            ),
          ),
          child: isLoading ?  Center (child:  new CircularProgressIndicator(),) : ListView(
            children: <Widget>[
              //info(),
              Form(
                key: correctFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0, left: 16.0, right: 16.0,bottom: 32.0),
                          child: Text(
                            'Mineral : ',
                            style: TextStyle(fontSize: 22.0,color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0,top: 28.0),
                          child: Text(
                            _qrDetails.mineralName,
                            style: TextStyle(
                              fontSize: 20.0, color: Colors.white
                            ),
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter a valid Vehicle Number';
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
                      padding:
                      const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value){
                          if(value.isEmpty){
                            return 'Please enter the  mineral quantity';
                          }
                          _quantity = value;
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.yellowAccent),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            hintText: 'Enter Mineral Quantity (in MT)',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                            labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                            labelText: 'Enter Mineral Quantity (in MT)'
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                      child: TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return 'Please enter remarks';
                          }
                          _remarks = value;
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 20.0,
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
                    'Upload Photo',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
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
                    if (correctFormKey.currentState.validate() && _image != null) {
                      setState(() {
                        isLoading = true;
                      });
                      pushInformation();
                    }
                  },
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
      _qrDetails.mineralName,
      _quantity,
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
      if(val.containsKey(QRSTATUS)) {
        // MISMATCH of WEIGHT
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FailurePage(user: _user)));

      }
      else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SuccessPage(user: _user)));
      }

    });
  }
}
