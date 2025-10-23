import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.userId, required super.userEmail});

  factory UserModel.fromFirebase(Map<String, dynamic> firebaseData) {
    return UserModel(
      userId: firebaseData['userId'] as String,
      userEmail: firebaseData['userEmail'] as String,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {'userId': userId, 'userEmail': userEmail};
  }
}
