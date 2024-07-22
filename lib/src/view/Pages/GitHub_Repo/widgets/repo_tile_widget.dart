import 'package:flutter/material.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/utils.dart';
import 'package:thiran_tech/src/models/github_list_model.dart';

class RepoTileWidget extends StatelessWidget {
  final GithubListModel repoList;
  const RepoTileWidget({super.key, required this.repoList});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(repoList.avatar_url),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          repoList.repo_name,
                          style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColor,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 12,
                            ),
                            SizedBox(width: 5),
                            Text(
                              Utils().formatNumber(repoList.stargazers_count),
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w500,
                                color: AppColors.blackLite,
                                fontSize: 11,
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        )
                      ],
                    ),
                    Text(
                      repoList.user_name,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 11,
                        color: Colors.teal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      repoList.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
