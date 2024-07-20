import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiran_tech/core/services/data/network/network_api_services.dart';
import 'package:thiran_tech/core/services/sqflite_services.dart';

class RepositoryState {
  final List<Map<String, dynamic>> repositories;
  final int pageCount;
  final bool isLoading;

  RepositoryState({
    required this.repositories,
    required this.pageCount,
    this.isLoading = false,
  });

  RepositoryState copyWith({
    List<Map<String, dynamic>>? repositories,
    int? pageCount,
    bool? isLoading,
  }) {
    return RepositoryState(
      repositories: repositories ?? this.repositories,
      pageCount: pageCount ?? this.pageCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RepositoryNotifier extends StateNotifier<RepositoryState> {
  final SqfliteServices _dbHelper;

  RepositoryNotifier(this._dbHelper)
      : super(
            RepositoryState(repositories: [], pageCount: 1, isLoading: true)) {
    refreshRepositories();
  }

  Future<void> _fetchSqliteRepositories() async {
    state = state.copyWith(isLoading: true);
    final repos = await _dbHelper.queryAll();
    state = state.copyWith(repositories: repos, isLoading: false);
  }

  Future<void> _fetchGithubRepositories() async {
    state = state.copyWith(repositories: [], isLoading: true);
    try {
      final data = await NetworkApiServices().getApi();
      print(data);
    } catch (e) {
      print(e);
    }
  }

  void incrementPageCount() {
    state = state.copyWith(pageCount: state.pageCount + 1);
  }

  Future<void> refreshRepositories() async {
    await _fetchGithubRepositories();
    await _fetchSqliteRepositories();
  }
}

final repositoryNotifierProvider =
    StateNotifierProvider<RepositoryNotifier, RepositoryState>((ref) {
  final databaseHelper = ref.watch(databaseProvider);
  return RepositoryNotifier(databaseHelper);
});
