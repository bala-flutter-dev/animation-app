class JobModel {
  JobModel({
    required this.id,
    required this.sId,
    required this.cId,
    required this.collectionDate,
    required this.name,
    required this.location,
  });
  String id;
  String? sId;
  String? cId;
  String? collectionDate;
  String? name;
  String? location;

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
      id: json['id'],
      sId: json['sId'],
      cId: json['cId'],
      collectionDate: json['collectionDate'],
      name: json['name'],
      location: json['location']);

  Map<String, dynamic> toMap() => {
        "id": id,
        "sId": sId,
        "cId": cId,
        "collectionDate": collectionDate,
        "name": name,
        "location": location
      };
}
