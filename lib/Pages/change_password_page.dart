import 'package:flutter/material.dart';
import 'package:gov_qr/Models/User.dart';
//import 'package:gov_qr/Networking/post_api.dart';
//import 'package:gov_qr/Pages/otp_page.dart';
//import 'package:gov_qr/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'home_page.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChangePasswordPageState();
  }
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _userDetailsKey = GlobalKey<FormState>();
  String _userpassword = "";
  User _user;
  bool apiCall = false;
  bool hidePassword = true;
  SharedPreferences preferences;

//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    isSignedIn();
//  }
//
//  void isSignedIn() async{
//    User user = new User();
//    preferences = await SharedPreferences.getInstance();
//    if(preferences.getString(USER_ID) == null)
//      return ;
//    user.userId = preferences.getString(USER_ID);
//    user.userName = preferences.getString(USERNAME);
//    user.loginId = preferences.getString(LOGIN_ID);
//    user.roleId = preferences.getString(ROLE_ID);
//    user.mobile = preferences.getString(MOBILE);
//    user.email = preferences.getString(EMAIL);
//    user.deptId = preferences.getString(DEPT_ID);
//    user.gateId = preferences.getString(GATE_ID);
//    user.districtId = preferences.getString(DISTRICT_ID);
//    user.designation = preferences.getString(DESIGNATION);
//    user.gateName = preferences.getString("GATE_NAME");
//    user.isVerified = null;
//    Navigator.pushReplacement(context,
//        MaterialPageRoute(builder: (context) => HomePage(user: user)));
//  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Builder(
          builder : (context) => Container(
            color: Color(0xFF571845),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF49327B), Color(0xFFCB4440)],
                ),
              ),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 25.0),
                  Container(
                    height: 150.0,
                    width: 150.0,
                    child: Image.asset('assets/images/logo.png',width: 150.0,height: 150.0,),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      'Government of Meghalaya',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF4C104),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Text(
                      'Welcome to QR3CMS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      '(QR Coded Challan & Check-Post Manangement System)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Form(
                    key: _userDetailsKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: TextFormField(
                                      onSaved: (value) {
                                        setState(() {
                                          _userpassword = value;
                                        });
                                      },
                                      obscureText: hidePassword,
                                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Please enter new password";
                                        }
                                        setState(() {
                                          _userpassword = value;
                                        });
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Container(child: Icon(Icons.lock,color: Colors.white,),color: Colors.black,height: 52.0,),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.remove_red_eye,color: Colors.black,),
                                          onPressed: (){
                                            if(hidePassword){
                                              setState(() {
                                                hidePassword = false;
                                              });
                                            } else {
                                              setState(() {
                                                hidePassword= true;
                                              });
                                            }
                                          },
                                        ),
                                        errorStyle: TextStyle(
                                            color: Colors.yellowAccent,
                                            fontSize: 13.0,
                                            letterSpacing: 1.0),
                                        hintText: 'New Password',
                                        hintStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
//                        if (_userDetailsKey.currentState.validate()) {
//                          setState(() {
//                            apiCall = true;
//                          });
//                          _callverifyLoginAndFetchUserDataApi(context);
//                        }
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

  Widget getProperWidget(){
    if(apiCall)
      return new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      );
    else
      return Text(
        'CHANGE PASSWORD',
        style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
      );
  }

//  void _callverifyLoginAndFetchUserDataApi(BuildContext context) {
//    var postApi = new PostApi();
//    postApi.verifyLoginAndFetchUserData(_username, _userpassword).then((user) {
//
//      if (user == null ) {
//        //Send a message of not verified
//        Scaffold.of(context).showSnackBar(new SnackBar(
//          content: new Text("Invalid Credentials, try Again"),
//        ));
//        setState(() {
//          _user = null;
//          apiCall = false;
//        });
//        return;
//      }
//      if (user.roleId != "4") {
//        Scaffold.of(context).showSnackBar(new SnackBar(
//          content: new Text("Not Allowed to access"),
//        ));
//        setState(() {
//          _user = null;
//          apiCall = false;
//        });
//        return;
//      }
//      postApi.generateOtp(user.loginId);
//      setState(() {
//        _user = user;
//        apiCall = false;
//        Navigator.push(context,
//            MaterialPageRoute(builder: (context) => OTPPage(user: _user)));
//      });
//
//    }, onError: (error) {
//      setState(() {
//        apiCall = false;
//        _user = null;
//      });
//      Scaffold.of(context).showSnackBar(new SnackBar(
//        content: new Text("Error while verifying credentials"),
//      ));
//    });
//
//  }


}