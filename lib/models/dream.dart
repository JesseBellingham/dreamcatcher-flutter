import 'package:uuid/uuid.dart';
class Dream {
  String id;
  String name;
  String body;
  DateTime createdAt = DateTime.now();
  int rating;
  bool makePublic = false;

  Dream();
  Dream.withAll(this.name,
    this.body,
    this.createdAt,
    this.makePublic,
    this.rating);

  Dream.newDream()
  {
    this.id = new Uuid().v4();
  }
  Dream.withBody(this.body);

  toJson() {
    return {
      "body": this.body,
      "name": this.name,
      "created_at": this.createdAt,
      "rating": this.rating,
      "make_public": this.makePublic
    };
  }
}