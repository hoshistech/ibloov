import 'package:ibloov/model/currency.dart';

class Tickets {
  String sId;
  bool deleted;
  Currency currency;
  int quantity;
  int price;
  String name;
  String type;
  String event;
  int remainingQuantity;
  String createdAt;
  String updatedAt;
  int iV;
  String deletedAt;
  String deletedBy;
  String salesEnd;
  String salesStart;

  Tickets(
      {this.sId,
        this.deleted,
        this.currency,
        this.quantity,
        this.price,
        this.name,
        this.type,
        this.event,
        this.remainingQuantity,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.deletedAt,
        this.deletedBy,
        this.salesEnd,
        this.salesStart});

  Tickets.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    deleted = json['deleted'];
    currency = json['currency'] != null
        ? new Currency.fromJson(json['currency'])
        : null;
    quantity = json['quantity'];
    price = json['price'];
    name = json['name'];
    type = json['type'];
    event = json['event'];
    remainingQuantity = json['remainingQuantity'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    deletedAt = json['deletedAt'];
    deletedBy = json['deletedBy'];
    salesEnd = json['salesEnd'];
    salesStart = json['salesStart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['deleted'] = this.deleted;
    if (this.currency != null) {
      data['currency'] = this.currency.toJson();
    }
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['name'] = this.name;
    data['type'] = this.type;
    data['event'] = this.event;
    data['remainingQuantity'] = this.remainingQuantity;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['deletedAt'] = this.deletedAt;
    data['deletedBy'] = this.deletedBy;
    data['salesEnd'] = this.salesEnd;
    data['salesStart'] = this.salesStart;
    return data;
  }
}