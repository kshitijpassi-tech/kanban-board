import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String userEmail;

  const UserEntity({required this.userId, required this.userEmail});

  UserEntity copyWith({String? userId, String? userEmail}) {
    return UserEntity(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
