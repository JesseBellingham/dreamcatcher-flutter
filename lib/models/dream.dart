import 'package:uuid/uuid.dart';
class Dream {
  String id;
  String authorId;
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

  Dream.newDream(String authorId)
  {
    this.id = new Uuid().v4();
    this.authorId = authorId;
  }
  Dream.withBody(this.body);

  toJson() {
    return {
      "body": this.body,
      "name": this.name,
      "created_at": this.createdAt,
      "rating": this.rating,
      "make_public": this.makePublic,
      "author_id": this.authorId
    };
  }
}