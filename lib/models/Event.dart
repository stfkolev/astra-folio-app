import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  late int id;
  late String name;
  late String description;
  late DateTime timestamp;

  Event(this.id, this.name, this.description, this.timestamp);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}