class AuthorModal {
  String? id;
  String? firstName;
  String? lastName;

  AuthorModal({this.id, this.firstName, this.lastName});

  factory AuthorModal.fromMap(Map<String, dynamic> authors) {
    return AuthorModal(
      id: authors['id'],
      firstName: authors['first_name'],
      lastName: authors['last_name'],
    );
  }
}
