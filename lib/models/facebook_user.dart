class FacebookUser {
  String id;
  String name;
  String firstName;
  String lastName;
  dynamic profilePictureData;

  FacebookUser();  
  FacebookUser.withAll(
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.profilePictureData
  );
}