class Location {
  List<double> coordinates;
  String type;
  String countryCode;
  String country;
  String city;
  String address;
  String name;

  Location(
      {this.coordinates,
        this.type,
        this.countryCode,
        this.country,
        this.city,
        this.address,
        this.name});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
    countryCode = json['countryCode'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coordinates'] = this.coordinates;
    data['type'] = this.type;
    data['countryCode'] = this.countryCode;
    data['country'] = this.country;
    data['city'] = this.city;
    data['address'] = this.address;
    data['name'] = this.name;
    return data;
  }
}