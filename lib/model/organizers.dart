class Organizers {
  String sId;
  String fullName;

  Organizers({this.sId, this.fullName});

  Organizers.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    return data;
  }
}