class PerformingArtist {
  String sId;
  List<String> genre;
  String imgUrl;
  String name;
  String createdAt;
  String updatedAt;
  int iV;

  PerformingArtist(
      {this.sId,
        this.genre,
        this.imgUrl,
        this.name,
        this.createdAt,
        this.updatedAt,
        this.iV});

  PerformingArtist.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    genre = json['genre'].cast<String>();
    imgUrl = json['imgUrl'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['genre'] = this.genre;
    data['imgUrl'] = this.imgUrl;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}