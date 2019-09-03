import 'package:gov_qr/global.dart';

class Issue {
  String id;
  String issue;
  String status;

  Issue({this.id, this.issue, this.status});

  factory Issue.fromJson(Map<String, dynamic> json) {
    return new Issue(
       id: json["Id"],
      status: json["Status"],
      issue: json["Issue"]
    );
  }
}