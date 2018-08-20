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
}