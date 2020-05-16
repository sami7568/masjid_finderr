class Imam {
  String fullName;
  String email;
  String contact;
  String password;

  Imam({this.fullName, this.email, this.password, this.contact});

  toJson() {
    return {
      'fullName': this.fullName,
      'email': this.email,
      'contact': this.contact,
    };
  }
}
