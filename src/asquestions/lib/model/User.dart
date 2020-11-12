class User {
  String username;
  String email;
  String password;
  String name;
  String picture;
  String bio;

  User(this.username, this.email, this.name, this.picture, this.bio, this.password);

  String replacePassword() {
    String result = this
        .password
        .replaceRange(0, this.password.length, "*" * this.password.length);
    return result;
  }
}
