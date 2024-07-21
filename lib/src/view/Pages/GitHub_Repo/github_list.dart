import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/res/colors.dart';
import 'package:thiran_tech/core/res/constant.dart';
import 'package:thiran_tech/core/res/strings.dart';
import 'package:thiran_tech/core/utils.dart';
import 'package:thiran_tech/src/controllers/Github_Controllers/github_list_controller.dart';
import 'package:thiran_tech/src/controllers/Github_Controllers/scroll_controller.dart';
import 'package:thiran_tech/src/models/github_list_model.dart';
import 'package:thiran_tech/src/view/Pages/GitHub_Repo/widgets/repo_tile_widget.dart';
import 'package:thiran_tech/src/view/Pages/Ticket/ticket_list.dart';
import 'package:thiran_tech/src/view/components/shimmer.dart';
import 'package:thiran_tech/src/view/components/shimmer_card.dart';

class RepositoryLists extends ConsumerStatefulWidget {
  const RepositoryLists({super.key});

  @override
  RepositoryListsState createState() => RepositoryListsState();
}

class RepositoryListsState extends ConsumerState<RepositoryLists> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(repositoryNotifierProvider.notifier).fetchGithubRepositories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repositoryState = ref.watch(repositoryNotifierProvider);
    final scrollState = ref.read(scrollStateProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _homeAppbar(),
      body: Shimmer(
        child: Container(
          width: AppConstants.screenWidth,
          height: AppConstants.screenHeight - AppConstants.appBarHeight,
          decoration: BoxDecoration(
            color: AppColors.whiteLite,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(75),
            ),
          ),
          child: Container(
            width: AppConstants.screenWidth,
            height: AppConstants.screenHeight - AppConstants.appBarHeight,
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: AppColors.whiteLite,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(75),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () =>
                          Utils().navigateTo(context, TicketList()),
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.green),
                      ),
                      child: Text(
                        AppStrings.view_ticket,
                        style: TextStyle(
                          color: AppColors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  _searchContent(context, repositoryState.repositories),
                  SizedBox(height: 30),
                  _UserList(repositoryState, scrollState),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _homeAppbar() {
    return AppBar(
      backgroundColor: AppColors.white,
      centerTitle: true,
      title: Text(
        AppStrings.github_repo.toUpperCase(),
        style: TextStyle(
          wordSpacing: 8,
          letterSpacing: 4,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  Column _searchContent(BuildContext context, List<GithubListModel> userLists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.search_repo,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 20),
        TextField(
          autocorrect: true,
          autofocus: false,
          onSubmitted: (value) {
            ref.read(repositoryNotifierProvider.notifier).filterList(value);
          },
          onChanged: (value) {
            ref.read(repositoryNotifierProvider.notifier).filterList(value);
          },
          onTapOutside: (event) {
            ref.read(repositoryNotifierProvider.notifier).clearFiler();
            SystemChannels.textInput.invokeMethod('TextInput.hide');
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            prefixIconColor: Colors.black38,
            hintText: AppStrings.search,
            hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide.none,
            ),
            fillColor: AppColors.white,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          ),
        ),
      ],
    );
  }

  Widget _UserList(RepositoryState state, ScrollStateNotifier scrollState) {
    return state.isLoading && state.isLoading && state.repositories.isEmpty
        ? ShimmerCard()
        : Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollState.scrollController,
                    shrinkWrap: false,
                    itemCount: state.isFilterON
                        ? state.filteredRepo!.length
                        : state.repositories.length,
                    itemBuilder: (context, index) {
                      GithubListModel item = state.isFilterON
                          ? state.filteredRepo![index]
                          : state.repositories[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: RepoTileWidget(repoList: item),
                      );
                    },
                  ),
                ),
                if (state.isPageLoading)
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          );
  }
}
