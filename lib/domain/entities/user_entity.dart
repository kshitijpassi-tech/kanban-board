class UserEntity {
  final String userId;
  final String userEmail;

  UserEntity({required this.userId, required this.userEmail});

  UserEntity copyWith({String? userId, String? userEmail}) {
    return UserEntity(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}
