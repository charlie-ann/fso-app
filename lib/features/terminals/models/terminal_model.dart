class TerminalResponseModel {
  List<TerminalModel>? terminals;
  int? currentPage;
  int? lastPage;
  int? total;

  TerminalResponseModel({
    this.terminals,
    this.currentPage,
    this.lastPage,
    this.total,
  });

  TerminalResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      terminals =
          (json["data"] as List).map((e) => TerminalModel.fromJson(e)).toList();
    }
    currentPage = json['meta']['current_page'];
    lastPage = json['meta']['last_page'];
    total = json['meta']['total'];
  }
}

class TerminalModel {
  int? id;
  String? terminalId;
  String? type;
  String? appVersion;
  String? serialNumber;
  String? merchantName;
  String? address;
  String? dateRegistered;
  String? bank;
  String? status;
  String? state;
  String? merchantId;
  DateTime? createdAt;
  String? chargingStatus;
  String? printerStatus;
  String? signalLevel;
  String? batteryLevel;
  DateTime? lastConnection;
  String? terminalType;
  String? phoneNumber;

  TerminalModel({
    this.id,
    this.terminalId,
    this.type,
    this.appVersion,
    this.serialNumber,
    this.merchantName,
    this.address,
    this.dateRegistered,
    this.bank,
    this.status,
    this.state,
    this.merchantId,
    this.createdAt,
    this.chargingStatus,
    this.printerStatus,
    this.signalLevel,
    this.batteryLevel,
    this.lastConnection,
    this.terminalType,
    this.phoneNumber,
  });

  TerminalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    terminalId = json['terminal_id'];
    type = json['type'];
    appVersion = json['app_version'];
    serialNumber = json['serial_number'];
    merchantName = json['merchant_name'];
    address = json['address'];
    dateRegistered = json['date_registered'];
    bank = json['bank'];
    status = json['status'];
    state = json['state'];
    merchantId = json['merchant_id'];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    chargingStatus = json["extra"]?['chargingStatus'];
    printerStatus = json["extra"]?['printerstatus'];
    signalLevel = json["extra"]?['signalLevel'];
    batteryLevel = json["extra"]?['batteeyLevel'];
    lastConnection = json["extra"]?['lastConnectionDate'] != null
        ? DateTime.parse(json["extra"]['lastConnectionDate'])
        : null;
    terminalType = json["extra"]?['type'];
    phoneNumber = json['phone_number'];
  }
}

class TerminalParams {
  TerminalModel? terminalModel;
  int? taskId;
  String? tid;
  bool? isCreateTask;
  String? supportReqType;

  TerminalParams({
    this.terminalModel,
    this.taskId,
    this.tid,
    this.isCreateTask,
    this.supportReqType,
  });
}

class TerminalDetailRoute {
  TerminalModel? terminalModel;
  String? status;

  TerminalDetailRoute({
    this.terminalModel,
    this.status,
  });
}

class QrRouteParams {
  int? taskId;
  String? supportReqType;

  QrRouteParams({
    this.supportReqType,
    this.taskId,
  });
}
