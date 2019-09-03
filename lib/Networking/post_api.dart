import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:gov_qr/Models/Issue.dart';
import 'package:gov_qr/Models/QRDetails.dart';
import 'package:http/http.dart';
import 'package:gov_qr/Models/User.dart';
import 'package:gov_qr/global.dart';

class PostApi {
  Map<String, String> headers = {
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<User> verifyLoginAndFetchUserData(
      String username, String password) async {
    Map<String, String> body = {
      "username": SERVER_USER_NAME,
      "password": SERVER_USER_PASSWORD,
      "loginid": username,
      "userpassword": password
    };

    final response = await post(SERVER_VERIFY_LOGIN,
        headers: headers,
        body: body,
        encoding: Encoding.getByName(SERVER_ENCODING_TYPE));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      debugPrint("$responseJson");
      if (responseJson[STATUS] == 1) {
        return User.fromJson(responseJson[DATA]);
      } else {
        return null;
      }
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
    }
    return null;
  }

  void generateOtp(String loginId) async {
    debugPrint("LoginID: $loginId");
    Map<String, String> body = {
      "username": SERVER_USER_NAME,
      "password": SERVER_USER_PASSWORD,
      "loginid": loginId
    };

    final response = await post(SERVER_OTP_GENERATE_VERIFY,
        headers: headers,
        body: body,
        encoding: Encoding.getByName(SERVER_ENCODING_TYPE));
    if (response.statusCode == 200) {
      // OTP sent successfully
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
    }
  }

