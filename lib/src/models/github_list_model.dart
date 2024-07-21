// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GithubListModel {
  String repo_name;
  String description;
  String stargazers_count;
  String avatar_url;
  String user_name;
  GithubListModel({
    required this.repo_name,
    required this.description,
    required this.stargazers_count,
    required this.avatar_url,
    required this.user_name,
  });

  GithubListModel copyWith({
    String? repo_name,
    String? description,
    String? stargazers_count,
    String? avatar_url,
    String? user_name,
  }) {
    return GithubListModel(
      repo_name: repo_name ?? this.repo_name,
      description: description ?? this.description,
      stargazers_count: stargazers_count ?? this.stargazers_count,
      avatar_url: avatar_url ?? this.avatar_url,
      user_name: user_name ?? this.user_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'full_name': repo_name,
      'description': description,
      'stargazers_count': stargazers_count,
      'avatar_url': avatar_url,
      'user_name': user_name,
    };
  }

  factory GithubListModel.fromMap(Map<String, dynamic> map) {
    return GithubListModel(
      repo_name: map['full_name'].toString(),
      description: map['description'].toString(),
      stargazers_count: map['stargazers_count'].toString(),
      avatar_url: map['avatar_url'].toString(),
      user_name: map['user_name'].toString(),
    );
  }

  factory GithubListModel.fromAPI(Map<String, dynamic> map) {
    return GithubListModel(
      repo_name: map['full_name'].toString(),
      description: map['description'].toString(),
      stargazers_count: map['stargazers_count'].toString(),
      avatar_url: map['owner']['avatar_url'].toString(),
      user_name: map['owner']['login'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GithubListModel.fromJson(String source) =>
      GithubListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GithubListModel(full_name: $repo_name, description: $description, stargazers_count: $stargazers_count, avatar_url: $avatar_url, user_name: $user_name)';
  }

  @override
  bool operator ==(covariant GithubListModel other) {
    if (identical(this, other)) return true;

    return other.repo_name == repo_name &&
        other.description == description &&
        other.stargazers_count == stargazers_count &&
        other.avatar_url == avatar_url &&
        other.user_name == user_name;
  }

  @override
  int get hashCode {
    return repo_name.hashCode ^
        description.hashCode ^
        stargazers_count.hashCode ^
        avatar_url.hashCode ^
        user_name.hashCode;
  }
}
