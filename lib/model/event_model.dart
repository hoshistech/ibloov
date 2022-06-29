import 'package:ibloov/model/guest.dart';
import 'package:ibloov/model/location.dart';
import 'package:ibloov/model/organizers.dart';
import 'package:ibloov/model/performing_artists.dart';
import 'package:ibloov/model/ticket.dart';

class Event {
  String sId;
  String terms;
  List<Organizers> organizers;
  List<PerformingArtist> performingArtists;
  List<dynamic> viewers;
  String qrcode;
  String link;
  String linkId;
  String publishOn;
  List<String> invitees;
  bool plusOne;
  String status;
  bool availability;
  String deletedAt;
  List<String> conditions;
  bool displayEndTime;
  bool displayStartTime;
  bool isCancelledDate;
  String registrationClosedDate;
  bool isPublished;
  List<String> hashtags;
  Category category;
  String description;
  String title;
  String createdBy;
  List<Guests> guests;
  String createdAt;
  String updatedAt;
  int iV;
  Location location;
  String endTime;
  String startTime;
  String ageLimit;
  String landscapeImage;
  String portraitImage;
  String accountName;
  String accountNumber;
  String bank;
  String banner;
  String visibility;
  String customMessage;
  List<Tickets> tickets;
  bool userLiked;
  int noOfRegistrations;

  Event(
      {this.sId,
      this.terms,
      this.organizers,
      this.performingArtists,
      this.viewers,
      this.qrcode,
      this.link,
      this.linkId,
      this.publishOn,
      this.invitees,
      this.plusOne,
      this.status,
      this.availability,
      this.deletedAt,
      this.conditions,
      this.displayEndTime,
      this.displayStartTime,
      this.isCancelledDate,
      this.registrationClosedDate,
      this.isPublished,
      this.hashtags,
      this.category,
      this.description,
      this.title,
      this.createdBy,
      this.guests,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.location,
      this.endTime,
      this.startTime,
      this.ageLimit,
      this.landscapeImage,
      this.portraitImage,
      this.accountName,
      this.accountNumber,
      this.bank,
      this.banner,
      this.visibility,
      this.customMessage,
      this.tickets,
      this.userLiked,
      this.noOfRegistrations});

  Event.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    terms = json['terms'];
    if (json['organizers'] != null) {
      organizers = <Organizers>[];
      json['organizers'].forEach((v) {
        if (v is Map<String, dynamic>) organizers.add(Organizers.fromJson(v));
      });
    }

    if (json['performingArtists'] != null) {
      performingArtists = <PerformingArtist>[];
      json['performingArtists'].forEach((v) {
        if (v is Map<String, dynamic>)
          performingArtists.add(PerformingArtist.fromJson(v));
      });
    }

    if (json['viewers'] != null) {
      viewers = [];
      json['viewers'].forEach((v) {
        conditions.add(v);
      });
    }
    qrcode = json['qrcode'];
    link = json['link'];
    linkId = json['linkId'];
    publishOn = json['publishOn'];
    invitees = json['invitees']?.cast<String>();
    plusOne = json['plusOne'];
    status = json['status'];
    availability = json['availability'];
    deletedAt = json['deletedAt'];
    if (json['conditions'] != null) {
      conditions = <String>[];
      json['conditions'].forEach((v) {
        conditions.add(v);
      });
    }
    displayEndTime = json['displayEndTime'];
    displayStartTime = json['displayStartTime'];
    // isCancelledDate = json['isCancelledDate'] != "null" ? json["isCancelledDate"] : null;
    registrationClosedDate = json['registrationClosedDate'];
    isPublished = json['isPublished'];
    hashtags = json['hashtags'].cast<String>();
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    description = json['description'];
    title = json['title'];
    createdBy = json['createdBy'];
    if (json['guests'] != null) {
      guests = <Guests>[];
      json['guests'].forEach((v) {
        if (v is Map<String, dynamic>) guests.add(Guests.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    endTime = json['endTime'];
    startTime = json['startTime'];
    ageLimit = json['ageLimit'];
    landscapeImage = json['landscapeImage'];
    portraitImage = json['portraitImage'];
    accountName = json['accountName'];
    accountNumber = json['accountNumber'];
    bank = json['bank'];
    banner = json['banner'];
    visibility = json['visibility'];
    customMessage = json['customMessage'];
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        if (v is Map<String, dynamic>) tickets.add(Tickets.fromJson(v));
      });
    }
    userLiked = json['userLiked'];
    noOfRegistrations = json['noOfRegistrations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['terms'] = this.terms;
    if (this.organizers != null) {
      data['organizers'] = this.organizers.map((v) => v.toJson()).toList();
    }
    data['performingArtists'] = this.performingArtists;
    if (this.viewers != null) {
      data['viewers'] = this.viewers.map((v) => v.toJson()).toList();
    }
    data['qrcode'] = this.qrcode;
    data['link'] = this.link;
    data['linkId'] = this.linkId;
    data['publishOn'] = this.publishOn;
    data['invitees'] = this.invitees;
    data['plusOne'] = this.plusOne;
    data['status'] = this.status;
    data['availability'] = this.availability;
    data['deletedAt'] = this.deletedAt;
    if (this.conditions != null) {
      data['conditions'] = this.conditions.map((v) => v).toList();
    }
    data['displayEndTime'] = this.displayEndTime;
    data['displayStartTime'] = this.displayStartTime;
    data['isCancelledDate'] = this.isCancelledDate;
    data['registrationClosedDate'] = this.registrationClosedDate;
    data['isPublished'] = this.isPublished;
    data['hashtags'] = this.hashtags;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['description'] = this.description;
    data['title'] = this.title;
    data['createdBy'] = this.createdBy;
    if (this.guests != null) {
      data['guests'] = this.guests.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    data['endTime'] = this.endTime;
    data['startTime'] = this.startTime;
    data['ageLimit'] = this.ageLimit;
    data['landscapeImage'] = this.landscapeImage;
    data['portraitImage'] = this.portraitImage;
    data['accountName'] = this.accountName;
    data['accountNumber'] = this.accountNumber;
    data['bank'] = this.bank;
    data['banner'] = this.banner;
    data['visibility'] = this.visibility;
    data['customMessage'] = this.customMessage;
    if (this.tickets != null) {
      data['tickets'] = this.tickets.map((v) => v.toJson()).toList();
    }
    data['userLiked'] = this.userLiked;
    data['noOfRegistrations'] = this.noOfRegistrations;
    return data;
  }
}

class Category {
  String sId;
  String name;
  String createdAt;
  String updatedAt;
  int iV;
  String imageUrl;

  Category(
      {this.sId,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.imageUrl});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}