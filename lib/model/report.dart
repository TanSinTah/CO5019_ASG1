class Report {
  final String uid;
  final String description;
  final String? imageUrl;
  final String dateTime;
  final String reference;
  final String location;
  final String status;

  Report(
      {required this.uid,
      required this.description,
      required this.imageUrl,
      required this.reference,
      required this.dateTime,
      required this.location,
        required this.status});

  //function to convert snapshot to report
  factory Report.fromSnapshot(Map<String, dynamic> document) {
    return Report(
        uid: document["uid"],
        description: document["description"],
        imageUrl: document["imageUrl"],
        reference: document["reference"],
        dateTime: document["dateTime"],
        location: document["location"],
        status: document["status"]);
  }
}
