import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gov_qr/Models/User.dart';
import 'package:gov_qr/Networking/post_api.dart';
import 'package:gov_qr/Pages/home_page.dart';
import 'package:gov_qr/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPPage extends StatefulWidget {
  User user;

  OTPPage({@required this.user});

  @override
  _OTPPageState createState() => _OTPPageState(user);
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _otpController = TextEditingController();
  User user;
  String _Otp = "";
  bool apiCall = false;
  final _otpKey = GlobalKey<FormState>();
  Timer _timer;
  int _start = 120;

  _OTPPageState(User user) {
    this.user = user;
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            setState(() {
              _start = _start - 1;
            });

          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => Container(
        color: Color(0xFF571845),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFFcc2b5e), Color(0xFF753a88)],
            ),
          ),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 50.0),
              Container(
                height: 150.0,
                width: 150.0,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 30.0),
                child: Text(
                  'Enter OTP',
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Form(
                key: _otpKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Enter Otp";
                          }
                          setState(() {
                            _Otp = value;
                          });
                          return null;
                        },
                        controller: _otpController,
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                            filled: true,
                            errorStyle: TextStyle(
                                color: Colors.yellow,
                                fontSize: 13.0,
                                letterSpacing: 1.0),
                            hintText: 'OTP',
                            hintStyle: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      // Resend OTP function
                      if (_start < 1) {
                        _start = 120;
                        startTimer();
                        new PostApi().generateOtp(user.userName);
                      }
                    },
                    child: Text(
                      'Resend OTP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18.0,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {},

                    child: Text(
                      '$_start secs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18.0,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: RaisedButton(
                  color: Colors.black,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  onPressed: () {
                    if (_otpKey.currentState.validate()) {
                      setState(() {
                        apiCall = true;
                      });
                      verifyOtp(context);
                    }
                  },
                  padding: EdgeInsets.all(10.0),
                  child: getProperWidget(),
                  textColor: Color(0xFF571845),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget getProperWidget() {
    if (apiCall)
      return new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      );
    else
      return Text(
        'VERIFY',
        style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
  }

  void verifyOtp(BuildContext context) {
    var postApi = new PostApi();
    postApi.verifyOtp(this.user.loginId, this._Otp).then((status) {
      setState(() {
        apiCall = false;
      });
      if (status == FAILURE) {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text("Invalid OTP"),
        ));
        return;
      }
      _handleSignIn(user).then((val) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(user: user)));
      });
    }, onError: (error) {
      setState(() {
        apiCall = false;
      });
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Error while verifying OTP"),
      ));
    });
  }

  Future<bool> _handleSignIn(User user) async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString(USER_ID, user.userId);
    await preferences.setString(USERNAME, user.userName);
    await preferences.setString(LOGIN_ID, user.loginId);
    await preferences.setString(ROLE_ID, user.roleId);
    await preferences.setString(MOBILE, user.mobile);
    await preferences.setString(EMAIL, user.email);
    await preferences.setString(DEPT_ID, user.deptId);
    await preferences.setString(GATE_ID, user.gateId);
    await preferences.setString(DISTRICT_ID, user.districtId);
    await preferences.setString(DESIGNATION, user.designation);
    await preferences.setString("GATE_NAME", user.gateName);
    await preferences.setString("is_verified", user.isVerified.toString());
    return true;
  }
}
