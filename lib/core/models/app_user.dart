class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.avatarUrl,
  });

  final String id;
  final String name;
  final String email;
  final String bio;
  final String avatarUrl;

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? avatarUrl,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'avatarUrl': avatarUrl,
    };
  }

  factory AppUser.fromJson(Map<dynamic, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );
  }
}
