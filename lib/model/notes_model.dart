class NotesModel {
  final int? id;
  final String title;
  final int age;
  final String description;
  final String email;

  NotesModel(
      {this.id,
      required this.title,
      required this.age,
      required this.description,
      required this.email});

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
        id: map['id'],
        title: map['title'],
        age: map['age'],
        description: map['description'],
        email: map['email']);
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'title': title,
        'age': age,
        'description': description,
        'email': email
      };
}
