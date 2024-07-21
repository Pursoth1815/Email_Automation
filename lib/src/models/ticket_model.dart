import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  String title;
  String description;
  String location;
  DateTime reportedDate;
  String attachment;

  TicketModel({
    required this.title,
    required this.description,
    required this.location,
    required this.reportedDate,
    required this.attachment,
  });

  TicketModel copyWith({
    String? title,
    String? description,
    String? location,
    DateTime? reportedDate,
    String? attachment,
  }) {
    return TicketModel(
        title: title ?? this.title,
        description: description ?? this.description,
        location: location ?? this.description,
        reportedDate: reportedDate ?? this.reportedDate,
        attachment: attachment ?? this.attachment);
  }

  factory TicketModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TicketModel(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      reportedDate: (data['reported_date'] as Timestamp).toDate(),
      attachment: data['attachment'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'reported_date': Timestamp.fromDate(reportedDate),
      'attachment': attachment,
    };
  }

  // Create a TicketModel instance from a map
  factory TicketModel.fromMap(Map<String, dynamic> map) {
    print("$map");
    return TicketModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      reportedDate: (map['reported_date'] as Timestamp).toDate(),
      attachment: map['attachment'] ?? '',
    );
  }
}
