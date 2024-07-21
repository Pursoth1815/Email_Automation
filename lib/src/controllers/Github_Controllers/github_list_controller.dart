import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/services/data/network/network_api_services.dart';
import 'package:thiran_tech/core/services/sqflite_services.dart';
import 'package:thiran_tech/src/models/github_list_model.dart';

class RepositoryState {
  final List<GithubListModel> repositories;
  final int pageCount;
  final int totalCount;
  final bool maxCountReached;
  final bool isLoading;
  final bool isPageLoading;
  final bool isFilterON;
  final List<GithubListModel>? filteredRepo;
  final String? errorMessage;

  RepositoryState({
    required this.repositories,
    required this.pageCount,
    this.filteredRepo,
    this.totalCount = 0,
    this.maxCountReached = false,
    this.isLoading = false,
    this.isFilterON = false,
    this.isPageLoading = false,
    this.errorMessage = "",
  });

  RepositoryState copyWith({
    List<GithubListModel>? repositories,
    List<GithubListModel>? filteredRepo,
    int? pageCount,
    int? totalCount,
    bool? maxCountReached,
    bool? isLoading,
    bool? isPageLoading,
    bool? isFilterON,
    String? errorMessage,
  }) {
    return RepositoryState(
      repositories: repositories ?? this.repositories,
      filteredRepo: filteredRepo ?? this.filteredRepo,
      pageCount: pageCount ?? this.pageCount,
      totalCount: totalCount ?? this.totalCount,
      maxCountReached: maxCountReached ?? this.maxCountReached,
      isLoading: isLoading ?? this.isLoading,
      isFilterON: isFilterON ?? this.isFilterON,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class RepositoryNotifier extends StateNotifier<RepositoryState> {
  final SqfliteServices _dbHelper;

  RepositoryNotifier(this._dbHelper)
      : super(
            RepositoryState(pageCount: 1, repositories: [], isLoading: false));

  void incrementPageCount() {
    if (!state.maxCountReached && !state.isFilterON) {
      state =
          state.copyWith(pageCount: state.pageCount + 1, isPageLoading: true);
      Future.delayed(
        Durations.extralong4,
        () => refreshRepositories(totalCount: state.totalCount),
      );
    }
  }

  void clearFiler() {
    if (state.filteredRepo!.length < 1) {
      state = state.copyWith(isFilterON: false, filteredRepo: []);
    }
  }

  Future<void> filterList(String value) async {
    state = state.copyWith(isFilterON: true);
    List<GithubListModel> _filterList = [];

    if (value.isNotEmpty) {
      _filterList = state.repositories.where((element) {
        return element.repo_name.toLowerCase().contains(value.toLowerCase()) ||
            element.user_name.toLowerCase().contains(value.toLowerCase());
      }).toList();
    }
    state = state.copyWith(filteredRepo: _filterList);
  }

  Future<void> fetchGithubRepositories() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    try {
      List<Map<String, dynamic>> repositories =
          await NetworkApiServices().getApi();

      List<Map<String, dynamic>> dataList = repositories.map(
        (element) {
          return GithubListModel.fromAPI(element).toMap();
        },
      ).toList();
      bool flag = await _dbHelper.bulkInsert(dataList);

      if (flag) {
        await refreshRepositories(totalCount: dataList.length);
      }
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: e.toString(), isPageLoading: false);
    }
  }

  Future<void> refreshRepositories({int totalCount = 0}) async {
    if (!state.isLoading && !state.isPageLoading)
      state = state.copyWith(isLoading: true);
    try {
      List<Map<String, dynamic>> repos =
          await _dbHelper.fetchOfflineLimitData(state.pageCount);
      List<GithubListModel> dataList = repos
          .map(
            (e) => GithubListModel.fromMap(e),
          )
          .toList();
      state = state.copyWith(
          repositories: [...state.repositories, ...dataList],
          isLoading: false,
          totalCount: totalCount,
          maxCountReached: totalCount == state.repositories.length,
          isPageLoading: false);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: e.toString(), isPageLoading: false);
    }
  }
}

final repositoryNotifierProvider =
    StateNotifierProvider<RepositoryNotifier, RepositoryState>((ref) {
  final databaseHelper = ref.watch(databaseProvider);
  return RepositoryNotifier(databaseHelper);
});
