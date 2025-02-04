// ignore_for_file: non_constant_identifier_names

class FuelSale {
  String fdCTimeStamp;
  String type;
  String deviceID;
  String pumpNo;
  String nozzleNo;
  String transactionSeqNo;
  String fusionSaleId;
  String state;
  String releaseToken;
  String completionReason;
  String fuelMode;
  String productNo;
  double amount;
  double volume;
  double unitPrice;
  double volumeProduct1;
  double volumeProduct2;
  String productNo1;
  String productUM;
  String productName;
  String blendRatio;
  String TipsValue;
  String Isupolade;
  String Isuuidgenerate;
  String statusvoid;
  String payment_type;
  String Isportal;
  int Stannumber;
  int shift_id; // Foreign key reference to Shifts
  int taxRequestID;
  int voucherNo;
  String ecrRef;
  int batchNo;

  FuelSale({
    required this.fdCTimeStamp,
    required this.type,
    required this.deviceID,
    required this.pumpNo,
    required this.nozzleNo,
    required this.transactionSeqNo,
    required this.fusionSaleId,
    required this.state,
    required this.releaseToken,
    required this.completionReason,
    required this.fuelMode,
    required this.productNo,
    required this.amount,
    required this.volume,
    required this.unitPrice,
    required this.volumeProduct1,
    required this.volumeProduct2,
    required this.productNo1,
    required this.productUM,
    required this.productName,
    required this.blendRatio,
    required this.TipsValue,
    required this.Isupolade,
    required this.Isuuidgenerate,
    required this.statusvoid,
    required this.Stannumber,
    required this.Isportal,
    required this.payment_type,
    required this.shift_id,
    required this.taxRequestID,
    required this.voucherNo,
    required this.ecrRef,
    required this.batchNo,
  });

  // Convert FuelSale object to a Map
  Map<String, dynamic> toMap() {
    return {
      'fdCTimeStamp': fdCTimeStamp,
      'type': type,
      'deviceID': deviceID,
      'pumpNo': pumpNo,
      'nozzleNo': nozzleNo,
      'transactionSeqNo': transactionSeqNo,
      'fusionSaleId': fusionSaleId,
      'state': state,
      'releaseToken': releaseToken,
      'completionReason': completionReason,
      'fuelMode': fuelMode,
      'productNo': productNo,
      'amount': amount,
      'volume': volume,
      'unitPrice': unitPrice,
      'volumeProduct1': volumeProduct1,
      'volumeProduct2': volumeProduct2,
      'productNo1': productNo1,
      'productUM': productUM,
      'productName': productName,
      'blendRatio': blendRatio,
      'TipsValue': TipsValue,
      'Isupolade': Isupolade,
      'Isuuidgenerate': Isuuidgenerate,
      'statusvoid': statusvoid,
      'payment_type': payment_type,
      'Isportal': Isportal,
      'Stannumber': Stannumber,
      'shift_id': shift_id,
      'taxRequestID': taxRequestID,
      'voucherNo': voucherNo,
      'ecrRef': ecrRef,
      'batchNo': batchNo,
    };
  }

  // Convert a Map to FuelSale object
  factory FuelSale.fromMap(Map<String, dynamic> map) {
    return FuelSale(
      fdCTimeStamp: map['fdCTimeStamp'],
      type: map['type'],
      deviceID: map['deviceID'],
      pumpNo: map['pumpNo'],
      nozzleNo: map['nozzleNo'],
      transactionSeqNo: map['transactionSeqNo'],
      fusionSaleId: map['fusionSaleId'],
      state: map['state'],
      releaseToken: map['releaseToken'],
      completionReason: map['completionReason'],
      fuelMode: map['fuelMode'],
      productNo: map['productNo'],
      amount: map['amount'],
      volume: map['volume'],
      unitPrice: map['unitPrice'],
      volumeProduct1: map['volumeProduct1'],
      volumeProduct2: map['volumeProduct2'],
      productNo1: map['productNo1'],
      productUM: map['productUM'],
      productName: map['productName'],
      blendRatio: map['blendRatio'],
      TipsValue: map['TipsValue'],
      Isupolade: map['Isupolade'],
      Isuuidgenerate: map['Isuuidgenerate'],
      statusvoid: map['statusvoid'],
      payment_type: map['payment_type'],
      Isportal: map['Isportal'],
      Stannumber: map['Stannumber'],
      shift_id: map['shift_id'],
      taxRequestID: map['taxRequestID'],
      voucherNo: map['voucherNo'],
      ecrRef: map['ecrRef'],
      batchNo: map['batchNo'],
    );
  }
}

class Shifts {
  String startshift;
  String endshift;
  String supervisor;
  double totalamount;
  double totalmoney;
  double totaltips;
  int transnum;
  String status;
  String Isportal;
  int supervisor_id;
  String shift_num;

  Shifts({
    required this.startshift,
    required this.endshift,
    required this.supervisor,
    required this.totalamount,
    required this.totalmoney,
    required this.totaltips,
    required this.transnum,
    required this.status,
    required this.Isportal,
    required this.supervisor_id,
    required this.shift_num,
  });

  Map<String, dynamic> toMap() {
    return {
      'startshift': startshift,
      'endshift': endshift,
      'supervisor': supervisor,
      'totalamount': totalamount,
      'totalmoney': totalmoney,
      'totaltips': totaltips,
      'transnum': transnum,
      'status': status,
      'Isportal': Isportal,
      'supervisor_id': supervisor_id,
      'shift_num': shift_num,
    };
  }

  factory Shifts.fromMap(Map<String, dynamic> map) {
    return Shifts(
      startshift: map['startshift'],
      endshift: map['endshift'],
      supervisor: map['supervisor'],
      totalamount: map['totalamount'],
      totalmoney: map['totalmoney'],
      totaltips: map['totaltips'],
      transnum: map['transnum'],
      status: map['status'],
      Isportal: map['Isportal'],
      supervisor_id: map['supervisor_id'],
      shift_num: map['shift_num'],
    );
  }
}

class PosAuth {
  String andriod_id;
  String pos_serial;
  String client_id;
  String secret_key;
  String status_code;
  String access_token;
  String status;

  PosAuth({
    required this.andriod_id,
    required this.pos_serial,
    required this.client_id,
    required this.secret_key,
    required this.status_code,
    required this.access_token,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'andriod_id': andriod_id,
      'pos_serial': pos_serial,
      'client_id': client_id,
      'secret_key': secret_key,
      'status_code': status_code,
      'access_token': access_token,
      'status': status,
    };
  }

  factory PosAuth.fromMap(Map<String, dynamic> map) {
    return PosAuth(
      andriod_id: map['andriod_id'],
      pos_serial: map['pos_serial'],
      client_id: map['client_id'],
      secret_key: map['secret_key'],
      status_code: map['status_code'],
      access_token: map['access_token'],
      status: map['status'],
    );
  }
}

class PosReceipt {
  String req_id;
  String status_code;
  String status;

  PosReceipt({
    required this.req_id,
    required this.status_code,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'req_id': req_id,
      'status_code': status_code,
      'status': status,
    };
  }

  factory PosReceipt.fromMap(Map<String, dynamic> map) {
    return PosReceipt(
      req_id: map['req_id'],
      status_code: map['status_code'],
      status: map['status'],
    );
  }
}
