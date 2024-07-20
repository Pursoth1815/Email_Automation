// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GithubListModel {
  String full_name;
  String description;
  String stargazers_count;
  String avatar_url;
  String user_name;
  GithubListModel({
    required this.full_name,
    required this.description,
    required this.stargazers_count,
    required this.avatar_url,
    required this.user_name,
  });

  GithubListModel copyWith({
    String? full_name,
    String? description,
    String? stargazers_count,
    String? avatar_url,
    String? user_name,
  }) {
    return GithubListModel(
      full_name: full_name ?? this.full_name,
      description: description ?? this.description,
      stargazers_count: stargazers_count ?? this.stargazers_count,
      avatar_url: avatar_url ?? this.avatar_url,
      user_name: user_name ?? this.user_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'full_name': full_name,
      'description': description,
      'stargazers_count': stargazers_count,
      'avatar_url': avatar_url,
      'user_name': user_name,
    };
  }

  factory GithubListModel.fromMap(Map<String, dynamic> map) {
    return GithubListModel(
      full_name: map['full_name'] as String,
      description: map['description'] as String,
      stargazers_count: map['stargazers_count'] as String,
      avatar_url: map['avatar_url'] as String,
      user_name: map['user_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GithubListModel.fromJson(String source) =>
      GithubListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GithubListModel(full_name: $full_name, description: $description, stargazers_count: $stargazers_count, avatar_url: $avatar_url, user_name: $user_name)';
  }

  @override
  bool operator ==(covariant GithubListModel other) {
    if (identical(this, other)) return true;

    return other.full_name == full_name &&
        other.description == description &&
        other.stargazers_count == stargazers_count &&
        other.avatar_url == avatar_url &&
        other.user_name == user_name;
  }

  @override
  int get hashCode {
    return full_name.hashCode ^
        description.hashCode ^
        stargazers_count.hashCode ^
        avatar_url.hashCode ^
        user_name.hashCode;
  }
}
