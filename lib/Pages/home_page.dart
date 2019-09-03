import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gov_qr/Models/QRDetails.dart';
import 'package:gov_qr/Models/User.dart';
import 'package:gov_qr/Pages/login_page.dart';
import 'package:gov_qr/Pages/report_error_page.dart';
import 'package:gov_qr/Widgets/info_widget.dart';
import 'package:gov_qr/Pages/help_page.dart';
import 'package:gov_qr/Pages/report_issue_page.dart';
import 'package:gov_qr/Pages/QR_info_page.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'error_info_page.dart';
import 'package:geolocator/geolocator.dart';
import '../Networking/post_api.dart';


class HomePage extends StatefulWidget {
  User user;

  HomePage({this.user});

  @override
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends State<HomePage> {
  bool _visibility = false;
  String barcode;
  User _user;
  String _alertBoxTitle;
  String _id;
  String _alertBoxMessage;
  bool apiCall;
  bool qrCodeScanSuccess = false, uniqueKeySuccess = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  _HomePageState(User user) {
    this._user = user;
  }

  Future scan() async {

        String barcode = await BarcodeScanner.scan();
        setState(() {
          this.barcode = barcode;
          this.qrCodeScanSuccess = true;});


  }

  TextEditingController uniqueKeyController = new TextEditingController();

  _getUniqueId() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Unique QR Key"),
            content: TextField(
              autofocus: true,
              controller: uniqueKeyController,
              decoration: InputDecoration(
                hintText: "Enter the unique QR key"
              ),
            ),
            actions: <Widget>[

              FlatButton(
                child: Text('Submit'),
                onPressed: ()  {
                  if(uniqueKeyController.text == "")
                    return;
                  if (uniqueKeyController != null && uniqueKeyController.text != "") {
                    this.barcode = uniqueKeyController.text;
                  }
                  setState(() {
                    _alertBoxTitle = "Verifying QR Code";
                    _alertBoxMessage = "";
                    apiCall = true;
                  });

                  if (this.barcode != null) {
                    verifyQrCode(this.barcode);
                    _onAlertButtonPressed(
                        context, _alertBoxMessage, _id, _alertBoxTitle,
                        null);
                  }
                  Navigator.of(context).pop();

                }
              ),

            ],
          );
        }
    );
  }



  _onAlertButtonPressed(
      context, String message, String id, String title, QRDetails qrDetails) {
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
          child: getProperWidget(),
          onPressed: () {
            _handleOkPress(qrDetails, context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  _onLogOutButtonPressed(
      context, String message, String id, String title, QRDetails qrDetails) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text('Do you want to proceed ?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('Log out'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  sharedPreferences.clear().then((val) {
                    if(val) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage()));
                    } else {
                      debugPrint("Failed to logout");
                    }
                  });
                },
              ),

            ],
          );
        }
    );
  }

  Position currentPosition;
  bool isLocationFetch = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.qrCodeScanSuccess = false;
    this.uniqueKeySuccess = false;
    changeStatusBarColor();
    getLocation();
  }

  void getLocation() {
    try {
      Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((val) {
        setState(() {
          currentPosition = val;
          isLocationFetch = false;
        });
      });
    } catch (error) {
      debugPrint(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willCallBack,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Color(0xFF9791B5),
            title: Text('QR3CMS',style: TextStyle(color: Colors.black),),
            elevation: 0.0,
            leading: IconButton(
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
              icon: Icon(
                Icons.person, color: Colors.black,
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/images/issue.png',width: 25.0,height: 25.0,),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportErrorPage(user: _user)));
                },
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: Color(0xFFCDCCCC),
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF49327B), Color(0xFFCB4440)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Color(0xFFCDCCCC),
                              maxRadius: 35.0,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_user.userName,style: TextStyle(color: Colors.white),),
                              ),
                              Text(_user.email,style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'GATE NAME :',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,bottom: 8.0),
                        child: Text(
                          _user.gateName,
                          style: TextStyle(fontSize: 20.0,color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Registered number :',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,bottom: 16.0),
                        child: Text(
                          _user.mobile,
                          style: TextStyle(fontSize: 20.0,color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80.0,
                  color: Color(0xFFCDCCCC),
                  child: ListTile(
                    title: Text('Update Details'),
                    leading: Icon(Icons.update),
                  ),
                ),
                Divider(
                  height: 1.0,
                  color: Colors.white,
                ),
                Container(
                  color: Color(0xFFCDCCCC),
                  alignment: Alignment.center,
                  height: 80.0,
                  child: ListTile(
                    title: Text('Change Password'),
                    leading: Icon(Icons.lock),
                  ),
                ),
                Divider(
                  height: 1.0,
                  color: Colors.white,
                ),
                Container(
                  color: Color(0xFFCDCCCC),
                  alignment: Alignment.center,
                  height: 80.0,
                  child: ListTile(
                    title: Text('Log Out'),
                    onTap: _handleLogOut,
                    leading: Icon(Icons.clear),
                  ),
                ),
                Divider(
                  height: 1.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        body: isLocationFetch ? Center(
          child: Container(
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
                  CircularProgressIndicator(),
                  Text("Fetching your location", style: TextStyle(color: Colors.white, fontSize: 20.0),)
                ],
              ),
            ),
          ),
        ) : Builder(
          builder: (context) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF49327B), Color(0xFFCB4440)],
              ),
            ),
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: _visibility,
                  child: info(),
                ),

                SizedBox(
                  height: 50.0,
                ),

                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Image.asset(
                              'assets/images/scan.png',
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Scan QR',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        scan().then((val) {
                          setState(() {
                            _alertBoxTitle = "Verifying QR Code";
                            _alertBoxMessage = "";
                            if(this.barcode != null)
                              apiCall = true;
                          });

                          if (this.barcode != null) {
                            verifyQrCode(val);
                            _onAlertButtonPressed(
                                context, _alertBoxMessage, _id, _alertBoxTitle,
                                null);
                          }
                        }, onError: (error) {

                        });
                      },
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: Image.asset(
                              'assets/images/enter_id_button.png',
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Enter Unique ID',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(child: Text('(If not able to scan QR)',style: TextStyle(color: Colors.yellowAccent),)),
                              ],
                            ),
                          ),

                        ],
                      ),
                      onTap: () {
                        _getUniqueId();


                      },
                    ),
                  ),
                ),
