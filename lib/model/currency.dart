class Currency {
  String sId;
  bool isActive;
  String isoCode;
  String uniCode;
  String name;
  String code;
  String htmlCode;
  String createdAt;
  String updatedAt;
  int iV;

  Currency(
      {this.sId,
        this.isActive,
        this.isoCode,
        this.uniCode,
        this.name,
        this.code,
        this.htmlCode,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Currency.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    isActive = json['isActive'];
    isoCode = json['isoCode'];
    uniCode = json['uniCode'];
    name = json['name'];
    code = json['code'];
    htmlCode = json['htmlCode'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['isActive'] = this.isActive;
    data['isoCode'] = this.isoCode;
    data['uniCode'] = this.uniCode;
    data['name'] = this.name;
    data['code'] = this.code;
    data['htmlCode'] = this.htmlCode;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}