class User {
  String fullName;
  String email;
  String password;
  String fcmToken;

  User({this.fullName, this.email, this.password});

  toJson() {
    return {
      'fullName': this.fullName,
      'email': this.email,
    };
  }
}
