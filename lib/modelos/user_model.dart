class UserModel {
  final String uid;
  final String email;
  final String? nombres;
  final String? apellidos;
  final String? telefono;
  final String? role;

  UserModel({
    required this.uid,
    required this.email,
    this.nombres,
    this.apellidos,
    this.telefono,
    this.role = 'user',
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      nombres: data['nombres'],
      apellidos: data['apellidos'],
      telefono: data['telefono'],
      role: data['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'role': role,
    };
  }
}
