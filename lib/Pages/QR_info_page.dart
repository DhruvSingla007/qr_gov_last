import 'package:flutter/material.dart';
import 'package:gov_qr/Models/QRDetails.dart';
import 'package:gov_qr/Models/User.dart';
import 'package:gov_qr/Widgets/info_widget.dart';
import 'package:gov_qr/Widgets/appbar_widget.dart';
import 'package:gov_qr/Pages/correct_info_page.dart';
import 'package:gov_qr/Pages/incorrect_info_page.dart';
import 'report_issue_page.dart';

class QRCodeInfo extends StatefulWidget {
  QRDetails qrDetails;
  User user;

  QRCodeInfo({this.qrDetails, this.user});

  @override
  _QRCodeInfoState createState() => _QRCodeInfoState(qrDetails, user);
}

class _QRCodeInfoState extends State<QRCodeInfo> {
  QRDetails _qrDetails;
  User _user;

  _QRCodeInfoState(QRDetails input, User user) {
    this._qrDetails = input;
    this._user = user;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppbar(
            context: context, title: "Details"),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF49327B), Color(0xFFCB4440)],
            ),
          ),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: <Widget>[
              //info(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Please verify the information',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Details : ',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white,),
                ),
              ),


              Container(
                height: 365.0,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          verticalDirection: VerticalDirection.down,
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Lease Holder Name',
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Address',
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Mineral',
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Quantity',
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Book No.',
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Serial No.',
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Permit/NOC No.',
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Validity',
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Issue Date',
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Gate',
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white,),
                              ),
                            ),
                          ],
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.leaseName,
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ), //Lease Holder Name
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.leaseAddress,
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ), //Mineral
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.mineralName,
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ), //Quantity
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.weight,
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ), //Book No.
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.bookNo,
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ), //Serial No.
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.srNo,
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ), //Permit No.
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.permitNo,
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ), //Validity
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.expiryDate,
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white,),
                              ),
                            ), //Issue Date
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.generatedOn,
                                style: TextStyle(fontSize: 15.0, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _qrDetails.gateName,
                                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white,),
                              ),
                            ), //Gate
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 20.0,
              ),

              SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    color: Color(0xFFFF5733),
                    textColor: Colors.white,
                    onPressed: () {
                      print('Incorrect');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IncorrectInfoPage(user: _user, qrDetails: _qrDetails)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Incorrect',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    color: Color(0xFFFF5733),
                    textColor: Colors.white,
                    onPressed: () {
                      print('Correct');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => YesForm(qrDetails: _qrDetails, user: _user,)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Correct',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
