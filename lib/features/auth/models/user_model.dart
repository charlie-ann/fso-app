class UserModel {
  int? id;
  String? name;
  String? email;
  DateTime? emailVerifiedAt;
  int? stateId;
  String? phoneNumber;
  String? area;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? lat;
  num? lng;
  String? status;
  String? accessToken;
  String? state;
  bool? passwordChanged;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.stateId,
    this.phoneNumber,
    this.area,
    this.createdAt,
    this.updatedAt,
    this.lat,
    this.lng,
    this.status,
    this.accessToken,
    this.state,
    this.passwordChanged,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json["roles"][0]["pivot"]["user_id"];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'] != null
        ? DateTime.parse(json['email_verified_at'])
        : null;
    stateId = json['state_id'];
    phoneNumber = json['phone_number'];
    area = json['area'];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt =
        json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
    lat = json['lat'];
    lng = json['lng'];
    status = json['status'];
    accessToken = json['access_token'];
    state = json['state'];
    passwordChanged = json['password_changed'];
  }
}