  Future<String> verifyOtp(String loginId, String Otp) async {
    Map<String, String> body = {
      "username": SERVER_USER_NAME,
      "password": SERVER_USER_PASSWORD,
      "loginid": loginId,
      "otp": Otp
    };

    final response = await post(SERVER_OTP_GENERATE_VERIFY,
        headers: headers,
        body: body,
        encoding: Encoding.getByName(SERVER_ENCODING_TYPE));

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      debugPrint("$responseJson");
      if (responseJson[STATUS] == 1) {
        return SUCCESS;
      } else {
        return FAILURE;
      }
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
      return FAILURE;
    }
  }

  Future<QRDetails> verifyQrCode(
      String userId, String qrCode, String logitute, String latitude, bool uniqueKey) async {
    Map<String, String> body = new Map<String, String>();
    if(uniqueKey) {
      body = {
        "username": SERVER_USER_NAME,
        "password": SERVER_USER_PASSWORD,
        "userid": userId,
        "uniqueid": qrCode,
        "Logitute": logitute,
        "Latitute": latitude
      };
    } else {
      body = {
        "username": SERVER_USER_NAME,
        "password": SERVER_USER_PASSWORD,
        "userid": userId,
        "qrcode": qrCode,
        "Logitute": logitute,
        "Latitute": latitude
      };
    }
    print(qrCode);

    final response = await post(SERVER_SCAN_QR_CODE,
        body: body,
        headers: headers,
        encoding: Encoding.getByName(SERVER_ENCODING_TYPE));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      debugPrint("$responseJson");
      if (responseJson[STATUS].toString() != "9") {
        QRDetails qrDetails = QRDetails.fromJson(responseJson[QRDETAILS]);
        qrDetails.status = responseJson[STATUS].toString();
        qrDetails.activityId = responseJson[ACTIVITY_ID];
        qrDetails.message = responseJson[MESSAGE];
        var details = responseJson[QRDETAILS]["Consmed_Details"];
        if(qrDetails.status == "8") {
          qrDetails.when = details["When"];
          qrDetails.who = details["WhoName"];
        }
        return qrDetails;
      } else {
        return new QRDetails(
            status: responseJson[STATUS].toString(),
            message: responseJson[MESSAGE],
            activityId: responseJson[ACTIVITY_ID]);
      }
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
    }
    return null;
  }

  Future<Map<String, dynamic>> getMinerals(String userId) async {
    Map<String, String> body = {
      "username": SERVER_USER_NAME,
      "password": SERVER_USER_PASSWORD,
      "userid": userId
    };

    final response = await post(SERVER_GET_MINERAL_TYPE,
        body: body, encoding: Encoding.getByName(SERVER_ENCODING_TYPE));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      debugPrint("$responseJson");
      if (responseJson[STATUS] == 1) {
        Map<String, dynamic> mineralType = responseJson[MINERAL];
        return mineralType;
      } else {
        return null;
      }
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
    }
    return null;
  }

  Future<Map<String, dynamic>> getReasons(String userId, String qrStatus) async {
    Map<String, String> body = {
      "username": SERVER_USER_NAME,
      "password": SERVER_USER_PASSWORD,
      "userid": userId,
      "qrstatus": qrStatus
    };

    final response = await post(SERVER_GET_REASONS,
        body: body, encoding: Encoding.getByName(SERVER_ENCODING_TYPE));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      debugPrint("$responseJson");
      if (responseJson[STATUS] == 1) {
        Map<String, dynamic> reasonType = responseJson["Reasons"];
        return reasonType;
      } else {
        return null;
      }
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
    }
    return null;
  }

  Future<bool> truckPass(String activityId, String truckPass, String reasonId,
      String remarks, String userId) async {
    Map<String, String> body = {
      "username": SERVER_USER_NAME,
      "password": SERVER_USER_PASSWORD,
      "userid": userId,
      "activityid": activityId,
      "truckpass": truckPass,
      "reasonid": reasonId,
      "remarks": remarks
    };

    final response = await post(SERVER_TRUCK_PASS,
        body: body, encoding: Encoding.getByName(SERVER_ENCODING_TYPE));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      debugPrint("$responseJson");
      if (responseJson[STATUS] == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
    }
    return false;
  }

  Future<List<Issue>> getIssues(String userId) async {
    Map<String, String> body = {
      "username": SERVER_USER_NAME,
      "password": SERVER_USER_PASSWORD,
      "userid": userId
    };

    final response = await post(SERVER_GET_ISSUE,
        body: body, encoding: Encoding.getByName(SERVER_ENCODING_TYPE));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      debugPrint("$responseJson");
      if (responseJson[STATUS] == 1) {
        List<Issue> list = new List<Issue>();
        var issueFromJson = responseJson["Data"];
        issueFromJson.forEach((item) => list.add(Issue.fromJson(item)));
        return list;
      } else {
        return null;
      }
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
    }
    return null;
  }

  Future<bool> reportIssue(String userId, String issueId, String issue ) async {
    Map<String, String> body = {
      "username": SERVER_USER_NAME,
      "password": SERVER_USER_PASSWORD,
      "userid": userId,
      "issuetype": issueId,
      "issue": issue
    };

    final response = await post(SERVER_REPORT_ISSUE,
        body: body, encoding: Encoding.getByName(SERVER_ENCODING_TYPE));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      debugPrint("$responseJson");
      if (responseJson[STATUS] == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
    }
    return false;
  }

  Future<Map<String, dynamic>> pushInformation(
      String userId,
      String activityId,
      String leaseId,
      String leaseName,
      String leaseAddress,
      String vehicleNo,
      String mineral,
      String weight,
      String bookNo,
      String serialNo,
      String permitNo,
      String remarks,
      String photo,
      String infoStatus,
      String fileExtension) async {
    Map<String, String> body = {
      "username": SERVER_USER_NAME,
      "password": SERVER_USER_PASSWORD,
      "userid": userId,
      "activityid": activityId,
      "LeaseID": leaseId,
      "LeaseName": leaseName,
      "LeaseAddress": leaseAddress,
      "VechileNo": vehicleNo,
      "Mineral": mineral,
      "Weight": weight,
      "BookNo": bookNo,
      "SerialNo": serialNo,
      "PermitNo": permitNo,
      "Remarks": remarks,
      "Photo": photo,
      "infostatus": infoStatus,
      "fileextension": fileExtension
    };

    final response = await post(SERVER_FILL_INFO,
        body: body, headers: headers, encoding: Encoding.getByName(SERVER_ENCODING_TYPE));
    debugPrint(response.toString());
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      debugPrint("$responseJson");
      return responseJson;
    } else {
      debugPrint("RESPONSE CODE FAILURE == $response");
      return null;
    }
  }
}
