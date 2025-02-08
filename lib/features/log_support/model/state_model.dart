class StateModel {
  int? id;
  String? name;

  StateModel({this.id, this.name});

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
