import 'package:ibloov/model/event_model.dart';

class ExploreEventResponse {
  int statusCode;
  String message;
  ExploreEventData data;

  ExploreEventResponse({this.statusCode, this.message, this.data});

  ExploreEventResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? new ExploreEventData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class ExploreEventData {
  List<Event> happeningToday;
  List<Event> happeningThisWeek;
  List<Event> happeningNearMe;
  List<Event> trendingEvents;
  List<Event> featuredEvents;
  List<Event> filtered;

  ExploreEventData(
      {this.happeningToday,
      this.happeningThisWeek,
      this.happeningNearMe,
      this.trendingEvents,
      this.featuredEvents,
      this.filtered});

  ExploreEventData.fromJson(Map<String, dynamic> json) {
    if (json['happeningToday'] != null) {
      happeningToday = <Event>[];
      json['happeningToday'].forEach((v) {
        happeningToday.add(Event.fromJson(v));
      });
    }
    if (json['happeningThisWeek'] != null) {
      happeningThisWeek = <Event>[];
      json['happeningThisWeek'].forEach((v) {
        happeningThisWeek.add(Event.fromJson(v));
      });
    }
    if (json['happeningNearMe'] != null) {
      happeningNearMe = <Event>[];
      json['happeningNearMe'].forEach((v) {
        happeningNearMe.add(Event.fromJson(v));
      });
    }
    if (json['trendingEvents'] != null) {
      trendingEvents = <Event>[];
      json['trendingEvents'].forEach((v) {
        trendingEvents.add(Event.fromJson(v));
      });
    }
    if (json['featuredEvents'] != null) {
      featuredEvents = <Event>[];
      json['featuredEvents'].forEach((v) {
        featuredEvents.add(Event.fromJson(v));
      });
    }
    if (json['filtered'] != null) {
      filtered = <Event>[];
      json['filtered'].forEach((v) {
        filtered.add(Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.happeningToday != null) {
      data['happeningToday'] =
          this.happeningToday.map((v) => v.toJson()).toList();
    }
    if (this.happeningThisWeek != null) {
      data['happeningThisWeek'] =
          this.happeningThisWeek.map((v) => v.toJson()).toList();
    }
    if (this.happeningNearMe != null) {
      data['happeningNearMe'] =
          this.happeningNearMe.map((v) => v.toJson()).toList();
    }
    if (this.trendingEvents != null) {
      data['trendingEvents'] =
          this.trendingEvents.map((v) => v.toJson()).toList();
    }
    if (this.featuredEvents != null) {
      data['featuredEvents'] =
          this.featuredEvents.map((v) => v.toJson()).toList();
    }
    if (this.filtered != null) {
      data['filtered'] = this.filtered.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
