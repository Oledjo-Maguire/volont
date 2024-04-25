class Events {
  String eventName;
  String catygory;
  String startDate;
  String endDate;
  String location;

  Events(
      {
        required this.eventName,
        required this.catygory,
        required this.startDate,
        required this.endDate,
        required this.location
      }
      );
  factory Events.fromJson(dynamic json) {
    return Events(
      eventName: "${json['eventName']}",
      catygory: "${json['catygory']}",
      startDate: "${json['startDate']}",
      endDate: "${json['endDate']}",
      location: "${json['location']}",
    );
  }
  Map toJson() => {
    "eventName": eventName,
    "catygory": catygory,
    "startDate": startDate,
    "endDate": endDate,
    "location": location,
  };
}