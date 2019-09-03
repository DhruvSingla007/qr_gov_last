import 'package:flutter/material.dart';
import 'package:gov_qr/Models/Issue.dart';
import 'package:gov_qr/Pages/home_page.dart';
import 'package:gov_qr/Widgets/appbar_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Models/User.dart';
import '../Networking/post_api.dart';

class ReportErrorPage extends StatefulWidget {
  User user;
  ReportErrorPage({this.user});

  @override
  _ReportErrorPageState createState() =>
      _ReportErrorPageState(this.user);
}

class _ReportErrorPageState extends State<ReportErrorPage> {
  User _user;
  String _remarks;
  String errorMessage = "This field can't be empty";
  bool isSubmitting = false;

  _ReportErrorPageState(User user) {
    this._user = user;
  }

  final issueGlobalKey = GlobalKey<FormState>();

  List<String> _issues;
  List<Issue> issue;
  bool isLoading = true;
  String _selectedIssue;

  onAlertButtonPressed(
      context, String message, String title) {
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
          child: Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushNamedAndRemoveUntil(
                context,'/login',ModalRoute.withName('/fake'));
          },
          width: 120,
        )
      ],
    ).show();
  }

  void getListIssues() {
    setState(() {
      isLoading = true;
    });
    List<String> list = new List();
    new PostApi().getIssues(_user.userId).then((val) {
      //print(val);
      val.forEach((item) => list.add(item.issue.toString()));
      _issues = list;
      setState(() {
        issue = val;
        _selectedIssue = list[0];
        isLoading = false;
      });
      //print(list);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListIssues();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppbar(title: "Report Issue", context: context),
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
            Form(
              key: issueGlobalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          'Select Issue : ',
                          style: TextStyle(fontSize: 15.0,color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16.0, left: 16.0, right: 16.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(canvasColor: Colors.black),
                            child: DropdownButton(// Not necessary for Option 1
                              iconEnabledColor: Colors.white,
                              value: _selectedIssue,
                              style: TextStyle(color: Colors.white),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedIssue = newValue;
                                });
                              },
                              items: _issues.map((location) {
                                return DropdownMenuItem(
                                  child: new Text(location,style: TextStyle(color: Colors.white, fontSize: 15.0, ),),
                                  value: location,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.0,),
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
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                      decoration: InputDecoration(
                          errorStyle: TextStyle(color: Colors.yellowAccent),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        hintText: 'Enter Description',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                        labelText: 'Enter Description'
                      ),
                    ),
                  ),
                ],
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
                      setState(() {
                        isLoading = true;
                      });
                      pushIssue();
                  }
                },
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                textColor: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }

  void pushIssue() {
    new PostApi()
        .reportIssue(_user.userId, getIssueId(), _remarks)
        .then((val) {
      //SHOW_SUCCESS_QR_CODE
      setState(() {
        isLoading = false;
      });
     onAlertButtonPressed(context, "Issue recorded", "Success");
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
      onAlertButtonPressed(context,"Error in issue reporting", "Error");
      debugPrint(error);
    });
  }

  String getIssueId() {
    debugPrint(issue.toString());
    Map<String, String> map = new Map<String, String>();
    issue.forEach((item) {
      map[item.issue] = item.id;
    });
    return map[_selectedIssue];
  }
}
