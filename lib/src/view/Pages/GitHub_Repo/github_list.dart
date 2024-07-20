import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/constant.dart';
import 'package:thiran_tech/core/res/strings.dart';
import 'package:thiran_tech/src/controllers/Github_Controllers/github_list_controller.dart';
import 'package:thiran_tech/src/view/components/shimmer.dart';

class GithubList extends ConsumerStatefulWidget {
  const GithubList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GithubListState();
}

class _GithubListState extends ConsumerState<GithubList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(repositoryNotifierProvider.notifier).refreshRepositories();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController
                .position.maxScrollExtent /* &&
        !isLoading */
        ) {
      /* setState(() {
        page_id = page_id + 1;
        // homeBloc.add(AddUsersEvent(page_id: page_id));
      }); */
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(repositoryNotifierProvider);
    print("  check   ^^^^^  ${state.repositories}");
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _homeAppbar(),
      body: Shimmer(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height:
              MediaQuery.of(context).size.height - AppConstants.appBarHeight,
          padding: EdgeInsets.only(bottom: AppConstants.appBarHeight),
          decoration: BoxDecoration(
            color: AppColors.whiteLite,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(75),
            ),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height:
                MediaQuery.of(context).size.height - AppConstants.appBarHeight,
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: AppColors.whiteLite,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(75),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _searchContent(userLists),
                  SizedBox(height: 30),
                  // _UserList(userLists, shimmer, loader),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _ErrorWidget(String img_path, String msg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          img_path,
          width: AppConstants.screenWidth * 0.8,
          height: AppConstants.screenWidth * 0.8,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        SizedBox(
          height: AppConstants.screenHeight * 0.05,
        ),
        Text(
          msg,
          style: TextStyle(
            fontSize: 25,
            color: AppColors.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: AppConstants.screenHeight * 0.05),
          child: ElevatedButton(
            onPressed: () {
              /* setState(() {
                page_id = 1;
              }); */
              // homeBloc.add(HomeInitialEvent(page_id: page_id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorPrimaryLite,
              minimumSize: Size(150, 50),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              elevation: 4,
            ),
            child: Text(
              'Try Again!',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    );
  }

  AppBar _homeAppbar() {
    return AppBar(
      backgroundColor: AppColors.white,
      centerTitle: true,
      title: Text(
        AppStrings.appName.toUpperCase(),
        style: TextStyle(
          wordSpacing: 8,
          letterSpacing: 4,
          fontSize: 18,
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }
}
