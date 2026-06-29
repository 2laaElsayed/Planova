import 'package:planova_app/features/group/domain/entities/user_search_entity.dart';

class UserSearchModel extends UserSearchEntity {
  UserSearchModel({
    required super.uid,
    required super.name,
    required super.email,
    super.avatarUrl,  
  });

  factory UserSearchModel.fromJson(Map<String, dynamic> json, String documentId) {
    return UserSearchModel(
      uid: documentId,
      name: json['full_name'] ?? 'No Name',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }
}

extension UserSearchMapper on UserSearchModel {
  UserSearchEntity toEntity() {
    return UserSearchEntity(
      uid: uid,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
}