//
//                Divider(),

//                Expanded(
//                  child: Container(
//                    alignment: Alignment.center,
//                    child: GestureDetector(
//                      child: Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: <Widget>[
//                          Expanded(
//                            flex: 2,
//                            child: Image.asset(
//                              'assets/images/issue.png',
//                              color: Colors.white,
//                            ),
//                          ),
//                          Expanded(
//                            flex: 2,
//                            child: Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text(
//                                'Report Issue',
//                                style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 20.0,
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                      onTap: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (context) => ReportErrorPage(user: _user)));
//                      },
//                    ),
//                  ),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void verifyQrCode(String val) {
    var postApi = new PostApi();
    if(this.barcode == null) {
      setState(() {
        apiCall = false;
      });
      return;
    }
    postApi.verifyQrCode(this._user.userId, this.barcode, currentPosition.longitude.toString(), currentPosition.latitude.toString(), this.uniqueKeySuccess).then(
            (QRDetails) {
          if (QRDetails.status == "1") {
            setState(() {
              apiCall = false;
              _alertBoxMessage = QRDetails.message;
              _alertBoxTitle = "Success";
              _id = QRDetails.qrID;
            });
            Navigator.of(context).pop();
            _onAlertButtonPressed(
                context, QRDetails.message, "", "Success", QRDetails);
          } else {
            setState(() {
              _alertBoxTitle = "Error";
              _alertBoxMessage = QRDetails.message;
              _id = QRDetails.qrID;
              apiCall = false;
            });
            Navigator.of(context).pop();
            if (QRDetails.status == "9")
              _onAlertButtonPressed(
                  context, QRDetails.message, "", "Invalid QR Code", QRDetails);
            else
              _onAlertButtonPressed(
                  context, QRDetails.message, "", "Error", QRDetails);
          }
        }, onError: (error) {
      setState(() {
        _alertBoxTitle = "Failure";
        _alertBoxMessage = "null";
        _id = "null";
        apiCall = false;
      });
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Error while verifying QR Code"),
      ));
    });
  }

  getProperWidget() {
    if (apiCall) {
      return new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Text(
        "OK",
        style: TextStyle(color: Colors.white),
      );
    }
  }

  _handleOkPress(QRDetails qrDetails, BuildContext context) {
    Navigator.of(context).pop();
    if (!apiCall) {
      switch (qrDetails.status) {
        case "1":
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QRCodeInfo(qrDetails: qrDetails, user: _user)));
          break;
        case "2":
          //Consumed
        case "3":
        //Expired
        case "4":
        //Wrong Gate
        case "5":
        //Wrong Mineral
        case "6":
        //Wrong weight
        case "7":
        //Wrong department
        case "8":
        //Duplicate
        case "10":
        //Wrong Mineral and Weight
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ErrorQRCodeInfo(qrDetails: qrDetails, user: _user)));
          break;
        case "9":
        //Invalid/Not generated
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReportIssuePage(qrDetails: qrDetails, user: _user, infoStatus: 1,)));
          break;
        default:
          break;
      }
    }
  }

  void changeStatusBarColor()  {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black
    ));
  }

  void _handleLogOut() async {
    _onLogOutButtonPressed(context, "Do you want to Logout?", "", "Log Out", null);
  }


  Future<bool> _willCallBack() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('EXIT'),
          content: Text('Do you want to proceed ?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('Exit'),
              onPressed: () => exit(0),
            ),

          ],
        );
      }
    );
  }


}
