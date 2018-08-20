class Dream {
  String dreamName;
  String dreamBody;
  DateTime createdAt = DateTime.now();
  int rating;
  bool makePublic = false;

  Dream();
  Dream.withAll(this.dreamName,
    this.dreamBody,
    this.createdAt,
    this.makePublic,
    this.rating);

  Dream.withBody(this.dreamBody);

  toJson() {
    return {
      "body": this.dreamBody,
      "name": this.dreamName,
      "created_at": this.createdAt,
      "rating": this.rating,
      "make_public": this.makePublic
    };
  }
}