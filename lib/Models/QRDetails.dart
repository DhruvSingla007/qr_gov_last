import 'package:gov_qr/global.dart';

class QRDetails {
  String qrID;
  String qrCode;
  String uniqueID;
  String generatedBy;
  String generatedOn;
  String expiryDate;
  String type;
  String weight;
  String gateId;
  String bookNo;
  String srNo;
  String deptId;
  String requestId;
  String mineralId;
  String mineralName;
  String weightID;
  String gateName;
  String deptName;
  String permitNo;
  String permitDate;
  String leaseId;
  String leaseName;
  String leaseAddress;
  String status;
  String message;
  String activityId;
  String who;
  String when;

  QRDetails(
      {this.qrID,
      this.qrCode,
      this.uniqueID,
      this.generatedBy,
      this.generatedOn,
      this.expiryDate,
      this.type,
      this.weight,
      this.gateId,
      this.bookNo,
      this.srNo,
      this.deptId,
      this.requestId,
      this.mineralId,
      this.mineralName,
      this.weightID,
      this.gateName,
      this.deptName,
      this.permitNo,
      this.permitDate,
      this.leaseId,
      this.leaseName,
      this.leaseAddress,
      this.status,
      this.message,
      this.activityId,
      this.who,
      this.when});

  factory QRDetails.fromJson(Map<String, dynamic> json) {
    return QRDetails(
        qrID: json[QrDetails.QR_ID],
        qrCode: json[QrDetails.QR_CODE],
        uniqueID: json[QrDetails.UNIQUE_ID],
        generatedBy: json[QrDetails.GENERATED_BY],
        generatedOn: json[QrDetails.GENERATED_ON],
        expiryDate: json[QrDetails.EXPIRY_DATE],
        type: json[QrDetails.TYPE],
        weight: json[QrDetails.WEIGHT],
        gateId: json[QrDetails.GATE_ID],
        bookNo: json[QrDetails.BOOK_NO],
        srNo: json[QrDetails.SR_NO],
        deptId: json[QrDetails.DEPT_ID],
        requestId: json[QrDetails.REQUEST_ID],
        mineralId: json[QrDetails.MINERAL_ID],
        mineralName: json[QrDetails.MINERAL_NAME],
        weightID: json[QrDetails.WEIGHT_ID],
        gateName: json[QrDetails.GATE_NAME],
        deptName: json[QrDetails.DEPT_NAME],
        permitNo: json[QrDetails.PERMIT_NO],
        permitDate: json[QrDetails.PERMIT_DATE],
        leaseAddress: json[QrDetails.LEASE_ADDRESS],
        leaseId: json[QrDetails.LEASE_ID],
        leaseName: json[QrDetails.LEASE_NAME]);
  }
}
