class Guests {
  String imgUrl;
  String role;
  String name;

  Guests({this.imgUrl, this.role, this.name});

  Guests.fromJson(Map<String, dynamic> json) {
    imgUrl = json['imgUrl'];
    role = json['role'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgUrl'] = this.imgUrl;
    data['role'] = this.role;
    data['name'] = this.name;
    return data;
  }
}