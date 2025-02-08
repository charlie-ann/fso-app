class HistoryModel {
  int? id;
  String? terminalId;
  String? name;
  String? fso;
  String? type;
  String? address;
  String? appVersion;
  String? lat;
  String? lng;
  String? logType;
  String? supportType;
  String? status;
  DateTime? createdAt;
  DocumentModel? document;
  DocumentModel? signature;
  String? purpose;

  HistoryModel({
    this.id,
    this.terminalId,
    this.name,
    this.fso,
    this.type,
    this.address,
    this.appVersion,
    this.lat,
    this.lng,
    this.logType,
    this.supportType,
    this.status,
    this.createdAt,
    this.document,
    this.signature,
    this.purpose,
  });

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    terminalId = json['terminal_id'];
    name = json['name'];
    fso = json['fso'];
    type = json['type'];
    address = json['address'];
    appVersion = json['app_version'];
    lat = json['lat'];
    lng = json['lng'];
    logType = json['log_type'];
    supportType = json['support_type'];
    status = json['status'];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    document = json['document'] != null
        ? DocumentModel.fromJson(json['document'])
        : null;
    signature = json['signature'] != null
        ? DocumentModel.fromJson(json['signature'])
        : null;
    purpose = json['purpose'];
  }
}

class DocumentModel {
  String? name;
  String? url;
  String? extension;

  DocumentModel({this.name, this.url, this.extension});

  DocumentModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    extension = json['extension'];
  }
}
