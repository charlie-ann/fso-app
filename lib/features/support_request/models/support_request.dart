import 'package:fso_support/features/terminals/models/terminal_model.dart';

class SupportRequestModel {
  int? id;
  String? supportType;
  String? supportIssue;
  String? status;
  String? phoneNumber;
  DateTime? createdAt;
  Attachment? attachment;
  TerminalModel? terminal;
  Fso? fso;

  SupportRequestModel({
    this.id,
    this.supportType,
    this.supportIssue,
    this.status,
    this.createdAt,
    this.attachment,
    this.terminal,
    this.fso,
    this.phoneNumber,
  });

  SupportRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    supportType = json['support_type'];
    supportIssue = json['support_issue'];
    status = json['status'];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    attachment = json['attachment'] != null
        ? Attachment.fromJson(json['attachment'])
        : null;
    terminal = json['terminal'] != null
        ? TerminalModel.fromJson(json['terminal'])
        : null;
    fso = json['fso'] != null ? Fso.fromJson(json['fso']) : null;
    phoneNumber = json['phone_number'];
  }
}

class Fso {
  String? name;
  String? email;
  String? phoneNumber;
  String? area;
  num? lat;
  num? lng;
  String? status;
  String? state;
  int? stateId;

  Fso({
    this.name,
    this.email,
    this.phoneNumber,
    this.area,
    this.lat,
    this.lng,
    this.status,
    this.state,
    this.stateId,
  });

  Fso.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    area = json['area'];
    lat = json['lat'];
    lng = json['lng'];
    status = json['status'];
    state = json['state'];
    stateId = json['state_id'];
  }
}

class Attachment {
  String? name;
  String? url;
  String? extension;

  Attachment({
    this.name,
    this.url,
    this.extension,
  });

  Attachment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    extension = json['extension'];
  }
}
