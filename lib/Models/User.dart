import 'package:gov_qr/global.dart';

class User {
  String userId;
  String userName;
  String loginId;
  String roleId;
  String mobile;
  String email;
  String deptId;
  String gateId;
  String districtId;
  String designation;
  bool isVerified;
  String gateName;

  User({this.userId, this.userName, this.loginId, this.roleId, this.mobile,
      this.email, this.deptId, this.gateId, this.districtId, this.designation, this.isVerified, this.gateName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json[USER_ID],
      userName: json[USERNAME],
      loginId: json[LOGIN_ID],
      roleId: json[ROLE_ID],
      mobile: json[MOBILE],
      email: json[EMAIL],
      deptId: json[DEPT_ID],
      gateId: json[GATE_ID],
      districtId: json[DISTRICT_ID],
      designation: json[DESIGNATION],
      gateName: json["GateName"]
    );
  }
}